import 'dart:typed_data';

import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/supabase/supabase_providers.dart';
import 'package:pulse/core/utils/random_id.dart';
import 'package:pulse/features/profile/domain/profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'profile_repository.g.dart';

const _photosBucket = 'profile-photos';

/// Profile rows and photos (SPEC 6).
class ProfileRepository {
  new(this._client);

  final SupabaseClient _client;

  Future<MyProfile> fetchMine(String userId) => guardFailures(() async {
    final row = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();
    return MyProfile.fromJson(row);
  });

  /// Updates the user's own row. Protected columns are guarded by the
  /// database (prevent_role_change trigger).
  Future<void> update(String userId, Map<String, Object?> fields) =>
      guardFailures(
        () => _client.from('profiles').update(fields).eq('id', userId),
      );

  /// "Pausar conta" (only through the RPC).
  Future<void> setPaused({required bool paused}) => guardFailures(
    () => _client.rpc<void>('set_paused', params: {'p_paused': paused}),
  );

  /// Another user (or the user themself) as others see them.
  Future<PublicProfile> fetchPublic(String userId) => guardFailures(() async {
    final row = await _client
        .from('public_profiles')
        .select()
        .eq('id', userId)
        .single();
    return PublicProfile.fromJson(row);
  });

  Future<List<ProfilePhoto>> fetchPhotos(String userId) =>
      guardFailures(() async {
        final rows = await _client
            .from('profile_photos')
            .select('id, user_id, storage_path, position')
            .eq('user_id', userId)
            .order('position');
        return rows.map(ProfilePhoto.fromJson).toList();
      });

  /// Uploads an already cropped/compressed JPEG to `{user}/{random}.jpg`
  /// and registers it at [position].
  Future<void> addPhoto({
    required String userId,
    required Uint8List jpeg,
    required int position,
  }) => guardFailures(() async {
    final path = '$userId/${randomId()}.jpg';
    await _client.storage
        .from(_photosBucket)
        .uploadBinary(
          path,
          jpeg,
          fileOptions: const FileOptions(contentType: 'image/jpeg'),
        );
    try {
      await _client.from('profile_photos').insert({
        'user_id': userId,
        'storage_path': path,
        'position': position,
      });
    } on Object {
      // Don't leave an orphan file when the row is rejected.
      await _client.storage.from(_photosBucket).remove([path]);
      rethrow;
    }
  });

  /// Deletes the row first (the database refuses going below 2 photos
  /// after onboarding), then the file.
  Future<void> removePhoto(ProfilePhoto photo) => guardFailures(() async {
    await _client.from('profile_photos').delete().eq('id', photo.id);
    await _client.storage.from(_photosBucket).remove([photo.storagePath]);
  });

  /// [photoIds] in display order; the first one becomes the main photo.
  Future<void> reorderPhotos(List<String> photoIds) => guardFailures(
    () => _client.rpc<void>(
      'reorder_profile_photos',
      params: {'p_photo_ids': photoIds},
    ),
  );

  /// Short-lived URL for a photo in the private bucket.
  Future<String> signedPhotoUrl(String storagePath, Duration expiresIn) =>
      guardFailures(
        () => _client.storage
            .from(_photosBucket)
            .createSignedUrl(storagePath, expiresIn.inSeconds),
      );
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) =>
    ProfileRepository(ref.watch(supabaseClientProvider));
