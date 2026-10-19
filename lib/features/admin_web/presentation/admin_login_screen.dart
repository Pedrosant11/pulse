import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/features/auth/presentation/auth_controllers.dart';

/// Console sign-in: the same account as in the app (admins only get in).
class AdminLoginScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends ConsumerState<AdminLoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _hidden = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_email.text.trim().isEmpty || _password.text.isEmpty) return;
    // The router moves on once the session and the role are known.
    await ref
        .read(loginControllerProvider.notifier)
        .signIn(email: _email.text, password: _password.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final login = ref.watch(loginControllerProvider);
    return Scaffold(
      backgroundColor: context.colors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(spacing.md),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: GlassCard(
              child: AutofillGroup(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const ConsoleBrand(),
                    SizedBox(height: spacing.lg),
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      decoration: InputDecoration(labelText: l10n.fieldEmail),
                    ),
                    SizedBox(height: spacing.sm),
                    TextField(
                      controller: _password,
                      obscureText: _hidden,
                      autofillHints: const [AutofillHints.password],
                      onSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: l10n.fieldPassword,
                        suffixIcon: IconButton(
                          tooltip: l10n.showPassword,
                          onPressed: () => setState(() => _hidden = !_hidden),
                          icon: Icon(
                            _hidden ? Icons.visibility : Icons.visibility_off,
                          ),
                        ),
                      ),
                    ),
                    FormErrorText(error: login.error),
                    SizedBox(height: spacing.md),
                    NeonButton(
                      label: l10n.loginTitle,
                      isLoading: login.isLoading,
                      onPressed: login.isLoading ? null : _submit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// "PULSE · Admin" title.
class ConsoleBrand extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.graphic_eq_rounded, color: colors.magenta),
        SizedBox(width: context.spacing.xs),
        Text('PULSE', style: context.textTheme.titleLarge),
        SizedBox(width: context.spacing.xs),
        Text(
          context.l10n.consoleTitle,
          style: context.textTheme.titleMedium?.copyWith(color: colors.lime),
        ),
      ],
    );
  }
}

/// Signed in, but not an admin.
class AdminDeniedScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: context.colors.background,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(context.spacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 48,
                color: context.colors.error,
              ),
              SizedBox(height: context.spacing.md),
              Text(l10n.consoleDenied, style: context.textTheme.titleLarge),
              SizedBox(height: context.spacing.md),
              OutlinedButton(
                onPressed: () =>
                    ref.read(signOutControllerProvider.notifier).signOut(),
                child: Text(l10n.signOut),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
