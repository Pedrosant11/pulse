import 'dart:async';
import 'dart:typed_data';

import 'package:pulse/app/constants.dart';
import 'package:pulse/core/utils/random_id.dart';
import 'package:pulse/core/utils/run_action.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/chat/data/chat_repository.dart';
import 'package:pulse/features/chat/domain/chat_models.dart';
import 'package:pulse/features/chat/domain/poll.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_providers.g.dart';

String _requireUserId(Ref ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) throw StateError('No signed-in user');
  return userId;
}

/// Inbox (SPEC 9.1), refreshed live by new messages and matches.
@riverpod
class Conversations extends _$Conversations {
  Timer? _debounce;

  @override
  Future<List<ConversationSummary>> build() async {
    final userId = _requireUserId(ref);
    final repository = ref.watch(chatRepositoryProvider);
    final subscription = repository.subscribeInbox(userId, _scheduleRefresh);
    ref.onDispose(() {
      _debounce?.cancel();
      unawaited(subscription.close());
    });
    return await repository.conversations();
  }

  /// Bursts of events (e.g. a match creates rows in 3 tables) refresh once.
  void _scheduleRefresh() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (!ref.mounted) return;
      final fresh = await AsyncValue.guard(
        ref.read(chatRepositoryProvider).conversations,
      );
      if (ref.mounted && fresh.hasValue) state = fresh;
    });
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      ref.read(chatRepositoryProvider).conversations,
    );
  }
}

@riverpod
Future<ConversationHeader?> conversationHeader(
  Ref ref,
  String conversationId,
) => ref.watch(chatRepositoryProvider).header(conversationId);

/// Signed link to a photo or voice message, cached while the chat is open.
@riverpod
Future<String> chatMediaUrl(Ref ref, String path) =>
    ref.watch(chatRepositoryProvider).mediaUrl(path);

/// Members by id (names in group chat bubbles).
@riverpod
Future<Map<String, ConversationMember>> conversationMembers(
  Ref ref,
  String conversationId,
) async {
  final members = await ref
      .watch(chatRepositoryProvider)
      .members(conversationId);
  return {for (final m in members) m.userId: m};
}

/// One open conversation: messages (paginated), optimistic sending, read
/// receipts and typing (SPEC 9.1).
@riverpod
class ConversationController extends _$ConversationController {
  static const typingTimeout = Duration(seconds: 4);
  static const _typingThrottle = Duration(milliseconds: 2500);

  late ChatRepository _repository;
  late String _userId;
  ChatSubscription? _subscription;
  Timer? _typingTimer;
  DateTime? _lastTypingSent;

  @override
  Future<ConversationState> build(String conversationId) async {
    _repository = ref.watch(chatRepositoryProvider);
    _userId = _requireUserId(ref);

    final subscription = _repository.subscribeConversation(
      conversationId,
      ConversationEvents(
        onMessage: _onRealtimeMessage,
        onReadReceipt: _onReadReceipt,
        onTyping: _onTyping,
      ),
    );
    _subscription = subscription;
    ref.onDispose(() {
      _typingTimer?.cancel();
      unawaited(subscription.close());
    });

    final header = await ref.watch(
      conversationHeaderProvider(conversationId).future,
    );
    final page = await _repository.messages(conversationId);
    unawaited(markRead());
    return ConversationState(
      messages: page,
      hasMore: page.length >= AppConstants.messagesPageSize,
      otherLastReadAt: header?.otherLastReadAt,
    );
  }

  ConversationState? get _current => state.value;

  void _emit(ConversationState next) {
    if (ref.mounted) state = AsyncData(next);
  }

  // --- Realtime -----------------------------------------------------------

  void _onRealtimeMessage(ChatMessage message) {
    final current = _current;
    if (current == null) return;
    final exists = current.messages.any((m) => m.id == message.id);
    final messages = exists
        ? [
            for (final m in current.messages)
              if (m.id == message.id) message else m,
          ]
        : [message, ...current.messages];
    _emit(
      current.copyWith(
        messages: messages,
        otherTyping: message.senderId == _userId && current.otherTyping,
      ),
    );
    if (!exists && message.senderId != _userId) unawaited(markRead());
  }

  void _onReadReceipt(String userId, DateTime lastReadAt) {
    final current = _current;
    if (current == null || userId == _userId) return;
    _emit(current.copyWith(otherLastReadAt: lastReadAt));
  }

  void _onTyping(String userId) {
    final current = _current;
    if (current == null || userId == _userId) return;
    _emit(current.copyWith(otherTyping: true, typingUserId: userId));
    _typingTimer?.cancel();
    _typingTimer = Timer(typingTimeout, () {
      final now = _current;
      if (now != null) {
        _emit(now.copyWith(otherTyping: false, typingUserId: null));
      }
    });
  }

  // --- Actions ------------------------------------------------------------

  /// Called on every keystroke; sends at most one broadcast per 2.5 s.
  void userTyping() {
    final subscription = _subscription;
    final last = _lastTypingSent;
    final now = DateTime.now();
    if (subscription == null ||
        (last != null && now.difference(last) < _typingThrottle)) {
      return;
    }
    _lastTypingSent = now;
    unawaited(subscription.sendTyping(_userId).catchError((_) {}));
  }

  Future<void> markRead() async {
    try {
      await _repository.markRead(conversationId);
      ref.invalidate(conversationsProvider);
    } on Object {
      // Not critical: retried on the next message.
    }
  }

