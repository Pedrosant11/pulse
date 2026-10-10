import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/flow_scaffold.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/features/auth/presentation/auth_controllers.dart';
import 'package:pulse/features/auth/presentation/widgets/auth_form_widgets.dart';

/// Shown after sign-up while the e-mail is not confirmed. The confirmation
/// link opens the app (deep link) and signs the user in.
class CheckEmailScreen extends ConsumerStatefulWidget {
  const new({required this.email, super.key});

  final String email;

  @override
  ConsumerState<CheckEmailScreen> createState() => _CheckEmailScreenState();
}

class _CheckEmailScreenState extends ConsumerState<CheckEmailScreen> {
  static const _cooldown = Duration(seconds: 60);
  DateTime? _sentAt = DateTime.now();

  Future<void> _resend() async {
    final sent = await ref
        .read(signupControllerProvider.notifier)
        .resendConfirmation(widget.email);
    if (sent != true || !mounted) return;
    setState(() => _sentAt = DateTime.now());
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.emailResent)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final state = ref.watch(signupControllerProvider);

    return FlowScaffold(
      showLogo: true,
      title: l10n.checkEmailTitle,
      step: 1,
      onBack: () => context.go(AppRoutes.login),
      children: [
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.mark_email_unread_outlined,
                size: 40,
                color: context.colors.magenta,
              ),
              SizedBox(height: spacing.md),
              Text(
                l10n.checkEmailBody(widget.email),
                style: context.textTheme.bodyLarge,
              ),
              SizedBox(height: spacing.sm),
              Text(l10n.checkEmailSpamHint, style: context.textTheme.bodySmall),
            ],
          ),
        ),
        SizedBox(height: spacing.lg),
        FormErrorText(error: state.error),
        NeonButton(
          label: l10n.goToLogin,
          onPressed: () => context.go(AppRoutes.login),
        ),
        SizedBox(height: spacing.sm),
        CooldownButton(
          label: l10n.resendEmail,
          labelWithSeconds: l10n.resendEmailIn,
          cooldown: _cooldown,
          cooldownStartedAt: _sentAt,
          onPressed: state.isLoading ? null : _resend,
        ),
      ],
    );
  }
}
