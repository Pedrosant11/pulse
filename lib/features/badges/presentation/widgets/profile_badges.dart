import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/features/badges/domain/badge_models.dart';
import 'package:pulse/features/badges/presentation/badges_providers.dart';
import 'package:pulse/l10n/app_localizations.dart';

String badgeLabel(AppLocalizations l10n, ProfileBadgeType badge) =>
    switch (badge) {
      ProfileBadgeType.team => l10n.badgeTeam,
      ProfileBadgeType.dj => l10n.badgeDj,
      ProfileBadgeType.publicFigure => l10n.badgePublicFigure,
      ProfileBadgeType.producer => l10n.badgeProducer,
    };

IconData badgeIcon(ProfileBadgeType badge) => switch (badge) {
  ProfileBadgeType.team => Icons.bolt,
  ProfileBadgeType.dj => Icons.headphones,
  ProfileBadgeType.publicFigure => Icons.star_rounded,
  ProfileBadgeType.producer => Icons.graphic_eq,
};

Color badgeColor(BuildContext context, ProfileBadgeType badge) {
  final colors = context.colors;
  return switch (badge) {
    ProfileBadgeType.team => colors.lime,
    ProfileBadgeType.dj => colors.cyan,
    ProfileBadgeType.publicFigure => colors.magenta,
    ProfileBadgeType.producer => colors.violet,
  };
}

/// One badge: icon, name and the admin's title ("Equipe Pulse · CEO").
class BadgeChip extends StatelessWidget {
  const new({required this.badge, this.dense = false, super.key});

  final UserBadge badge;

  /// Smaller, for cards.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final color = badgeColor(context, badge.badge);
    final title = badge.title;
    final label = [badgeLabel(l10n, badge.badge), ?title].join(' · ');

    return Semantics(
      label: l10n.badgeSemantics(label),
      excludeSemantics: true,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: dense ? spacing.xs : spacing.sm,
          vertical: dense ? 2 : spacing.xxs,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(context.radii.pill),
          border: Border.all(color: color.withValues(alpha: 0.7)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(badgeIcon(badge.badge), size: dense ? 13 : 15, color: color),
            SizedBox(width: spacing.xxs),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    (dense
                            ? context.textTheme.labelSmall
                            : context.textTheme.labelMedium)
                        ?.copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Someone's badges, loaded on demand. Nothing while loading or when the
/// person has none. [max] keeps cards tidy.
class ProfileBadges extends ConsumerWidget {
  const new({required this.userId, this.max, this.dense = false, super.key});

  final String userId;
  final int? max;
  final bool dense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badges = ref.watch(userBadgesProvider(userId)).value ?? const [];
    if (badges.isEmpty) return const SizedBox.shrink();
    final shown = max == null ? badges : badges.take(max!);
    return Wrap(
      spacing: context.spacing.xs,
      runSpacing: context.spacing.xxs,
      children: [
        for (final badge in shown) BadgeChip(badge: badge, dense: dense),
      ],
    );
  }
}
