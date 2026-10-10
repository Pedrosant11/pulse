import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/crews/domain/crew_models.dart';
import 'package:pulse/features/crews/presentation/crews_providers.dart';
import 'package:pulse/features/profile/domain/profile_enums.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';

/// Create a crew for an event (optionally inviting a Crew match, e.g. from
/// the match screen) or edit one (SPEC 9.2).
class CrewFormScreen extends ConsumerWidget {
  const new({
    this.crewId,
    this.eventId,
    this.eventName,
    this.inviteUserId,
    this.inviteName,
    super.key,
  });

  /// Set when editing.
  final String? crewId;

  /// Set when creating.
  final String? eventId;
  final String? eventName;
  final String? inviteUserId;
  final String? inviteName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final crewId = this.crewId;
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(
          (crewId == null ? l10n.crewFormTitle : l10n.crewFormEditTitle)
              .toUpperCase(),
        ),
      ),
      body: SafeArea(
        child: crewId == null
            ? _CrewForm(
                eventId: eventId!,
                eventName: eventName,
                inviteUserId: inviteUserId,
                inviteName: inviteName,
              )
            : AsyncValueView(
                value: ref.watch(crewProvider(crewId)),
                onRetry: () => ref.invalidate(crewProvider(crewId)),
                data: (crew) => crew == null
                    ? EmptyView(
                        icon: Icons.group_off_outlined,
                        title: l10n.crewNotFound,
                      )
                    : _CrewForm(
                        eventId: crew.eventId,
                        eventName: crew.eventName,
                        initial: crew,
                      ),
              ),
      ),
    );
  }
}

class _CrewForm extends ConsumerStatefulWidget {
  const new({
    required this.eventId,
    this.eventName,
    this.initial,
    this.inviteUserId,
    this.inviteName,
  });

  final String eventId;
  final String? eventName;
  final CrewDetail? initial;
  final String? inviteUserId;
  final String? inviteName;

  @override
  ConsumerState<_CrewForm> createState() => _CrewFormState();
}

class _CrewFormState extends ConsumerState<_CrewForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initial?.name);
  late final _description = TextEditingController(
    text: widget.initial?.description,
  );
  late bool _isOpen = widget.initial?.isOpen ?? true;
  late bool _sameGender = widget.initial?.sameGenderOnly ?? false;

  @override
  void initState() {
    super.initState();
    if (widget.initial == null) {
      final firstName = ref.read(myProfileProvider).value?.firstName;
      if (firstName != null) {
        // Suggested name, editable.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _name.text.isEmpty) {
            _name.text = context.l10n.crewNameDefault(firstName);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final editor = ref.read(crewEditorProvider.notifier);
    final l10n = context.l10n;
    final description = _description.text.trim();
    final initial = widget.initial;

    if (initial != null) {
      final saved = await editor.save(initial.id, {
        'name': _name.text.trim(),
        'description': description.isEmpty ? null : description,
        'is_open': _isOpen,
      });
      if (saved == true && mounted) context.pop();
      return;
    }

    final crewId = await editor.create(
      eventId: widget.eventId,
      name: _name.text.trim(),
      description: description.isEmpty ? null : description,
      isOpen: _isOpen,
      sameGenderOnly: _sameGender,
      inviteUserId: widget.inviteUserId,
    );
    if (crewId == null || !mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.crewCreated)));
    context.pushReplacement(AppRoutes.crew(crewId));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final colors = context.colors;
    final editor = ref.watch(crewEditorProvider);
    final gender = ref.watch(myProfileProvider).value?.gender;
    final canSameGender = gender != null && gender != Gender.preferNotSay;
    final isNew = widget.initial == null;
    final eventName = widget.eventName;
    final inviteName = widget.inviteName;

    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(spacing.md),
        children: [
          if (eventName != null)
            Text(
              l10n.crewFormFor(eventName),
              style: context.textTheme.titleMedium?.copyWith(
                color: colors.cyan,
              ),
            ),
          if (isNew && inviteName != null) ...[
            SizedBox(height: spacing.sm),
            GlassCard(
              child: Row(
                children: [
                  Icon(Icons.person_add_alt_1, color: colors.cyan),
                  SizedBox(width: spacing.sm),
                  Expanded(child: Text(l10n.crewFormInviteNote(inviteName))),
                ],
              ),
            ),
          ],
          SizedBox(height: spacing.md),
          TextFormField(
            controller: _name,
            maxLength: 40,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: l10n.crewName),
            validator: (v) =>
                (v ?? '').trim().length < 2 ? l10n.validationRequired : null,
          ),
          SizedBox(height: spacing.sm),
          TextFormField(
            controller: _description,
            maxLength: 280,
            minLines: 2,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l10n.crewDescription,
              hintText: l10n.crewDescriptionHint,
              alignLabelWithHint: true,
            ),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _isOpen,
            activeThumbColor: colors.cyan,
            title: Text(l10n.crewOpen),
            subtitle: Text(l10n.crewOpenHint),
            onChanged: (v) => setState(() => _isOpen = v),
          ),
          // Fixed at creation (the database stores the owner's gender).
          if (isNew)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: canSameGender && _sameGender,
              activeThumbColor: colors.cyan,
              title: Text(l10n.crewSameGenderOnly),
              subtitle: canSameGender
                  ? null
                  : Text(l10n.crewSameGenderUnavailable),
              onChanged: canSameGender
                  ? (v) => setState(() => _sameGender = v)
                  : null,
            ),
          SizedBox(height: spacing.lg),
          FormErrorText(error: editor.error),
          NeonButton(
            label: isNew ? l10n.crewCreate : l10n.saveButton,
            icon: isNew ? Icons.groups_rounded : null,
            gradient: colors.crewGradient,
            isLoading: editor.isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
