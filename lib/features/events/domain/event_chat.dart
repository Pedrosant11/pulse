/// "Chat da festa": one open text chat per approved party. Who marked
/// "Eu vou" (and the party's team) reads and writes; the rules live in the
/// database (`send_event_message`, `event_chat_info`).
library;

/// Open from the approval until 12 h after the end; then read only for a
/// few days; then gone.
enum EventChatState { open, readOnly, closed }

/// Messages are short: a chat line, not a post.
const eventChatMaxLength = 500;

class EventChatInfo {
  const new({
    required this.state,
    required this.inChat,
    required this.canModerate,
    required this.muted,
    required this.people,
    required this.messages,
    this.lastAt,
  });

  factory fromJson(Map<String, dynamic> json) => EventChatInfo(
    state: switch (json['state']) {
      'open' => EventChatState.open,
      'read_only' => EventChatState.readOnly,
      _ => EventChatState.closed,
    },
    inChat: json['in_chat'] == true,
    canModerate: json['can_moderate'] == true,
    muted: json['muted'] == true,
    people: (json['people'] as num?)?.toInt() ?? 0,
    messages: (json['messages'] as num?)?.toInt() ?? 0,
    lastAt: switch (json['last_at']) {
      final String at => DateTime.parse(at),
      _ => null,
    },
  );

  final EventChatState state;

  /// Going ("Eu vou") or the party's team.
  final bool inChat;

  /// The party's team or the moderation team: deletes and mutes.
  final bool canModerate;

  /// Muted by the team in this chat.
  final bool muted;

  /// Who is going (the chat's audience).
  final int people;
  final int messages;
  final DateTime? lastAt;

  bool get canWrite => inChat && !muted && state == EventChatState.open;
}

class EventChatMessage {
  const new({
    required this.id,
    required this.senderId,
    required this.firstName,
    required this.content,
    required this.createdAt,
    this.photoPath,
    this.isVerified = false,
    this.isTeam = false,
  });

  factory fromJson(Map<String, dynamic> json) => EventChatMessage(
    id: json['id'] as String,
    senderId: json['sender_id'] as String,
    firstName: json['first_name'] as String,
    photoPath: json['photo_path'] as String?,
    isVerified: json['is_verified'] == true,
    isTeam: json['is_team'] == true,
    content: json['content'] as String,
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  final String id;
  final String senderId;
  final String firstName;
  final String? photoPath;
  final bool isVerified;

  /// Sent by the party's producer or the moderation team ("Produção").
  final bool isTeam;
  final String content;
  final DateTime createdAt;
}

/// Merges a fresh page of newest messages into what is loaded (oldest
/// first), dropping the ones that were deleted within that page's range.
List<EventChatMessage> mergeEventChat(
  List<EventChatMessage> loaded,
  List<EventChatMessage> newestFirst,
) {
  if (newestFirst.isEmpty) return const [];
  final fresh = newestFirst.reversed.toList();
  final from = fresh.first.createdAt;
  final older = [
    for (final m in loaded)
      if (m.createdAt.isBefore(from)) m,
  ];
  return [...older, ...fresh];
}
