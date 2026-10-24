import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/features/chat/presentation/widgets/chat_avatar.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';

/// The party's night and the day after, for who is going:
///   * from 6 h before until the end: "Tô ON" and who of my people is ON;
///   * for 48 h after: "Veja quem estava lá" ("Depois da festa").
class EventNightSection extends ConsumerWidget {
  const new({required this.event, this.now, super.key});

  final EventDetail event;

  /// For tests.
  final DateTime? now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (event.status != EventStatus.approved) return const SizedBox.shrink();
    final going = ref.watch(isAttendingProvider(event.id)).value ?? false;
    if (!going) return const SizedBox.shrink();
    final now = this.now ?? DateTime.now();
    final opensAt = event.startsAt.subtract(const Duration(hours: 6));
    final afterUntil = event.endsAt.add(const Duration(hours: 48));
    if (!now.isBefore(opensAt) && now.isBefore(event.endsAt)) {
      return _OnCard(event: event);
    }
    if (!now.isBefore(event.endsAt) && now.isBefore(afterUntil)) {
      return _AfterPartyCard(event: event);
    }
    return const SizedBox.shrink();
  }
}

class _OnCard extends ConsumerWidget {
  const new({required this.event});

  final EventDetail event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final on = ref.watch(isOnProvider(event.id)).value ?? false;
    final people = ref.watch(eventOnPeopleProvider(event.id)).value ?? const [];
    final busy = ref.watch(eventNightEditorProvider).isLoading;

    return GlassCard(
      borderGradient: on ? colors.primaryGradient : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.nightlife_rounded,
                color: on ? colors.lime : colors.textSecondary,
              ),
              SizedBox(width: spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.onTitle, style: context.textTheme.titleSmall),
                    Text(l10n.onHint, style: context.textTheme.bodySmall),
                  ],
                ),
              ),
              Switch(
                value: on,
                activeThumbColor: colors.lime,
                onChanged: busy
                    ? null
                    : (v) => ref
                          .read(eventNightEditorProvider.notifier)
                          .setOn(event.id, on: v),
              ),
            ],
          ),
          if (people.isNotEmpty) ...[
            SizedBox(height: spacing.sm),
            Row(
              children: [
                SizedBox(
                  width: 28.0 + (people.take(4).length - 1) * 20,
                  height: 28,
                  child: Stack(
                    children: [
                      for (final (i, person) in people.take(4).indexed)
                        Positioned(
                          left: i * 20.0,
                          child: ChatAvatar(
                            photoPath: person.photoPath,
                            size: 28,
                            ring: colors.lime,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: spacing.sm),
                Expanded(
                  child: Text(
                    _names(context, people),
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: colors.lime,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _names(BuildContext context, List<OnPerson> people) {
    final l10n = context.l10n;
    final first = people.first.firstName;
    return switch (people.length) {
      1 => l10n.onPeopleOne(first),
      2 => l10n.onPeopleTwo(first, people[1].firstName),
      _ => l10n.onPeopleMore(first, people.length - 1),
    };
  }
}

class _AfterPartyCard extends StatelessWidget {
  const new({required this.event});

  final EventDetail event;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    return InkWell(
      borderRadius: BorderRadius.circular(context.radii.lg),
      onTap: () => context.push(AppRoutes.afterParty(event.id)),
      child: GlassCard(
        borderGradient: colors.primaryGradient,
        child: Row(
          children: [
            Icon(Icons.favorite_rounded, color: colors.magenta),
            SizedBox(width: spacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.afterPartyCardTitle,
                    style: context.textTheme.titleSmall,
                  ),
                  Text(
                    l10n.afterPartyCardBody,
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: colors.magenta),
          ],
        ),
      ),
    );
  }
}
