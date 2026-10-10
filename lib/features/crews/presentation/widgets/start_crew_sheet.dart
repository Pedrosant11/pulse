import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/crews/presentation/crews_providers.dart';

/// Start a crew with a Crew match: pick one of the parties both go to, then
/// the crew form opens with them already invited.
Future<void> showStartCrewSheet(
  BuildContext context, {
  required String userId,
  required String name,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: context.colors.surface,
    builder: (_) =>
        _StartCrewSheet(userId: userId, name: name, parent: context),
  );
}

class _StartCrewSheet extends ConsumerWidget {
  const new({required this.userId, required this.name, required this.parent});

  final String userId;
  final String name;

  /// Navigates after the sheet closes.
  final BuildContext parent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final events = ref.watch(commonEventsProvider(userId));

    return Padding(
      padding: EdgeInsets.all(spacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.startCrewTitle(name), style: context.textTheme.titleLarge),
          SizedBox(height: spacing.xs),
          Text(l10n.startCrewSubtitle, style: context.textTheme.bodySmall),
          SizedBox(height: spacing.md),
          AsyncValueView(
            value: events,
            onRetry: () => ref.invalidate(commonEventsProvider(userId)),
            loading: const LoadingView(itemCount: 1),
            data: (events) => events.isEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(l10n.startCrewNoEvents(name)),
                      SizedBox(height: spacing.sm),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          parent.go(AppRoutes.events);
                        },
                        child: Text(l10n.discoverGoToEvents),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      for (final event in events)
                        Padding(
                          padding: EdgeInsets.only(bottom: spacing.sm),
                          child: GlassCard(
                            padding: EdgeInsets.zero,
                            child: ListTile(
                              leading: Icon(
                                Icons.nightlife_rounded,
                                color: context.colors.cyan,
                              ),
                              title: Text(event.name),
                              subtitle: Text(
                                DateFormat(
                                  "EEE, d 'de' MMM · HH:mm",
                                  'pt_BR',
                                ).format(event.startsAt.toLocal()),
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                Navigator.pop(context);
                                unawaited(
                                  parent.push(
                                    AppRoutes.newCrew(
                                      eventId: event.id,
                                      eventName: event.name,
                                      inviteUserId: userId,
                                      inviteName: name,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
