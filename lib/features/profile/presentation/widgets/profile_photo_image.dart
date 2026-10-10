import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';

/// Photo from the private bucket. Signed URLs change, so the disk cache is
/// keyed by the storage path.
class ProfilePhotoImage extends ConsumerWidget {
  const new(
    this.storagePath, {
    this.fit = BoxFit.cover,
    this.decodeWidth,
    super.key,
  });

  final String storagePath;
  final BoxFit fit;

  /// Logical width it is drawn at (avatars): decodes a smaller bitmap
  /// instead of the full photo, saving memory and jank in long lists.
  final double? decodeWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const placeholder = SizedBox.expand(
      child: ShimmerBox(height: double.infinity, radius: 0),
    );
    final broken = ColoredBox(
      color: context.colors.surfaceElevated,
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: context.colors.textSecondary,
        ),
      ),
    );

    return ref
        .watch(photoUrlProvider(storagePath))
        .when(
          data: (url) => CachedNetworkImage(
            imageUrl: url,
            cacheKey: storagePath,
            memCacheWidth: decodeWidth == null
                ? null
                : (decodeWidth! * MediaQuery.devicePixelRatioOf(context))
                      .round(),
            fit: fit,
            width: double.infinity,
            height: double.infinity,
            fadeInDuration: context.reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 200),
            placeholder: (_, _) => placeholder,
            errorWidget: (_, _, _) => broken,
          ),
          loading: () => placeholder,
          error: (_, _) => broken,
        );
  }
}
