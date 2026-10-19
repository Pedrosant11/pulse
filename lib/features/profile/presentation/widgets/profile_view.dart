import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/genre_chip.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/features/badges/presentation/widgets/profile_badges.dart';
import 'package:pulse/features/profile/domain/profile.dart';
import 'package:pulse/features/profile/presentation/profile_labels.dart';
import 'package:pulse/features/profile/presentation/widgets/profile_photo_image.dart';
import 'package:pulse/features/profile/presentation/widgets/profile_prompts.dart';

/// A profile exactly as other users see it (SPEC 6.3): photos, first name,
/// age, city and the public details. Reused by Discover (Phase 5).
class ProfileView extends StatelessWidget {
  const new({
    required this.profile,
    required this.photos,
    this.photoHeroTag,
    super.key,
  });

  final PublicProfile profile;
  final List<ProfilePhoto> photos;

  /// Hero tag of the photo (e.g. flying from the discovery card).
  final Object? photoHeroTag;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final colors = context.colors;
    final p = profile;

    final aboutItems = [
      if (p.heightCm != null) (Icons.height, l10n.heightValue(p.heightCm!)),
      if (p.zodiac != null) (Icons.auto_awesome, l10n.zodiac(p.zodiac!)),
      if (p.drinks != null) (Icons.local_bar_outlined, l10n.habit(p.drinks!)),
      if (p.smokes != null) (Icons.smoke_free, l10n.habit(p.smokes!)),
      if (p.orientation != null)
        (Icons.favorite_border, l10n.orientation(p.orientation!)),
      if (p.dateLookingFor != null)
        (Icons.search, l10n.dateIntent(p.dateLookingFor!)),
      for (final pet in p.pets) (Icons.pets, l10n.pet(pet)),
      for (final lang in p.languages) (Icons.translate, l10n.language(lang)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(context.radii.lg),
          child: AspectRatio(
            aspectRatio: 4 / 5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                PhotoCarousel(photos: photos, heroTag: photoHeroTag),
                // Name/age/city over a bottom gradient.
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            colors.background.withValues(alpha: 0),
                            colors.background.withValues(alpha: 0.85),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          spacing.md,
                          spacing.xxl,
                          spacing.md,
                          spacing.md,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    l10n.profileNameAge(p.firstName, p.age),
                                    style: context.textTheme.headlineMedium,
                                  ),
                                ),
                                if (p.isVerified) ...[
                                  SizedBox(width: spacing.xs),
                                  Icon(
                                    Icons.verified,
                                    color: colors.lime,
                                    semanticLabel: l10n.profileVerified,
                                  ),
                                ],
                              ],
                            ),
                            if (p.city != null)
                              Text(
                                '${p.city}, ${p.state}',
                                style: context.textTheme.bodyMedium,
                              ),
                            Padding(
                              padding: EdgeInsets.only(top: spacing.xxs),
                              child: ProfileBadges(userId: p.id, dense: true),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (p.bio != null || p.occupation != null) ...[
          SizedBox(height: spacing.md),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (p.occupation != null)
                  Row(
                    children: [
                      Icon(
                        Icons.work_outline,
                        size: 18,
                        color: colors.textSecondary,
                      ),
                      SizedBox(width: spacing.xs),
                      Expanded(
                        child: Text(
                          p.occupation!,
                          style: context.textTheme.titleSmall,
                        ),
                      ),
                    ],
                  ),
                if (p.bio != null && p.occupation != null)
                  SizedBox(height: spacing.sm),
                if (p.bio != null)
                  Text(p.bio!, style: context.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
        // Answers to the profile questions (empty when there are none).
        ProfilePromptsView(userId: p.id),
        if (p.musicGenres.isNotEmpty || p.favoriteDjs.isNotEmpty) ...[
          SizedBox(height: spacing.lg),
          Text(
            l10n.profileSectionMusic.toUpperCase(),
            style: context.textTheme.titleLarge,
          ),
          SizedBox(height: spacing.sm),
          Wrap(
            spacing: spacing.xs,
            runSpacing: spacing.xs,
            children: [
              for (final genre in p.musicGenres)
                GenreChip(label: l10n.genre(genre), selected: true),
              for (final dj in p.favoriteDjs)
                GenreChip(label: dj, accent: colors.cyan),
            ],
          ),
        ],
        if (aboutItems.isNotEmpty) ...[
          SizedBox(height: spacing.lg),
          Text(
            l10n.profileSectionAbout.toUpperCase(),
            style: context.textTheme.titleLarge,
          ),
          SizedBox(height: spacing.sm),
          Wrap(
            spacing: spacing.xs,
            runSpacing: spacing.xs,
            children: [
              for (final (icon, label) in aboutItems)
                Chip(avatar: Icon(icon, size: 16), label: Text(label)),
            ],
          ),
        ],
      ],
    );
  }
}

/// Tap the left/right side to change photo; segment indicators on top
/// (SPEC 8.2).
class PhotoCarousel extends StatefulWidget {
  const new({required this.photos, this.heroTag, super.key});

  final List<ProfilePhoto> photos;

  /// Wraps the photo in a Hero with this tag.
  final Object? heroTag;

  @override
  State<PhotoCarousel> createState() => _PhotoCarouselState();
}

class _PhotoCarouselState extends State<PhotoCarousel> {
  int _index = 0;

  void _go(int delta) {
    final next = (_index + delta).clamp(0, widget.photos.length - 1);
    if (next != _index) setState(() => _index = next);
  }

  @override
  Widget build(BuildContext context) {
    final photos = widget.photos;
    final colors = context.colors;
    final l10n = context.l10n;
    if (photos.isEmpty) {
      return ColoredBox(
        color: colors.surfaceElevated,
        child: Icon(Icons.person, size: 96, color: colors.textSecondary),
      );
    }
    final index = _index.clamp(0, photos.length - 1);

    return Stack(
      fit: StackFit.expand,
      children: [
        if (widget.heroTag case final tag?)
          Hero(tag: tag, child: ProfilePhotoImage(photos[index].storagePath))
        else
          ProfilePhotoImage(photos[index].storagePath),
        Row(
          children: [
            Expanded(
              child: Semantics(
                button: true,
                label: l10n.previousPhoto,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _go(-1),
                ),
              ),
            ),
            Expanded(
              child: Semantics(
                button: true,
                label: l10n.nextPhoto,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _go(1),
                ),
              ),
            ),
          ],
        ),
        if (photos.length > 1)
          Positioned(
            top: context.spacing.sm,
            left: context.spacing.sm,
            right: context.spacing.sm,
            child: Row(
              children: [
                for (var i = 0; i < photos.length; i++) ...[
                  if (i > 0) const SizedBox(width: 4),
                  Expanded(
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: i == index
                            ? colors.textPrimary
                            : colors.textPrimary.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
