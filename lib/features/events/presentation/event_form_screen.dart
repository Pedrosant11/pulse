import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/utils/enum_json.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/domain/event_import.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/events/presentation/widgets/event_location.dart';
import 'package:pulse/features/events/presentation/widgets/event_visuals.dart';
import 'package:pulse/features/profile/data/location_repository.dart';
import 'package:pulse/features/profile/data/photo_picker.dart';
import 'package:pulse/features/profile/domain/city.dart';
import 'package:pulse/features/profile/domain/profile_enums.dart';
import 'package:pulse/features/profile/presentation/profile_labels.dart';
import 'package:pulse/features/profile/presentation/widgets/choice_chip_group.dart';
import 'package:pulse/features/profile/presentation/widgets/city_picker.dart';
import 'package:pulse/features/venues/data/venues_repository.dart';
import 'package:pulse/features/venues/domain/venue.dart';
import 'package:pulse/features/venues/presentation/widgets/venue_picker_sheet.dart';

/// Create (curator/producer/admin), suggest (user) or edit an event
/// (SPEC 7.2/7.3). Status and the official flag are set by the database.
/// With [copyOfId], a new event starts filled from that one ("Duplicar
/// festa"): same everything, a week later.
class EventFormScreen extends ConsumerWidget {
  const new({this.eventId, this.copyOfId, super.key});

  /// null = new event.
  final String? eventId;

  /// "Duplicar festa": the event to copy.
  final String? copyOfId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventId = this.eventId;
    final sourceId = eventId ?? copyOfId;
    final l10n = context.l10n;
    final role = ref.watch(currentRoleProvider);
    final title = eventId != null
        ? l10n.eventFormEditTitle
        : copyOfId != null
        ? l10n.eventDuplicateTitle
        : role.createsApprovedEvents
        ? l10n.eventFormCreateTitle
        : l10n.eventFormSuggestTitle;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(title.toUpperCase())),
      body: SafeArea(
        child: sourceId == null
            ? const _EventForm(initial: null)
            : AsyncValueView(
                value: ref.watch(eventDetailProvider(sourceId)),
                onRetry: () => ref.invalidate(eventDetailProvider(sourceId)),
                data: (event) => AsyncValueView(
                  // Editors can always read the venue (RLS).
                  value: ref.watch(eventVenueProvider(sourceId)),
                  onRetry: () => ref.invalidate(eventVenueProvider(sourceId)),
                  data: (venue) => eventId != null
                      ? _EventForm(initial: event, initialVenue: venue)
                      : _EventForm(
                          initial: null,
                          copyOf: event,
                          initialVenue: venue,
                        ),
                ),
              ),
      ),
    );
  }
}

class _EventForm extends ConsumerStatefulWidget {
  const new({required this.initial, this.copyOf, this.initialVenue});

  final EventDetail? initial;

  /// "Duplicar festa": prefills a new event.
  final EventDetail? copyOf;
  final EventVenue? initialVenue;

  @override
  ConsumerState<_EventForm> createState() => _EventFormState();
}

class _EventFormState extends ConsumerState<_EventForm> {
  final _formKey = GlobalKey<FormState>();
  late final EventDetail? _initial = widget.initial;

  /// Prefills the form: the event being edited, or the one being
  /// duplicated ("Duplicar festa", saved as a new event).
  late final EventDetail? _source = widget.initial ?? widget.copyOf;
  late final _name = TextEditingController(text: _source?.name);
  late final _venue = TextEditingController(text: _source?.venueName);
  late final _description = TextEditingController(text: _source?.description);
  late final _ticketUrl = TextEditingController(text: _source?.ticketUrl);
  late final _ticketCoupon = TextEditingController(text: _source?.ticketCoupon);
  final _artist = TextEditingController();
  late final _cityText = TextEditingController(
    text: _source == null ? '' : '${_source.city}, ${_source.state}',
  );

