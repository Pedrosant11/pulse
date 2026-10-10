import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/constants.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/flow_scaffold.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/features/auth/domain/auth_validators.dart';
import 'package:pulse/features/auth/presentation/auth_controllers.dart';
import 'package:pulse/features/auth/presentation/widgets/auth_form_widgets.dart';

/// Sign-up step 1: account data (SPEC 5.1). Steps 2–4 (phone, code, terms)
/// happen after the e-mail is confirmed, in AccountSetupScreen.
class SignupScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _birthDateText = TextEditingController();
  DateTime? _birthDate;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _password.dispose();
    _birthDateText.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final adultLimit = DateTime(
      now.year - AppConstants.minAge,
      now.month,
      now.day,
    );
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 25),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
      initialEntryMode: DatePickerEntryMode.input,
      helpText: context.l10n.fieldBirthDate,
    );
    if (picked == null || !mounted) return;
    setState(() {
      _birthDate = picked;
      _birthDateText.text = MaterialLocalizations.of(context)
          .formatCompactDate(picked);
    });
    // Re-validate right away so minors see the message immediately.
    if (picked.isAfter(adultLimit)) _formKey.currentState?.validate();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final needsConfirmation = await ref
        .read(signupControllerProvider.notifier)
        .signUp(
          firstName: _firstName.text,
          lastName: _lastName.text,
          email: _email.text,
          password: _password.text,
          birthDate: _birthDate!,
        );
    // When confirmation is off (local dev) the session starts and the router
    // moves on to the next steps by itself.
    if (needsConfirmation == true && mounted) {
      context.go(AppRoutes.checkEmailFor(_email.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final state = ref.watch(signupControllerProvider);
    String? required(String? value) =>
        (value ?? '').trim().isEmpty ? l10n.validationRequired : null;

    return FlowScaffold(
      showLogo: true,
      title: l10n.signupAccountTitle,
      subtitle: l10n.signupAccountSubtitle,
      step: 1,
      children: [
        Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _firstName,
                  textCapitalization: TextCapitalization.words,
                  autofillHints: const [AutofillHints.givenName],
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: l10n.fieldFirstName),
                  validator: required,
                ),
                SizedBox(height: spacing.md),
                TextFormField(
                  controller: _lastName,
                  textCapitalization: TextCapitalization.words,
                  autofillHints: const [AutofillHints.familyName],
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l10n.fieldLastName,
                    helperText: l10n.lastNamePrivacyHint,
                  ),
                  validator: required,
                ),
                SizedBox(height: spacing.md),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  inputFormatters: emailInputFormatters,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: l10n.fieldEmail),
                  validator: (value) => AuthValidators.isValidEmail(value ?? '')
                      ? null
                      : l10n.validationEmail,
                ),
                SizedBox(height: spacing.md),
                PasswordField(
                  controller: _password,
                  label: l10n.fieldPassword,
                  autofillHints: const [AutofillHints.newPassword],
                  onChanged: (_) => setState(() {}),
                  validator: (value) =>
                      AuthValidators.isPasswordAccepted(value ?? '')
                      ? null
                      : l10n.validationPassword,
                ),
                SizedBox(height: spacing.xs),
                PasswordStrengthMeter(password: _password.text),
                SizedBox(height: spacing.md),
                TextFormField(
                  controller: _birthDateText,
                  readOnly: true,
                  onTap: _pickBirthDate,
                  decoration: InputDecoration(
                    labelText: l10n.fieldBirthDate,
                    helperText: l10n.birthDatePrivacyHint,
                    suffixIcon: const Icon(Icons.calendar_today_outlined),
                  ),
                  validator: (_) {
                    final birthDate = _birthDate;
                    if (birthDate == null) return l10n.validationRequired;
                    return AuthValidators.isAdult(birthDate)
                        ? null
                        : l10n.validationUnderage;
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: spacing.lg),
        FormErrorText(error: state.error),
        NeonButton(
          label: l10n.signupSubmit,
          isLoading: state.isLoading,
          onPressed: _submit,
        ),
        SizedBox(height: spacing.sm),
        TextButton(
          onPressed: () => context.go(AppRoutes.login),
          child: Text(l10n.goToLogin),
        ),
      ],
    );
  }
}
