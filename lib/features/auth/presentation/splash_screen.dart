import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/errors/app_failure_message.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/neon_backdrop.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/core/widgets/pulse_logo.dart';
import 'package:pulse/features/auth/presentation/auth_controllers.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';

/// Shown while the session and account load. If the account can't be
/// loaded, offers retry (or sign out) instead of spinning forever.
class SplashScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = context.l10n;
    final spacing = context.spacing;
    final accountError = ref.watch(accountProvider).error;

    Widget logo = const PulseLogo(markSize: 96, vertical: true, beating: true);
    Widget tagline = Text(
      l10n.splashTagline,
      style: context.textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
    );
    if (!context.reduceMotion) {
      logo = logo
          .animate()
          .fadeIn(duration: 500.ms)
          .scaleXY(begin: 0.9, curve: Curves.easeOutBack);
      tagline = tagline.animate().fadeIn(delay: 300.ms, duration: 400.ms);
    }

    return NeonBackdrop(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(spacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: logo),
                SizedBox(height: spacing.sm),
                Center(child: tagline),
                if (accountError != null) ...[
                  SizedBox(height: spacing.xxl),
                  Text(
                    l10n.splashLoadError,
                    textAlign: TextAlign.center,
                    style: context.textTheme.titleMedium,
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    friendlyErrorMessage(accountError, l10n),
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodySmall,
                  ),
                  SizedBox(height: spacing.lg),
                  NeonButton(
                    label: l10n.stateRetry,
                    onPressed: () => ref.invalidate(accountProvider),
                  ),
                  TextButton(
                    onPressed: () =>
                        ref.read(signOutControllerProvider.notifier).signOut(),
                    child: Text(l10n.signOut),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
