import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/supabase/supabase_providers.dart';
import 'package:pulse/features/events/domain/event_chat.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'event_chat_repository.g.dart';

/// A live listener on a party's chat; close it when leaving the screen.
abstract interface class EventChatSubscription {
  Future<void> close();
}

class _RealtimeSubscription implements EventChatSubscription {
  new(this._client, this._channel);

  final SupabaseClient _client;
  final RealtimeChannel _channel;

  @override
  Future<void> close() => _client.removeChannel(_channel);
}

class EventChatRepository {
  new(this._client);

  final SupabaseClient _client;

  Future<EventChatInfo> info(String eventId) => guardFailures(() async {
    final json = await _client.rpc<Map<String, dynamic>>(
      'event_chat_info',
      params: {'p_event': eventId},
    );
    return EventChatInfo.fromJson(json);
  });

  /// A page of messages, newest first.
  Future<List<EventChatMessage>> messages(
    String eventId, {
    DateTime? before,
    int limit = 50,
  }) => guardFailures(() async {
    final rows = await _client.rpc<List<dynamic>>(
      'event_chat_messages',
      params: {
        'p_event': eventId,
        'p_before': before?.toUtc().toIso8601String(),
        'p_limit': limit,
      },
    );
    return [
      for (final row in rows)
        EventChatMessage.fromJson(row as Map<String, dynamic>),
    ];
  });

  Future<void> send(String eventId, String content) => guardFailures(
    () => _client.rpc<String>(
      'send_event_message',
      params: {'p_event': eventId, 'p_content': content},
    ),
  );

  Future<void> delete(String messageId) => guardFailures(
    () => _client.rpc<void>(
      'delete_event_message',
      params: {'p_message': messageId},
    ),
  );

  Future<void> setMuted(String eventId, String userId, {required bool muted}) =>
      guardFailures(
        () => _client.rpc<void>(
          'set_event_chat_mute',
          params: {'p_event': eventId, 'p_user': userId, 'p_muted': muted},
        ),
      );

  /// Calls [onChange] when a message arrives or is deleted. The rows only
  /// say "something changed"; the screen reloads the newest page through
  /// [messages], which brings names and photos and drops blocked people.
  EventChatSubscription subscribe(String eventId, void Function() onChange) {
    final channel = _client
        .channel(
          'event-chat:$eventId',
          opts: const RealtimeChannelConfig(private: true),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'event_messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'event_id',
            value: eventId,
          ),
          callback: (_) => onChange(),
        )
        // Deletes carry only the id (no event_id to filter on).
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'event_messages',
          callback: (_) => onChange(),
        )
        .subscribe();
    return _RealtimeSubscription(_client, channel);
  }
}

@Riverpod(keepAlive: true)
EventChatRepository eventChatRepository(Ref ref) =>
    EventChatRepository(ref.watch(supabaseClientProvider));
