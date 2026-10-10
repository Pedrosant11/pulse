import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/models/app_mode.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/chat/data/chat_repository.dart';
import 'package:pulse/features/chat/domain/chat_models.dart';
import 'package:pulse/features/chat/presentation/chat_providers.dart';

const conversationId = 'c1';

ChatMessage msg(String id, String sender, int minute) => ChatMessage(
  id: id,
  conversationId: conversationId,
  senderId: sender,
  content: 'm$id',
  createdAt: DateTime.utc(2026, 10, 4, 20, minute),
);

class FakeSubscription implements ChatSubscription {
  final typing = <String>[];
  bool closed = false;

  @override
  Future<void> sendTyping(String userId) async => typing.add(userId);

  @override
  Future<void> close() async => closed = true;
}

class FakeChatRepository implements ChatRepository {
  List<ChatMessage> history = [];
  ConversationEvents? events;
  final subscription = FakeSubscription();
  Exception? sendError;
  int markedRead = 0;
  final deleted = <String>[];

  @override
  Future<ConversationHeader?> header(String id) async => ConversationHeader(
    id: id,
    type: ConversationType.direct,
    mode: AppMode.date,
    otherUserId: 'other',
    otherFirstName: 'Elisa',
  );

  @override
  Future<List<ChatMessage>> messages(
    String id, {
    DateTime? before,
    int limit = 30,
  }) async {
    final older = before == null
        ? history
        : history.where((m) => m.createdAt.isBefore(before)).toList();
    return older.take(limit).toList();
  }

  @override
  Future<ChatMessage> send({
    required String conversationId,
    required String senderId,
    required String content,
  }) async {
    if (sendError case final error?) throw error;
    return ChatMessage(
      id: 'server-$content',
      conversationId: conversationId,
      senderId: senderId,
      content: content,
      createdAt: DateTime.utc(2026, 10, 4, 21),
    );
  }

  @override
  Future<void> markRead(String id) async => markedRead++;

  @override
  Future<void> deleteMessage(String id) async => deleted.add(id);

  @override
  ChatSubscription subscribeConversation(String id, ConversationEvents events) {
    this.events = events;
    return subscription;
  }

  @override
  ChatSubscription subscribeInbox(String userId, void Function() onChange) =>
      FakeSubscription();

  @override
  Future<List<ConversationSummary>> conversations() async => const [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeChatRepository repository;
  late ProviderContainer container;

  ConversationController controller() =>
      container.read(conversationControllerProvider(conversationId).notifier);
  ConversationState state() => container
      .read(conversationControllerProvider(conversationId))
      .requireValue;

  Future<void> open() async {
    container = ProviderContainer(
      overrides: [
        chatRepositoryProvider.overrideWithValue(repository),
        currentUserIdProvider.overrideWithValue('me'),
      ],
    );
    addTearDown(container.dispose);
    container.listen(conversationControllerProvider(conversationId), (_, _) {});
    await container.read(conversationControllerProvider(conversationId).future);
  }

  setUp(() {
    repository = FakeChatRepository()
      ..history = [msg('2', 'other', 2), msg('1', 'me', 1)];
  });

  test('loads the latest page and marks the conversation as read', () async {
    await open();
    expect(state().messages.map((m) => m.id), ['2', '1']);
    expect(state().hasMore, isFalse);
    expect(repository.markedRead, 1);
  });

  test('sending is optimistic and settles on the server message', () async {
    await open();
    final sending = controller().send('  oi  ');
    expect(state().pending.single.content, 'oi');
    await sending;
    expect(state().pending, isEmpty);
    expect(state().messages.first.id, 'server-oi');
  });

  test('a failed message can be retried', () async {
    repository.sendError = const NetworkFailure();
    await open();
    await controller().send('oi');
    expect(state().pending.single.failed, isTrue);

    repository.sendError = null;
    await controller().retry(state().pending.single);
    expect(state().pending, isEmpty);
    expect(state().messages.first.content, 'oi');
  });

  test('realtime messages are added once and marked as read', () async {
    await open();
    final incoming = msg('3', 'other', 3);
    repository.events!.onMessage(incoming);
    repository.events!.onMessage(incoming);
    expect(state().messages.where((m) => m.id == '3'), hasLength(1));
    await Future<void>.delayed(Duration.zero);
    expect(repository.markedRead, 2);
  });

  test('read receipts from the other person update the status', () async {
    await open();
    final readAt = DateTime.utc(2026, 10, 4, 22);
    repository.events!.onReadReceipt('me', readAt);
    expect(state().otherLastReadAt, isNull);
    repository.events!.onReadReceipt('other', readAt);
    expect(state().otherLastReadAt, readAt);
  });

  test('typing shows up and expires after a few seconds', () {
    fakeAsync((async) {
      unawaited(open());
      async.flushMicrotasks();
      repository.events!.onTyping('other');
      expect(state().otherTyping, isTrue);
      async.elapse(ConversationController.typingTimeout);
      expect(state().otherTyping, isFalse);
    });
  });

  test('typing broadcasts are throttled', () async {
    await open();
    controller()
      ..userTyping()
      ..userTyping()
      ..userTyping();
    await Future<void>.delayed(Duration.zero);
    expect(repository.subscription.typing, ['me']);
  });

  test('pages older messages', () async {
    repository.history = [
      for (var i = 40; i >= 1; i--) msg('$i', i.isEven ? 'me' : 'other', i),
    ];
    await open();
    expect(state().messages, hasLength(30));
    expect(state().hasMore, isTrue);
    await controller().loadMore();
    expect(state().messages, hasLength(40));
    expect(state().hasMore, isFalse);
  });

  test('deleting marks the message as deleted', () async {
    await open();
    await controller().delete(state().messages.last);
    expect(repository.deleted, ['1']);
    expect(state().messages.last.deletedAt, isNotNull);
  });

  test('closing the screen closes the realtime subscription', () async {
    await open();
    container.dispose();
    await Future<void>.delayed(Duration.zero);
    expect(repository.subscription.closed, isTrue);
  });
}
