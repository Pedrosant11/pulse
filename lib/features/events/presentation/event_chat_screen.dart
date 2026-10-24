import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/errors/app_failure_message.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/core/widgets/text_with_badge.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/chat/presentation/widgets/chat_avatar.dart';
import 'package:pulse/features/events/domain/event_chat.dart';
import 'package:pulse/features/events/presentation/event_chat_providers.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/safety/domain/safety_models.dart';
import 'package:pulse/features/safety/presentation/safety_actions.dart';

/// "Chat da festa": everyone going to the party, live.
class EventChatScreen extends ConsumerStatefulWidget {
  const new({required this.eventId, super.key});

  final String eventId;

  @override
  ConsumerState<EventChatScreen> createState() => _EventChatScreenState();
}

class _EventChatScreenState extends ConsumerState<EventChatScreen> {
  final _input = TextEditingController();

  String get _eventId => widget.eventId;

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _showError(Object? error) {
    if (error == null || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(friendlyErrorMessage(error, context.l10n))),
    );
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    final editor = ref.read(eventChatEditorProvider.notifier);
    final ok = await editor.send(_eventId, text);
    if (!mounted) return;
    if (ok ?? false) {
      _input.clear();
      setState(() {});
    } else {
      _showError(ref.read(eventChatEditorProvider).error);
      ref.invalidate(eventChatInfoProvider(_eventId));
    }
  }

  Future<void> _actions(EventChatMessage message, EventChatInfo info) async {
    final l10n = context.l10n;
    final mine = message.senderId == ref.read(currentUserIdProvider);
    final choice = await showModalBottomSheet<_Action>(
      context: context,
      useRootNavigator: true,
      backgroundColor: context.colors.surface,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (mine || info.canModerate)
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded),
                title: Text(l10n.chatDeleteMessage),
                onTap: () => Navigator.pop(context, _Action.delete),
              ),
            if (!mine)
              ListTile(
                leading: const Icon(Icons.flag_outlined),
                title: Text(l10n.eventChatReport),
                onTap: () => Navigator.pop(context, _Action.report),
              ),
            if (!mine && info.canModerate && !message.isTeam)
              ListTile(
                leading: const Icon(Icons.volume_off_outlined),
                title: Text(l10n.eventChatMute),
                onTap: () => Navigator.pop(context, _Action.mute),
              ),
          ],
        ),
      ),
    );
    if (choice == null || !mounted) return;
    final editor = ref.read(eventChatEditorProvider.notifier);
    switch (choice) {
      case _Action.delete:
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.chatDeleteTitle),
            content: Text(l10n.eventChatDeleteBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.chatDeleteMessage),
              ),
            ],
          ),
        );
        if (confirmed != true) return;
        if (await editor.delete(_eventId, message.id) == null) {
          _showError(ref.read(eventChatEditorProvider).error);
        }
      case _Action.report:
        if (!mounted) return;
        await showReportSheet(
          context,
          target: ReportTarget.message,
          targetId: message.id,
          userId: message.senderId,
          userName: message.firstName,
        );
        // A block hides their messages right away.
        await ref.read(eventChatProvider(_eventId).notifier).refresh();
      case _Action.mute:
        if (await editor.mute(_eventId, message.senderId) ?? false) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.eventChatMuteDone(message.firstName))),
          );
        } else {
          _showError(ref.read(eventChatEditorProvider).error);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final event = ref.watch(eventDetailProvider(_eventId)).value;
    final info = ref.watch(eventChatInfoProvider(_eventId)).value;
    final chat = ref.watch(eventChatProvider(_eventId));
    final busy = ref.watch(eventChatEditorProvider).isLoading;
    final me = ref.watch(currentUserIdProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.eventChatTitle.toUpperCase()),
            if (event != null)
              Text(
                info == null
                    ? event.name
                    : '${event.name} · ${l10n.eventChatPeople(info.people)}',
                style: context.textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AsyncValueView(
                value: chat,
                onRetry: () => ref.invalidate(eventChatProvider(_eventId)),
                data: (view) => _Messages(
                  view: view,
                  me: me,
                  onLoadOlder: () => ref
                      .read(eventChatProvider(_eventId).notifier)
                      .loadOlder(),
                  onLongPress: info == null
                      ? null
                      : (message) => _actions(message, info),
                ),
              ),
            ),
            if (info != null && !info.canWrite)
              Padding(
                padding: EdgeInsets.all(spacing.md),
                child: Text(
                  info.muted
                      ? l10n.eventChatMuted
                      : info.state == EventChatState.readOnly
                      ? l10n.eventChatReadOnly
                      : l10n.eventChatJoinHint,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodySmall,
                ),
              )
            else
              Padding(
                padding: EdgeInsets.fromLTRB(
                  spacing.sm,
                  spacing.xs,
                  spacing.sm,
                  spacing.sm,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _input,
                        minLines: 1,
                        maxLines: 4,
                        maxLength: eventChatMaxLength,
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: l10n.eventChatInputHint,
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              context.radii.lg,
                            ),
                            borderSide: BorderSide(color: colors.glassBorder),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: spacing.xs),
                    IconButton.filled(
                      tooltip: l10n.chatSend,
                      style: IconButton.styleFrom(backgroundColor: colors.cyan),
                      onPressed: busy || _input.text.trim().isEmpty
                          ? null
                          : _send,
                      icon: const Icon(Icons.send_rounded),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum _Action { delete, report, mute }

class _Messages extends StatelessWidget {
  const new({
    required this.view,
    required this.me,
    required this.onLoadOlder,
    required this.onLongPress,
  });

  final EventChatView view;
  final String? me;
  final VoidCallback onLoadOlder;
  final void Function(EventChatMessage message)? onLongPress;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final messages = view.messages;
    // Newest at the bottom: the list is reversed.
    return ListView(
      reverse: true,
      padding: EdgeInsets.all(spacing.md),
      children: [
        for (final message in messages.reversed)
          _Bubble(
            message: message,
            mine: message.senderId == me,
            onLongPress: onLongPress == null
                ? null
                : () => onLongPress!(message),
          ),
        if (view.hasOlder)
          Center(
            child: TextButton(
              onPressed: onLoadOlder,
              child: Text(l10n.eventChatLoadOlder),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(bottom: spacing.md),
          child: Text(
            messages.isEmpty
                ? '${l10n.eventChatRules}\n\n${l10n.eventChatEmpty}'
                : l10n.eventChatRules,
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

class _Bubble extends StatelessWidget {
  const new({
    required this.message,
    required this.mine,
    required this.onLongPress,
  });

  final EventChatMessage message;
  final bool mine;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final time = formatChatTime(
      context,
      message.createdAt,
      yesterday: l10n.chatYesterday,
    );
    final bubble = Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.sm,
        vertical: spacing.xs,
      ),
      decoration: BoxDecoration(
        color: mine ? colors.surfaceElevated : colors.glassFill,
        borderRadius: BorderRadius.circular(context.radii.md),
        border: Border.all(
          color: message.isTeam ? colors.lime : colors.glassBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!mine)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: TextWithBadge(
                    message.firstName,
                    style: context.textTheme.labelMedium?.copyWith(
                      color: message.isTeam ? colors.lime : colors.cyan,
                    ),
                    badge: message.isVerified
                        ? Icon(
                            Icons.verified,
                            size: 14,
                            color: colors.lime,
                            semanticLabel: l10n.profileVerified,
                          )
                        : null,
                  ),
                ),
                if (message.isTeam) ...[
                  SizedBox(width: spacing.xs),
                  Text(
                    l10n.eventChatTeam.toUpperCase(),
                    style: context.textTheme.labelSmall?.copyWith(
                      color: colors.lime,
                    ),
                  ),
                ],
              ],
            ),
          Text(message.content, style: context.textTheme.bodyMedium),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              time,
              style: context.textTheme.labelSmall?.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );

    return Padding(
      padding: EdgeInsets.only(bottom: spacing.xs),
      child: GestureDetector(
        onLongPress: onLongPress,
        child: Row(
          mainAxisAlignment: mine
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!mine) ...[
              ChatAvatar(photoPath: message.photoPath, size: 32),
              SizedBox(width: spacing.xs),
            ],
            Flexible(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 300),
                child: bubble,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
