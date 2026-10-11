import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/errors/app_failure_message.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/legal/domain/legal_document.dart';
import 'package:pulse/features/plans/data/store_purchases.dart';
import 'package:pulse/features/plans/domain/plan_models.dart';
import 'package:pulse/features/plans/presentation/plans_providers.dart';

/// Plans and packs (SPEC monetization). Prices come from the store; what
/// the person can use comes from the database.
class PlansScreen extends ConsumerStatefulWidget {
  const new({this.feature, super.key});

  final PlanFeature? feature;

  @override
  ConsumerState<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends ConsumerState<PlansScreen> {
  PlanPeriod _period = PlanPeriod.monthly;

  Future<void> _buy(
    BuildContext context,
    WidgetRef ref,
    StoreOffer offer,
  ) async {
    final bought = await ref.read(planActionsProvider.notifier).buy(offer);
    if (bought == true && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.plansPurchaseDone)));
    }
  }

  /// Annual price against 12 monthly payments, in % (null when unknown).
  int? _annualSavings(Map<StoreItem, StoreOffer> offers, PlanTier tier) {
    final monthly = offers[StoreItem.plan(tier, PlanPeriod.monthly)]?.amount;
    final annual = offers[StoreItem.plan(tier, PlanPeriod.annual)]?.amount;
    if (monthly == null || annual == null || monthly <= 0 || annual <= 0) {
      return null;
    }
    final savings = ((1 - annual / (monthly * 12)) * 100).round();
    return savings > 0 ? savings : null;
  }

  @override
  Widget build(BuildContext context) {
    final feature = widget.feature;
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final entitlements = ref.watch(entitlementsProvider);
    final store = ref.watch(storePurchasesProvider);
    final offers = {
      for (final offer
          in ref.watch(storeOffersProvider).value ?? const <StoreOffer>[])
        offer.item: offer,
    };
    final actions = ref.watch(planActionsProvider);

    ref.listen(planActionsProvider, (_, next) {
      if (next case AsyncError(:final error)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(friendlyErrorMessage(error, l10n))),
        );
      }
    });

    VoidCallback? buy(StoreItem item) {
      final offer = offers[item];
      if (offer == null || actions.isLoading) return null;
      return () => _buy(context, ref, offer);
    }

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(l10n.plansTitle.toUpperCase())),
      body: SafeArea(
        child: AsyncValueView(
          value: entitlements,
          onRetry: () => ref.invalidate(entitlementsProvider),
          data: (me) => ListView(
            padding: EdgeInsets.all(spacing.md),
            children: [
              if (feature case final feature?)
                Padding(
                  padding: EdgeInsets.only(bottom: spacing.md),
                  child: Text(
                    l10n.planFeatureHeadline(feature.name),
                    style: context.textTheme.titleLarge,
                  ),
                ),
              if (me.hasPlan) ...[
                _CurrentPlan(entitlements: me),
                SizedBox(height: spacing.md),
              ],
              if (!store.isAvailable) ...[
                Text(
                  l10n.plansStoreUnavailable,
                  style: context.textTheme.bodySmall,
                ),
                SizedBox(height: spacing.md),
              ],
              // Billing period for both plans.
              SegmentedButton<PlanPeriod>(
                showSelectedIcon: false,
                segments: [
                  for (final period in PlanPeriod.values)
                    ButtonSegment(
                      value: period,
                      label: Text(l10n.planPeriodName(period.name)),
                    ),
                ],
                selected: {_period},
                onSelectionChanged: (s) => setState(() => _period = s.first),
              ),
              SizedBox(height: spacing.md),
              _PlanCard(
                tier: PlanTier.plus,
                current: me.tier == PlanTier.plus,
                period: _period,
                price: offers[StoreItem.plan(PlanTier.plus, _period)]?.price,
                savings: _period == PlanPeriod.annual
                    ? _annualSavings(offers, PlanTier.plus)
                    : null,
                benefits: [
                  l10n.planBenefitUnlimitedLikes,
                  l10n.planBenefitRewind,
                  l10n.planBenefitTravel,
                  l10n.planBenefitSuperlikes(5),
                ],
                busy: actions.isLoading,
                onBuy: buy(StoreItem.plan(PlanTier.plus, _period)),
              ),
              SizedBox(height: spacing.md),
              _PlanCard(
                tier: PlanTier.black,
                current: me.tier == PlanTier.black,
                period: _period,
                price: offers[StoreItem.plan(PlanTier.black, _period)]?.price,
                savings: _period == PlanPeriod.annual
                    ? _annualSavings(offers, PlanTier.black)
                    : null,
                benefits: [
                  l10n.planBenefitEverythingPlus,
                  l10n.planBenefitLikedYou,
                  l10n.planBenefitBoost,
                  l10n.planBenefitIncognito,
                ],
                busy: actions.isLoading,
                onBuy: buy(StoreItem.plan(PlanTier.black, _period)),
              ),
              SizedBox(height: spacing.lg),
              Text(
                l10n.plansPacksTitle.toUpperCase(),
                style: context.textTheme.titleLarge,
              ),
              SizedBox(height: spacing.xs),
              Text(
                l10n.plansWallet(me.superlikeBalance, me.boostBalance),
                style: context.textTheme.bodySmall,
              ),
              SizedBox(height: spacing.sm),
              for (final (item, icon, label) in [
                (
                  StoreItem.superlikes5,
                  Icons.star_rounded,
                  l10n.packSuperlikes(5),
                ),
                (
                  StoreItem.superlikes15,
                  Icons.star_rounded,
                  l10n.packSuperlikes(15),
                ),
                (StoreItem.boost1, Icons.bolt_rounded, l10n.packBoosts(1)),
                (StoreItem.boosts5, Icons.bolt_rounded, l10n.packBoosts(5)),
              ])
                Padding(
                  padding: EdgeInsets.only(bottom: spacing.sm),
                  child: GlassCard(
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      leading: Icon(icon, color: colors.lime),
                      title: Text(label),
                      trailing: FilledButton(
                        onPressed: buy(item),
                        child: Text(offers[item]?.price ?? l10n.plansSoon),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: spacing.sm),
              Center(
                child: TextButton(
                  onPressed: store.isAvailable && !actions.isLoading
                      ? () => ref.read(planActionsProvider.notifier).restore()
                      : null,
                  child: Text(l10n.plansRestore),
                ),
              ),
              Text(l10n.plansLegal, style: context.textTheme.bodySmall),
              Wrap(
                spacing: spacing.sm,
                children: [
                  TextButton(
                    onPressed: () =>
                        context.push(AppRoutes.legal(LegalDocument.terms)),
                    child: Text(l10n.legalTerms),
                  ),
                  TextButton(
                    onPressed: () =>
                        context.push(AppRoutes.legal(LegalDocument.privacy)),
                    child: Text(l10n.legalPrivacy),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CurrentPlan extends StatelessWidget {
  const new({required this.entitlements});

  final Entitlements entitlements;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final expires = entitlements.expiresAt;
    final date = expires == null
        ? null
        : DateFormat.yMd('pt_BR').format(expires.toLocal());
    final detail = switch ((entitlements.source, date)) {
      ('admin', _) => l10n.planGrantedByTeam,
      ('trial', final date?) => l10n.planTrialUntil(date),
      (_, final date?) when entitlements.willRenew => l10n.planRenewsOn(date),
      (_, final date?) => l10n.planEndsOn(date),
      _ => null,
    };
    return GlassCard(
      child: Row(
        children: [
          Icon(Icons.workspace_premium_rounded, color: context.colors.lime),
          SizedBox(width: context.spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.planYours(l10n.planName(entitlements.tier!.name)),
                  style: context.textTheme.titleMedium,
                ),
                if (detail != null)
                  Text(detail, style: context.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const new({
    required this.tier,
    required this.current,
    required this.period,
    required this.price,
    required this.benefits,
    required this.busy,
    required this.onBuy,
    this.savings,
  });

  final PlanTier tier;
  final bool current;
  final PlanPeriod period;
  final String? price;

  /// Annual discount against 12 months, in %.
  final int? savings;
  final List<String> benefits;
  final bool busy;
  final VoidCallback? onBuy;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final gradient = tier == PlanTier.black
        ? colors.blackGradient
        : colors.plusGradient;
    final accent = gradient.colors.first;

    return GlassCard(
      borderGradient: gradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.planName(tier.name).toUpperCase(),
                  style: context.textTheme.headlineSmall?.copyWith(
                    color: accent,
                  ),
                ),
              ),
              if (price != null)
                Text(
                  l10n.planPricePer(price!, period.name),
                  style: context.textTheme.titleMedium,
                ),
            ],
          ),
          if (savings case final savings?)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                l10n.planAnnualSavings(savings),
                style: context.textTheme.labelMedium?.copyWith(
                  color: colors.lime,
                ),
              ),
            ),
          SizedBox(height: spacing.sm),
          for (final benefit in benefits)
            Padding(
              padding: EdgeInsets.only(bottom: spacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_rounded, size: 18, color: accent),
                  SizedBox(width: spacing.sm),
                  Expanded(child: Text(benefit)),
                ],
              ),
            ),
          SizedBox(height: spacing.sm),
          if (current)
            Text(
              l10n.planCurrent,
              textAlign: TextAlign.center,
              style: context.textTheme.labelLarge?.copyWith(color: accent),
            )
          else
            NeonButton(
              label: price == null ? l10n.plansSoon : l10n.planSubscribe,
              gradient: gradient,
              isLoading: busy,
              onPressed: onBuy,
            ),
        ],
      ),
    );
  }
}
