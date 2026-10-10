import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pulse/app/theme/pulse_colors.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'photo_picker.g.dart';

enum PhotoSource { gallery, camera }

enum PhotoShape {
  /// Profile photo, 4:5, 1080×1350 max.
  profile(4, 5, 1080, 1350),

  /// Event cover, 16:9, 1600×900 max.
  cover(16, 9, 1600, 900);

  new(this.ratioX, this.ratioY, this.maxWidth, this.maxHeight);

  final int ratioX;
  final int ratioY;
  final int maxWidth;
  final int maxHeight;
}

/// Pick → crop → compress to a JPEG. Defaults to profile photos: 4:5 and
/// ≤1080px wide (SPEC 6.1). Event covers use [PhotoShape.cover].
/// Returns null when the user cancels at any point.
class PhotoPicker {
  new({ImagePicker? picker, ImageCropper? cropper})
    : _picker = picker ?? ImagePicker(),
      _cropper = cropper ?? ImageCropper();

  static const _quality = 85;

  final ImagePicker _picker;
  final ImageCropper _cropper;

  Future<Uint8List?> pick(
    PhotoSource source, {
    required String cropTitle,
    PhotoShape shape = PhotoShape.profile,
  }) async {
    final picked = await _picker.pickImage(
      source: source == PhotoSource.camera
          ? ImageSource.camera
          : ImageSource.gallery,
      requestFullMetadata: false,
    );
    if (picked == null) return null;

    final cropped = await _cropper.cropImage(
      sourcePath: picked.path,
      aspectRatio: CropAspectRatio(
        ratioX: shape.ratioX.toDouble(),
        ratioY: shape.ratioY.toDouble(),
      ),
      maxWidth: shape.maxWidth,
      maxHeight: shape.maxHeight,
      compressQuality: 95,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: cropTitle,
          toolbarColor: PulsePalette.background,
          statusBarLight: false,
          toolbarWidgetColor: PulsePalette.textPrimary,
          backgroundColor: PulsePalette.background,
          activeControlsWidgetColor: PulsePalette.magenta,
          lockAspectRatio: true,
          hideBottomControls: false,
        ),
        IOSUiSettings(
          title: cropTitle,
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
        ),
      ],
    );
    if (cropped == null) return null;

    // Final pass: guarantees the size limit and strips EXIF (GPS, device).
    return await FlutterImageCompress.compressWithFile(
      cropped.path,
      minWidth: shape.maxWidth,
      minHeight: shape.maxHeight,
      quality: _quality,
    );
  }
}

@Riverpod(keepAlive: true)
PhotoPicker photoPicker(Ref ref) => PhotoPicker();
