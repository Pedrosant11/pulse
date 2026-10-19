import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/errors/app_failure_message.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/domain/featured.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/plans/data/store_purchases.dart';
import 'package:pulse/features/plans/presentation/plans_providers.dart';

final _money = NumberFormat.simpleCurrency(locale: 'pt_BR');

/// For the producer of an open party: put it on top of "Próximos", or see
/// how the highlight is going.
class FeaturedPromoCard extends ConsumerWidget {
  const new({required this.event, super.key});

  final EventDetail event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final until = event.featuredUntil;
    final featured = until?.isAfter(DateTime.now()) ?? false;
    final open = ref.watch(openFeaturedRequestProvider(event.id)).value;

    final (title, body, action) = switch ((featured, open)) {
      (true, _) => (
        l10n.featuredOnTitle,
        l10n.featuredOnBody(
          DateFormat("d/M 'às' HH:mm", 'pt_BR').format(until!.toLocal()),
        ),
        l10n.featuredExtend,
      ),
      (false, final r?) when r.method == FeaturedMethod.team => (
        l10n.featuredRequestedTitle,
        l10n.featuredRequestedBody(r.days, _money.format(r.priceCents / 100)),
        l10n.featuredChange,
      ),
      _ => (l10n.featuredPromoTitle, l10n.featuredPromoBody, l10n.featuredCta),
    };

    return GlassCard(
      borderGradient: colors.blackGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.rocket_launch_rounded, color: colors.lime),
              SizedBox(width: spacing.sm),
              Expanded(
                child: Text(title, style: context.textTheme.titleMedium),
              ),
            ],
          ),
          SizedBox(height: spacing.xs),
          Text(body, style: context.textTheme.bodySmall),
          SizedBox(height: spacing.sm),
          OutlinedButton(
            onPressed: () => showFeaturedSheet(context, event),
            child: Text(action),
          ),
        ],
      ),
    );
  }
}

Future<void> showFeaturedSheet(BuildContext context, EventDetail event) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: context.colors.surface,
    builder: (_) => _FeaturedSheet(event: event),
  );
}

class _FeaturedSheet extends ConsumerStatefulWidget {
  const new({required this.event});

  final EventDetail event;

  @override
  ConsumerState<_FeaturedSheet> createState() => _FeaturedSheetState();
}

class _FeaturedSheetState extends ConsumerState<_FeaturedSheet> {
  int _days = 7;

  StoreOffer? _offerFor(int days) {
    final offers = ref.watch(storeOffersProvider).value ?? const [];
    for (final offer in offers) {
      if (offer.item.featuredDays == days) return offer;
    }
    return null;
  }

  Future<void> _buy(StoreOffer offer) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final l10n = context.l10n;
    final sales = ref.read(featuredSalesProvider.notifier);
    final asked = await sales.request(
      widget.event.id,
      days: _days,
      method: FeaturedMethod.store,
    );
    if (asked != true || !mounted) return;
    final bought = await ref.read(planActionsProvider.notifier).buy(offer);
    if (bought != true) return;
    navigator.pop();
    messenger.showSnackBar(SnackBar(content: Text(l10n.featuredBought)));
    // The store webhook turns it on in a few seconds.
    unawaited(
      Future<void>.delayed(
        const Duration(seconds: 4),
        () => sales.refreshAfterPurchase(widget.event.id),
      ),
    );
  }

  Future<void> _askTeam() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final l10n = context.l10n;
    final asked = await ref
        .read(featuredSalesProvider.notifier)
        .request(widget.event.id, days: _days, method: FeaturedMethod.team);
    if (asked != true) return;
    navigator.pop();
    messenger.showSnackBar(SnackBar(content: Text(l10n.featuredRequestSent)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final prices = ref.watch(featuredPricesProvider);
    final sales = ref.watch(featuredSalesProvider);
    final buying = ref.watch(planActionsProvider);
    final store = ref.watch(storePurchasesProvider);
    final busy = sales.isLoading || buying.isLoading;
    final offer = store.isAvailable ? _offerFor(_days) : null;
    final buyError = switch (buying) {
      AsyncError(:final error) => friendlyErrorMessage(error, l10n),
      _ => null,
    };

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.md,
        spacing.md,
        spacing.md,
        spacing.md + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: AsyncValueView(
        value: prices,
        onRetry: () => ref.invalidate(featuredPricesProvider),
        data: (prices) {
          final bestPerDay = prices.isEmpty
              ? null
              : prices.reduce((a, b) => a.perDay <= b.perDay ? a : b).days;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.featuredSheetTitle,
                style: context.textTheme.titleLarge,
              ),
              SizedBox(height: spacing.xs),
              Text(l10n.featuredSheetBody, style: context.textTheme.bodySmall),
              SizedBox(height: spacing.md),
              for (final price in prices)
                Padding(
                  padding: EdgeInsets.only(bottom: spacing.sm),
                  child: _LengthOption(
                    price: price,
                    // The store's own price, when it sells it.
                    priceLabel:
                        (store.isAvailable ? _offerFor(price.days) : null)
                            ?.price ??
                        _money.format(price.price),
                    selected: price.days == _days,
                    bestPerDay: price.days == bestPerDay,
                    onTap: () => setState(() => _days = price.days),
                  ),
                ),
              FormErrorText(error: sales.error),
              if (buyError != null)
                Text(
                  buyError,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: colors.error,
                  ),
                ),
              SizedBox(height: spacing.sm),
              if (offer != null) ...[
                NeonButton(
                  label: l10n.featuredBuyNow(offer.price),
                  icon: Icons.bolt_rounded,
                  gradient: colors.blackGradient,
                  isLoading: busy,
                  onPressed: busy ? null : () => _buy(offer),
                ),
                SizedBox(height: spacing.sm),
              ],
              OutlinedButton(
                onPressed: busy ? null : _askTeam,
                child: Text(l10n.featuredAskTeam),
              ),
              SizedBox(height: spacing.xs),
              Text(
                l10n.featuredTeamHint,
                textAlign: TextAlign.center,
                style: context.textTheme.bodySmall,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LengthOption extends StatelessWidget {
  const new({
    required this.price,
    required this.priceLabel,
    required this.selected,
    required this.bestPerDay,
    required this.onTap,
  });

  final FeaturedPrice price;
  final String priceLabel;
  final bool selected;
  final bool bestPerDay;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = BorderRadius.circular(context.radii.md);
    return Material(
      color: selected ? colors.surfaceElevated : colors.background,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: selected ? colors.lime : colors.glassBorder,
              width: selected ? 2 : 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(spacing.md),
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: selected ? colors.lime : colors.textSecondary,
                ),
                SizedBox(width: spacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.featuredDays(price.days),
                        style: context.textTheme.titleMedium,
                      ),
                      Text(
                        l10n.featuredPerDay(_money.format(price.perDay)),
                        style: context.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(priceLabel, style: context.textTheme.titleMedium),
                    if (bestPerDay)
                      Text(
                        l10n.featuredBestValue,
                        style: context.textTheme.labelSmall?.copyWith(
                          color: colors.lime,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
