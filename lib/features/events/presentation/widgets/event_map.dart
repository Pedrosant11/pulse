import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart' as vmt;

/// Shared pieces of the event map (SPEC 7.4): OpenFreeMap dark vector tiles,
/// neon pins and the "approximate area" circle used while a location is
/// secret. OpenFreeMap is free, keyless and allows commercial use.

/// Style of the base map (vector tiles, fonts and icons).
const mapStyleUrl = 'https://tiles.openfreemap.org/styles/dark';

/// Radius drawn around approximate pins (they are rounded to ~1 km).
const approximateAreaMeters = 1500.0;

/// Default view when nothing else is known: São Paulo.
const fallbackMapCenter = LatLng(-23.55, -46.63);

/// The base map style, read once per app run. Until it loads (or if it
/// fails, e.g. offline) maps show only the background, pins still work.
final mapStyleProvider = FutureProvider<vmt.Style>(
  (ref) => vmt.StyleReader(uri: mapStyleUrl).read(),
);

/// Base map layers for [style]: nothing while it is loading.
List<Widget> mapBaseLayers(vmt.Style? style) => [
  if (style != null)
    vmt.VectorTileLayer(
      theme: style.theme,
      sprites: style.sprites,
      tileProviders: style.providers,
    ),
];

/// Attribution required by OpenFreeMap / OpenMapTiles / OpenStreetMap.
Widget mapAttribution() => const RichAttributionWidget(
  showFlutterMapAttribution: false,
  attributions: [
    TextSourceAttribution('OpenFreeMap'),
    TextSourceAttribution('© OpenMapTiles'),
    TextSourceAttribution('© OpenStreetMap'),
  ],
);

/// Neon map pin. Lime for official events, magenta otherwise; dimmed when
/// it only marks an area.
class EventPin extends StatelessWidget {
  const new({
    this.official = false,
    this.approximate = false,
    this.selected = false,
    super.key,
  });

  /// Width and height reserved for a [Marker] with this pin.
  static const size = 44.0;

  final bool official;
  final bool approximate;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = official ? colors.lime : colors.magenta;
    return AnimatedScale(
      scale: selected ? 1.25 : 1,
      duration: context.reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 180),
      alignment: Alignment.bottomCenter,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.55), blurRadius: 16),
          ],
        ),
        child: Icon(
          approximate ? Icons.blur_circular : Icons.location_on,
          size: size,
          color: approximate ? color.withValues(alpha: 0.7) : color,
        ),
      ),
    );
  }
}

/// Area circle for a secret location.
CircleMarker approximateArea(BuildContext context, LatLng point) {
  final colors = context.colors;
  return CircleMarker(
    point: point,
    radius: approximateAreaMeters,
    useRadiusInMeter: true,
    color: colors.violet.withValues(alpha: 0.18),
    borderColor: colors.violet.withValues(alpha: 0.6),
    borderStrokeWidth: 1.5,
  );
}

/// Banner over a map whose base layer couldn't load (pins still work).
class MapUnavailable extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Card(
      color: colors.surfaceElevated,
      child: Padding(
        padding: EdgeInsets.all(context.spacing.sm),
        child: Row(
          children: [
            Icon(Icons.cloud_off_outlined, color: colors.textSecondary),
            SizedBox(width: context.spacing.sm),
            Expanded(
              child: Text(
                l10n.mapUnavailable,
                style: context.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
