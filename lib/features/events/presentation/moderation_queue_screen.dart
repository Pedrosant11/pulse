import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/events/presentation/widgets/event_visuals.dart';
import 'package:pulse/features/venues/presentation/venues_providers.dart';
import 'package:pulse/features/venues/presentation/widgets/venue_widgets.dart';

/// Pending suggestions for curators/admins (SPEC 7.3). Approve/reject and
/// edit happen on the event detail screen.
class ModerationQueueScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final pending = ref.watch(pendingEventsProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(l10n.moderationQueue.toUpperCase())),
      body: SafeArea(
        child: Column(
          children: [
            const _PendingVenues(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref
                    ..invalidate(pendingVenuesProvider)
                    ..invalidate(pendingEventsProvider);
                  await ref.read(pendingEventsProvider.future);
                },
                child: AsyncValueView(
                  value: pending,
                  onRetry: () => ref.invalidate(pendingEventsProvider),
                  data: (events) => events.isEmpty
                      ? ListView(
                          children: [
                            EmptyView(
                              icon: Icons.fact_check_outlined,
                              title: l10n.queueEmpty,
                            ),
                          ],
                        )
                      : ListView.separated(
                          padding: EdgeInsets.all(spacing.md),
                          itemCount: events.length,
                          separatorBuilder: (_, _) =>
                              SizedBox(height: spacing.sm),
                          itemBuilder: (context, i) {
                            final event = events[i];
                            return Material(
                              color: context.colors.surface,
                              borderRadius: BorderRadius.circular(
                                context.radii.md,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: ListTile(
                                leading: SizedBox(
                                  width: 64,
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: EventCover(
                                      coverPath: event.coverPath,
                                      seed: event.id,
                                    ),
                                  ),
                                ),
                                title: Text(event.name),
                                subtitle: Text(
                                  [
                                    formatEventDate(context, event.startsAt),
                                    [
                                      event.venueName,
                                      '${event.city}, ${event.state}',
                                    ].join(' · '),
                                  ].join('\n'),
                                ),
                                isThreeLine: true,
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () => context.push(
                                  AppRoutes.eventDetail(event.id),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Casas suggested by producers, waiting for the curators.
class _PendingVenues extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final venues = ref.watch(pendingVenuesProvider).value ?? const [];
    if (venues.isEmpty) return const SizedBox.shrink();
    final spacing = context.spacing;
    return Padding(
      padding: EdgeInsets.fromLTRB(spacing.md, spacing.md, spacing.md, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.venuesPending(venues.length),
            style: context.textTheme.titleMedium,
          ),
          SizedBox(height: spacing.xs),
          for (final venue in venues)
            Padding(
              padding: EdgeInsets.only(bottom: spacing.xs),
              child: Material(
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(context.radii.md),
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  leading: SizedBox(
                    width: 48,
                    height: 48,
                    child: VenuePhoto(photoPath: venue.photoPath, iconSize: 20),
                  ),
                  title: Text(venue.name),
                  subtitle: Text('${venue.city}, ${venue.state}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.venue(venue.id)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
