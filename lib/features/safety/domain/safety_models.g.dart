// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'safety_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BlockedUser _$BlockedUserFromJson(Map<String, dynamic> json) => _BlockedUser(
  userId: json['user_id'] as String,
  firstName: json['first_name'] as String,
  blockedAt: DateTime.parse(json['blocked_at'] as String),
  photoPath: json['photo_path'] as String?,
);

Map<String, dynamic> _$BlockedUserToJson(_BlockedUser instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'first_name': instance.firstName,
      'blocked_at': instance.blockedAt.toIso8601String(),
      'photo_path': instance.photoPath,
    };

_ModerationNotice _$ModerationNoticeFromJson(Map<String, dynamic> json) =>
    _ModerationNotice(
      id: json['id'] as String,
      action: $enumDecode(_$ModerationActionEnumMap, json['action']),
      reason: json['reason'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$ModerationNoticeToJson(_ModerationNotice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'action': _$ModerationActionEnumMap[instance.action]!,
      'reason': instance.reason,
      'created_at': instance.createdAt.toIso8601String(),
      'expires_at': instance.expiresAt?.toIso8601String(),
    };

const _$ModerationActionEnumMap = {
  ModerationAction.warning: 'warning',
  ModerationAction.suspension: 'suspension',
  ModerationAction.ban: 'ban',
  ModerationAction.reactivation: 'reactivation',
};
