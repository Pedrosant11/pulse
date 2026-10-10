import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/plans/domain/plan_models.dart';
import 'package:pulse/features/plans/presentation/plans_providers.dart';

/// Admins grant a plan for 30 days or packs (tests, partners, support).
/// Store purchases are not touched: a granted plan only replaces a store
/// one until the next store event.
class AdminPlanSection extends ConsumerWidget {
  const new({required this.userId, super.key});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final plan = ref.watch(adminPlanProvider(userId));
    final editor = ref.watch(adminPlanEditorProvider);
    final notifier = ref.read(adminPlanEditorProvider.notifier);
    final busy = editor.isLoading;

    return Padding(
      padding: EdgeInsets.only(top: spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.adminPlanTitle.toUpperCase(),
            style: context.textTheme.titleLarge,
          ),
          SizedBox(height: spacing.sm),
          FormErrorText(error: editor.error),
          AsyncValueView(
            value: plan,
            onRetry: () => ref.invalidate(adminPlanProvider(userId)),
            loading: const LoadingView(itemCount: 1),
            data: (plan) {
              final expires = plan.expiresAt;
              return GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(switch (plan.tier) {
                      final tier? => l10n.planName(tier.name),
                      null => l10n.planFree,
                    }, style: context.textTheme.titleMedium),
                    if (expires != null)
                      Text(
                        l10n.planEndsOn(
                          DateFormat.yMd('pt_BR').format(expires.toLocal()),
                        ),
                        style: context.textTheme.bodySmall,
                      ),
                    Text(
                      l10n.plansWallet(
                        plan.superlikeBalance,
                        plan.boostBalance,
                      ),
                      style: context.textTheme.bodySmall,
                    ),
                    SizedBox(height: spacing.sm),
                    Wrap(
                      spacing: spacing.sm,
                      runSpacing: spacing.xs,
                      children: [
                        for (final tier in PlanTier.values)
                          OutlinedButton(
                            onPressed: busy
                                ? null
                                : () => notifier.grantPlan(
                                    userId,
                                    tier,
                                    days: 30,
                                  ),
                            child: Text(
                              l10n.adminGrantPlan(l10n.planName(tier.name)),
                            ),
                          ),
                        if (plan.source == 'admin')
                          TextButton(
                            onPressed: busy
                                ? null
                                : () => notifier.grantPlan(userId, null),
                            child: Text(l10n.adminRemovePlan),
                          ),
                        OutlinedButton(
                          onPressed: busy
                              ? null
                              : () =>
                                    notifier.grantWallet(userId, superlikes: 5),
                          child: Text(l10n.adminGiveSuperlikes(5)),
                        ),
                        OutlinedButton(
                          onPressed: busy
                              ? null
                              : () => notifier.grantWallet(userId, boosts: 1),
                          child: Text(l10n.adminGiveBoosts(1)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
