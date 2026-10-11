import 'dart:async';

import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// "Compartilhar meu rolê": sends a trusted contact where the person is
/// going (and with whom) through any app (WhatsApp, SMS…). Nothing goes to
/// our servers; the text leaves the phone only if the person sends it.
Future<void> shareMyNight(
  BuildContext context, {
  String? eventName,
  String? venue,
  DateTime? startsAt,
  String? withName,
}) {
  final l10n = context.l10n;
  final when = startsAt == null
      ? null
      : DateFormat("EEE, d/M 'às' HH:mm", 'pt_BR').format(startsAt.toLocal());
  final text = [
    l10n.shareNightIntro,
    if (eventName != null)
      l10n.shareNightEvent([eventName, ?venue].join(' · '), when ?? ''),
    if (withName != null) l10n.shareNightWith(withName),
    l10n.shareNightOutro,
  ].join('\n');
  return SharePlus.instance.share(
    ShareParams(text: text, subject: l10n.shareNightSubject),
  );
}

/// Tips for a safe night and one-tap emergency numbers (Brazil).
Future<void> showNightSafetySheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: context.colors.surface,
    builder: (_) => const _NightSafetySheet(),
  );
}

class _NightSafetySheet extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final tips = [
      (Icons.local_drink_outlined, l10n.nightTipWater),
      (Icons.no_drinks_outlined, l10n.nightTipDrink),
      (Icons.place_outlined, l10n.nightTipMeetingPoint),
      (Icons.battery_charging_full_rounded, l10n.nightTipBattery),
      (Icons.local_taxi_outlined, l10n.nightTipRide),
      (Icons.health_and_safety_outlined, l10n.nightTipHelp),
    ];
    final emergencies = [
      ('190', l10n.emergencyPolice),
      ('192', l10n.emergencySamu),
      ('180', l10n.emergencyWomen),
      ('188', l10n.emergencyCvv),
    ];

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: EdgeInsets.all(spacing.lg),
        children: [
          Row(
            children: [
              Icon(Icons.shield_moon_outlined, color: colors.lime),
              SizedBox(width: spacing.sm),
              Text(
                l10n.nightSafetyTitle.toUpperCase(),
                style: context.textTheme.titleLarge,
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          for (final (icon, tip) in tips)
            Padding(
              padding: EdgeInsets.only(bottom: spacing.sm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 20, color: colors.cyan),
                  SizedBox(width: spacing.sm),
                  Expanded(child: Text(tip)),
                ],
              ),
            ),
          SizedBox(height: spacing.md),
          Text(
            l10n.emergencyTitle.toUpperCase(),
            style: context.textTheme.titleMedium,
          ),
          SizedBox(height: spacing.sm),
          for (final (number, label) in emergencies)
            Padding(
              padding: EdgeInsets.only(bottom: spacing.sm),
              child: GlassCard(
                padding: EdgeInsets.zero,
                child: ListTile(
                  leading: Icon(Icons.call_rounded, color: colors.error),
                  title: Text(label),
                  trailing: Text(number, style: context.textTheme.titleLarge),
                  onTap: () => unawaited(launchUrl(Uri.parse('tel:$number'))),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Event card: share the night and open the safety tips.
class NightSafetyCard extends StatelessWidget {
  const new({
    required this.eventName,
    required this.venue,
    required this.startsAt,
    super.key,
  });

  final String eventName;
  final String venue;
  final DateTime startsAt;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.shield_moon_outlined, color: colors.lime),
              SizedBox(width: spacing.sm),
              Expanded(
                child: Text(
                  l10n.nightSafetyCardTitle,
                  style: context.textTheme.titleMedium,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.xs),
          Text(l10n.nightSafetyCardBody, style: context.textTheme.bodySmall),
          SizedBox(height: spacing.sm),
          Wrap(
            spacing: spacing.sm,
            runSpacing: spacing.xs,
            children: [
              OutlinedButton.icon(
                onPressed: () => shareMyNight(
                  context,
                  eventName: eventName,
                  venue: venue,
                  startsAt: startsAt,
                ),
                icon: const Icon(Icons.ios_share_rounded, size: 18),
                label: Text(l10n.shareNightAction),
              ),
              TextButton.icon(
                onPressed: () => showNightSafetySheet(context),
                icon: const Icon(Icons.health_and_safety_outlined, size: 18),
                label: Text(l10n.nightSafetyTipsAction),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
