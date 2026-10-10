import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/neon_backdrop.dart';
import 'package:pulse/features/auth/domain/account_state.dart';
import 'package:pulse/features/auth/presentation/auth_controllers.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/events/presentation/widgets/event_visuals.dart';
import 'package:pulse/features/safety/presentation/safety_providers.dart';

/// Shown instead of the app while the account is suspended or banned
/// (SPEC 10). The database already blocks every social action; this
/// explains why and until when.
class AccountRestrictedScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final isBanned =
        ref.watch(accountProvider).value?.status == AccountStatus.banned;
    final notice = ref.watch(moderationNoticeProvider).value;
    final expiresAt = notice?.expiresAt;
    final signOut = ref.watch(signOutControllerProvider);

    return NeonBackdrop(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(spacing.lg),
            children: [
              SizedBox(height: spacing.xl),
              Icon(
                isBanned ? Icons.gpp_bad_outlined : Icons.pause_circle_outline,
                size: 72,
                color: colors.error,
              ),
              SizedBox(height: spacing.md),
              Text(
                (isBanned
                        ? l10n.restrictedBannedTitle
                        : l10n.restrictedSuspendedTitle)
                    .toUpperCase(),
                textAlign: TextAlign.center,
                style: context.textTheme.headlineMedium,
              ),
              if (!isBanned && expiresAt != null) ...[
                SizedBox(height: spacing.xs),
                Text(
                  l10n.restrictedUntil(formatEventDate(context, expiresAt)),
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: colors.lime,
                  ),
                ),
              ],
              SizedBox(height: spacing.lg),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isBanned
                          ? l10n.restrictedBannedBody
                          : l10n.restrictedSuspendedBody,
                      style: context.textTheme.bodyLarge,
                    ),
                    if (notice != null) ...[
                      SizedBox(height: spacing.sm),
                      Text(
                        l10n.restrictedReason(notice.reason),
                        style: context.textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: spacing.xl),
              if (!isBanned)
                OutlinedButton.icon(
                  onPressed: () {
                    ref
                      ..invalidate(accountProvider)
                      ..invalidate(moderationNoticeProvider);
                  },
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.restrictedCheckAgain),
                ),
              SizedBox(height: spacing.sm),
              OutlinedButton.icon(
                onPressed: signOut.isLoading
                    ? null
                    : ref.read(signOutControllerProvider.notifier).signOut,
                icon: const Icon(Icons.logout_rounded),
                label: Text(l10n.signOut),
              ),
              SizedBox(height: spacing.sm),
              TextButton(
                onPressed: () => context.push(AppRoutes.deleteAccount),
                child: Text(
                  l10n.deleteAccountEntry,
                  style: TextStyle(color: colors.error),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
