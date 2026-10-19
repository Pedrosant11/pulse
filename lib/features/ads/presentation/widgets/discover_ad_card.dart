import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/features/ads/domain/ad_models.dart';
import 'package:pulse/features/ads/presentation/widgets/sponsored_slot.dart';

/// The ad between profiles in Discover: same shape as a profile card, and
/// any swipe moves on.
class DiscoverAdCard extends StatelessWidget {
  const new({required this.index, required this.onUnavailable, super.key});

  final int index;

  /// Nothing to show (e.g. Google had no ad): the deck goes on.
  final VoidCallback onUnavailable;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = BorderRadius.circular(context.radii.xl);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: radius,
        border: Border.all(color: colors.glassBorder),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Column(
          children: [
            Expanded(
              child: SponsoredSlot(
                placement: AdPlacement.discover,
                index: index,
                expand: true,
                onUnavailable: onUnavailable,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: spacing.sm),
              child: Text(
                context.l10n.adSwipeHint,
                style: context.textTheme.labelSmall?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
