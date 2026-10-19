import 'dart:typed_data';

import 'package:pulse/app/constants.dart';
import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/supabase/supabase_providers.dart';
import 'package:pulse/core/utils/random_id.dart';
import 'package:pulse/features/chat/domain/chat_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'chat_repository.g.dart';

const _messageColumns =
    'id, conversation_id, sender_id, content, created_at, deleted_at, '
    'kind, media_path, media_duration_ms';

const _mediaBucket = 'chat-media';

/// Callbacks of a conversation's realtime channel.
class ConversationEvents {
  const new({
    required this.onMessage,
    required this.onReadReceipt,
    required this.onTyping,
  });

  /// New or updated (soft-deleted) message.
  final void Function(ChatMessage message) onMessage;

  /// Another member's `last_read_at` changed.
  final void Function(String userId, DateTime lastReadAt) onReadReceipt;

  /// Someone is typing (broadcast, not stored).
  final void Function(String userId) onTyping;
}

/// A live subscription; [sendTyping] is only meaningful for conversations.
abstract interface class ChatSubscription {
  Future<void> sendTyping(String userId);
  Future<void> close();
}

class _RealtimeSubscription implements ChatSubscription {
  new(this._client, this._channel);

  final SupabaseClient _client;
  final RealtimeChannel _channel;

  @override
  Future<void> sendTyping(String userId) => _channel.sendBroadcastMessage(
    event: 'typing',
    payload: {'user_id': userId},
  );

  @override
  Future<void> close() => _client.removeChannel(_channel);
}

class ChatRepository {
  new(this._client);

  final SupabaseClient _client;

  Future<List<ConversationSummary>> conversations() => guardFailures(() async {
    final rows = await _client.rpc<List<dynamic>>('list_conversations');
    return rows
        .map((r) => ConversationSummary.fromJson(r as Map<String, dynamic>))
        .toList();
  });

  /// Null when the conversation is no longer accessible (unmatch/block).
  Future<ConversationHeader?> header(String conversationId) =>
      guardFailures(() async {
        final rows = await _client.rpc<List<dynamic>>(
          'get_conversation',
          params: {'p_conversation_id': conversationId},
        );
        if (rows.isEmpty) return null;
        return ConversationHeader.fromJson(rows.first as Map<String, dynamic>);
      });

  Future<List<ConversationMember>> members(String conversationId) =>
      guardFailures(() async {
        final rows = await _client.rpc<List<dynamic>>(
          'get_conversation_members',
          params: {'p_conversation_id': conversationId},
        );
        return rows
            .map((r) => ConversationMember.fromJson(r as Map<String, dynamic>))
            .toList();
      });

  /// A page of messages, newest first, older than [before] (SPEC 9.1: 30).
  Future<List<ChatMessage>> messages(
    String conversationId, {
    DateTime? before,
    int limit = AppConstants.messagesPageSize,
  }) => guardFailures(() async {
    var query = _client
        .from('messages')
        .select(_messageColumns)
        .eq('conversation_id', conversationId);
    if (before != null) {
      query = query.lt('created_at', before.toUtc().toIso8601String());
    }
    final rows = await query.order('created_at', ascending: false).limit(limit);
    return rows.map(ChatMessage.fromJson).toList();
  });

  Future<ChatMessage> send({
    required String conversationId,
    required String senderId,
    required String content,
    MessageKind kind = MessageKind.text,
    String? mediaPath,
    int? mediaDurationMs,
  }) => guardFailures(() async {
    final row = await _client
        .from('messages')
        .insert({
          'conversation_id': conversationId,
          'sender_id': senderId,
          'content': content,
          'kind': kind.name,
          'media_path': ?mediaPath,
          'media_duration_ms': ?mediaDurationMs,
        })
        .select(_messageColumns)
        .single();
    return ChatMessage.fromJson(row);
  });

  /// Uploads a photo (jpg) or voice message (m4a) to
  /// `{sender}/{conversation}/{random}`; returns its path.
  Future<String> uploadMedia({
    required String conversationId,
    required String senderId,
    required MessageKind kind,
    required Uint8List bytes,
  }) => guardFailures(() async {
    final image = kind == MessageKind.image;
    final path =
        '$senderId/$conversationId/${randomId()}.${image ? 'jpg' : 'm4a'}';
    await _client.storage
        .from(_mediaBucket)
        .uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            contentType: image ? 'image/jpeg' : 'audio/mp4',
          ),
        );
    return path;
  });

  /// Short-lived link to a photo or voice message (members only).
  Future<String> mediaUrl(String path) => guardFailures(
    () => _client.storage.from(_mediaBucket).createSignedUrl(path, 60 * 60),
  );

  /// Best effort: the message is already gone for everyone.
  Future<void> removeMedia(String path) async {
    try {
      await _client.storage.from(_mediaBucket).remove([path]);
    } on Object {
      // Left behind; removed with the account.
    }
  }

  /// Soft delete (only the sender; enforced by RLS and a trigger).
  Future<void> deleteMessage(String messageId) => guardFailures(
    () => _client
        .from('messages')
        .update({'deleted_at': DateTime.now().toUtc().toIso8601String()})
        .eq('id', messageId),
  );

  Future<void> markRead(String conversationId) => guardFailures(
    () => _client.rpc<void>(
      'mark_conversation_read',
      params: {'p_conversation_id': conversationId},
    ),
  );

  Future<void> unmatch(String matchId) => guardFailures(
    () => _client.rpc<void>('unmatch', params: {'p_match_id': matchId}),
  );

  /// Messages, read receipts and typing for one conversation. The typing
  /// broadcast uses a private channel authorized by RLS (chat migration).
  ChatSubscription subscribeConversation(
    String conversationId,
    ConversationEvents events,
  ) {
    final filter = PostgresChangeFilter(
      type: PostgresChangeFilterType.eq,
      column: 'conversation_id',
      value: conversationId,
    );
    void onMessageChange(PostgresChangePayload payload) {
      if (payload.newRecord.isEmpty) return;
      events.onMessage(ChatMessage.fromJson(payload.newRecord));
    }

    final channel = _client
        .channel(
          'conversation:$conversationId',
          opts: const RealtimeChannelConfig(private: true),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: filter,
          callback: onMessageChange,
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'messages',
          filter: filter,
          callback: onMessageChange,
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'conversation_members',
          filter: filter,
          callback: (payload) {
            final row = payload.newRecord;
            final readAt = row['last_read_at'] as String?;
            if (readAt == null) return;
            events.onReadReceipt(
              row['user_id'] as String,
              DateTime.parse(readAt),
            );
          },
        )
        .onBroadcast(
          event: 'typing',
          callback: (payload) {
            final userId = payload['user_id'];
            if (userId is String) events.onTyping(userId);
          },
        )
        .subscribe();
    return _RealtimeSubscription(_client, channel);
  }

  /// Anything that changes the inbox (new message, new match, unmatch).
  ChatSubscription subscribeInbox(String userId, void Function() onChange) {
    final channel = _client
        .channel('inbox:$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          callback: (_) => onChange(),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'matches',
          callback: (_) => onChange(),
        )
        .subscribe();
    return _RealtimeSubscription(_client, channel);
  }
}

@Riverpod(keepAlive: true)
ChatRepository chatRepository(Ref ref) =>
    ChatRepository(ref.watch(supabaseClientProvider));
