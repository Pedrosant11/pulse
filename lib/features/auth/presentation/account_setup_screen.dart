import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/constants.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/flow_scaffold.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/features/auth/domain/phone_number.dart';
import 'package:pulse/features/auth/presentation/auth_controllers.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/auth/presentation/widgets/auth_form_widgets.dart';
import 'package:pulse/features/legal/domain/legal_document.dart';

enum _SetupStep { phone, terms }

/// Sign-up steps 2–3 (SPEC 5.1): phone and terms. The phone is saved
/// without a code (launch decision) and must not belong to another
/// account. Reached after the e-mail is confirmed; resumes where the user
/// stopped.
class AccountSetupScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends ConsumerState<AccountSetupScreen> {
  final _phoneFormKey = GlobalKey<FormState>();
  final _phone = TextEditingController();

  late _SetupStep _step;
  CallingCode _callingCode = CallingCode.brazil;
  bool _acceptedTerms = false;
  bool _acceptedPrivacy = false;
  bool _acceptedLgpd = false;

  @override
  void initState() {
    super.initState();
    final hasPhone = ref.read(accountProvider).value?.hasPhone ?? false;
    _step = hasPhone ? _SetupStep.terms : _SetupStep.phone;
  }

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  AccountSetupController get _controller =>
      ref.read(accountSetupControllerProvider.notifier);

  Future<void> _savePhone() async {
    if (!_phoneFormKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final saved = await _controller.savePhone(
      PhoneNumbers.toE164(_callingCode, _phone.text),
    );
    if (saved == true && mounted) setState(() => _step = _SetupStep.terms);
  }

  Future<void> _acceptTerms() async {
    // On success the account refreshes and the router moves to onboarding.
    await _controller.acceptTerms();
  }

  void _signOut() => ref.read(signOutControllerProvider.notifier).signOut();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(accountSetupControllerProvider);
    final signOutAction = TextButton(
      onPressed: _signOut,
      child: Text(l10n.signOut),
    );

    final (title, subtitle, stepNumber, content) = switch (_step) {
      _SetupStep.phone => (
        l10n.phoneStepTitle,
        l10n.phoneStepSubtitle,
        2,
        _buildPhoneStep(context, state),
      ),
      _SetupStep.terms => (
        l10n.termsStepTitle,
        l10n.termsStepSubtitle,
        3,
        _buildTermsStep(context, state),
      ),
    };

    return FlowScaffold(
      key: ValueKey(_step),
      title: title,
      subtitle: subtitle,
      step: stepNumber,
      actions: [signOutAction],
      children: [content],
    );
  }

  Widget _buildPhoneStep(BuildContext context, AsyncValue<void> state) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Form(
          key: _phoneFormKey,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<CallingCode>(
                  initialValue: _callingCode,
                  // Shrinks with large fonts instead of overflowing.
                  isExpanded: true,
                  decoration: InputDecoration(labelText: l10n.callingCodeLabel),
                  items: [
                    for (final code in CallingCode.values)
                      DropdownMenuItem(
                        value: code,
                        child: Text(
                          '${code.flag} +${code.dialCode}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  onChanged: (code) => setState(() {
                    _callingCode = code ?? CallingCode.brazil;
                    _phone.clear();
                  }),
                ),
              ),
              SizedBox(width: spacing.sm),
              Expanded(
                flex: 5,
                child: TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  autofillHints: const [AutofillHints.telephoneNumberNational],
                  inputFormatters: [NationalPhoneFormatter(_callingCode)],
                  decoration: InputDecoration(labelText: l10n.fieldPhone),
                  validator: (value) =>
                      PhoneNumbers.isValidNational(_callingCode, value ?? '')
                      ? null
                      : l10n.validationPhone,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: spacing.xl),
        FormErrorText(error: state.error),
        NeonButton(
          label: l10n.continueButton,
          isLoading: state.isLoading,
          onPressed: _savePhone,
        ),
      ],
    );
  }

  Widget _buildTermsStep(BuildContext context, AsyncValue<void> state) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final allAccepted = _acceptedTerms && _acceptedPrivacy && _acceptedLgpd;

    Widget check({
      required String label,
      required bool value,
      required ValueChanged<bool> onChanged,
      LegalDocument? document,
    }) {
      return CheckboxListTile(
        value: value,
        onChanged: (checked) => setState(() => onChanged(checked ?? false)),
        title: Text(label, style: context.textTheme.bodyMedium),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        // The document opens inside the app (it's bundled).
        secondary: document == null
            ? null
            : TextButton(
                onPressed: () => context.push(AppRoutes.legal(document)),
                child: Text(l10n.legalRead),
              ),
      );
    }

    final checks = [
      check(
        label: l10n.termsAcceptTerms,
        document: LegalDocument.terms,
        value: _acceptedTerms,
        onChanged: (v) => _acceptedTerms = v,
      ),
      check(
        label: l10n.termsAcceptPrivacy,
        document: LegalDocument.privacy,
        value: _acceptedPrivacy,
        onChanged: (v) => _acceptedPrivacy = v,
      ),
      check(
        label: l10n.termsAcceptLgpd,
        value: _acceptedLgpd,
        onChanged: (v) => _acceptedLgpd = v,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GlassCard(
          child: Column(
            children: context.reduceMotion
                ? checks
                : checks.animate(interval: 80.ms).fadeIn(duration: 250.ms),
          ),
        ),
        SizedBox(height: spacing.xs),
        Text(
          l10n.termsVersion(AppConstants.termsVersion),
          style: context.textTheme.labelSmall,
        ),
        SizedBox(height: spacing.xl),
        FormErrorText(error: state.error),
        NeonButton(
          label: l10n.termsSubmit,
          isLoading: state.isLoading,
          onPressed: allAccepted ? _acceptTerms : null,
        ),
      ],
    );
  }
}
