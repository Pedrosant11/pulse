import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/events/presentation/widgets/event_location.dart';
import 'package:pulse/features/profile/data/photo_picker.dart';
import 'package:pulse/features/profile/domain/city.dart';
import 'package:pulse/features/profile/presentation/widgets/city_picker.dart';
import 'package:pulse/features/venues/domain/venue.dart';
import 'package:pulse/features/venues/presentation/venues_providers.dart';
import 'package:pulse/features/venues/presentation/widgets/venue_widgets.dart';

/// Add (team/producer) or edit a venue. A new one pops with its id.
class VenueFormScreen extends ConsumerWidget {
  const new({this.venueId, this.initialName, super.key});

  /// null = new venue.
  final String? venueId;

  /// Prefills the name (from the event form's search).
  final String? initialName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final venueId = this.venueId;
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(
          (venueId == null ? l10n.venueAdd : l10n.venueEdit).toUpperCase(),
        ),
      ),
      body: SafeArea(
        child: venueId == null
            ? _VenueForm(initial: null, initialName: initialName)
            : AsyncValueView(
                value: ref.watch(venueDetailProvider(venueId)),
                onRetry: () => ref.invalidate(venueDetailProvider(venueId)),
                data: (venue) => _VenueForm(initial: venue),
              ),
      ),
    );
  }
}

class _VenueForm extends ConsumerStatefulWidget {
  const new({required this.initial, this.initialName});

  final VenueDetail? initial;
  final String? initialName;

  @override
  ConsumerState<_VenueForm> createState() => _VenueFormState();
}

class _VenueFormState extends ConsumerState<_VenueForm> {
  final _formKey = GlobalKey<FormState>();
  late final VenueDetail? _initial = widget.initial;
  late final _name = TextEditingController(
    text: _initial?.name ?? widget.initialName,
  );
  late final _neighborhood = TextEditingController(
    text: _initial?.neighborhood,
  );
  late final _description = TextEditingController(text: _initial?.description);
  late final _instagram = TextEditingController(text: _initial?.instagram);
  late final _cityText = TextEditingController(
    text: _initial == null ? '' : '${_initial.city}, ${_initial.state}',
  );
  late City? _city = _initial == null
      ? null
      : City(
          name: _initial.city,
          state: _initial.state,
          lat: _initial.lat ?? 0,
          lng: _initial.lng ?? 0,
        );
  late VenueChoice _place = (
    address: _initial?.address,
    point: _initial?.lat != null && _initial?.lng != null
        ? LatLng(_initial!.lat!, _initial.lng!)
        : null,
  );
  Uint8List? _photo;

  @override
  void dispose() {
    for (final c in [
      _name,
      _neighborhood,
      _description,
      _instagram,
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

  Future<void> _pickPhoto() async {
    final jpeg = await ref
        .read(photoPickerProvider)
        .pick(
          PhotoSource.gallery,
          cropTitle: context.l10n.venuePhoto,
          shape: PhotoShape.cover,
        );
    if (jpeg != null && mounted) setState(() => _photo = jpeg);
  }

  String? _blankToNull(String v) => v.trim().isEmpty ? null : v.trim();

  Map<String, Object?> _fields() {
    final city = _city!;
    final (:address, :point) = _place;
    final handle = _instagram.text.trim().replaceFirst('@', '');
    return {
      'name': _name.text.trim(),
      'neighborhood': _blankToNull(_neighborhood.text),
      'description': _blankToNull(_description.text),
      'instagram': handle.isEmpty ? null : handle,
      'city': city.name,
      'state': city.state,
      'address': address,
      'lat': point?.latitude ?? city.lat,
      'lng': point?.longitude ?? city.lng,
    };
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final editor = ref.read(venueEditorProvider.notifier);
    final l10n = context.l10n;
    final initial = _initial;
    if (initial != null) {
      final ok = await editor.save(initial.id, _fields(), photo: _photo);
      if (ok == true && mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.savedMessage)));
        context.pop();
      }
      return;
    }
    final id = await editor.create(_fields(), photo: _photo);
    if (id == null || !mounted) return;
    final role = ref.read(currentRoleProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          role.isModerator ? l10n.venueCreated : l10n.venueSuggested,
        ),
      ),
    );
    context.pop(id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final colors = context.colors;
    final role = ref.watch(currentRoleProvider);
    final editor = ref.watch(venueEditorProvider);

    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(spacing.md),
        children: [
          if (_initial == null && !role.isModerator) ...[
            GlassCard(
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: colors.lime),
                  SizedBox(width: spacing.sm),
                  Expanded(child: Text(l10n.venueSuggestHint)),
                ],
              ),
            ),
            SizedBox(height: spacing.md),
          ],
          ClipRRect(
            borderRadius: BorderRadius.circular(context.radii.lg),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (_photo != null)
                    Image.memory(_photo!, fit: BoxFit.cover)
                  else
                    VenuePhoto(photoPath: _initial?.photoPath),
                  Positioned(
                    right: spacing.sm,
                    bottom: spacing.sm,
                    child: FilledButton.tonalIcon(
                      onPressed: _pickPhoto,
                      icon: const Icon(Icons.image_outlined),
                      label: Text(l10n.venuePhoto),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: spacing.lg),
          TextFormField(
            controller: _name,
            maxLength: 80,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: l10n.venueName),
            validator: (v) =>
                (v ?? '').trim().length < 2 ? l10n.validationRequired : null,
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
          TextFormField(
            controller: _neighborhood,
            maxLength: 80,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: l10n.venueNeighborhood),
          ),
          SizedBox(height: spacing.sm),
          VenuePicker(
            initial: _place,
            city: _city == null
                ? null
                : (
                    name: _city!.name,
                    state: _city!.state,
                    lat: _city!.lat,
                    lng: _city!.lng,
                  ),
            onChanged: (choice) => _place = choice,
          ),
          SizedBox(height: spacing.md),
          TextFormField(
            controller: _description,
            maxLength: 1000,
            minLines: 2,
            maxLines: 6,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l10n.fieldDescription,
              alignLabelWithHint: true,
            ),
          ),
          SizedBox(height: spacing.sm),
          TextFormField(
            controller: _instagram,
            maxLength: 31,
            decoration: InputDecoration(
              labelText: l10n.venueInstagram,
              prefixText: '@',
            ),
            validator: (v) {
              final handle = (v ?? '').trim().replaceFirst('@', '');
              return handle.isEmpty ||
                      RegExp(r'^[A-Za-z0-9._]{1,30}$').hasMatch(handle)
                  ? null
                  : l10n.venueInstagramInvalid;
            },
          ),
          SizedBox(height: spacing.xl),
          FormErrorText(error: editor.error),
          NeonButton(
            label: _initial != null
                ? l10n.saveButton
                : role.isModerator
                ? l10n.venueAdd
                : l10n.venueSuggest,
            isLoading: editor.isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
