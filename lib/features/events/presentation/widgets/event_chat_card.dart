import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/features/chat/presentation/widgets/chat_avatar.dart';
import 'package:pulse/features/events/domain/event_chat.dart';
import 'package:pulse/features/events/presentation/event_chat_providers.dart';

/// Entry to the party's chat on the event page. Who isn't going sees how
/// many are and an invitation to mark "Eu vou".
class EventChatCard extends ConsumerWidget {
  const new({required this.eventId, super.key});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(eventChatInfoProvider(eventId)).value;
    if (info == null || info.state == EventChatState.closed) {
      return const SizedBox.shrink();
    }
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final lastAt = info.lastAt;
    final subtitle = !info.inChat
        ? l10n.eventChatJoinHint
        : lastAt == null
        ? l10n.eventChatCardEmpty
        : l10n.eventChatCardLast(
            info.messages,
            formatChatTime(context, lastAt, yesterday: l10n.chatYesterday),
          );

    return InkWell(
      borderRadius: BorderRadius.circular(context.radii.lg),
      onTap: info.inChat
          ? () => context.push(AppRoutes.eventChat(eventId))
          : null,
      child: GlassCard(
        child: Row(
          children: [
            Icon(Icons.forum_outlined, color: colors.cyan),
            SizedBox(width: spacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    [
                      l10n.eventChatTitle,
                      l10n.eventChatPeople(info.people),
                    ].join(' · '),
                    style: context.textTheme.titleSmall,
                  ),
                  Text(subtitle, style: context.textTheme.bodySmall),
                ],
              ),
            ),
            if (info.inChat)
              Icon(Icons.chevron_right_rounded, color: colors.cyan),
          ],
        ),
      ),
    );
  }
}
