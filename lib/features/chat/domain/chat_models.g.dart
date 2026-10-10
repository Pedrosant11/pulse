// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConversationSummary _$ConversationSummaryFromJson(Map<String, dynamic> json) =>
    _ConversationSummary(
      id: json['id'] as String,
      type: $enumDecode(_$ConversationTypeEnumMap, json['type']),
      createdAt: DateTime.parse(json['created_at'] as String),
      mode: $enumDecodeNullable(_$AppModeEnumMap, json['mode']),
      matchId: json['match_id'] as String?,
      otherUserId: json['other_user_id'] as String?,
      otherFirstName: json['other_first_name'] as String?,
      otherPhotoPath: json['other_photo_path'] as String?,
      lastMessage: json['last_message'] as String?,
      lastMessageSenderId: json['last_message_sender_id'] as String?,
      lastMessageAt: json['last_message_at'] == null
          ? null
          : DateTime.parse(json['last_message_at'] as String),
      unreadCount: (json['unread_count'] as num?)?.toInt() ?? 0,
      crewId: json['crew_id'] as String?,
      crewName: json['crew_name'] as String?,
      eventName: json['event_name'] as String?,
      memberCount: (json['member_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ConversationSummaryToJson(
  _ConversationSummary instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': _$ConversationTypeEnumMap[instance.type]!,
  'created_at': instance.createdAt.toIso8601String(),
  'mode': _$AppModeEnumMap[instance.mode],
  'match_id': instance.matchId,
  'other_user_id': instance.otherUserId,
  'other_first_name': instance.otherFirstName,
  'other_photo_path': instance.otherPhotoPath,
  'last_message': instance.lastMessage,
  'last_message_sender_id': instance.lastMessageSenderId,
  'last_message_at': instance.lastMessageAt?.toIso8601String(),
  'unread_count': instance.unreadCount,
  'crew_id': instance.crewId,
  'crew_name': instance.crewName,
  'event_name': instance.eventName,
  'member_count': instance.memberCount,
};

const _$ConversationTypeEnumMap = {
  ConversationType.direct: 'direct',
  ConversationType.crew: 'crew',
};

const _$AppModeEnumMap = {AppMode.date: 'date', AppMode.crew: 'crew'};

_ConversationHeader _$ConversationHeaderFromJson(Map<String, dynamic> json) =>
    _ConversationHeader(
      id: json['id'] as String,
      type: $enumDecode(_$ConversationTypeEnumMap, json['type']),
      mode: $enumDecodeNullable(_$AppModeEnumMap, json['mode']),
      matchId: json['match_id'] as String?,
      otherUserId: json['other_user_id'] as String?,
      otherFirstName: json['other_first_name'] as String?,
      otherPhotoPath: json['other_photo_path'] as String?,
      otherLastReadAt: json['other_last_read_at'] == null
          ? null
          : DateTime.parse(json['other_last_read_at'] as String),
      commonEvents:
          (json['common_events'] as List<dynamic>?)
              ?.map((e) => CommonEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      crewId: json['crew_id'] as String?,
      crewName: json['crew_name'] as String?,
      eventName: json['event_name'] as String?,
      memberCount: (json['member_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ConversationHeaderToJson(_ConversationHeader instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$ConversationTypeEnumMap[instance.type]!,
      'mode': _$AppModeEnumMap[instance.mode],
      'match_id': instance.matchId,
      'other_user_id': instance.otherUserId,
      'other_first_name': instance.otherFirstName,
      'other_photo_path': instance.otherPhotoPath,
      'other_last_read_at': instance.otherLastReadAt?.toIso8601String(),
      'common_events': instance.commonEvents.map((e) => e.toJson()).toList(),
      'crew_id': instance.crewId,
      'crew_name': instance.crewName,
      'event_name': instance.eventName,
      'member_count': instance.memberCount,
    };

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
  id: json['id'] as String,
  conversationId: json['conversation_id'] as String,
  senderId: json['sender_id'] as String,
  content: json['content'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
);

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversation_id': instance.conversationId,
      'sender_id': instance.senderId,
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };

_ConversationMember _$ConversationMemberFromJson(Map<String, dynamic> json) =>
    _ConversationMember(
      userId: json['user_id'] as String,
      firstName: json['first_name'] as String?,
      photoPath: json['photo_path'] as String?,
    );

Map<String, dynamic> _$ConversationMemberToJson(_ConversationMember instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'first_name': instance.firstName,
      'photo_path': instance.photoPath,
    };
