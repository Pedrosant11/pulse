import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/features/chat/presentation/widgets/chat_avatar.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';

/// "Modo Hoje" on the party night: check in, see how many people are there
/// and which matches and crew mates arrived. Shown from 2 h before the
/// start until 2 h after the end. Honour-based: no location is used.
class TonightCard extends ConsumerWidget {
  const new({required this.event, super.key});

  final EventDetail event;

  static bool isTonight(EventDetail event, DateTime now) =>
      now.isAfter(event.startsAt.subtract(const Duration(hours: 2))) &&
      now.isBefore(event.endsAt.add(const Duration(hours: 2)));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final checkedIn = ref.watch(isCheckedInProvider(event.id)).value ?? false;
    final count = ref.watch(hereCountProvider(event.id)).value ?? 0;
    final editor = ref.watch(checkInEditorProvider);
    final notifier = ref.read(checkInEditorProvider.notifier);
    final canCheckIn = DateTime.now().isBefore(event.endsAt);

    return GlassCard(
      borderGradient: colors.primaryGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.local_fire_department_rounded, color: colors.magenta),
              SizedBox(width: spacing.sm),
              Expanded(
                child: Text(
                  checkedIn ? l10n.tonightCheckedIn : l10n.tonightTitle,
                  style: context.textTheme.titleMedium,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.xs),
          Text(
            l10n.tonightHereCount(count),
            style: context.textTheme.bodySmall,
          ),
          SizedBox(height: spacing.sm),
          FormErrorText(error: editor.error),
          if (checkedIn) ...[
            _Friends(eventId: event.id),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: editor.isLoading
                    ? null
                    : () => notifier.setCheckedIn(event.id, checkedIn: false),
                child: Text(l10n.tonightCheckOut),
              ),
            ),
          ] else if (canCheckIn) ...[
            NeonButton(
              label: l10n.tonightCheckIn,
              icon: Icons.where_to_vote_rounded,
              isLoading: editor.isLoading,
              onPressed: () => notifier.setCheckedIn(event.id, checkedIn: true),
            ),
            SizedBox(height: spacing.xs),
            Text(l10n.tonightCheckInHint, style: context.textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}

class _Friends extends ConsumerWidget {
  const new({required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final friends = ref.watch(hereFriendsProvider(eventId)).value ?? const [];
    if (friends.isEmpty) {
      return Text(l10n.tonightNoFriends, style: context.textTheme.bodySmall);
    }
    return SizedBox(
      // Avatar + name + relation, with room for larger text sizes.
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: friends.length,
        separatorBuilder: (_, _) => SizedBox(width: spacing.md),
        itemBuilder: (_, index) {
          final friend = friends[index];
          final ring = friend.isCrew ? colors.cyan : colors.magenta;
          return Column(
            children: [
              ChatAvatar(photoPath: friend.photoPath, size: 52, ring: ring),
              SizedBox(height: spacing.xxs),
              Text(friend.firstName, style: context.textTheme.labelMedium),
              Text(
                friend.isCrew ? l10n.tonightCrewMate : l10n.tonightMatch,
                style: context.textTheme.labelSmall?.copyWith(color: ring),
              ),
            ],
          );
        },
      ),
    );
  }
}
