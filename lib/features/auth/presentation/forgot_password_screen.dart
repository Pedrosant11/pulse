import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/flow_scaffold.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/features/auth/domain/auth_validators.dart';
import 'package:pulse/features/auth/presentation/auth_controllers.dart';
import 'package:pulse/features/auth/presentation/widgets/auth_form_widgets.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final sent = await ref
        .read(passwordResetControllerProvider.notifier)
        .sendLink(_email.text);
    if (sent == true && mounted) setState(() => _sent = true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final state = ref.watch(passwordResetControllerProvider);

    return FlowScaffold(
      showLogo: true,
      title: l10n.forgotPasswordTitle,
      subtitle: l10n.forgotPasswordSubtitle,
      children: [
        Form(
          key: _formKey,
          child: TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            inputFormatters: emailInputFormatters,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            decoration: InputDecoration(labelText: l10n.fieldEmail),
            validator: (value) => AuthValidators.isValidEmail(value ?? '')
                ? null
                : l10n.validationEmail,
          ),
        ),
        SizedBox(height: spacing.lg),
        if (_sent) ...[
          GlassCard(
            child: Row(
              children: [
                Icon(Icons.check_circle_outline, color: context.colors.success),
                SizedBox(width: spacing.sm),
                Expanded(child: Text(l10n.forgotPasswordSent)),
              ],
            ),
          ),
          SizedBox(height: spacing.lg),
        ],
        FormErrorText(error: state.error),
        NeonButton(
          label: l10n.forgotPasswordSubmit,
          isLoading: state.isLoading,
          onPressed: _submit,
        ),
      ],
    );
  }
}
