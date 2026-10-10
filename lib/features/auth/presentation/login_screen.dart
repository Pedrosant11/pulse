import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/flow_scaffold.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/features/auth/domain/auth_validators.dart';
import 'package:pulse/features/auth/presentation/auth_controllers.dart';
import 'package:pulse/features/auth/presentation/widgets/auth_form_widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    // On success the session changes and the router redirects.
    await ref
        .read(loginControllerProvider.notifier)
        .signIn(email: _email.text, password: _password.text);
  }

  Future<void> _resendConfirmation() async {
    final sent = await ref
        .read(loginControllerProvider.notifier)
        .resendConfirmation(_email.text);
    if (sent == true && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.emailResent)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final state = ref.watch(loginControllerProvider);
    final error = state.error;

    return FlowScaffold(
      showLogo: true,
      title: l10n.loginTitle,
      subtitle: l10n.loginSubtitle,
      children: [
        Form(
          key: _formKey,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                  validator: (value) =>
                      (value ?? '').isEmpty ? l10n.validationRequired : null,
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => context.push(AppRoutes.forgotPassword),
            child: Text(l10n.goToForgotPassword),
          ),
        ),
        SizedBox(height: spacing.sm),
        FormErrorText(error: error),
        if (error is EmailNotConfirmedFailure)
          Padding(
            padding: EdgeInsets.only(bottom: spacing.md),
            child: OutlinedButton(
              onPressed: state.isLoading ? null : _resendConfirmation,
              child: Text(l10n.resendConfirmation),
            ),
          ),
        NeonButton(
          label: l10n.loginSubmit,
          icon: Icons.login_rounded,
          isLoading: state.isLoading,
          onPressed: _submit,
        ),
        SizedBox(height: spacing.md),
        OutlinedButton(
          onPressed: () => context.push(AppRoutes.signup),
          child: Text(l10n.goToSignup),
        ),
      ],
    );
  }
}
