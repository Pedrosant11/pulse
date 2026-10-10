import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pulse/core/models/app_mode.dart';
import 'package:pulse/features/discover/domain/discover_models.dart';

part 'chat_models.freezed.dart';
part 'chat_models.g.dart';

/// Mirrors the database enum `conversation_type`.
enum ConversationType { direct, crew }

/// Row of `list_conversations()` (SPEC 9.1).
@freezed
abstract class ConversationSummary with _$ConversationSummary {
  const factory({
    required String id,
    required ConversationType type,
    required DateTime createdAt,
    AppMode? mode,
    String? matchId,
    String? otherUserId,
    String? otherFirstName,
    String? otherPhotoPath,
    String? lastMessage,
    String? lastMessageSenderId,
    DateTime? lastMessageAt,
    @Default(0) int unreadCount,
    String? crewId,
    String? crewName,
    String? eventName,
    int? memberCount,
  }) = _ConversationSummary;

  const new _();

  factory fromJson(Map<String, dynamic> json) =>
      _$ConversationSummaryFromJson(json);

  /// Matched but nobody wrote yet ("Novos matches" strip).
  bool get isNewMatch => type == ConversationType.direct && lastMessage == null;
}

/// Row of `get_conversation()`: header, read receipt and icebreakers.
@freezed
abstract class ConversationHeader with _$ConversationHeader {
  const factory({
    required String id,
    required ConversationType type,
    AppMode? mode,
    String? matchId,
    String? otherUserId,
    String? otherFirstName,
    String? otherPhotoPath,
    DateTime? otherLastReadAt,
    @Default([]) List<CommonEvent> commonEvents,
    String? crewId,
    String? crewName,
    String? eventName,
    int? memberCount,
  }) = _ConversationHeader;

  factory fromJson(Map<String, dynamic> json) =>
      _$ConversationHeaderFromJson(json);

  const new _();

  bool get isGroup => type == ConversationType.crew;
}

@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory({
    required String id,
    required String conversationId,
    required String senderId,
    required String content,
    required DateTime createdAt,
    DateTime? deletedAt,
  }) = _ChatMessage;

  factory fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
}

/// A member of a conversation (group chat bubbles).
@freezed
abstract class ConversationMember with _$ConversationMember {
  const factory({
    required String userId,
    String? firstName,
    String? photoPath,
  }) = _ConversationMember;

  factory fromJson(Map<String, dynamic> json) =>
      _$ConversationMemberFromJson(json);
}

/// A message being sent (optimistic UI).
@freezed
abstract class PendingMessage with _$PendingMessage {
  const factory({
    required String localId,
    required String content,
    required DateTime createdAt,
    @Default(false) bool failed,
  }) = _PendingMessage;
}

@freezed
abstract class ConversationState with _$ConversationState {
  const factory({
    /// Newest first (the list is reversed on screen).
    required List<ChatMessage> messages,
    @Default(true) bool hasMore,
    @Default(false) bool loadingMore,
    @Default(false) bool otherTyping,

    /// Who is typing (group chats show the name).
    String? typingUserId,
    DateTime? otherLastReadAt,
    @Default([]) List<PendingMessage> pending,
  }) = _ConversationState;
}
