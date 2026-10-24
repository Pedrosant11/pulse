import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/features/achievements/domain/achievement.dart';
import 'package:pulse/features/achievements/presentation/achievements_providers.dart';
import 'package:pulse/features/events/presentation/widgets/event_attend_tile.dart';
import 'package:pulse/l10n/app_localizations.dart';

IconData achievementIcon(AchievementKey key) => switch (key) {
  AchievementKey.firstParty => Icons.celebration_rounded,
  AchievementKey.partyAnimal => Icons.nightlife_rounded,
  AchievementKey.nightLegend => Icons.auto_awesome_rounded,
  AchievementKey.loyalToTheHouse => Icons.storefront_rounded,
  AchievementKey.neverAlone => Icons.groups_rounded,
  AchievementKey.explorer => Icons.travel_explore_rounded,
  AchievementKey.eclectic => Icons.graphic_eq_rounded,
  AchievementKey.marathoner => Icons.timer_rounded,
};

extension AchievementLabels on AppLocalizations {
  String achievementLabel(AchievementKey key) => achievementName(key.name);
  String achievementHow(AchievementKey key) => achievementGoal(key.name);
}

/// Round badge; grey and dimmed while locked.
class AchievementBadge extends StatelessWidget {
  const new({
    required this.keyName,
    this.unlocked = true,
    this.size = 52,
    super.key,
  });

  final AchievementKey keyName;
  final bool unlocked;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: unlocked ? colors.primaryGradient : null,
        color: unlocked ? null : colors.surfaceElevated,
        boxShadow: unlocked
            ? [
                BoxShadow(
                  color: colors.magenta.withValues(alpha: 0.4),
                  blurRadius: 14,
                ),
              ]
            : null,
      ),
      child: Icon(
        achievementIcon(keyName),
        size: size * 0.5,
        color: unlocked ? colors.textPrimary : colors.textSecondary,
      ),
    );
  }
}

/// Someone's unlocked conquistas on their profile (rarest 3).
class AchievementsRow extends ConsumerWidget {
  const new({required this.userId, super.key});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keys = ref.watch(userAchievementsProvider(userId)).value ?? const [];
    if (keys.isEmpty) return const SizedBox.shrink();
    final l10n = context.l10n;
    final spacing = context.spacing;
    return Padding(
      padding: EdgeInsets.only(top: spacing.sm),
      child: Wrap(
        spacing: spacing.xs,
        runSpacing: spacing.xs,
        children: [
          for (final key in keys.take(3))
            Chip(
              avatar: Icon(achievementIcon(key), size: 16),
              label: Text(l10n.achievementLabel(key)),
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}

/// My profile: every conquista with its progress.
class AchievementsSection extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final list = ref.watch(myAchievementsProvider).value;
    if (list == null) return const SizedBox.shrink();
    final unlocked = list.where((a) => a.unlocked).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.achievementsTitle(unlocked, list.length).toUpperCase(),
          style: context.textTheme.titleLarge,
        ),
        SizedBox(height: spacing.sm),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: spacing.sm,
          crossAxisSpacing: spacing.xs,
          childAspectRatio: 0.74,
          children: [
            for (final a in list)
              Tooltip(
                message: l10n.achievementHow(a.key),
                triggerMode: TooltipTriggerMode.tap,
                child: Column(
                  children: [
                    AchievementBadge(keyName: a.key, unlocked: a.unlocked),
                    SizedBox(height: spacing.xxs),
                    Text(
                      l10n.achievementLabel(a.key),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: a.unlocked ? null : context.colors.textSecondary,
                      ),
                    ),
                    if (!a.unlocked)
                      Text(
                        '${a.progress}/${a.goal}',
                        style: context.textTheme.labelSmall?.copyWith(
                          color: context.colors.cyan,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// My passport: totals, the parties, and the full history with Black.
class PassportCard extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final passport = ref.watch(myPassportProvider).value;
    if (passport == null) return const SizedBox.shrink();
    Widget stat(int value, String label) => Expanded(
      child: Column(
        children: [
          Text('$value', style: context.textTheme.headlineSmall),
          Text(label, style: context.textTheme.labelSmall),
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.passportTitle.toUpperCase(),
          style: context.textTheme.titleLarge,
        ),
        Text(l10n.passportPrivate, style: context.textTheme.bodySmall),
        SizedBox(height: spacing.sm),
        GlassCard(
          child: Row(
            children: [
              stat(passport.parties, l10n.passportParties),
              stat(passport.venues, l10n.passportVenues),
              stat(passport.cities, l10n.passportCities),
              stat(passport.genres, l10n.passportGenres),
            ],
          ),
        ),
        SizedBox(height: spacing.sm),
        if (passport.entries.isEmpty)
          Text(l10n.passportEmpty, style: context.textTheme.bodyMedium)
        else
          for (final event in passport.entries)
            Padding(
              padding: EdgeInsets.only(bottom: spacing.xs),
              child: EventAttendTile(event: event),
            ),
        if (!passport.full && passport.parties > passport.entries.length)
          OutlinedButton.icon(
            onPressed: () => context.push(AppRoutes.plans),
            icon: Icon(Icons.workspace_premium_rounded, color: colors.lime),
            label: Text(
              l10n.passportSeeAll(passport.parties - passport.entries.length),
            ),
          ),
      ],
    );
  }
}
