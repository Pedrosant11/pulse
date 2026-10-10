import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/constants.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/models/app_mode.dart';
import 'package:pulse/core/utils/enum_json.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/features/profile/domain/city.dart';
import 'package:pulse/features/profile/domain/profile.dart';
import 'package:pulse/features/profile/domain/profile_enums.dart';
import 'package:pulse/features/profile/presentation/profile_labels.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/features/profile/presentation/widgets/choice_chip_group.dart';
import 'package:pulse/features/profile/presentation/widgets/city_picker.dart';

/// Saves a section; the screen decides what happens next (next onboarding
/// step or closing the edit screen).
typedef ProfileSubmit = Future<void> Function(Map<String, Object?> fields);

/// Submit button + error line shared by the forms.
class _SubmitArea extends ConsumerWidget {
  const new({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileEditorProvider);
    return Padding(
      padding: EdgeInsets.only(top: context.spacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormErrorText(error: state.error),
          NeonButton(
            label: label,
            isLoading: state.isLoading,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}

String? _blankToNull(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

T? _single<T>(Set<T> values) => values.isEmpty ? null : values.first;

// ---------------------------------------------------------------------------
// Basics: name, city, occupation, bio, gender, orientation
// ---------------------------------------------------------------------------

class BasicsForm extends StatefulWidget {
  const new({
    required this.initial,
    required this.submitLabel,
    required this.onSubmit,
    this.minimal = false,
    super.key,
  });

  final MyProfile initial;
  final String submitLabel;
  final ProfileSubmit onSubmit;

  /// Only name and city ("events only" profiles).
  final bool minimal;

  @override
  State<BasicsForm> createState() => _BasicsFormState();
}

class _BasicsFormState extends State<BasicsForm> {
  final _formKey = GlobalKey<FormState>();
  late final _firstName = TextEditingController(text: widget.initial.firstName);
  late final _occupation = TextEditingController(
    text: widget.initial.occupation,
  );
  late final _bio = TextEditingController(text: widget.initial.bio);
  late final _cityText = TextEditingController(text: _cityLabel);
  late City? _city = _initialCity();
  late Gender? _gender = widget.initial.gender;
  late SexualOrientation? _orientation = widget.initial.orientation;
  late bool _showOrientation = widget.initial.showOrientation;

  /// Specific consent for sensitive data (LGPD art. 11). A stored
  /// orientation means it was already given.
  late bool _orientationConsent = widget.initial.orientation != null;
  bool _consentMissing = false;

  String get _cityLabel {
    final i = widget.initial;
    return i.city == null ? '' : '${i.city}, ${i.state}';
  }

  City? _initialCity() {
    final i = widget.initial;
    if (i.city == null || i.state == null) return null;
    return City(
      name: i.city!,
      state: i.state!,
      lat: i.lat ?? 0,
      lng: i.lng ?? 0,
    );
  }

  @override
  void dispose() {
    _firstName.dispose();
    _occupation.dispose();
    _bio.dispose();
    _cityText.dispose();
    super.dispose();
  }

  Future<void> _pickCity() async {
    final city = await showCityPicker(context);
    if (city == null || !mounted) return;
    setState(() {
      _city = city;
      _cityText.text = city.label;
    });
    _formKey.currentState?.validate();
  }

  Future<void> _submit() async {
    final consentMissing =
        !widget.minimal && _orientation != null && !_orientationConsent;
    setState(() => _consentMissing = consentMissing);
    if (!_formKey.currentState!.validate() || consentMissing) return;
    final city = _city!;
    final place = {
      'first_name': _firstName.text.trim(),
      'city': city.name,
      'state': city.state,
      // Two decimals ≈ 1 km (SPEC 6.1); the column also rounds.
      'lat': double.parse(city.lat.toStringAsFixed(2)),
      'lng': double.parse(city.lng.toStringAsFixed(2)),
    };
    if (widget.minimal) {
      await widget.onSubmit(place);
      return;
    }
    await widget.onSubmit({
      ...place,
      'occupation': _blankToNull(_occupation.text),
      'bio': _blankToNull(_bio.text),
      'gender': enumToDb(_gender!),
      'orientation': _orientation == null ? null : enumToDb(_orientation!),
      'show_orientation': _orientation != null && _showOrientation,
      // "I consent": the database records its own clock (lgpd migration).
      if (_orientation != null)
        'sensitive_data_consent_at': DateTime.now().toUtc().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    String? required(String? v) =>
        (v ?? '').trim().isEmpty ? l10n.validationRequired : null;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _firstName,
            textCapitalization: TextCapitalization.words,
            maxLength: 50,
            decoration: InputDecoration(labelText: l10n.fieldFirstName),
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
          if (!widget.minimal) ...[
            SizedBox(height: spacing.md),
            TextFormField(
              controller: _occupation,
              maxLength: 60,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.fieldOccupation,
                hintText: l10n.occupationHint,
              ),
            ),
            SizedBox(height: spacing.sm),
            TextFormField(
              controller: _bio,
              maxLength: AppConstants.maxBioLength,
              minLines: 3,
              maxLines: 6,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.fieldBio,
                hintText: l10n.bioHint,
                alignLabelWithHint: true,
              ),
            ),
            FormField<Gender>(
              initialValue: _gender,
              validator: (_) =>
                  _gender == null ? l10n.validationRequired : null,
              builder: (field) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FieldLabel(l10n.fieldGender),
                  ChoiceChipGroup<Gender>(
                    options: Gender.values,
                    selected: {?_gender},
                    labelOf: l10n.gender,
                    onChanged: (value) {
                      setState(() => _gender = _single(value));
                      field.didChange(_gender);
                    },
                  ),
                  if (field.errorText case final error?)
                    Padding(
                      padding: EdgeInsets.only(top: spacing.xs),
                      child: Text(
                        error,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colors.error,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            FieldLabel(l10n.fieldOrientation),
            ChoiceChipGroup<SexualOrientation>(
              options: SexualOrientation.values,
              selected: {?_orientation},
              labelOf: l10n.orientation,
              onChanged: (value) =>
                  setState(() => _orientation = _single(value)),
            ),
            if (_orientation != null) ...[
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: _orientationConsent,
                title: Text(
                  l10n.orientationConsent,
                  style: context.textTheme.bodySmall,
                ),
                subtitle: _consentMissing && !_orientationConsent
                    ? Text(
                        l10n.orientationConsentRequired,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colors.error,
                        ),
                      )
                    : null,
                onChanged: (v) =>
                    setState(() => _orientationConsent = v ?? false),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _showOrientation,
                title: Text(l10n.showOrientation),
                onChanged: (v) => setState(() => _showOrientation = v),
              ),
            ],
          ],
          _SubmitArea(label: widget.submitLabel, onPressed: _submit),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// About me (all optional)
// ---------------------------------------------------------------------------

class AboutForm extends StatefulWidget {
  const new({
    required this.initial,
    required this.submitLabel,
    required this.onSubmit,
    super.key,
  });

  final MyProfile initial;
  final String submitLabel;
  final ProfileSubmit onSubmit;

  @override
  State<AboutForm> createState() => _AboutFormState();
}

class _AboutFormState extends State<AboutForm> {
  late int? _height = widget.initial.heightCm;
  late Set<String> _languages = {...widget.initial.languages};
  late ZodiacSign? _zodiac = widget.initial.zodiac;
  late HabitFrequency? _drinks = widget.initial.drinks;
  late HabitFrequency? _smokes = widget.initial.smokes;
  late Set<Pet> _pets = {...widget.initial.pets};

  Future<void> _submit() => widget.onSubmit({
    'height_cm': _height,
    'languages': _languages.toList(),
    'zodiac': _zodiac == null ? null : enumToDb(_zodiac!),
    'drinks': _drinks == null ? null : enumToDb(_drinks!),
    'smokes': _smokes == null ? null : enumToDb(_smokes!),
    'pets': enumsToDb(_pets),
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FieldLabel(
          l10n.fieldHeight,
          trailing: Text(
            _height == null ? l10n.notInformed : l10n.heightValue(_height!),
            style: context.textTheme.labelMedium,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Slider(
                min: 120,
                max: 230,
                divisions: 110,
                value: (_height ?? 170).toDouble(),
                label: l10n.heightValue(_height ?? 170),
                onChanged: (v) => setState(() => _height = v.round()),
              ),
            ),
            if (_height != null)
              IconButton(
                tooltip: l10n.notInformed,
                onPressed: () => setState(() => _height = null),
                icon: const Icon(Icons.close),
              ),
          ],
        ),
        FieldLabel(l10n.fieldLanguages),
        ChoiceChipGroup<String>(
          options: profileLanguages,
          selected: _languages,
          multiple: true,
          labelOf: l10n.language,
          onChanged: (v) => setState(() => _languages = v),
        ),
        FieldLabel(l10n.fieldZodiac),
        ChoiceChipGroup<ZodiacSign>(
          options: ZodiacSign.values,
          selected: {?_zodiac},
          labelOf: l10n.zodiac,
          onChanged: (v) => setState(() => _zodiac = _single(v)),
        ),
        FieldLabel(l10n.fieldDrinks),
        ChoiceChipGroup<HabitFrequency>(
          options: HabitFrequency.values,
          selected: {?_drinks},
          labelOf: l10n.habit,
          onChanged: (v) => setState(() => _drinks = _single(v)),
        ),
        FieldLabel(l10n.fieldSmokes),
        ChoiceChipGroup<HabitFrequency>(
          options: HabitFrequency.values,
          selected: {?_smokes},
          labelOf: l10n.habit,
          onChanged: (v) => setState(() => _smokes = _single(v)),
        ),
        FieldLabel(l10n.fieldPets),
        ChoiceChipGroup<Pet>(
          options: Pet.values,
          selected: _pets,
          multiple: true,
          labelOf: l10n.pet,
          onChanged: (v) => setState(() => _pets = v),
        ),
        _SubmitArea(label: widget.submitLabel, onPressed: _submit),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Music: genres (1+) and up to 10 DJs
// ---------------------------------------------------------------------------

class MusicForm extends StatefulWidget {
  const new({
    required this.initial,
    required this.submitLabel,
    required this.onSubmit,
    super.key,
  });

  final MyProfile initial;
  final String submitLabel;
  final ProfileSubmit onSubmit;

  @override
  State<MusicForm> createState() => _MusicFormState();
}

class _MusicFormState extends State<MusicForm> {
  final _dj = TextEditingController();
  late Set<MusicGenre> _genres = {...widget.initial.musicGenres};
  late final List<String> _djs = [...widget.initial.favoriteDjs];
  bool _showGenreError = false;

  @override
  void dispose() {
    _dj.dispose();
    super.dispose();
  }

  void _addDj() {
    final name = _dj.text.trim();
    if (name.isEmpty || _djs.length >= AppConstants.maxFavoriteDjs) return;
    final exists = _djs.any((d) => d.toLowerCase() == name.toLowerCase());
    setState(() {
      if (!exists) _djs.add(name);
      _dj.clear();
    });
  }

  Future<void> _submit() async {
    if (_genres.isEmpty) {
      setState(() => _showGenreError = true);
      return;
    }
    await widget.onSubmit({
      'music_genres': enumsToDb(_genres),
      'favorite_djs': _djs,
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final full = _djs.length >= AppConstants.maxFavoriteDjs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FieldLabel(l10n.fieldGenres),
        ChoiceChipGroup<MusicGenre>(
          options: MusicGenre.values,
          selected: _genres,
          multiple: true,
          labelOf: l10n.genre,
          onChanged: (v) => setState(() {
            _genres = v;
            _showGenreError = false;
          }),
        ),
        if (_showGenreError)
          Padding(
            padding: EdgeInsets.only(top: spacing.xs),
            child: Text(
              l10n.genresMinHint,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colors.error,
              ),
            ),
          ),
        FieldLabel(
          l10n.fieldDjs,
          trailing: Text(
            '${_djs.length}/${AppConstants.maxFavoriteDjs}',
            style: context.textTheme.labelSmall,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _dj,
                enabled: !full,
                maxLength: 50,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _addDj(),
                decoration: InputDecoration(
                  hintText: full ? l10n.djsLimit : l10n.djsHint,
                  counterText: '',
                ),
              ),
            ),
            SizedBox(width: spacing.xs),
            IconButton.filled(
              tooltip: l10n.addDj,
              onPressed: full ? null : _addDj,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        SizedBox(height: spacing.sm),
        Wrap(
          spacing: spacing.xs,
          runSpacing: spacing.xs,
          children: [
            for (final dj in _djs)
              InputChip(
                label: Text(dj),
                deleteButtonTooltipMessage: l10n.removeDj(dj),
                onDeleted: () => setState(() => _djs.remove(dj)),
              ),
          ],
        ),
        _SubmitArea(label: widget.submitLabel, onPressed: _submit),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Modes and preferences
// ---------------------------------------------------------------------------

class ModesForm extends StatefulWidget {
  const new({
    required this.initial,
    required this.submitLabel,
    required this.onSubmit,
    this.allowNone = false,
    super.key,
  });

  final MyProfile initial;
  final String submitLabel;
  final ProfileSubmit onSubmit;

  /// Turning every mode off means "events only" (edit screen).
  final bool allowNone;

  @override
  State<ModesForm> createState() => _ModesFormState();
}

class _ModesFormState extends State<ModesForm> {
  late final Set<AppMode> _modes = {...widget.initial.modes};
  late DateIntent? _lookingFor = widget.initial.dateLookingFor;
  late Set<Gender> _showMe = {...widget.initial.dateShowMe};
  late RangeValues _ages = RangeValues(
    widget.initial.dateAgeMin.toDouble(),
    widget.initial.dateAgeMax.toDouble(),
  );
  late bool _sameGender = widget.initial.crewSameGenderOnly;
  bool _showModesError = false;

  /// "Same gender only" needs a defined gender (database check).
  bool get _canUseSameGender {
    final gender = widget.initial.gender;
    return gender != null && gender != Gender.preferNotSay;
  }

  Future<void> _submit() async {
    if (_modes.isEmpty && !widget.allowNone) {
      setState(() => _showModesError = true);
      return;
    }
    await widget.onSubmit({
      'modes': enumsToDb(_modes),
      'date_looking_for': _lookingFor == null ? null : enumToDb(_lookingFor!),
      'date_show_me': enumsToDb(_showMe),
      'date_age_min': _ages.start.round(),
      'date_age_max': _ages.end.round(),
      'crew_same_gender_only': _canUseSameGender && _sameGender,
    });
  }

  void _toggleMode(AppMode mode, {required bool enabled}) => setState(() {
    enabled ? _modes.add(mode) : _modes.remove(mode);
    _showModesError = false;
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final dateAccent = colors.accentOf(AppMode.date);
    final crewAccent = colors.accentOf(AppMode.crew);

    Widget modeCard({
      required AppMode mode,
      required String title,
      required String description,
      required Color accent,
      required List<Widget> settings,
    }) {
      final enabled = _modes.contains(mode);
      return Padding(
        padding: EdgeInsets.only(bottom: spacing.md),
        child: GlassCard(
          borderGradient: enabled ? colors.gradientOf(mode) : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: enabled,
                activeThumbColor: accent,
                title: Text(
                  title.toUpperCase(),
                  style: context.textTheme.titleLarge?.copyWith(color: accent),
                ),
                subtitle: Text(description),
                onChanged: (v) => _toggleMode(mode, enabled: v),
              ),
              if (enabled) ...settings,
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        modeCard(
          mode: AppMode.date,
          title: l10n.modeDate,
          description: l10n.modeDateDescription,
          accent: dateAccent,
          settings: [
            FieldLabel(l10n.dateLookingFor),
            ChoiceChipGroup<DateIntent>(
              options: DateIntent.values,
              selected: {?_lookingFor},
              accent: dateAccent,
              labelOf: l10n.dateIntent,
              onChanged: (v) => setState(() => _lookingFor = _single(v)),
            ),
            FieldLabel(l10n.dateShowMe),
            Wrap(
              spacing: spacing.xs,
              runSpacing: spacing.xs,
              children: [
                ChoiceChipGroup<bool>(
                  options: const [true],
                  selected: {if (_showMe.isEmpty) true},
                  accent: dateAccent,
                  labelOf: (_) => l10n.showMeEveryone,
                  onChanged: (_) => setState(() => _showMe = {}),
                ),
                ChoiceChipGroup<Gender>(
                  options: const [Gender.woman, Gender.man, Gender.nonBinary],
                  selected: _showMe,
                  multiple: true,
                  accent: dateAccent,
                  labelOf: l10n.showMe,
                  onChanged: (v) => setState(() => _showMe = v),
                ),
              ],
            ),
            FieldLabel(
              l10n.dateAgeRange(_ages.start.round(), _ages.end.round()),
            ),
            RangeSlider(
              min: AppConstants.minAge.toDouble(),
              max: 99,
              divisions: 99 - AppConstants.minAge,
              values: _ages,
              activeColor: dateAccent,
              labels: RangeLabels(
                '${_ages.start.round()}',
                '${_ages.end.round()}',
              ),
              onChanged: (v) => setState(() => _ages = v),
            ),
          ],
        ),
        modeCard(
          mode: AppMode.crew,
          title: l10n.modeCrew,
          description: l10n.modeCrewDescription,
          accent: crewAccent,
          settings: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _canUseSameGender && _sameGender,
              activeThumbColor: crewAccent,
              title: Text(l10n.crewSameGender),
              subtitle: Text(
                _canUseSameGender
                    ? l10n.crewSameGenderHint
                    : l10n.crewSameGenderUnavailable,
              ),
              onChanged: _canUseSameGender
                  ? (v) => setState(() => _sameGender = v)
                  : null,
            ),
          ],
        ),
        if (_showModesError)
          Text(
            l10n.modesMinHint,
            style: context.textTheme.bodySmall?.copyWith(color: colors.error),
          )
        else if (widget.allowNone && _modes.isEmpty)
          Text(l10n.modesNoneHint, style: context.textTheme.bodySmall),
        _SubmitArea(label: widget.submitLabel, onPressed: _submit),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// First onboarding step: Date, Crew or only events
// ---------------------------------------------------------------------------

class IntentForm extends StatefulWidget {
  const new({
    required this.initial,
    required this.submitLabel,
    required this.onSubmit,
    super.key,
  });

  final MyProfile initial;
  final String submitLabel;
  final ProfileSubmit onSubmit;

  @override
  State<IntentForm> createState() => _IntentFormState();
}

class _IntentFormState extends State<IntentForm> {
  late final Set<AppMode> _modes = {...widget.initial.modes};

  /// Coming back to this step after choosing "only events" keeps it marked.
  late bool _eventsOnly =
      widget.initial.modes.isEmpty && widget.initial.onboardingStep > 0;
  bool _showError = false;

  void _toggleMode(AppMode mode) => setState(() {
    _modes.contains(mode) ? _modes.remove(mode) : _modes.add(mode);
    _eventsOnly = false;
    _showError = false;
  });

  void _chooseEventsOnly() => setState(() {
    _eventsOnly = !_eventsOnly;
    if (_eventsOnly) _modes.clear();
    _showError = false;
  });

  Future<void> _submit() async {
    if (_modes.isEmpty && !_eventsOnly) {
      setState(() => _showError = true);
      return;
    }
    await widget.onSubmit({'modes': enumsToDb(_modes)});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;

    Widget option({
      required bool selected,
      required String title,
      required String description,
      required Color accent,
      required IconData icon,
      required VoidCallback onTap,
      Gradient? gradient,
    }) {
      return Padding(
        padding: EdgeInsets.only(bottom: spacing.md),
        child: Semantics(
          button: true,
          selected: selected,
          child: GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: GlassCard(
              borderGradient: selected ? gradient : null,
              child: Row(
                children: [
                  Icon(icon, color: accent),
                  SizedBox(width: spacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title.toUpperCase(),
                          style: context.textTheme.titleLarge?.copyWith(
                            color: accent,
                          ),
                        ),
                        SizedBox(height: spacing.xs),
                        Text(description, style: context.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    color: selected ? accent : colors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        option(
          selected: _modes.contains(AppMode.date),
          title: l10n.modeDate,
          description: l10n.modeDateDescription,
          accent: colors.accentOf(AppMode.date),
          gradient: colors.gradientOf(AppMode.date),
          icon: Icons.favorite_rounded,
          onTap: () => _toggleMode(AppMode.date),
        ),
        option(
          selected: _modes.contains(AppMode.crew),
          title: l10n.modeCrew,
          description: l10n.modeCrewDescription,
          accent: colors.accentOf(AppMode.crew),
          gradient: colors.gradientOf(AppMode.crew),
          icon: Icons.bolt_rounded,
          onTap: () => _toggleMode(AppMode.crew),
        ),
        option(
          selected: _eventsOnly,
          title: l10n.intentEventsOnly,
          description: l10n.intentEventsOnlyDescription,
          accent: colors.lime,
          icon: Icons.event_rounded,
          onTap: _chooseEventsOnly,
        ),
        Text(
          _showError ? l10n.intentRequired : l10n.intentHint,
          style: context.textTheme.bodySmall?.copyWith(
            color: _showError ? colors.error : null,
          ),
        ),
        _SubmitArea(label: widget.submitLabel, onPressed: _submit),
      ],
    );
  }
}
