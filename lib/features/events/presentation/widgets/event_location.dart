import 'dart:async';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/features/events/data/place_search_repository.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/events/presentation/widgets/event_map.dart';
import 'package:pulse/features/events/presentation/widgets/event_visuals.dart';
import 'package:url_launcher/url_launcher.dart';

/// When a secret location becomes public.
DateTime? locationRevealAt(EventDetail event) {
  final hours = event.locationRevealHours;
  return hours == null ? null : event.startsAt.subtract(Duration(hours: hours));
}

/// Event detail (SPEC 7.4): mini map with the venue and "Como chegar", or
/// a notice while the location is secret.
class EventLocationSection extends ConsumerWidget {
  const new({required this.event, super.key});

  final EventDetail event;

  Future<void> _directions(BuildContext context, EventVenue venue) async {
    final destination = venue.hasPoint
        ? '${venue.lat},${venue.lng}'
        : '${venue.address}, ${event.city} - ${event.state}';
    // Opens Google Maps (app or site); on iOS the system offers the
    // installed apps.
    final opened = await launchUrl(
      Uri.https('www.google.com', '/maps/dir/', {
        'api': '1',
        'destination': destination,
      }),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.eventLinkError)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final venue = ref.watch(eventVenueProvider(event.id)).value;
    final style = ref.watch(mapStyleProvider).value;
    final revealAt = locationRevealAt(event);

    if (venue == null) {
      if (revealAt == null || DateTime.now().isAfter(revealAt)) {
        return const SizedBox.shrink();
      }
      return GlassCard(
        child: Row(
          children: [
            Icon(Icons.lock_clock_outlined, color: colors.lime),
            SizedBox(width: spacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.eventSecretLocation,
                    style: context.textTheme.titleSmall,
                  ),
                  Text(
                    l10n.eventLocationRevealAt(
                      formatEventDate(context, revealAt),
                    ),
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final point = venue.hasPoint ? LatLng(venue.lat!, venue.lng!) : null;
    // Creator/moderators see a secret venue early: say it's still hidden
    // for everyone else.
    final stillSecret = revealAt != null && DateTime.now().isBefore(revealAt);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (stillSecret) ...[
          Row(
            children: [
              Icon(Icons.lock_clock_outlined, size: 18, color: colors.lime),
              SizedBox(width: spacing.xs),
              Expanded(
                child: Text(
                  l10n.eventSecretVisibleToYou(
                    formatEventDate(context, revealAt),
                  ),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: colors.lime,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.sm),
        ],
        if (point != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(context.radii.lg),
            child: SizedBox(
              height: 170,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: point,
                  initialZoom: 15,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.none,
                  ),
                ),
                children: [
                  ...mapBaseLayers(style),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: point,
                        width: EventPin.size,
                        height: EventPin.size,
                        alignment: Alignment.topCenter,
                        child: EventPin(official: event.isOfficial),
                      ),
                    ],
                  ),
                  mapAttribution(),
                ],
              ),
            ),
          ),
        if (venue.hasPoint || venue.address != null) ...[
          SizedBox(height: spacing.sm),
          OutlinedButton.icon(
            onPressed: () => _directions(context, venue),
            icon: const Icon(Icons.directions_outlined),
            label: Text(l10n.eventDirections),
          ),
        ],
      ],
    );
  }
}

/// Venue chosen in the event form.
typedef VenueChoice = ({String? address, LatLng? point});

/// Event form (SPEC 7.4): search an address (with number) or a CEP, then
/// adjust the pin by tapping the map.
class VenuePicker extends ConsumerStatefulWidget {
  const new({
    required this.initial,
    required this.onChanged,
    this.city,
    super.key,
  });

  final VenueChoice initial;
  final ValueChanged<VenueChoice> onChanged;

  /// The event's city: completes and biases the search.
  final SearchCity? city;

  LatLng? get _cityCenter {
    final city = this.city;
    return city == null ? null : LatLng(city.lat, city.lng);
  }

  @override
  ConsumerState<VenuePicker> createState() => _VenuePickerState();
}

