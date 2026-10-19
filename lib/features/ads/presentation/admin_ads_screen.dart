import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/ads/domain/ad_models.dart';
import 'package:pulse/features/ads/presentation/ad_form_screen.dart';
import 'package:pulse/features/ads/presentation/ads_providers.dart';

/// Admin: own ads with their numbers (views and taps, once per person a
/// day), to report to whoever bought them.
class AdminAdsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final ads = ref.watch(adminAdsProvider);
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(l10n.adminAds.toUpperCase())),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            context.push(AppRoutes.adminAdForm, extra: const AdFormArgs()),
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.adNew),
      ),
      body: SafeArea(
        child: AsyncValueView(
          value: ads,
          onRetry: () => ref.invalidate(adminAdsProvider),
          data: (ads) => ads.isEmpty
              ? EmptyView(
                  icon: Icons.campaign_outlined,
                  title: l10n.adsEmptyTitle,
                  message: l10n.adsEmptyBody,
                )
              : ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    spacing.md,
                    spacing.md,
                    spacing.md,
                    spacing.xxl * 2,
                  ),
                  itemCount: ads.length,
                  separatorBuilder: (_, _) => SizedBox(height: spacing.sm),
                  itemBuilder: (context, i) => _AdTile(ad: ads[i]),
                ),
        ),
      ),
    );
  }
}

class _AdTile extends StatelessWidget {
  const new({required this.ad});

  final AdminAd ad;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final dates = DateFormat.yMd('pt_BR');
    final running = ad.runningAt(DateTime.now());
    final ctr = ad.impressions == 0 ? 0 : ad.clicks * 100 / ad.impressions;
    return GlassCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        onTap: () =>
            context.push(AppRoutes.adminAdForm, extra: AdFormArgs(ad: ad)),
        leading: Icon(
          ad.eventId == null ? Icons.link_rounded : Icons.event_rounded,
          color: running ? colors.lime : colors.textSecondary,
        ),
        title: Text(ad.title),
        subtitle: Text(
          [
            if (running) l10n.adRunning else l10n.adNotRunning,
            switch (ad.endsAt) {
              final end? => l10n.adUntil(dates.format(end.toLocal())),
              null => l10n.adNoEnd,
            },
            l10n.adStats(ad.impressions, ad.clicks, ctr.toStringAsFixed(1)),
          ].join(' · '),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
