import 'dart:async';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/ads/domain/ad_models.dart';
import 'package:pulse/features/ads/presentation/ads_providers.dart';
import 'package:pulse/features/ads/presentation/widgets/sponsored_slot.dart';
import 'package:pulse/features/events/data/events_repository.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/events/presentation/widgets/event_visuals.dart';
import 'package:pulse/features/events/presentation/widgets/events_map_view.dart';
import 'package:pulse/features/profile/domain/profile_enums.dart';
import 'package:pulse/features/profile/presentation/profile_labels.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/features/profile/presentation/widgets/choice_chip_group.dart';

/// Events tab (SPEC 7.3): "Próximos" (within the radius, or nationwide name
/// search) and "Meus eventos".
class EventsScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventsScreen> {
  // Approvals/attendance can change elsewhere: refresh when the app comes
  // back to the foreground.
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onResume: () => ref.invalidate(eventListProvider),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final role = ref.watch(currentRoleProvider);
    final view = ref.watch(eventsViewProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: AppBar(
          title: Text(l10n.eventsTitle.toUpperCase()),
          actions: [
            // List / map of "Próximos" (SPEC 7.4).
            Builder(
              builder: (context) => IconButton(
                tooltip: view == EventsViewMode.list
                    ? l10n.eventsViewMap
                    : l10n.eventsViewList,
                icon: Icon(
                  view == EventsViewMode.list
                      ? Icons.map_outlined
                      : Icons.view_agenda_outlined,
                ),
                onPressed: () {
                  ref.read(eventsViewProvider.notifier).toggle();
                  DefaultTabController.of(context).animateTo(0);
                },
              ),
            ),
            if (role.isModerator)
              IconButton(
                tooltip: l10n.moderationQueue,
                icon: const Icon(Icons.fact_check_outlined),
                onPressed: () => context.push(AppRoutes.eventQueue),
              ),
            IconButton(
              tooltip: role.createsApprovedEvents
                  ? l10n.createEvent
                  : l10n.suggestEvent,
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => context.push(AppRoutes.newEvent),
            ),
          ],
          bottom: TabBar(
            indicatorColor: context.colors.magenta,
            labelStyle: context.textTheme.labelLarge,
            tabs: [
              Tab(text: l10n.eventsTabUpcoming),
              Tab(text: l10n.eventsTabMine),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _EventList(scope: EventListScope.nearby),
            _EventList(scope: EventListScope.mine),
          ],
        ),
      ),
    );
  }
}

/// Events with an ad (its turn number) after every [every] events. A list
/// shorter than that still gets one ad, at the end.
@visibleForTesting
List<({EventListEntry? event, int? ad})> eventsWithAds(
  List<EventListEntry> events,
  int every,
) {
  final items = <({EventListEntry? event, int? ad})>[];
  var ads = 0;
  for (final (i, event) in events.indexed) {
    items.add((event: event, ad: null));
    if ((i + 1) % every == 0) items.add((event: null, ad: ads++));
  }
  if (ads == 0) items.add((event: null, ad: 0));
  return items;
}

class _EventList extends ConsumerWidget {
  const new({required this.scope});

  final EventListScope scope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final events = ref.watch(eventListProvider(scope));
    final filters = ref.watch(eventListFiltersProvider);
    final nearby = scope == EventListScope.nearby;
    if (nearby && ref.watch(eventsViewProvider) == EventsViewMode.map) {
      return const Column(
        children: [
          _NearbyFilters(),
          Expanded(child: EventsMapView()),
        ],
      );
    }
    // Room for the floating bottom navigation.
    final bottomPadding = MediaQuery.paddingOf(context).bottom + spacing.xl;

    // Ads only in "Próximos".
    final adsEvery =
        ref.watch(adsConfigProvider).value?.every(AdPlacement.events) ?? 0;
    final withAds =
        nearby &&
        adsEvery > 0 &&
        ref.watch(adsReadyProvider(AdPlacement.events));

    Future<void> refresh() async {
      ref.invalidate(eventListProvider(scope));
      await ref.read(eventListProvider(scope).future);
    }

    Widget empty() {
      if (!nearby) {
        return EmptyView(
          icon: Icons.event_available_outlined,
          title: l10n.eventsEmptyMine,
          message: l10n.eventsEmptyMineHint,
          actionLabel: l10n.eventsSeeUpcoming,
          onAction: () => DefaultTabController.of(context).animateTo(0),
        );
      }
      final searching = filters.query.trim().isNotEmpty;
      return EmptyView(
        icon: Icons.travel_explore,
        title: searching ? l10n.eventsEmptySearch : l10n.eventsEmptyNearby,
        message: l10n.eventsEmptyNearbyHint,
        actionLabel: l10n.suggestEvent,
        onAction: () => context.push(AppRoutes.newEvent),
      );
    }

