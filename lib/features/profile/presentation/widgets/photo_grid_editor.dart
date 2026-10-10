import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/constants.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/profile/data/photo_picker.dart';
import 'package:pulse/features/profile/domain/profile.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/features/profile/presentation/widgets/profile_photo_image.dart';

/// 2–6 photo slots (SPEC 6.1). The first photo is the main one; long-press
/// and drag a photo onto another slot to reorder.
class PhotoGridEditor extends ConsumerWidget {
  const new({super.key});

  static const int _slots = AppConstants.maxProfilePhotos;

  Future<void> _add(BuildContext context, WidgetRef ref, int position) async {
    final l10n = context.l10n;
    final source = await showModalBottomSheet<PhotoSource>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      backgroundColor: context.colors.surface,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: Text(l10n.photoFromGallery),
            onTap: () => Navigator.pop(context, PhotoSource.gallery),
          ),
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: Text(l10n.photoFromCamera),
            onTap: () => Navigator.pop(context, PhotoSource.camera),
          ),
        ],
      ),
    );
    if (source == null) return;
    await ref
        .read(photosEditorProvider.notifier)
        .add(
          source: source,
          position: position,
          cropTitle: l10n.photoCropTitle,
        );
  }

  void _move(WidgetRef ref, List<ProfilePhoto> photos, int from, int to) {
    if (from == to) return;
    final ordered = [...photos];
    ordered.insert(to, ordered.removeAt(from));
    unawaited(HapticFeedback.selectionClick());
    unawaited(ref.read(photosEditorProvider.notifier).reorder(ordered));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photosValue = ref.watch(myPhotosProvider);
    final editor = ref.watch(photosEditorProvider);
    final spacing = context.spacing;

    return AsyncValueView(
      value: photosValue,
      onRetry: () => ref.invalidate(myPhotosProvider),
      loading: const SizedBox(height: 240, child: LoadingView(itemCount: 1)),
      data: (photos) {
        final used = {for (final p in photos) p.position};
        final freePosition = List.generate(
          _slots,
          (i) => i,
        ).firstWhere((i) => !used.contains(i), orElse: () => -1);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 4 / 5,
              mainAxisSpacing: spacing.xs,
              crossAxisSpacing: spacing.xs,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (var i = 0; i < _slots; i++)
                  if (i < photos.length)
                    _PhotoSlot(
                      photo: photos[i],
                      index: i,
                      enabled: !editor.isLoading,
                      onRemove: () => ref
                          .read(photosEditorProvider.notifier)
                          .remove(photos[i]),
                      onDropped: (from) => _move(ref, photos, from, i),
                    )
                  else
                    _EmptySlot(
                      index: i,
                      uploading: editor.isLoading && i == photos.length,
                      onTap: editor.isLoading || freePosition < 0
                          ? null
                          : () => _add(context, ref, freePosition),
                    ),
              ],
            ),
            SizedBox(height: spacing.sm),
            FormErrorText(error: editor.error),
          ],
        );
      },
    );
  }
}

class _PhotoSlot extends StatelessWidget {
  const new({
    required this.photo,
    required this.index,
    required this.enabled,
    required this.onRemove,
    required this.onDropped,
  });

  final ProfilePhoto photo;
  final int index;
  final bool enabled;
  final VoidCallback onRemove;
  final ValueChanged<int> onDropped;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final radius = BorderRadius.circular(context.radii.md);

    Widget tile({bool highlighted = false}) => ClipRRect(
      borderRadius: radius,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ProfilePhotoImage(photo.storagePath),
          if (highlighted)
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: colors.magenta, width: 2),
                borderRadius: radius,
              ),
            ),
          if (index == 0)
            Positioned(
              left: 6,
              bottom: 6,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: colors.primaryGradient,
                  borderRadius: BorderRadius.circular(context.radii.pill),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  child: Text(
                    l10n.photoMain,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            right: 2,
            top: 2,
            child: IconButton.filledTonal(
              tooltip: l10n.photoRemove,
              iconSize: 18,
              visualDensity: VisualDensity.compact,
              onPressed: enabled ? onRemove : null,
              icon: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );

    return Semantics(
      label: l10n.photoSlotLabel(index + 1),
      image: true,
      child: DragTarget<int>(
        onWillAcceptWithDetails: (details) => enabled && details.data != index,
        onAcceptWithDetails: (details) => onDropped(details.data),
        builder: (context, candidates, _) => LongPressDraggable<int>(
          data: index,
          maxSimultaneousDrags: enabled ? 1 : 0,
          feedback: LayoutBuilder(
            builder: (context, _) => SizedBox(
              width: 110,
              height: 137,
              child: Opacity(opacity: 0.85, child: tile()),
            ),
          ),
          childWhenDragging: Opacity(opacity: 0.3, child: tile()),
          child: tile(highlighted: candidates.isNotEmpty),
        ),
      ),
    );
  }
}

class _EmptySlot extends StatelessWidget {
  const new({required this.index, required this.uploading, this.onTap});

  final int index;
  final bool uploading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = BorderRadius.circular(context.radii.md);
    if (uploading) {
      return ClipRRect(
        borderRadius: radius,
        child: const ShimmerBox(height: double.infinity, radius: 0),
      );
    }
    return Semantics(
      button: true,
      label:
          '${context.l10n.photoAdd}, ${context.l10n.photoSlotLabel(index + 1)}',
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: radius,
            border: Border.all(color: colors.glassBorder),
          ),
          child: Center(
            child: Icon(
              Icons.add_rounded,
              size: 32,
              color: onTap == null ? colors.textSecondary : colors.magenta,
            ),
          ),
        ),
      ),
    );
  }
}
