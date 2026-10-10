import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/pulse_bottom_nav.dart';
import 'package:pulse/features/auth/data/account_repository.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/chat/presentation/chat_providers.dart';
import 'package:pulse/features/crews/presentation/crews_providers.dart';
import 'package:pulse/features/notifications/data/push_messaging.dart';
import 'package:pulse/features/notifications/domain/push_route.dart';
import 'package:pulse/features/notifications/presentation/push_registration.dart';
import 'package:pulse/features/safety/domain/safety_models.dart';
import 'package:pulse/features/safety/presentation/safety_providers.dart';

/// Scaffold for the 4 main tabs with the floating bottom navigation.
/// Also re-checks the account when the app comes back to the foreground
/// (a suspension takes effect) and shows moderation warnings once.
class HomeShell extends ConsumerStatefulWidget {
  const new({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  late final AppLifecycleListener _lifecycle;
  final _pushSubscriptions = <StreamSubscription<Map<String, dynamic>>>[];
  bool _showingNotice = false;

  @override
  void initState() {
    super.initState();
    unawaited(_logAccess());
    unawaited(_setUpPush());
    _lifecycle = AppLifecycleListener(
      onResume: () {
        ref
          ..invalidate(accountProvider)
          ..invalidate(moderationNoticeProvider)
          ..invalidate(myCrewInvitesProvider);
        unawaited(_logAccess());
      },
    );
  }

  /// Access log required by law (Marco Civil); never blocks the user.
  Future<void> _logAccess() async {
    try {
      await ref.read(accountRepositoryProvider).logAccess();
    } on Object catch (error) {
      debugPrint('Access log failed: $error');
    }
  }

  /// Opens the screen of a tapped notification and registers this device.
  Future<void> _setUpPush() async {
    final messaging = ref.read(pushMessagingProvider);
    _pushSubscriptions
      ..add(messaging.onMessageOpened.listen(_openFromPush))
      ..add(
        messaging.onForegroundMessage.listen((data) {
          // Invites have no realtime feed; matches and messages do.
          if (data['kind'] == 'crew_invite') {
            ref.invalidate(myCrewInvitesProvider);
          }
        }),
      );
    try {
      final initial = await messaging.initialMessageData();
      if (initial != null) _openFromPush(initial);
    } on Object catch (error) {
      debugPrint('Push initial message failed: $error');
    }
    await ref.read(pushRegistrationProvider.notifier).enable();
  }

  void _openFromPush(Map<String, dynamic> data) {
    if (mounted) context.go(routeFromPushData(data));
  }

  @override
  void dispose() {
    for (final subscription in _pushSubscriptions) {
      unawaited(subscription.cancel());
    }
    _lifecycle.dispose();
    super.dispose();
  }

  Future<void> _showWarning(ModerationNotice notice) async {
    if (_showingNotice) return;
    _showingNotice = true;
    final l10n = context.l10n;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.report_outlined, color: context.colors.lime),
        title: Text(l10n.warningNoticeTitle),
        content: Text(l10n.warningNoticeBody(notice.reason)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.warningNoticeOk),
          ),
        ],
      ),
    );
    _showingNotice = false;
    await ref.read(safetyActionsProvider.notifier).acknowledge(notice.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final navigationShell = widget.navigationShell;
    // Unread messages + pending crew invites.
    final chatBadge =
        ref.watch(unreadMessageCountProvider) +
        (ref.watch(myCrewInvitesProvider).value?.length ?? 0);

    ref.listen(moderationNoticeProvider, (_, next) {
      final notice = next.value;
      if (notice != null && notice.action == ModerationAction.warning) {
        unawaited(_showWarning(notice));
      }
    });

    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: PulseBottomNav(
        currentIndex: navigationShell.currentIndex,
        onSelected: (index) => navigationShell.goBranch(
          index,
          // Tapping the active tab returns to its root.
          initialLocation: index == navigationShell.currentIndex,
        ),
        items: [
          PulseNavItem(
            icon: Icons.local_fire_department_outlined,
            selectedIcon: Icons.local_fire_department,
            label: l10n.navDiscover,
          ),
          PulseNavItem(
            icon: Icons.event_outlined,
            selectedIcon: Icons.event,
            label: l10n.navEvents,
          ),
          PulseNavItem(
            icon: Icons.chat_bubble_outline,
            selectedIcon: Icons.chat_bubble,
            label: l10n.navChats,
            badgeCount: chatBadge,
          ),
          PulseNavItem(
            icon: Icons.person_outline,
            selectedIcon: Icons.person,
            label: l10n.navProfile,
          ),
        ],
      ),
    );
  }
}
