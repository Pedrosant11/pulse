import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/events/presentation/widgets/event_map.dart';
import 'package:pulse/features/events/presentation/widgets/event_visuals.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';

/// "Próximos" on the map (SPEC 7.4): one pin per event (clustered when
/// close), secret locations as an area, and the tapped event as a card.
class EventsMapView extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<EventsMapView> createState() => _EventsMapViewState();
}

class _EventsMapViewState extends ConsumerState<EventsMapView> {
  final _map = MapController();
  String? _selectedId;
  bool _mapReady = false;

  /// Pins framed last, so new filter results are framed again.
  String? _framedPins;

  @override
  void dispose() {
    _map.dispose();
    super.dispose();
  }

  /// Frames every pin once the map has its real size (an initial fit can
  /// run before layout settles and cut pins at the edges).
  void _frame(List<LatLng> points, double bottomInset) {
    final key = points.map((p) => '${p.latitude},${p.longitude}').join(';');
    if (!_mapReady || points.isEmpty || key == _framedPins) return;
    _framedPins = key;
    _map.fitCamera(
      points.length == 1
          ? CameraFit.coordinates(coordinates: points, maxZoom: 14)
          : CameraFit.coordinates(
              coordinates: points,
              padding: EdgeInsets.fromLTRB(56, 72, 56, bottomInset),
              maxZoom: 14,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(eventMapProvider);
    return AsyncValueView(
      value: events,
      onRetry: () => ref.invalidate(eventMapProvider),
      data: (events) => _buildMap(context, events),
    );
  }

  Widget _buildMap(BuildContext context, List<EventListEntry> events) {
    final style = ref.watch(mapStyleProvider);
    final l10n = context.l10n;
    final spacing = context.spacing;
    final colors = context.colors;
    final pinned = [
      for (final e in events)
        if (e.pinLat != null && e.pinLng != null) e,
    ];
    final points = [for (final e in pinned) LatLng(e.pinLat!, e.pinLng!)];
    final profile = ref.watch(myProfileProvider).value;
    final home = profile?.lat != null && profile?.lng != null
        ? LatLng(profile!.lat!, profile.lng!)
        : fallbackMapCenter;
    final selected = pinned.where((e) => e.id == _selectedId).firstOrNull;
    // Room for the floating bottom navigation.
    final bottomInset = MediaQuery.paddingOf(context).bottom + 96;

    final markers = [
      for (final e in pinned)
        Marker(
          key: ValueKey(e.id),
          point: LatLng(e.pinLat!, e.pinLng!),
          width: EventPin.size,
          height: EventPin.size,
          alignment: Alignment.topCenter,
          child: Semantics(
            button: true,
            label: e.name,
            child: GestureDetector(
              onTap: () => setState(() => _selectedId = e.id),
              child: EventPin(
                official: e.isOfficial,
                approximate: !e.pinExact,
                selected: e.id == _selectedId,
              ),
            ),
          ),
        ),
    ];

    if (_mapReady) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => mounted ? _frame(points, bottomInset) : null,
      );
    }

    return Stack(
      children: [
        FlutterMap(
          mapController: _map,
          options: MapOptions(
            initialCenter: home,
            initialZoom: 11,
            onMapReady: () {
              _mapReady = true;
              _frame(points, bottomInset);
            },
            onTap: (_, _) => setState(() => _selectedId = null),
          ),
          children: [
            ...mapBaseLayers(style.value),
            CircleLayer(
              circles: [
                for (final e in pinned)
                  if (!e.pinExact)
                    approximateArea(context, LatLng(e.pinLat!, e.pinLng!)),
              ],
            ),
            MarkerClusterLayerWidget(
              options: MarkerClusterLayerOptions(
                markers: markers,
                maxClusterRadius: 45,
                size: const Size(44, 44),
                padding: EdgeInsets.fromLTRB(48, 48, 48, bottomInset),
                builder: (context, clustered) => DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: colors.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: colors.magenta.withValues(alpha: 0.5),
                        blurRadius: 14,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${clustered.length}',
                      style: context.textTheme.labelLarge?.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            mapAttribution(),
          ],
        ),
        if (style.hasError)
          Positioned(
            top: spacing.md,
            left: spacing.md,
            right: spacing.md,
            child: const MapUnavailable(),
          ),
        if (pinned.isEmpty)
          Positioned(
            top: spacing.md,
            left: spacing.md,
            right: spacing.md,
            child: Card(
              color: colors.surfaceElevated,
              child: Padding(
                padding: EdgeInsets.all(spacing.md),
                child: Text(l10n.mapNoEvents, textAlign: TextAlign.center),
              ),
            ),
          ),
        if (selected != null)
          Positioned(
            left: spacing.md,
            right: spacing.md,
            bottom: bottomInset - spacing.lg,
            child: EventCard(
              event: selected,
              onTap: () => context.push(AppRoutes.eventDetail(selected.id)),
            ),
          ),
      ],
    );
  }
}