class _VenuePickerState extends ConsumerState<VenuePicker> {
  late final _address = TextEditingController(text: widget.initial.address);
  final _map = MapController();
  late LatLng? _point = widget.initial.point;
  List<PlaceSuggestion> _suggestions = const [];
  bool _searching = false;
  bool _noResults = false;
  Timer? _debounce;
  int _query = 0;

  /// The text came from a map tap (not typed), so a new tap may replace it.
  bool _addressFromMap = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _address.dispose();
    _map.dispose();
    super.dispose();
  }

  void _emit() => widget.onChanged((
    address: _address.text.trim().isEmpty ? null : _address.text.trim(),
    point: _point,
  ));

  void _onTyped(String text) {
    _addressFromMap = false;
    _emit();
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () => _search(text));
  }

  Future<void> _search(String text) async {
    final repository = ref.read(placeSearchRepositoryProvider);
    if (text.trim().length < 3) {
      setState(() => _suggestions = const []);
      return;
    }
    final query = ++_query;
    setState(() => _searching = true);
    try {
      final results = await repository.search(text, city: widget.city);
      if (!mounted || query != _query) return;
      setState(() {
        _suggestions = results;
        _noResults = results.isEmpty;
      });
    } on Object {
      if (mounted && query == _query) setState(() => _suggestions = const []);
    } finally {
      if (mounted && query == _query) setState(() => _searching = false);
    }
  }

  void _choose(PlaceSuggestion place) {
    FocusScope.of(context).unfocus();
    setState(() {
      _address.text = place.label;
      _addressFromMap = false;
      _point = LatLng(place.lat, place.lng);
      _suggestions = const [];
      _noResults = false;
    });
    _map.move(_point!, 16);
    _emit();
  }

  /// Moves the pin; names the place when the field is empty or was filled
  /// by an earlier tap.
  Future<void> _onMapTap(LatLng tapped) async {
    setState(() => _point = tapped);
    _emit();
    if (_address.text.trim().isNotEmpty && !_addressFromMap) return;
    try {
      final label = await ref
          .read(placeSearchRepositoryProvider)
          .reverse(tapped.latitude, tapped.longitude);
      if (!mounted || label == null || _point != tapped) return;
      setState(() {
        _address.text = label;
        _addressFromMap = true;
      });
      _emit();
    } on Object {
      // The pin alone is enough.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final colors = context.colors;
    final style = ref.watch(mapStyleProvider).value;
    final point = _point;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _address,
          maxLength: 200,
          textCapitalization: TextCapitalization.words,
          onChanged: _onTyped,
          decoration: InputDecoration(
            labelText: l10n.eventLocationSearch,
            hintText: l10n.eventLocationSearchHint,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searching
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : null,
          ),
        ),
        if (_suggestions.isNotEmpty)
          GlassCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (final place in _suggestions)
                  ListTile(
                    dense: true,
                    leading: Icon(Icons.place_outlined, color: colors.magenta),
                    title: Text(
                      place.label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => _choose(place),
                  ),
              ],
            ),
          )
        else if (_noResults)
          Text(l10n.eventLocationNoResults, style: context.textTheme.bodySmall),
        ...[
          SizedBox(height: spacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(context.radii.lg),
            child: SizedBox(
              height: 200,
              child: FlutterMap(
                mapController: _map,
                options: MapOptions(
                  initialCenter:
                      point ?? widget._cityCenter ?? fallbackMapCenter,
                  initialZoom: point == null ? 12 : 16,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                  ),
                  onTap: (_, tapped) => _onMapTap(tapped),
                ),
                children: [
                  ...mapBaseLayers(style),
                  if (point != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: point,
                          width: EventPin.size,
                          height: EventPin.size,
                          alignment: Alignment.topCenter,
                          child: const EventPin(),
                        ),
                      ],
                    ),
                  mapAttribution(),
                ],
              ),
            ),
          ),
          SizedBox(height: spacing.xs),
          Text(l10n.eventLocationPinHint, style: context.textTheme.bodySmall),
        ],
      ],
    );
  }
}
