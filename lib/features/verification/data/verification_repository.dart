import 'dart:typed_data';

import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/supabase/supabase_providers.dart';
import 'package:pulse/core/utils/enum_json.dart';
import 'package:pulse/core/utils/random_id.dart';
import 'package:pulse/features/verification/domain/verification_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'verification_repository.g.dart';

/// Selfie verification (selfie_verification migration). The database
/// decides who may send and who reviews; the selfie is deleted on review.
class VerificationRepository {
  new(this._client);

  final SupabaseClient _client;

  static const _bucket = 'verification-selfies';

  Future<VerificationRequest?> latest(String userId) => guardFailures(() async {
    final rows = await _client
        .from('verification_requests')
        .select('id, pose, status, created_at, rejection_reason')
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(1);
    return rows.isEmpty ? null : VerificationRequest.fromJson(rows.first);
  });

  /// Uploads the selfie to `{user}/{random}.jpg` and sends it for review.
  Future<void> submit({
    required String userId,
    required VerificationPose pose,
    required Uint8List jpeg,
  }) => guardFailures(() async {
    final path = '$userId/${randomId()}.jpg';
    await _client.storage
        .from(_bucket)
        .uploadBinary(
          path,
          jpeg,
          fileOptions: const FileOptions(contentType: 'image/jpeg'),
        );
    try {
      await _client.rpc<void>(
        'submit_verification',
        params: {'p_pose': enumToDb(pose), 'p_selfie_path': path},
      );
    } on Object {
      // Don't leave the selfie behind when the request is refused.
      await _client.storage.from(_bucket).remove([path]);
      rethrow;
    }
  });

  // Admin ---------------------------------------------------------------

  Future<List<PendingVerification>> pending() => guardFailures(() async {
    final rows = await _client.rpc<List<dynamic>>('admin_list_verifications');
    return rows
        .map((r) => PendingVerification.fromJson(r as Map<String, dynamic>))
        .toList();
  });

  Future<String> selfieUrl(String path) => guardFailures(
    () => _client.storage.from(_bucket).createSignedUrl(path, 600),
  );

  /// Records the decision, then deletes the selfie (used only for this).
  Future<void> review(
    String requestId, {
    required bool approve,
    String? reason,
  }) => guardFailures(() async {
    final path = await _client.rpc<String?>(
      'admin_review_verification',
      params: {
        'p_request_id': requestId,
        'p_approve': approve,
        'p_reason': reason,
      },
    );
    if (path != null) await _client.storage.from(_bucket).remove([path]);
  });
}

@Riverpod(keepAlive: true)
VerificationRepository verificationRepository(Ref ref) =>
    VerificationRepository(ref.watch(supabaseClientProvider));