  late City? _city = _source == null
      ? null
      : City(
          name: _source.city,
          state: _source.state,
          lat: _source.lat ?? 0,
          lng: _source.lng ?? 0,
        );
  late DateTime _startsAt =
      _initial?.startsAt.toLocal() ??
      _nextEdition(widget.copyOf?.startsAt.toLocal()) ??
      _defaultStart();
  late DateTime _endsAt = _startsAt.add(
    _source == null
        ? const Duration(hours: 6)
        : _source.endsAt.difference(_source.startsAt),
  );
  late Set<MusicGenre> _genres = {...?_source?.genres};
  late final List<String> _lineup = [...?_source?.lineup];
  late int _minAge = _source?.minAge ?? 18;
  late VenueChoice _venueChoice = (
    address: widget.initialVenue?.address,
    point: widget.initialVenue?.hasPoint ?? false
        ? LatLng(widget.initialVenue!.lat!, widget.initialVenue!.lng!)
        : null,
  );
  late bool _secretLocation = _source?.locationRevealHours != null;
  late int _revealHours = _source?.locationRevealHours ?? 24;
  Uint8List? _cover;

  bool get _isNew => _initial == null;

  /// "Duplicar festa": the same weekday and time, a week later (or the
  /// first such date still ahead).
  static DateTime? _nextEdition(DateTime? from) {
    if (from == null) return null;
    var next = from.add(const Duration(days: 7));
    while (next.isBefore(DateTime.now())) {
      next = next.add(const Duration(days: 7));
    }
    return next;
  }

  /// Next Saturday, 23:00.
  static DateTime _defaultStart() {
    final now = DateTime.now();
    final days = (DateTime.saturday - now.weekday) % 7;
    return DateTime(now.year, now.month, now.day + (days == 0 ? 7 : days), 23);
  }

  @override
  void dispose() {
    for (final c in [
      _name,
      _venue,
      _description,
      _ticketUrl,
      _ticketCoupon,
      _artist,
      _cityText,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickCity() async {
    final city = await showCityPicker(context);
    if (city == null || !mounted) return;
    setState(() {
      _city = city;
      _cityText.text = city.label;
    });
  }

  Future<DateTime?> _pickDateTime(DateTime initial) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 730)),
    );
    if (date == null || !mounted) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> _pickCover() async {
    final jpeg = await ref
        .read(photoPickerProvider)
        .pick(
          PhotoSource.gallery,
          cropTitle: context.l10n.eventCoverAdd,
          shape: PhotoShape.cover,
        );
    if (jpeg != null && mounted) setState(() => _cover = jpeg);
  }

  void _addArtist() {
    final name = _artist.text.trim();
    if (name.isEmpty || _lineup.length >= 50) return;
    setState(() {
      if (!_lineup.contains(name)) _lineup.add(name);
      _artist.clear();
    });
  }

  /// Rebuilds the venue picker after an import (it keeps its own state).
  int _venueVersion = 0;

  /// Linked casa (venues migration) and the name it had when chosen;
  /// typing another name unlinks it.
  late String? _venueId = _source?.venueId;
  late String? _venueIdName = _source?.venueId == null
      ? null
      : _source?.venueName;

  Future<void> _chooseVenue() async {
    final venue = await showVenuePicker(context);
    if (venue == null || !mounted) return;
    final cities = await ref.read(cityIndexProvider.future);
    if (!mounted) return;
    _useVenue(venue, cities);
  }

  void _useVenue(Venue venue, CityIndex cities) {
    setState(() {
      _venueId = venue.id;
      _venueIdName = venue.name;
      _venue.text = venue.name;
      if (cities.find(venue.city, venue.state) case final city?) {
        _city = city;
        _cityText.text = city.label;
      }
      if (venue.address != null || venue.lat != null) {
        _venueChoice = (
          address: venue.address,
          point: venue.lat != null && venue.lng != null
              ? LatLng(venue.lat!, venue.lng!)
              : null,
        );
        _venueVersion++;
      }
    });
  }

