// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crew_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CrewSummary _$CrewSummaryFromJson(Map<String, dynamic> json) => _CrewSummary(
  id: json['id'] as String,
  name: json['name'] as String,
  maxMembers: (json['max_members'] as num).toInt(),
  memberCount: (json['member_count'] as num).toInt(),
  description: json['description'] as String?,
  isOpen: json['is_open'] as bool? ?? true,
  sameGenderOnly: json['same_gender_only'] as bool? ?? false,
  ownerFirstName: json['owner_first_name'] as String?,
  memberPhotos:
      (json['member_photos'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  myStatus: $enumDecodeNullable(
    _$CrewRelationEnumMap,
    json['my_status'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
);

Map<String, dynamic> _$CrewSummaryToJson(_CrewSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'max_members': instance.maxMembers,
      'member_count': instance.memberCount,
      'description': instance.description,
      'is_open': instance.isOpen,
      'same_gender_only': instance.sameGenderOnly,
      'owner_first_name': instance.ownerFirstName,
      'member_photos': instance.memberPhotos,
      'my_status': _$CrewRelationEnumMap[instance.myStatus],
    };

const _$CrewRelationEnumMap = {
  CrewRelation.owner: 'owner',
  CrewRelation.member: 'member',
  CrewRelation.requested: 'requested',
  CrewRelation.invited: 'invited',
};

_CrewDetail _$CrewDetailFromJson(Map<String, dynamic> json) => _CrewDetail(
  id: json['id'] as String,
  name: json['name'] as String,
  maxMembers: (json['max_members'] as num).toInt(),
  memberCount: (json['member_count'] as num).toInt(),
  ownerId: json['owner_id'] as String,
  eventId: json['event_id'] as String,
  eventName: json['event_name'] as String,
  eventStartsAt: DateTime.parse(json['event_starts_at'] as String),
  description: json['description'] as String?,
  isOpen: json['is_open'] as bool? ?? true,
  sameGenderOnly: json['same_gender_only'] as bool? ?? false,
  conversationId: json['conversation_id'] as String?,
  myStatus: $enumDecodeNullable(
    _$CrewRelationEnumMap,
    json['my_status'],
    unknownValue: JsonKey.nullForUndefinedEnumValue,
  ),
  myRequestId: json['my_request_id'] as String?,
);

Map<String, dynamic> _$CrewDetailToJson(_CrewDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'max_members': instance.maxMembers,
      'member_count': instance.memberCount,
      'owner_id': instance.ownerId,
      'event_id': instance.eventId,
      'event_name': instance.eventName,
      'event_starts_at': instance.eventStartsAt.toIso8601String(),
      'description': instance.description,
      'is_open': instance.isOpen,
      'same_gender_only': instance.sameGenderOnly,
      'conversation_id': instance.conversationId,
      'my_status': _$CrewRelationEnumMap[instance.myStatus],
      'my_request_id': instance.myRequestId,
    };

_CrewMember _$CrewMemberFromJson(Map<String, dynamic> json) => _CrewMember(
  userId: json['user_id'] as String,
  role: $enumDecode(_$CrewRoleEnumMap, json['role']),
  joinedAt: DateTime.parse(json['joined_at'] as String),
  firstName: json['first_name'] as String?,
  photoPath: json['photo_path'] as String?,
);

Map<String, dynamic> _$CrewMemberToJson(_CrewMember instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'role': _$CrewRoleEnumMap[instance.role]!,
      'joined_at': instance.joinedAt.toIso8601String(),
      'first_name': instance.firstName,
      'photo_path': instance.photoPath,
    };

const _$CrewRoleEnumMap = {CrewRole.owner: 'owner', CrewRole.member: 'member'};

_CrewPending _$CrewPendingFromJson(Map<String, dynamic> json) => _CrewPending(
  requestId: json['request_id'] as String,
  userId: json['user_id'] as String,
  kind: $enumDecode(_$CrewRequestKindEnumMap, json['kind']),
  createdAt: DateTime.parse(json['created_at'] as String),
  firstName: json['first_name'] as String?,
  photoPath: json['photo_path'] as String?,
);

Map<String, dynamic> _$CrewPendingToJson(_CrewPending instance) =>
    <String, dynamic>{
      'request_id': instance.requestId,
      'user_id': instance.userId,
      'kind': _$CrewRequestKindEnumMap[instance.kind]!,
      'created_at': instance.createdAt.toIso8601String(),
      'first_name': instance.firstName,
      'photo_path': instance.photoPath,
    };

const _$CrewRequestKindEnumMap = {
  CrewRequestKind.request: 'request',
  CrewRequestKind.invite: 'invite',
};

_CrewInviteCandidate _$CrewInviteCandidateFromJson(Map<String, dynamic> json) =>
    _CrewInviteCandidate(
      userId: json['user_id'] as String,
      firstName: json['first_name'] as String?,
      photoPath: json['photo_path'] as String?,
    );

Map<String, dynamic> _$CrewInviteCandidateToJson(
  _CrewInviteCandidate instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'first_name': instance.firstName,
  'photo_path': instance.photoPath,
};

_MyCrewInvite _$MyCrewInviteFromJson(Map<String, dynamic> json) =>
    _MyCrewInvite(
      requestId: json['request_id'] as String,
      crewId: json['crew_id'] as String,
      crewName: json['crew_name'] as String,
      eventName: json['event_name'] as String,
      eventStartsAt: DateTime.parse(json['event_starts_at'] as String),
      memberCount: (json['member_count'] as num).toInt(),
      invitedByName: json['invited_by_name'] as String?,
    );

Map<String, dynamic> _$MyCrewInviteToJson(_MyCrewInvite instance) =>
    <String, dynamic>{
      'request_id': instance.requestId,
      'crew_id': instance.crewId,
      'crew_name': instance.crewName,
      'event_name': instance.eventName,
      'event_starts_at': instance.eventStartsAt.toIso8601String(),
      'member_count': instance.memberCount,
      'invited_by_name': instance.invitedByName,
    };
