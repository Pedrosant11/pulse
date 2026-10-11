import 'dart:typed_data';

import 'package:pulse/core/utils/run_action.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/features/verification/data/verification_repository.dart';
import 'package:pulse/features/verification/domain/verification_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'verification_providers.g.dart';

@riverpod
Future<VerificationRequest?> myVerification(Ref ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Future.value();
  return ref.watch(verificationRepositoryProvider).latest(userId);
}

@riverpod
Future<List<PendingVerification>> pendingVerifications(Ref ref) =>
    ref.watch(verificationRepositoryProvider).pending();

@riverpod
Future<String> verificationSelfieUrl(Ref ref, String path) =>
    ref.watch(verificationRepositoryProvider).selfieUrl(path);

@riverpod
class VerificationController extends _$VerificationController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool?> submit(VerificationPose pose, Uint8List jpeg) =>
      runAction(ref, (s) => state = s, () async {
        final userId = ref.read(currentUserIdProvider);
        if (userId == null) throw StateError('Not signed in');
        await ref
            .read(verificationRepositoryProvider)
            .submit(userId: userId, pose: pose, jpeg: jpeg);
        ref.invalidate(myVerificationProvider);
        return true;
      });

  /// Admin decision; approving gives the badge.
  Future<bool?> review(
    String requestId, {
    required bool approve,
    String? reason,
  }) => runAction(ref, (s) => state = s, () async {
    await ref
        .read(verificationRepositoryProvider)
        .review(requestId, approve: approve, reason: reason);
    ref
      ..invalidate(pendingVerificationsProvider)
      ..invalidate(myProfileProvider);
    return true;
  });
}
