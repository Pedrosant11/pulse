import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/models/user_role.dart';
import 'package:pulse/core/widgets/text_with_badge.dart';
import 'package:pulse/features/events/data/events_repository.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/l10n/app_localizations.dart';

extension EventLabels on AppLocalizations {
  String eventStatus(EventStatus status) => switch (status) {
    EventStatus.pending => statusPending,
    EventStatus.approved => statusApproved,
    EventStatus.rejected => statusRejected,
    EventStatus.cancelled => statusCancelled,
  };

  String role(UserRole role) => switch (role) {
    UserRole.user => roleUser,
    UserRole.curator => roleCurator,
    UserRole.producer => roleProducer,
    UserRole.admin => roleAdmin,
  };
}

/// "sex., 10 de out. · 23:00" in the device's time zone.
String formatEventDate(BuildContext context, DateTime start) {
  final local = start.toLocal();
  final day = DateFormat("EEE, d 'de' MMM", 'pt_BR').format(local);
  final time = MaterialLocalizations.of(
    context,
  ).formatTimeOfDay(TimeOfDay.fromDateTime(local), alwaysUse24HourFormat: true);
  return '$day · $time';
}

/// Public cover from the `event-covers` bucket, or a neon gradient.
class EventCover extends ConsumerWidget {
  const new({required this.coverPath, this.seed = '', super.key});

  final String? coverPath;

  /// Varies the placeholder gradient per event.
  final String seed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final placeholder = DecoratedBox(
      decoration: BoxDecoration(
        gradient: seed.hashCode.isEven
            ? colors.primaryGradient
            : colors.crewGradient,
      ),
      child: Center(
        child: Icon(
          Icons.graphic_eq,
          size: 56,
          color: colors.textPrimary.withValues(alpha: 0.5),
        ),
      ),
    );
    final path = coverPath;
    if (path == null) return placeholder;
    return CachedNetworkImage(
      imageUrl: ref.watch(eventsRepositoryProvider).coverUrl(path),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (_, _) => placeholder,
      errorWidget: (_, _, _) => placeholder,
    );
  }
}

class StatusPill extends StatelessWidget {
  const new({required this.label, required this.color, super.key});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(context.radii.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        child: Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(color: color),
        ),
      ),
    );
  }
}

/// Big list card (SPEC 7.3): cover, highlighted date, "X pessoas vão".
class EventCard extends StatelessWidget {
  const new({required this.event, required this.onTap, super.key});

  final EventListEntry event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = BorderRadius.circular(context.radii.lg);
    final start = event.startsAt.toLocal();
    final distance = event.distanceKm;

    final statusPill = switch (event.status) {
      EventStatus.pending => StatusPill(
        label: l10n.statusPending,
        color: colors.lime,
      ),
      EventStatus.rejected => StatusPill(
        label: l10n.statusRejected,
        color: colors.error,
      ),
      EventStatus.cancelled => StatusPill(
        label: l10n.statusCancelled,
        color: colors.textSecondary,
      ),
      EventStatus.approved => null,
    };

    return Semantics(
      button: true,
      label: '${event.name}, ${formatEventDate(context, event.startsAt)}',
      child: Material(
        color: colors.surface,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    EventCover(coverPath: event.coverPath, seed: event.id),
                    // Date badge.
                    Positioned(
                      left: spacing.sm,
                      top: spacing.sm,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.background.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(context.radii.md),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: spacing.sm,
                            vertical: spacing.xs,
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${start.day}',
                                style: context.textTheme.headlineSmall,
                              ),
                              Text(
                                DateFormat.MMM('pt_BR')
                                    .format(start)
                                    .replaceAll('.', '')
                                    .toUpperCase(),
                                style: context.textTheme.labelSmall?.copyWith(
                                  color: colors.magenta,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Featured by the producer (paid highlight).
                    if (event.isFeatured)
                      Positioned(
                        left: spacing.sm,
                        bottom: spacing.sm,
                        child: StatusPill(
                          label: l10n.eventFeatured,
                          color: colors.lime,
                        ),
                      ),
                    if (statusPill != null || event.isGoing)
                      Positioned(
                        right: spacing.sm,
                        top: spacing.sm,
                        child:
                            statusPill ??
                            StatusPill(
                              label: l10n.attendingButton,
                              color: colors.magenta,
                            ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(spacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWithBadge(
                      event.name,
                      maxLines: 2,
                      style: context.textTheme.titleLarge,
                      badge: event.isOfficial
                          ? Icon(
                              Icons.verified,
                              size: 18,
                              color: colors.lime,
                              semanticLabel: l10n.eventOfficial,
                            )
                          : null,
                    ),
                    SizedBox(height: spacing.xxs),
                    Text(
                      [
                        formatEventDate(context, event.startsAt),
                        event.venueName,
                      ].join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodySmall,
                    ),
                    SizedBox(height: spacing.xs),
                    Row(
                      children: [
                        Icon(
                          Icons.groups_2_outlined,
                          size: 16,
                          color: colors.cyan,
                        ),
                        SizedBox(width: spacing.xxs),
                        Expanded(
                          child: Text(
                            l10n.goingCount(event.goingCount),
                            style: context.textTheme.labelMedium?.copyWith(
                              color: colors.cyan,
                            ),
                          ),
                        ),
                        Text(
                          distance == null
                              ? event.city
                              : [
                                  event.city,
                                  l10n.distanceKm(distance.round()),
                                ].join(' · '),
                          style: context.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
