// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserBadge _$UserBadgeFromJson(Map<String, dynamic> json) => _UserBadge(
  badge: $enumDecode(_$ProfileBadgeTypeEnumMap, json['badge']),
  title: json['title'] as String?,
);

Map<String, dynamic> _$UserBadgeToJson(_UserBadge instance) =>
    <String, dynamic>{
      'badge': _$ProfileBadgeTypeEnumMap[instance.badge]!,
      'title': instance.title,
    };

const _$ProfileBadgeTypeEnumMap = {
  ProfileBadgeType.team: 'team',
  ProfileBadgeType.dj: 'dj',
  ProfileBadgeType.publicFigure: 'public_figure',
  ProfileBadgeType.producer: 'producer',
};

_BadgeRequest _$BadgeRequestFromJson(Map<String, dynamic> json) =>
    _BadgeRequest(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      badge: $enumDecode(_$ProfileBadgeTypeEnumMap, json['badge']),
      justification: json['justification'] as String,
      status: $enumDecode(_$RequestStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['created_at'] as String),
      links:
          (json['links'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      requesterName: json['requester_name'] as String?,
    );

Map<String, dynamic> _$BadgeRequestToJson(_BadgeRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'badge': _$ProfileBadgeTypeEnumMap[instance.badge]!,
      'justification': instance.justification,
      'status': _$RequestStatusEnumMap[instance.status]!,
      'created_at': instance.createdAt.toIso8601String(),
      'links': instance.links,
      'requester_name': instance.requesterName,
    };

const _$RequestStatusEnumMap = {
  RequestStatus.pending: 'pending',
  RequestStatus.approved: 'approved',
  RequestStatus.rejected: 'rejected',
  RequestStatus.cancelled: 'cancelled',
};

_AdminUserResult _$AdminUserResultFromJson(Map<String, dynamic> json) =>
    _AdminUserResult(
      userId: json['user_id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      photoPath: json['photo_path'] as String?,
    );

Map<String, dynamic> _$AdminUserResultToJson(_AdminUserResult instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'city': instance.city,
      'state': instance.state,
      'photo_path': instance.photoPath,
    };