  Future<void> send(String text) async {
    final content = text.trim();
    final current = _current;
    if (content.isEmpty || current == null) return;
    final pending = PendingMessage(
      localId: randomId(),
      content: content,
      createdAt: DateTime.now(),
    );
    _emit(current.copyWith(pending: [pending, ...current.pending]));
    await _deliver(pending);
  }

  /// A photo (with an optional caption) or a voice message.
  Future<void> sendMedia(
    MessageKind kind,
    Uint8List bytes, {
    String caption = '',
    int? durationMs,
  }) async {
    final current = _current;
    if (current == null) return;
    final pending = PendingMessage(
      localId: randomId(),
      content: caption.trim(),
      createdAt: DateTime.now(),
      kind: kind,
      bytes: bytes,
      durationMs: durationMs,
    );
    _emit(current.copyWith(pending: [pending, ...current.pending]));
    await _deliver(pending);
  }

  Future<void> retry(PendingMessage pending) async {
    final current = _current;
    if (current == null) return;
    // The stored copy knows whether the file already went up.
    final stored = current.pending.firstWhere(
      (p) => p.localId == pending.localId,
      orElse: () => pending,
    );
    final again = stored.copyWith(failed: false);
    _replacePending(again);
    await _deliver(again);
  }

  Future<void> _deliver(PendingMessage original) async {
    var pending = original;
    try {
      // Media goes up first (once; a retry reuses the uploaded file).
      if (pending.kind != MessageKind.text && pending.mediaPath == null) {
        final path = await _repository.uploadMedia(
          conversationId: conversationId,
          senderId: _userId,
          kind: pending.kind,
          bytes: pending.bytes!,
        );
        pending = pending.copyWith(mediaPath: path);
        _replacePending(pending);
      }
      final sent = await _repository.send(
        conversationId: conversationId,
        senderId: _userId,
        content: pending.content,
        kind: pending.kind,
        mediaPath: pending.mediaPath,
        mediaDurationMs: pending.durationMs,
      );
      final current = _current;
      if (current == null) return;
      _emit(
        current.copyWith(
          pending: current.pending
              .where((p) => p.localId != pending.localId)
              .toList(),
          // The realtime echo may have arrived first.
          messages: current.messages.any((m) => m.id == sent.id)
              ? current.messages
              : [sent, ...current.messages],
        ),
      );
    } on Object {
      _replacePending(pending.copyWith(failed: true));
    }
  }

  void _replacePending(PendingMessage pending) {
    final current = _current;
    if (current == null) return;
    _emit(
      current.copyWith(
        pending: [
          for (final p in current.pending)
            if (p.localId == pending.localId) pending else p,
        ],
      ),
    );
  }

  Future<void> loadMore() async {
    final current = _current;
    if (current == null || !current.hasMore || current.loadingMore) return;
    _emit(current.copyWith(loadingMore: true));
    try {
      final older = await _repository.messages(
        conversationId,
        before: current.messages.lastOrNull?.createdAt,
      );
      final now = _current!;
      _emit(
        now.copyWith(
          messages: [...now.messages, ...older],
          hasMore: older.length >= AppConstants.messagesPageSize,
          loadingMore: false,
        ),
      );
    } on Object {
      final now = _current;
      if (now != null) _emit(now.copyWith(loadingMore: false));
    }
  }

  Future<void> delete(ChatMessage message) async {
    await _repository.deleteMessage(message.id);
    // The database drops the reference; the file goes too.
    if (message.mediaPath case final path?) {
      unawaited(_repository.removeMedia(path));
    }
    final current = _current;
    if (current == null) return;
    _emit(
      current.copyWith(
        messages: [
          for (final m in current.messages)
            if (m.id == message.id)
              m.copyWith(deletedAt: DateTime.now())
            else
              m,
        ],
      ),
    );
  }
}

/// Unmatch from the conversation menu (SPEC 9.1). Blocking and reporting
/// live in the safety feature.
@riverpod
class ChatSafety extends _$ChatSafety {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool?> unmatch(String matchId) =>
      runAction(ref, (s) => state = s, () async {
        await ref.read(chatRepositoryProvider).unmatch(matchId);
        ref.invalidate(conversationsProvider);
        return true;
      });
}

/// Unread messages across conversations (badge on the Chats tab). Follows
/// the realtime inbox.
@riverpod
int unreadMessageCount(Ref ref) {
  final conversations = ref.watch(conversationsProvider).value ?? const [];
  return conversations.fold(0, (sum, c) => sum + c.unreadCount);
}

@riverpod
Future<Poll> poll(Ref ref, String pollId) =>
    ref.watch(pollsRepositoryProvider).poll(pollId);

@riverpod
Stream<List<PollVote>> pollVotes(Ref ref, String pollId) =>
    ref.watch(pollsRepositoryProvider).votes(pollId);

/// Create polls and vote (null option removes the vote).
@riverpod
class PollEditor extends _$PollEditor {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<String?> create({
    required String conversationId,
    required String question,
    required List<String> options,
    required int hours,
  }) => runAction(
    ref,
    (s) => state = s,
    () => ref
        .read(pollsRepositoryProvider)
        .create(
          conversationId: conversationId,
          question: question.trim(),
          options: [
            for (final o in options)
              if (o.trim().isNotEmpty) o.trim(),
          ],
          hours: hours,
        ),
  );

  Future<bool?> vote(String pollId, int? option) =>
      runAction(ref, (s) => state = s, () async {
        final userId = ref.read(currentUserIdProvider);
        if (userId == null) throw StateError('No signed-in user');
        await ref
            .read(pollsRepositoryProvider)
            .vote(pollId, userId: userId, option: option);
        return true;
      });
}