  /// After an import: links the casa with the same name in that city.
  Future<void> _matchVenue(ImportedEvent event, CityIndex cities) async {
    final name = event.venueName;
    if (name == null || _venueId != null) return;
    final found = await ref.read(venuesRepositoryProvider).list(query: name);
    String fold(String s) => normalizeForSearch(s);
    final match = found
        .where(
          (v) =>
              fold(v.name) == fold(name) &&
              (event.city == null || fold(v.city) == fold(event.city!)),
        )
        .firstOrNull;
    if (match != null && mounted) _useVenue(match, cities);
  }

  Future<void> _importFromLink() async {
    final url = await showDialog<String>(
      context: context,
      builder: (_) => const _ImportLinkDialog(),
    );
    if (url == null || !mounted) return;
    final result = await ref.read(eventEditorProvider.notifier).importFrom(url);
    if (result == null || !mounted) return;
    final cities = await ref.read(cityIndexProvider.future);
    if (!mounted) return;
    _apply(result.event, result.cover, cities);
    await _matchVenue(result.event, cities);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.eventImportDone)));
  }

  /// Fills the form with what the page said; the rest stays as it was.
  void _apply(ImportedEvent event, Uint8List? cover, CityIndex cities) {
    setState(() {
      if (event.name case final name?) {
        _name.text = name.length > 120 ? name.substring(0, 120) : name;
      }
      if (event.description case final text?) {
        _description.text = text.length > 4000 ? text.substring(0, 4000) : text;
      }
      if (event.venueName case final venue?) _venue.text = venue;
      _ticketUrl.text = event.ticketUrl;
      final city = switch ((event.city, event.state)) {
        (final name?, final state?) =>
          cities.find(name, state) ??
              cities.search(name).where((c) => c.state == state).firstOrNull,
        _ when event.lat != null && event.lng != null => cities.nearest(
          event.lat!,
          event.lng!,
        ),
        _ => null,
      };
      if (city != null) {
        _city = city;
        _cityText.text = city.label;
      }
      final now = DateTime.now();
      if (event.startsAt case final start? when start.isAfter(now)) {
        _startsAt = start.toLocal();
        final end = event.endsAt?.toLocal();
        _endsAt = end != null && end.isAfter(_startsAt)
            ? end
            : _startsAt.add(const Duration(hours: 6));
      }
      for (final artist in event.lineup) {
        if (_lineup.length < 50 && !_lineup.contains(artist)) {
          _lineup.add(artist);
        }
      }
      _genres = {..._genres, ...event.genres};
      if (event.address != null || event.lat != null) {
        _venueChoice = (
          address: event.address,
          point: event.lat != null && event.lng != null
              ? LatLng(event.lat!, event.lng!)
              : null,
        );
        _venueVersion++;
      }
      if (cover != null) _cover = cover;
    });
  }

  String? _blankToNull(String v) => v.trim().isEmpty ? null : v.trim();

  /// Venue to store, or null when there is nothing to save.
  EventVenue? _venueFor(String eventId) {
    final (:address, :point) = _venueChoice;
    if (address == null && point == null && widget.initialVenue == null) {
      return null;
    }
    return EventVenue(
      eventId: eventId,
      address: address,
      lat: point?.latitude,
      lng: point?.longitude,
    );
  }

  Map<String, Object?> _fields() {
    final city = _city!;
    return {
      'name': _name.text.trim(),
      'description': _blankToNull(_description.text),
      'venue_name': _venue.text.trim(),
      'venue_id': _venueId,
      'city': city.name,
      'state': city.state,
      'lat': double.parse(city.lat.toStringAsFixed(2)),
      'lng': double.parse(city.lng.toStringAsFixed(2)),
      'starts_at': _startsAt.toUtc().toIso8601String(),
      'ends_at': _endsAt.toUtc().toIso8601String(),
      'genres': enumsToDb(_genres),
      'lineup': _lineup,
      'ticket_url': _blankToNull(_ticketUrl.text),
      'ticket_coupon': _blankToNull(_ticketCoupon.text),
      'min_age': _minAge,
      'location_reveal_hours': _secretLocation ? _revealHours : null,
      // "Duplicar festa": keeps the cover unless a new one is picked.
      if (_isNew && widget.copyOf?.coverPath != null)
        'cover_path': widget.copyOf!.coverPath,
    };
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final editor = ref.read(eventEditorProvider.notifier);
    final l10n = context.l10n;

    final initial = _initial;
    if (initial != null) {
      final saved = await editor.save(
        initial.id,
        _fields(),
        cover: _cover,
        venue: _venueFor(initial.id),
      );
      if (saved == true && mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.savedMessage)));
        context.pop();
      }
      return;
    }

    // Anti-duplication (SPEC 7.2).
    final similar = await editor.findSimilar(
      name: _name.text.trim(),
      startsAt: _startsAt,
      city: _city!.name,
    );
    if (similar == null || !mounted) return;
    if (similar.isNotEmpty) {
      final existing = await _askDuplicate(similar);
      if (!mounted) return;
      if (existing == false) return; // dismissed
      if (existing is SimilarEvent) {
        await ref
            .read(attendanceEditorProvider.notifier)
            .setAttending(existing.id, attending: true);
        if (mounted) {
          context.pushReplacement(AppRoutes.eventDetail(existing.id));
        }
        return;
      }
    }

    final created = await editor.create(
      _fields(),
      cover: _cover,
      venue: _venueFor(''),
    );
    if (created == null || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          created.status == EventStatus.pending
              ? l10n.eventSubmittedPending
              : l10n.eventPublished,
        ),
      ),
    );
    context.pushReplacement(AppRoutes.eventDetail(created.id));
  }

  /// Returns the chosen existing event, `true` to create anyway, or `false`
  /// when dismissed.
  Future<Object?> _askDuplicate(List<SimilarEvent> similar) {
    final l10n = context.l10n;
    return showDialog<Object>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.similarTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.similarBody),
              SizedBox(height: context.spacing.sm),
              for (final event in similar)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(event.name),
                  subtitle: Text(
                    '${formatEventDate(context, event.startsAt)}\n'
                    '${event.venueName} · ${event.city}',
                  ),
                  isThreeLine: true,
                  trailing: TextButton(
                    onPressed: () => Navigator.pop(context, event),
                    child: Text(l10n.similarUseExisting),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.similarCreateAnyway),
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final colors = context.colors;
    final role = ref.watch(currentRoleProvider);
    final editor = ref.watch(eventEditorProvider);
    String? required(String? v) =>
        (v ?? '').trim().isEmpty ? l10n.validationRequired : null;

    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(spacing.md),
        children: [
          if (_isNew && !role.createsApprovedEvents) ...[
            GlassCard(
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: colors.lime),
                  SizedBox(width: spacing.sm),
                  Expanded(child: Text(l10n.eventFormSuggestHint)),
                ],
              ),
            ),
            SizedBox(height: spacing.md),
          ],
          if (_isNew) ...[
            GlassCard(
              child: Row(
                children: [
                  Icon(Icons.link_rounded, color: colors.cyan),
                  SizedBox(width: spacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.eventImportTitle,
                          style: context.textTheme.titleSmall,
                        ),
                        Text(
                          l10n.eventImportHint,
                          style: context.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: spacing.xs),
                  FilledButton.tonal(
                    onPressed: editor.isLoading ? null : _importFromLink,
                    child: Text(l10n.eventImportButton),
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing.md),
          ],
          // Cover.
          ClipRRect(
            borderRadius: BorderRadius.circular(context.radii.lg),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (_cover != null)
                    Image.memory(_cover!, fit: BoxFit.cover)
                  else
                    EventCover(
                      coverPath: _source?.coverPath,
                      seed: _source?.id ?? '',
                    ),
                  Positioned(
                    right: spacing.sm,
                    bottom: spacing.sm,
                    child: FilledButton.tonalIcon(
                      onPressed: _pickCover,
                      icon: const Icon(Icons.image_outlined),
                      label: Text(
                        _cover == null && _source?.coverPath == null
                            ? l10n.eventCoverAdd
                            : l10n.eventCoverChange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: spacing.lg),
          TextFormField(
            controller: _name,
            maxLength: 120,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: l10n.fieldEventName),
            validator: (v) =>
                (v ?? '').trim().length < 3 ? l10n.validationRequired : null,
          ),
          SizedBox(height: spacing.sm),
          TextFormField(
            controller: _venue,
            maxLength: 120,
            textCapitalization: TextCapitalization.words,
            onChanged: (text) {
              if (_venueId != null && text.trim() != _venueIdName) {
                setState(() => _venueId = null);
              }
            },
            decoration: InputDecoration(
              labelText: l10n.fieldVenue,
              helperText: _venueId != null
                  ? l10n.venueLinked
                  : l10n.venueLinkHint,
              suffixIcon: IconButton(
                tooltip: l10n.venuePickTitle,
                onPressed: _chooseVenue,
                icon: Icon(
                  Icons.storefront_outlined,
                  color: _venueId != null ? colors.lime : null,
                ),
              ),
            ),
            validator: required,
          ),
          SizedBox(height: spacing.sm),
          TextFormField(
            controller: _cityText,
            readOnly: true,
            onTap: _pickCity,
            decoration: InputDecoration(
              labelText: l10n.fieldCity,
              suffixIcon: const Icon(Icons.location_city_outlined),
            ),
            validator: (_) => _city == null ? l10n.validationRequired : null,
          ),
          SizedBox(height: spacing.sm),
          // Where exactly (SPEC 7.4): search + pin on the map.
          VenuePicker(
            key: ValueKey(_venueVersion),
            initial: _venueChoice,
            city: _city == null
                ? null
                : (
                    name: _city!.name,
                    state: _city!.state,
                    lat: _city!.lat,
                    lng: _city!.lng,
                  ),
            onChanged: (choice) => _venueChoice = choice,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _secretLocation,
            activeThumbColor: colors.lime,
            title: Text(l10n.eventSecretToggle),
            subtitle: Text(l10n.eventSecretHint(_revealHours)),
            onChanged: (v) => setState(() => _secretLocation = v),
          ),
          if (_secretLocation)
            Wrap(
              spacing: spacing.xs,
              children: [
                for (final hours in const [6, 12, 24, 48])
                  ChoiceChip(
                    label: Text(l10n.eventRevealHours(hours)),
                    selected: _revealHours == hours,
                    onSelected: (_) => setState(() => _revealHours = hours),
                  ),
              ],
            ),
          SizedBox(height: spacing.md),
          _DateTimeField(
            label: l10n.fieldStartsAt,
            value: _startsAt,
            onTap: () async {
              final picked = await _pickDateTime(_startsAt);
              if (picked == null) return;
              setState(() {
                final duration = _endsAt.difference(_startsAt);
                _startsAt = picked;
                _endsAt = picked.add(duration);
              });
            },
            validator: () => _isNew && _startsAt.isBefore(DateTime.now())
                ? l10n.validationFuture
                : null,
          ),
          SizedBox(height: spacing.md),
          _DateTimeField(
            label: l10n.fieldEndsAt,
            value: _endsAt,
            onTap: () async {
              final picked = await _pickDateTime(_endsAt);
              if (picked != null) setState(() => _endsAt = picked);
            },
            validator: () {
              final duration = _endsAt.difference(_startsAt);
              return duration <= Duration.zero ||
                      duration > const Duration(days: 7)
                  ? l10n.validationEndsAfterStart
                  : null;
            },
          ),
          SizedBox(height: spacing.md),
          DropdownButtonFormField<int>(
            initialValue: _minAge,
            decoration: InputDecoration(labelText: l10n.fieldMinAge),
            items: [
              for (final age in [18, 21])
                DropdownMenuItem(value: age, child: Text('$age+')),
            ],
            onChanged: (v) => setState(() => _minAge = v ?? 18),
          ),
          FieldLabel(l10n.fieldGenres),
          ChoiceChipGroup<MusicGenre>(
            options: MusicGenre.values,
            selected: _genres,
            multiple: true,
            labelOf: l10n.genre,
            onChanged: (v) => setState(() => _genres = v),
          ),
          FieldLabel(l10n.fieldLineup),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _artist,
                  maxLength: 80,
                  textCapitalization: TextCapitalization.words,
                  onSubmitted: (_) => _addArtist(),
                  decoration: InputDecoration(
                    hintText: l10n.lineupHint,
                    counterText: '',
                  ),
                ),
              ),
              SizedBox(width: spacing.xs),
              IconButton.filled(
                tooltip: l10n.addArtist,
                onPressed: _addArtist,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          SizedBox(height: spacing.sm),
          Wrap(
            spacing: spacing.xs,
            runSpacing: spacing.xs,
            children: [
              for (final artist in _lineup)
                InputChip(
                  label: Text(artist),
                  onDeleted: () => setState(() => _lineup.remove(artist)),
                ),
            ],
          ),
          SizedBox(height: spacing.md),
          TextFormField(
            controller: _description,
            maxLength: 4000,
            minLines: 3,
            maxLines: 8,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l10n.fieldDescription,
              alignLabelWithHint: true,
            ),
          ),
          SizedBox(height: spacing.sm),
          TextFormField(
            controller: _ticketUrl,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(labelText: l10n.fieldTicketUrl),
            validator: (v) {
              final url = (v ?? '').trim();
              if (url.isEmpty) return null;
              return RegExp(
                    r'^https?://\S+$',
                    caseSensitive: false,
                  ).hasMatch(url)
                  ? null
                  : l10n.validationUrl;
            },
          ),
          SizedBox(height: spacing.sm),
          // Affiliate or promoter code, shown with a copy button.
          TextFormField(
            controller: _ticketCoupon,
            maxLength: 30,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              labelText: l10n.fieldTicketCoupon,
              helperText: l10n.fieldTicketCouponHint,
            ),
            validator: (v) {
              final code = (v ?? '').trim();
              return code.isNotEmpty && code.length < 2
                  ? l10n.validationRequired
                  : null;
            },
          ),
          SizedBox(height: spacing.xl),
          FormErrorText(error: editor.error),
          NeonButton(
            label: !_isNew
                ? l10n.saveButton
                : role.createsApprovedEvents
                ? l10n.eventSaveCreate
                : l10n.eventSaveSuggest,
            isLoading: editor.isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

class _DateTimeField extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    required this.onTap,
    required this.validator,
  });

  final String label;
  final DateTime value;
  final VoidCallback onTap;
  final String? Function() validator;

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      initialValue: value,
      validator: (_) => validator(),
      builder: (field) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.radii.md),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            errorText: field.errorText,
            suffixIcon: const Icon(Icons.event_outlined),
          ),
          child: Text(formatEventDate(context, value)),
        ),
      ),
    );
  }
}

/// Asks for the ticket page link; returns it, or null when dismissed.
class _ImportLinkDialog extends StatefulWidget {
  const new();

  @override
  State<_ImportLinkDialog> createState() => _ImportLinkDialogState();
}

class _ImportLinkDialogState extends State<_ImportLinkDialog> {
  final _url = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, _url.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.eventImportTitle),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _url,
          autofocus: true,
          keyboardType: TextInputType.url,
          decoration: InputDecoration(
            labelText: l10n.eventImportField,
            hintText: 'https://',
          ),
          onFieldSubmitted: (_) => _submit(),
          validator: (v) =>
              RegExp(
                r'^https?://\S+\.\S+$',
                caseSensitive: false,
              ).hasMatch((v ?? '').trim())
              ? null
              : l10n.validationUrl,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        TextButton(onPressed: _submit, child: Text(l10n.eventImportButton)),
      ],
    );
  }
}
