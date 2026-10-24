import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/events/presentation/widgets/event_visuals.dart';

/// Rows of small cards on top of "Próximos": em alta, esta semana and das
/// casas que você segue. Nothing while loading or when all are empty.
class EventSectionsView extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final sections = ref.watch(eventSectionsProvider).value;
    if (sections == null || sections.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (sections.followedVenues.isNotEmpty)
          _Row(
            title: l10n.sectionFollowedVenues,
            icon: Icons.storefront_rounded,
            events: sections.followedVenues,
          ),
        if (sections.trending.isNotEmpty)
          _Row(
            title: l10n.sectionTrending,
            icon: Icons.local_fire_department_rounded,
            events: sections.trending,
          ),
        if (sections.thisWeek.isNotEmpty)
          _Row(
            title: l10n.sectionThisWeek,
            icon: Icons.calendar_today_rounded,
            events: sections.thisWeek,
          ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            context.spacing.md,
            context.spacing.sm,
            context.spacing.md,
            0,
          ),
          child: Text(
            l10n.sectionAllUpcoming.toUpperCase(),
            style: context.textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const new({required this.title, required this.icon, required this.events});

  final String title;
  final IconData icon;
  final List<SectionEvent> events;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final colors = context.colors;
    return Padding(
      padding: EdgeInsets.only(top: spacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.md),
            child: Row(
              children: [
                Icon(icon, size: 18, color: colors.magenta),
                SizedBox(width: spacing.xs),
                Text(title.toUpperCase(), style: context.textTheme.titleMedium),
              ],
            ),
          ),
          SizedBox(height: spacing.xs),
          SizedBox(
            height: 182,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: spacing.md),
              itemCount: events.length,
              separatorBuilder: (_, _) => SizedBox(width: spacing.sm),
              itemBuilder: (context, i) => _MiniCard(event: events[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  const new({required this.event});

  final SectionEvent event;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final start = event.startsAt.toLocal();
    return SizedBox(
      width: 200,
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(context.radii.lg),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push(AppRoutes.eventDetail(event.id)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
                width: double.infinity,
                child: EventCover(coverPath: event.coverPath, seed: event.id),
              ),
              Padding(
                padding: EdgeInsets.all(spacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleSmall,
                    ),
                    Text(
                      '${DateFormat("EEE, d 'de' MMM", 'pt_BR').format(start)}'
                      ' · ${event.venueName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodySmall,
                    ),
                    if (event.goingCount > 0)
                      Text(
                        l10n.goingCount(event.goingCount),
                        style: context.textTheme.labelSmall?.copyWith(
                          color: colors.cyan,
                        ),
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
