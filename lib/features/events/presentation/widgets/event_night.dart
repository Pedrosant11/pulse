import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/errors/app_failure_message.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/features/chat/presentation/widgets/chat_avatar.dart';
import 'package:pulse/features/events/domain/check_in.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/profile/data/location_repository.dart';

/// The party's night and the day after:
///   * from 1 h before until the end, for anyone: the check-in (GPS or the
///     producer's QR), which also marks "Eu vou";
///   * from 6 h before until the end, for who is going: "Tô ON" and who of
///     my people is ON;
///   * for 48 h after, for who went: "Veja quem estava lá".
class EventNightSection extends ConsumerWidget {
  const new({required this.event, this.now, super.key});

  final EventDetail event;

  /// For tests.
  final DateTime? now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (event.status != EventStatus.approved) return const SizedBox.shrink();
    final going = ref.watch(isAttendingProvider(event.id)).value ?? false;
    final now = this.now ?? DateTime.now();
    final opensAt = event.startsAt.subtract(const Duration(hours: 6));
    final afterUntil = event.endsAt.add(const Duration(hours: 48));
    final checkIn = checkInOpen(
      startsAt: event.startsAt,
      endsAt: event.endsAt,
      now: now,
    );
    final on = going && !now.isBefore(opensAt) && now.isBefore(event.endsAt);
    final after =
        going && !now.isBefore(event.endsAt) && now.isBefore(afterUntil);
    final cards = [
      if (checkIn) _CheckInCard(event: event),
      if (on) _OnCard(event: event),
      if (after) _AfterPartyCard(event: event),
    ];
    if (cards.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: context.spacing.sm,
      children: cards,
    );
  }
}

class _CheckInCard extends ConsumerWidget {
  const new({required this.event});

  final EventDetail event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final at = ref.watch(myCheckInProvider(event.id)).value;
    final busy = ref.watch(checkInEditorProvider).isLoading;

    if (at != null) {
      return GlassCard(
        borderGradient: colors.primaryGradient,
        child: Row(
          children: [
            Icon(Icons.where_to_vote_rounded, color: colors.lime),
            SizedBox(width: spacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.checkInDone(
                      DateFormat.Hm('pt_BR').format(at.toLocal()),
                    ),
                    style: context.textTheme.titleSmall,
                  ),
                  Text(
                    l10n.checkInDoneHint,
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.where_to_vote_outlined, color: colors.lime),
              SizedBox(width: spacing.sm),
              Text(l10n.checkInTitle, style: context.textTheme.titleSmall),
            ],
          ),
          SizedBox(height: spacing.xs),
          Text(l10n.checkInHint, style: context.textTheme.bodySmall),
          SizedBox(height: spacing.sm),
          Row(
            spacing: spacing.sm,
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: busy ? null : () => _byGps(context, ref),
                  icon: busy
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location_rounded),
                  label: Text(l10n.checkInGps),
                ),
              ),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: busy ? null : () => _byQr(context, ref),
                  icon: const Icon(Icons.qr_code_scanner_rounded),
                  label: Text(l10n.checkInScan),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _byGps(BuildContext context, WidgetRef ref) async {
    final ok = await ref.read(checkInEditorProvider.notifier).byGps(event.id);
    if (context.mounted) _report(context, ref, ok);
  }

  Future<void> _byQr(BuildContext context, WidgetRef ref) async {
    final code = await context.push<String>(AppRoutes.checkInScan(event.id));
    if (code == null || !context.mounted) return;
    final ok = await ref
        .read(checkInEditorProvider.notifier)
        .byQr(event.id, code);
    if (context.mounted) _report(context, ref, ok);
  }

  void _report(BuildContext context, WidgetRef ref, bool? ok) {
    final l10n = context.l10n;
    final String message;
    if (ok ?? false) {
      message = l10n.checkInSuccess;
    } else {
      final error = ref.read(checkInEditorProvider).error;
      if (error == null) return;
      message = switch (error) {
        LocationUnavailable(reason: LocationFailureReason.serviceDisabled) =>
          l10n.locationDisabled,
        LocationUnavailable() => l10n.locationDenied,
        _ => friendlyErrorMessage(error, l10n),
      };
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
