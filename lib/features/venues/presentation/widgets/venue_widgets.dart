import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/features/venues/data/venues_repository.dart';
import 'package:pulse/features/venues/domain/venue.dart';

/// The venue's photo, or a neon gradient with a storefront.
class VenuePhoto extends ConsumerWidget {
  const new({required this.photoPath, this.iconSize = 40, super.key});

  final String? photoPath;
  final double iconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final placeholder = DecoratedBox(
      decoration: BoxDecoration(gradient: colors.crewGradient),
      child: Center(
        child: Icon(
          Icons.storefront_rounded,
          size: iconSize,
          color: colors.textPrimary.withValues(alpha: 0.6),
        ),
      ),
    );
    final path = photoPath;
    if (path == null) return placeholder;
    return CachedNetworkImage(
      imageUrl: ref.watch(venuesRepositoryProvider).photoUrl(path),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (_, _) => placeholder,
      errorWidget: (_, _, _) => placeholder,
    );
  }
}

/// ★ 4.6 (12) — or "Sem avaliações".
class VenueRating extends StatelessWidget {
  const new({required this.rating, required this.count, super.key});

  final double? rating;
  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = context.textTheme.bodySmall;
    final rating = this.rating;
    if (rating == null || count == 0) {
      return Text(context.l10n.venueNoRatings, style: style);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: 16, color: colors.lime),
        SizedBox(width: context.spacing.xxs),
        Text(
          '${rating.toStringAsFixed(1).replaceAll('.', ',')} ($count)',
          style: style?.copyWith(color: colors.textPrimary),
        ),
      ],
    );
  }
}

/// Five stars; tappable when [onChanged] is set.
class StarPicker extends StatelessWidget {
  const new({required this.value, this.onChanged, this.size = 36, super.key});

  final int value;
  final ValueChanged<int>? onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++)
          IconButton(
            visualDensity: VisualDensity.compact,
            tooltip: context.l10n.venueStars(i),
            onPressed: onChanged == null ? null : () => onChanged!(i),
            icon: Icon(
              i <= value ? Icons.star_rounded : Icons.star_outline_rounded,
              size: size,
              color: i <= value ? colors.lime : colors.textSecondary,
            ),
          ),
      ],
    );
  }
}

/// A row of the "Casas" list.
class VenueTile extends StatelessWidget {
  const new({required this.venue, required this.onTap, super.key});

  final Venue venue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final place = [?venue.neighborhood, venue.city].join(' · ');
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.radii.lg),
      child: GlassCard(
        padding: EdgeInsets.all(spacing.sm),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(context.radii.md),
              child: SizedBox(
                width: 72,
                height: 72,
                child: VenuePhoto(photoPath: venue.photoPath, iconSize: 28),
              ),
            ),
            SizedBox(width: spacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    venue.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.titleMedium,
                  ),
                  Text(
                    place,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodySmall,
                  ),
                  SizedBox(height: spacing.xxs),
                  Row(
                    children: [
                      VenueRating(
                        rating: venue.rating,
                        count: venue.ratingCount,
                      ),
                      if (venue.upcoming > 0) ...[
                        SizedBox(width: spacing.sm),
                        Flexible(
                          child: Text(
                            l10n.venueUpcomingCount(venue.upcoming),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: colors.cyan,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (venue.status == VenueStatus.pending)
              Icon(Icons.hourglass_top_rounded, color: colors.lime, size: 20)
            else if (venue.isFollowing)
              Icon(Icons.favorite_rounded, color: colors.magenta, size: 20),
          ],
        ),
      ),
    );
  }
}
