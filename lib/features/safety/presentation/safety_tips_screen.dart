import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:url_launcher/url_launcher.dart';

/// Party safety tips (SPEC 10), linked from the profile, settings and the
/// match screen.
class SafetyTipsScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;

    final tips = [
      (
        Icons.storefront_outlined,
        l10n.safetyTipPublicTitle,
        l10n.safetyTipPublicBody,
      ),
      (
        Icons.share_location_outlined,
        l10n.safetyTipFriendTitle,
        l10n.safetyTipFriendBody,
      ),
      (
        Icons.local_bar_outlined,
        l10n.safetyTipDrinkTitle,
        l10n.safetyTipDrinkBody,
      ),
      (
        Icons.water_drop_outlined,
        l10n.safetyTipLimitsTitle,
        l10n.safetyTipLimitsBody,
      ),
      (
        Icons.front_hand_outlined,
        l10n.safetyTipConsentTitle,
        l10n.safetyTipConsentBody,
      ),
      (
        Icons.directions_car_outlined,
        l10n.safetyTipRideTitle,
        l10n.safetyTipRideBody,
      ),
      (Icons.lock_outline, l10n.safetyTipDataTitle, l10n.safetyTipDataBody),
      (
        Icons.flag_outlined,
        l10n.safetyTipReportTitle,
        l10n.safetyTipReportBody,
      ),
    ];

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: Text(l10n.safetyTipsTitle.toUpperCase())),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(spacing.md),
          children: [
            Text(l10n.safetyTipsIntro, style: context.textTheme.bodyLarge),
            SizedBox(height: spacing.md),
            for (final (icon, title, body) in tips)
              Padding(
                padding: EdgeInsets.only(bottom: spacing.sm),
                child: GlassCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(icon, color: colors.cyan),
                      SizedBox(width: spacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: context.textTheme.titleMedium),
                            SizedBox(height: spacing.xs),
                            Text(body, style: context.textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: spacing.md),
            Text(
              l10n.safetyEmergency.toUpperCase(),
              style: context.textTheme.titleLarge,
            ),
            SizedBox(height: spacing.sm),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => launchUrl(Uri(scheme: 'tel', path: '190')),
                    icon: const Icon(Icons.local_police_outlined),
                    label: Text(l10n.safetyCallPolice),
                  ),
                ),
                SizedBox(width: spacing.sm),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => launchUrl(Uri(scheme: 'tel', path: '192')),
                    icon: const Icon(Icons.medical_services_outlined),
                    label: Text(l10n.safetyCallAmbulance),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
