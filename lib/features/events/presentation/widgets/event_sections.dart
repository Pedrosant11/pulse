import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/features/ads/domain/ad_models.dart';
import 'package:pulse/features/ads/domain/with_ads.dart';
import 'package:pulse/features/ads/presentation/ads_providers.dart';
import 'package:pulse/features/ads/presentation/widgets/sponsored_slot.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/events/presentation/widgets/event_visuals.dart';

/// On top of "Próximos": the paid highlights ("Em destaque", big cards in
/// the daily rotation), then rows of small cards (das casas que você segue,
/// em alta, esta semana). Ads follow the list's rule in every carousel: one
/// after every N parties, or one at the end when there are fewer.
class EventSectionsView extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final sections = ref.watch(eventSectionsProvider).value;
    if (sections == null || sections.isEmpty) return const SizedBox.shrink();
    final adsEvery = ref.watch(adsReadyProvider(AdPlacement.events))
        ? ref.watch(adsConfigProvider).value?.every(AdPlacement.events) ?? 0
        : 0;
    final rows = [
      (
        l10n.sectionFollowedVenues,
        Icons.storefront_rounded,
        sections.followedVenues,
      ),
      (
        l10n.sectionTrending,
        Icons.local_fire_department_rounded,
        sections.trending,
      ),
      (l10n.sectionThisWeek, Icons.calendar_today_rounded, sections.thisWeek),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (sections.featured.isNotEmpty)
          _FeaturedCarousel(events: sections.featured, adsEvery: adsEvery),
        for (final (i, (title, icon, events)) in rows.indexed)
          if (events.isNotEmpty)
            _Row(
              title: title,
              icon: icon,
              events: events,
              adsEvery: adsEvery,
              // Each carousel starts at a different own ad.
              firstAdTurn: 10 * (i + 1),
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

class _Title extends StatelessWidget {
  const new({required this.title, required this.icon, this.color});

  final String title;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: context.spacing.md),
    child: Row(
      children: [
        Icon(icon, size: 18, color: color ?? context.colors.magenta),
        SizedBox(width: context.spacing.xs),
        Text(title.toUpperCase(), style: context.textTheme.titleMedium),
      ],
    ),
  );
}

/// "Em destaque": one big card at a time, swiping sideways.
class _FeaturedCarousel extends StatefulWidget {
  const new({required this.events, required this.adsEvery});

  final List<SectionEvent> events;
  final int adsEvery;

  @override
  State<_FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<_FeaturedCarousel> {
  final _pages = PageController(viewportFraction: 0.88);
  int _page = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final items = withAds(widget.events, widget.adsEvery);
    return Padding(
      padding: EdgeInsets.only(top: spacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Title(
            title: context.l10n.sectionFeatured,
            icon: Icons.rocket_launch_rounded,
            color: colors.lime,
          ),
          SizedBox(height: spacing.xs),
          SizedBox(
            height: 262,
            child: PageView.builder(
              controller: _pages,
              padEnds: false,
              itemCount: items.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, i) {
                final (:item, :ad) = items[i];
                return Padding(
                  padding: EdgeInsets.only(
                    left: i == 0 ? spacing.md : spacing.xs,
                    right: spacing.xs,
                  ),
                  child: item == null
                      ? SponsoredSlot(
                          placement: AdPlacement.events,
                          index: ad!,
                          expand: true,
                          compact: true,
                        )
                      : _FeaturedCard(event: item),
                );
              },
            ),
          ),
          if (items.length > 1) ...[
            SizedBox(height: spacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < items.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == _page ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: i == _page ? colors.lime : colors.textSecondary,
                      borderRadius: BorderRadius.circular(context.radii.pill),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const new({required this.event});

  final SectionEvent event;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final start = event.startsAt.toLocal();
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(context.radii.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.eventDetail(event.id)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  EventCover(coverPath: event.coverPath, seed: event.id),
                  Positioned(
                    left: spacing.sm,
                    top: spacing.sm,
                    child: StatusPill(
                      label: l10n.eventFeatured,
                      color: colors.lime,
                    ),
                  ),
                ],
              ),
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
                    style: context.textTheme.titleMedium,
                  ),
                  Text(
                    '${formatEventDate(context, start)} · ${event.venueName}',
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
    );
  }
}

class _Row extends StatelessWidget {
  const new({
    required this.title,
    required this.icon,
    required this.events,
    required this.adsEvery,
    required this.firstAdTurn,
  });

  final String title;
  final IconData icon;
  final List<SectionEvent> events;
  final int adsEvery;
  final int firstAdTurn;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final items = withAds(events, adsEvery, firstTurn: firstAdTurn);
    return Padding(
      padding: EdgeInsets.only(top: spacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Title(title: title, icon: icon),
          SizedBox(height: spacing.xs),
          SizedBox(
            height: 182,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: spacing.md),
              itemCount: items.length,
              separatorBuilder: (_, _) => SizedBox(width: spacing.sm),
              itemBuilder: (context, i) {
                final (:item, :ad) = items[i];
                return SizedBox(
                  width: 200,
                  child: item == null
                      ? SponsoredSlot(
                          placement: AdPlacement.events,
                          index: ad!,
                          compact: true,
                        )
                      : _MiniCard(event: item),
                );
              },
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
    return Material(
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
    );
  }
}
