// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VerificationRequest _$VerificationRequestFromJson(Map<String, dynamic> json) =>
    _VerificationRequest(
      id: json['id'] as String,
      pose: $enumDecode(_$VerificationPoseEnumMap, json['pose']),
      status: $enumDecode(_$RequestStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['created_at'] as String),
      rejectionReason: json['rejection_reason'] as String?,
    );

Map<String, dynamic> _$VerificationRequestToJson(
  _VerificationRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'pose': _$VerificationPoseEnumMap[instance.pose]!,
  'status': _$RequestStatusEnumMap[instance.status]!,
  'created_at': instance.createdAt.toIso8601String(),
  'rejection_reason': instance.rejectionReason,
};

const _$VerificationPoseEnumMap = {
  VerificationPose.thumbsUp: 'thumbs_up',
  VerificationPose.peaceSign: 'peace_sign',
  VerificationPose.handOnHead: 'hand_on_head',
  VerificationPose.pointUp: 'point_up',
  VerificationPose.handOnChin: 'hand_on_chin',
};

const _$RequestStatusEnumMap = {
  RequestStatus.pending: 'pending',
  RequestStatus.approved: 'approved',
  RequestStatus.rejected: 'rejected',
  RequestStatus.cancelled: 'cancelled',
};

_PendingVerification _$PendingVerificationFromJson(Map<String, dynamic> json) =>
    _PendingVerification(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      firstName: json['first_name'] as String,
      age: (json['age'] as num).toInt(),
      pose: $enumDecode(_$VerificationPoseEnumMap, json['pose']),
      createdAt: DateTime.parse(json['created_at'] as String),
      selfiePath: json['selfie_path'] as String?,
      photoPaths:
          (json['photo_paths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PendingVerificationToJson(
  _PendingVerification instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'first_name': instance.firstName,
  'age': instance.age,
  'pose': _$VerificationPoseEnumMap[instance.pose]!,
  'created_at': instance.createdAt.toIso8601String(),
  'selfie_path': instance.selfiePath,
  'photo_paths': instance.photoPaths,
};
