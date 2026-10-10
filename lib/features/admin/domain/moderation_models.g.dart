// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminReport _$AdminReportFromJson(Map<String, dynamic> json) => _AdminReport(
  id: json['id'] as String,
  targetType: $enumDecode(_$ReportTargetEnumMap, json['target_type']),
  targetId: json['target_id'] as String,
  reason: $enumDecode(_$ReportReasonEnumMap, json['reason']),
  createdAt: DateTime.parse(json['created_at'] as String),
  snapshot:
      json['snapshot'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  details: json['details'] as String?,
  reporterId: json['reporter_id'] as String?,
  reporterFirstName: json['reporter_first_name'] as String?,
  reportedUserId: json['reported_user_id'] as String?,
  reportedFirstName: json['reported_first_name'] as String?,
  reportedPhotoPath: json['reported_photo_path'] as String?,
  reportedStatus: $enumDecodeNullable(
    _$AccountStatusEnumMap,
    json['reported_status'],
  ),
  reportsAgainstUser: (json['reports_against_user'] as num?)?.toInt() ?? 0,
  previousActions: (json['previous_actions'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AdminReportToJson(_AdminReport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'target_type': _$ReportTargetEnumMap[instance.targetType]!,
      'target_id': instance.targetId,
      'reason': _$ReportReasonEnumMap[instance.reason]!,
      'created_at': instance.createdAt.toIso8601String(),
      'snapshot': instance.snapshot,
      'details': instance.details,
      'reporter_id': instance.reporterId,
      'reporter_first_name': instance.reporterFirstName,
      'reported_user_id': instance.reportedUserId,
      'reported_first_name': instance.reportedFirstName,
      'reported_photo_path': instance.reportedPhotoPath,
      'reported_status': _$AccountStatusEnumMap[instance.reportedStatus],
      'reports_against_user': instance.reportsAgainstUser,
      'previous_actions': instance.previousActions,
    };

const _$ReportTargetEnumMap = {
  ReportTarget.user: 'user',
  ReportTarget.message: 'message',
  ReportTarget.event: 'event',
};

const _$ReportReasonEnumMap = {
  ReportReason.harassment: 'harassment',
  ReportReason.inappropriateContent: 'inappropriate_content',
  ReportReason.fakeProfile: 'fake_profile',
  ReportReason.scam: 'scam',
  ReportReason.spam: 'spam',
  ReportReason.underage: 'underage',
  ReportReason.safetyConcern: 'safety_concern',
  ReportReason.other: 'other',
};

const _$AccountStatusEnumMap = {
  AccountStatus.active: 'active',
  AccountStatus.suspended: 'suspended',
  AccountStatus.banned: 'banned',
};

_RestrictedUser _$RestrictedUserFromJson(Map<String, dynamic> json) =>
    _RestrictedUser(
      userId: json['user_id'] as String,
      firstName: json['first_name'] as String,
      status: $enumDecode(_$AccountStatusEnumMap, json['status']),
      photoPath: json['photo_path'] as String?,
      reason: json['reason'] as String?,
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      actedAt: json['acted_at'] == null
          ? null
          : DateTime.parse(json['acted_at'] as String),
    );

Map<String, dynamic> _$RestrictedUserToJson(_RestrictedUser instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'first_name': instance.firstName,
      'status': _$AccountStatusEnumMap[instance.status]!,
      'photo_path': instance.photoPath,
      'reason': instance.reason,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'acted_at': instance.actedAt?.toIso8601String(),
    };
