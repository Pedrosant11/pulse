import 'dart:async';
import 'dart:typed_data';

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
    MessageKind kind = MessageKind.text,
    String? mediaPath,
    int? mediaDurationMs,
  }) async {
    if (sendError case final error?) throw error;
    return ChatMessage(
      id: kind == MessageKind.text ? 'server-$content' : 'server-${kind.name}',
      conversationId: conversationId,
      senderId: senderId,
      content: content,
      createdAt: DateTime.utc(2026, 10, 4, 21),
      kind: kind,
      mediaPath: mediaPath,
      mediaDurationMs: mediaDurationMs,
    );
  }

  final uploads = <String>[];
  final removed = <String>[];
  Exception? uploadError;

  @override
  Future<String> uploadMedia({
    required String conversationId,
    required String senderId,
    required MessageKind kind,
    required Uint8List bytes,
  }) async {
    if (uploadError case final error?) throw error;
    final path =
        '$senderId/$conversationId/${uploads.length}.${kind == MessageKind.image ? 'jpg' : 'm4a'}';
    uploads.add(path);
    return path;
  }

  @override
  Future<void> removeMedia(String path) async => removed.add(path);

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

  test('a photo goes up first, then the message points to it', () async {
    await open();
    final bytes = Uint8List.fromList([1, 2, 3]);
    final sending = controller().sendMedia(
      MessageKind.image,
      bytes,
      caption: ' olha ',
    );
    // Shown right away from the local bytes.
    expect(state().pending.single.bytes, bytes);
    await sending;
    expect(repository.uploads, ['me/c1/0.jpg']);
    final sent = state().messages.first;
    expect(sent.kind, MessageKind.image);
    expect(sent.mediaPath, 'me/c1/0.jpg');
    expect(sent.content, 'olha');
  });

  test('a voice message keeps its length', () async {
    await open();
    await controller().sendMedia(
      MessageKind.audio,
      Uint8List(4),
      durationMs: 4200,
    );
    expect(state().messages.first.mediaDurationMs, 4200);
    expect(repository.uploads.single, endsWith('.m4a'));
  });

  test('a retry after the upload does not upload again', () async {
    repository.sendError = const NetworkFailure();
    await open();
    await controller().sendMedia(MessageKind.image, Uint8List(3));
    expect(state().pending.single.failed, isTrue);
    expect(state().pending.single.mediaPath, isNotNull);

    repository.sendError = null;
    await controller().retry(state().pending.single);
    expect(repository.uploads, hasLength(1));
    expect(state().pending, isEmpty);
  });

  test('deleting a photo removes the file too', () async {
    repository.history = [
      ChatMessage(
        id: 'p',
        conversationId: conversationId,
        senderId: 'me',
        content: '',
        createdAt: DateTime.utc(2026, 10, 4),
        kind: MessageKind.image,
        mediaPath: 'me/c1/x.jpg',
      ),
    ];
    await open();
    await controller().delete(state().messages.single);
    await Future<void>.delayed(Duration.zero);
    expect(repository.removed, ['me/c1/x.jpg']);
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
