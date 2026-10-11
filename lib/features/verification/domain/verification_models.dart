import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pulse/features/admin/data/role_requests_repository.dart';

part 'verification_models.freezed.dart';
part 'verification_models.g.dart';

/// Matches the database enum `verification_pose`. The app picks one at
/// random for each try, so an old photo can't be reused.
@JsonEnum(fieldRename: FieldRename.snake)
enum VerificationPose { thumbsUp, peaceSign, handOnHead, pointUp, handOnChin }

/// The person's latest verification request.
@freezed
abstract class VerificationRequest with _$VerificationRequest {
  const factory({
    required String id,
    required VerificationPose pose,
    required RequestStatus status,
    required DateTime createdAt,
    String? rejectionReason,
  }) = _VerificationRequest;

  factory fromJson(Map<String, dynamic> json) =>
      _$VerificationRequestFromJson(json);
}

/// A pending request in the admin queue.
@freezed
abstract class PendingVerification with _$PendingVerification {
  const factory({
    required String id,
    required String userId,
    required String firstName,
    required int age,
    required VerificationPose pose,
    required DateTime createdAt,
    String? selfiePath,
    @Default([]) List<String> photoPaths,
  }) = _PendingVerification;

  factory fromJson(Map<String, dynamic> json) =>
      _$PendingVerificationFromJson(json);
}
