import 'dart:async';

import 'package:pulse/core/utils/run_action.dart';
import 'package:pulse/features/events/data/event_chat_repository.dart';
import 'package:pulse/features/events/domain/event_chat.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_chat_providers.g.dart';

@riverpod
Future<EventChatInfo> eventChatInfo(Ref ref, String eventId) =>
    ref.watch(eventChatRepositoryProvider).info(eventId);

/// The loaded messages (oldest first) and whether older ones exist.
class EventChatView {
  const new({required this.messages, required this.hasOlder});

  final List<EventChatMessage> messages;
  final bool hasOlder;
}

/// The repository's page size: a full page means older ones may exist.
const _pageSize = 50;

/// The chat, live: the newest page, kept fresh by Realtime, plus older
/// pages loaded on demand.
@riverpod
class EventChat extends _$EventChat {
  @override
  Future<EventChatView> build(String eventId) async {
    final repository = ref.watch(eventChatRepositoryProvider);
    final subscription = repository.subscribe(
      eventId,
      () => unawaited(_refresh()),
    );
    ref.onDispose(subscription.close);
    final page = await repository.messages(eventId);
    return EventChatView(
      messages: page.reversed.toList(),
      hasOlder: page.length == _pageSize,
    );
  }

  Future<void> _refresh() async {
    final current = state.value;
    if (current == null) return;
    try {
      final page = await ref
          .read(eventChatRepositoryProvider)
          .messages(eventId);
      if (!ref.mounted) return;
      state = AsyncData(
        EventChatView(
          messages: mergeEventChat(current.messages, page),
          hasOlder: current.hasOlder,
        ),
      );
      ref.invalidate(eventChatInfoProvider(eventId));
    } on Object {
      // A missed live update is fixed by the next one or by reopening.
    }
  }

  Future<void> loadOlder() async {
    final current = state.value;
    if (current == null || !current.hasOlder || current.messages.isEmpty) {
      return;
    }
    final page = await ref
        .read(eventChatRepositoryProvider)
        .messages(eventId, before: current.messages.first.createdAt);
    if (!ref.mounted) return;
    state = AsyncData(
      EventChatView(
        messages: [...page.reversed, ...current.messages],
        hasOlder: page.length == _pageSize,
      ),
    );
  }

  /// After my own send/delete: no need to wait for Realtime.
  Future<void> refresh() => _refresh();
}

/// Send, delete and mute in a party's chat.
@riverpod
class EventChatEditor extends _$EventChatEditor {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool?> send(String eventId, String content) =>
      runAction(ref, (s) => state = s, () async {
        await ref.read(eventChatRepositoryProvider).send(eventId, content);
        await ref.read(eventChatProvider(eventId).notifier).refresh();
        return true;
      });

  Future<bool?> delete(String eventId, String messageId) =>
      runAction(ref, (s) => state = s, () async {
        await ref.read(eventChatRepositoryProvider).delete(messageId);
        await ref.read(eventChatProvider(eventId).notifier).refresh();
        return true;
      });

  Future<bool?> mute(String eventId, String userId) =>
      runAction(ref, (s) => state = s, () async {
        await ref
            .read(eventChatRepositoryProvider)
            .setMuted(eventId, userId, muted: true);
        return true;
      });
}
