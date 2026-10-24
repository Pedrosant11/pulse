// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Poll _$PollFromJson(Map<String, dynamic> json) => _Poll(
  id: json['id'] as String,
  conversationId: json['conversation_id'] as String,
  question: json['question'] as String,
  options: (json['options'] as List<dynamic>).map((e) => e as String).toList(),
  closesAt: DateTime.parse(json['closes_at'] as String),
  createdBy: json['created_by'] as String?,
);

Map<String, dynamic> _$PollToJson(_Poll instance) => <String, dynamic>{
  'id': instance.id,
  'conversation_id': instance.conversationId,
  'question': instance.question,
  'options': instance.options,
  'closes_at': instance.closesAt.toIso8601String(),
  'created_by': instance.createdBy,
};

_PollVote _$PollVoteFromJson(Map<String, dynamic> json) => _PollVote(
  pollId: json['poll_id'] as String,
  userId: json['user_id'] as String,
  option: (json['option'] as num).toInt(),
);

Map<String, dynamic> _$PollVoteToJson(_PollVote instance) => <String, dynamic>{
  'poll_id': instance.pollId,
  'user_id': instance.userId,
  'option': instance.option,
};
