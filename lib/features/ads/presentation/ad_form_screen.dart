import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/features/ads/data/ads_repository.dart';
import 'package:pulse/features/ads/domain/ad_models.dart';
import 'package:pulse/features/ads/presentation/ads_providers.dart';
import 'package:pulse/features/profile/data/photo_picker.dart';

/// What the form opens with: an ad to edit, or a party to advertise.
class AdFormArgs {
  const new({this.ad, this.eventId, this.eventName});

  final AdminAd? ad;
  final String? eventId;
  final String? eventName;
}

/// Admin: create or edit an own ad.
class AdFormScreen extends ConsumerStatefulWidget {
  const new({required this.args, super.key});

  final AdFormArgs args;

  @override
  ConsumerState<AdFormScreen> createState() => _AdFormScreenState();
}

class _AdFormScreenState extends ConsumerState<AdFormScreen> {
  final _form = GlobalKey<FormState>();
  late final AdminAd? _original = widget.args.ad;
  late final _title = TextEditingController(
    text: _original?.title ?? widget.args.eventName ?? '',
  );
  late final _body = TextEditingController(text: _original?.body ?? '');
  late final _cta = TextEditingController(text: _original?.cta ?? '');
  late final _link = TextEditingController(text: _original?.linkUrl ?? '');
  late String? _eventId = _original?.eventId ?? widget.args.eventId;
  late Set<AdPlacement> _placements = {
    ...(_original?.placements ?? AdPlacement.values),
  };
  late DateTime _startsAt = _original?.startsAt ?? DateTime.now();
  late DateTime? _endsAt = _original?.endsAt;
  late bool _active = _original?.active ?? true;
  Uint8List? _image;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    _cta.dispose();
    _link.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final jpeg = await ref
        .read(photoPickerProvider)
        .pick(
          PhotoSource.gallery,
          cropTitle: context.l10n.adImage,
          shape: PhotoShape.cover,
        );
    if (jpeg != null && mounted) setState(() => _image = jpeg);
  }

  Future<DateTime?> _pickDate(DateTime initial) {
    final now = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 1),
      lastDate: now.add(const Duration(days: 730)),
    );
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate() || _placements.isEmpty) return;
    final ad = AdminAd(
      id: _original?.id ?? '',
      title: _title.text,
      body: _body.text,
      cta: _cta.text,
      linkUrl: _link.text,
      eventId: _eventId,
      imagePath: _original?.imagePath,
      placements: [
        for (final p in AdPlacement.values)
          if (_placements.contains(p)) p,
      ],
      startsAt: _startsAt,
      endsAt: _endsAt,
      active: _active,
    );
    final saved = await ref
        .read(adEditorProvider.notifier)
        .save(ad, image: _image, isNew: _original == null);
    if (saved == true && mounted) context.pop();
  }

  Future<void> _delete() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.adDeleteTitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.notNow),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.adDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final deleted = await ref
        .read(adEditorProvider.notifier)
        .delete(_original!);
    if (deleted == true && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final editor = ref.watch(adEditorProvider);
    final dates = DateFormat.yMd('pt_BR');
    final imagePath = _original?.imagePath;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(
          (_original == null ? l10n.adNew : l10n.adEdit).toUpperCase(),
        ),
        actions: [
          if (_original != null)
            IconButton(
              tooltip: l10n.adDelete,
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: editor.isLoading ? null : _delete,
            ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _form,
          child: ListView(
            padding: EdgeInsets.all(spacing.md),
            children: [
              // 16:9 image, like event covers.
              InkWell(
                onTap: _pickImage,
                borderRadius: BorderRadius.circular(context.radii.lg),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(context.radii.lg),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: switch ((_image, imagePath)) {
                      (final bytes?, _) => Image.memory(
                        bytes,
                        fit: BoxFit.cover,
                      ),
                      (null, final path?) => CachedNetworkImage(
                        imageUrl: ref
                            .watch(adsRepositoryProvider)
                            .imageUrl(path),
                        fit: BoxFit.cover,
                      ),
                      _ => ColoredBox(
                        color: context.colors.surface,
                        child: Center(
                          child: Text(
                            l10n.adImage,
                            style: context.textTheme.labelLarge,
                          ),
                        ),
                      ),
                    },
                  ),
                ),
              ),
              SizedBox(height: spacing.md),
              TextFormField(
                controller: _title,
                maxLength: 60,
                decoration: InputDecoration(labelText: l10n.adTitle),
                validator: (v) =>
                    (v ?? '').trim().isEmpty ? l10n.adTitleRequired : null,
              ),
              TextFormField(
                controller: _body,
                maxLength: 140,
                maxLines: 3,
                minLines: 1,
                decoration: InputDecoration(labelText: l10n.adBody),
              ),
              TextFormField(
                controller: _cta,
                maxLength: 24,
                decoration: InputDecoration(
                  labelText: l10n.adCta,
                  hintText: l10n.adLearnMore,
                ),
              ),
              if (_eventId != null)
                InputChip(
                  avatar: const Icon(Icons.event_rounded),
                  label: Text(widget.args.eventName ?? l10n.adLinkedEvent),
                  onDeleted: () => setState(() => _eventId = null),
                )
              else
                TextFormField(
                  controller: _link,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    labelText: l10n.adLink,
                    hintText: 'https://',
                  ),
                  validator: (v) {
                    final value = (v ?? '').trim();
                    if (value.isEmpty) return null;
                    final uri = Uri.tryParse(value);
                    return uri != null &&
                            uri.scheme == 'https' &&
                            uri.host.isNotEmpty
                        ? null
                        : l10n.adLinkInvalid;
                  },
                ),
              SizedBox(height: spacing.md),
              Text(l10n.adPlacements, style: context.textTheme.titleSmall),
              for (final placement in AdPlacement.values)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _placements.contains(placement),
                  title: Text(l10n.adPlacement(placement.name)),
                  onChanged: (on) => setState(() {
                    _placements = {..._placements};
                    on!
                        ? _placements.add(placement)
                        : _placements.remove(placement);
                  }),
                ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.play_circle_outline_rounded),
                title: Text(l10n.adStartsAt),
                subtitle: Text(dates.format(_startsAt)),
                onTap: () async {
                  final date = await _pickDate(_startsAt);
                  if (date != null) setState(() => _startsAt = date);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.stop_circle_outlined),
                title: Text(l10n.adEndsAt),
                subtitle: Text(
                  _endsAt == null ? l10n.adNoEnd : dates.format(_endsAt!),
                ),
                trailing: _endsAt == null
                    ? null
                    : IconButton(
                        tooltip: l10n.adNoEnd,
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => setState(() => _endsAt = null),
                      ),
                onTap: () async {
                  final date = await _pickDate(
                    _endsAt ?? _startsAt.add(const Duration(days: 7)),
                  );
                  // Runs through the whole last day.
                  if (date != null) {
                    setState(
                      () => _endsAt = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        23,
                        59,
                      ),
                    );
                  }
                },
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.adActive),
                value: _active,
                onChanged: (on) => setState(() => _active = on),
              ),
              FormErrorText(error: editor.error),
              SizedBox(height: spacing.md),
              NeonButton(
                label: l10n.adSave,
                isLoading: editor.isLoading,
                onPressed: editor.isLoading ? null : _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
