import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/flow_scaffold.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/features/auth/domain/auth_validators.dart';
import 'package:pulse/features/auth/presentation/auth_controllers.dart';
import 'package:pulse/features/auth/presentation/widgets/auth_form_widgets.dart';

/// Opened from the password-reset e-mail link (recovery session).
class ResetPasswordScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    // On success the recovery flag clears and the router moves on.
    await ref
        .read(passwordResetControllerProvider.notifier)
        .saveNewPassword(_password.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final state = ref.watch(passwordResetControllerProvider);

    return FlowScaffold(
      showLogo: true,
      title: l10n.resetPasswordTitle,
      subtitle: l10n.resetPasswordSubtitle,
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PasswordField(
                controller: _password,
                label: l10n.fieldNewPassword,
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
              PasswordField(
                controller: _confirmation,
                label: l10n.fieldConfirmPassword,
                autofillHints: const [AutofillHints.newPassword],
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                validator: (value) => value == _password.text
                    ? null
                    : l10n.validationPasswordMismatch,
              ),
            ],
          ),
        ),
        SizedBox(height: spacing.lg),
        FormErrorText(error: state.error),
        NeonButton(
          label: l10n.resetPasswordSubmit,
          isLoading: state.isLoading,
          onPressed: _submit,
        ),
      ],
    );
  }
}