    return RefreshIndicator(
      onRefresh: refresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (nearby) const SliverToBoxAdapter(child: _NearbyFilters()),
          ...events.when(
            loading: () => [const SliverToBoxAdapter(child: LoadingView())],
            error: (error, _) => [
              SliverFillRemaining(
                hasScrollBody: false,
                child: ErrorView(error: error, onRetry: refresh),
              ),
            ],
            data: (events) {
              if (events.isEmpty) {
                return [
                  SliverFillRemaining(hasScrollBody: false, child: empty()),
                ];
              }
              final items = withAds
                  ? eventsWithAds(events, adsEvery)
                  : [for (final e in events) (event: e, ad: null)];
              return [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    spacing.md,
                    spacing.sm,
                    spacing.md,
                    bottomPadding,
                  ),
                  sliver: SliverList.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, _) => SizedBox(height: spacing.md),
                    itemBuilder: (context, i) {
                      final (:event, :ad) = items[i];
                      if (event == null) {
                        return SponsoredSlot(
                          placement: AdPlacement.events,
                          index: ad!,
                        );
                      }
                      final card = EventCard(
                        event: event,
                        onTap: () =>
                            context.push(AppRoutes.eventDetail(event.id)),
                      );
                      return context.reduceMotion || i > 6
                          ? card
                          : card
                                .animate(delay: (50 * i).ms)
                                .fadeIn(duration: 250.ms)
                                .slideY(begin: 0.06);
                    },
                  ),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }
}

class _NearbyFilters extends ConsumerStatefulWidget {
  const new();

  @override
  ConsumerState<_NearbyFilters> createState() => _NearbyFiltersState();
}

class _NearbyFiltersState extends ConsumerState<_NearbyFilters> {
  late final _search = TextEditingController(
    text: ref.read(eventListFiltersProvider).query,
  );
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _update(EventFilters Function(EventFilters current) change) {
    ref
        .read(eventListFiltersProvider.notifier)
        .update(change(ref.read(eventListFiltersProvider)));
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _update((f) => f.copyWith(query: value));
    });
  }

  Future<void> _editRadius(int current) async {
    final l10n = context.l10n;
    var value = current.toDouble();
    final chosen = await showModalBottomSheet<int>(
      context: context,
      useRootNavigator: true,
      backgroundColor: context.colors.surface,
      useSafeArea: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.all(context.spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.eventsRadiusTitle, style: context.textTheme.titleLarge),
              SizedBox(height: context.spacing.xs),
              Text(l10n.eventsRadiusHint(value.round())),
              Slider(
                min: 5,
                max: 100,
                divisions: 19,
                value: value,
                label: l10n.distanceKm(value.round()),
                onChanged: (v) => setSheetState(() => value = v),
              ),
              NeonButton(
                label: l10n.saveButton,
                onPressed: () => Navigator.pop(context, value.round()),
              ),
            ],
          ),
        ),
      ),
    );
    if (chosen == null || chosen == current) return;
    await ref.read(profileEditorProvider.notifier).save({
      'discovery_radius_km': chosen,
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final colors = context.colors;
    final filters = ref.watch(eventListFiltersProvider);
    final profile = ref.watch(myProfileProvider).value;
    final searching = filters.query.trim().isNotEmpty;
    final radius = profile?.discoveryRadiusKm ?? 50;

    return Padding(
      padding: EdgeInsets.fromLTRB(spacing.md, spacing.md, spacing.md, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _search,
            onChanged: _onSearchChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: l10n.eventsSearchHint,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searching
                  ? IconButton(
                      tooltip: l10n.cancel,
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _search.clear();
                        _update((f) => f.copyWith(query: ''));
                      },
                    )
                  : null,
            ),
          ),
          SizedBox(height: spacing.xs),
          Align(
            alignment: Alignment.centerLeft,
            child: searching
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: spacing.sm),
                    child: Text(
                      l10n.eventsSearchNationwide,
                      style: context.textTheme.labelMedium?.copyWith(
                        color: colors.cyan,
                      ),
                    ),
                  )
                : TextButton.icon(
                    onPressed: profile == null
                        ? null
                        : () => _editRadius(radius),
                    icon: Icon(Icons.near_me_outlined, color: colors.magenta),
                    label: Text(
                      l10n.eventsRadiusLabel(radius, profile?.city ?? '—'),
                    ),
                  ),
          ),
          ChoiceChipGroup<EventDateRange>(
            options: EventDateRange.values,
            selected: {filters.dateRange},
            labelOf: (range) => switch (range) {
              EventDateRange.any => l10n.filterAnyDate,
              EventDateRange.today => l10n.filterToday,
              EventDateRange.weekend => l10n.filterWeekend,
              EventDateRange.next30Days => l10n.filter30Days,
            },
            onChanged: (value) => _update(
              (f) => f.copyWith(
                dateRange: value.isEmpty ? EventDateRange.any : value.first,
              ),
            ),
          ),
          SizedBox(height: spacing.sm),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: MusicGenre.values.length,
              separatorBuilder: (_, _) => SizedBox(width: spacing.xs),
              itemBuilder: (context, i) {
                final genre = MusicGenre.values[i];
                return ChoiceChipGroup<MusicGenre>(
                  options: [genre],
                  selected: filters.genres,
                  multiple: true,
                  accent: colors.cyan,
                  labelOf: l10n.genre,
                  onChanged: (_) => _update((f) {
                    final genres = {...f.genres};
                    genres.contains(genre)
                        ? genres.remove(genre)
                        : genres.add(genre);
                    return f.copyWith(genres: genres);
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
