// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Inbox (SPEC 9.1), refreshed live by new messages and matches.

@ProviderFor(Conversations)
final conversationsProvider = ConversationsProvider._();

/// Inbox (SPEC 9.1), refreshed live by new messages and matches.
final class ConversationsProvider
    extends $AsyncNotifierProvider<Conversations, List<ConversationSummary>> {
  /// Inbox (SPEC 9.1), refreshed live by new messages and matches.
  ConversationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conversationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conversationsHash();

  @$internal
  @override
  Conversations create() => Conversations();
}

String _$conversationsHash() => r'e07ea0f38b10d3dca9f7930007d760a6368d223a';

/// Inbox (SPEC 9.1), refreshed live by new messages and matches.

abstract class _$Conversations
    extends $AsyncNotifier<List<ConversationSummary>> {
  FutureOr<List<ConversationSummary>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<ConversationSummary>>,
              List<ConversationSummary>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ConversationSummary>>,
                List<ConversationSummary>
              >,
              AsyncValue<List<ConversationSummary>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(conversationHeader)
final conversationHeaderProvider = ConversationHeaderFamily._();

final class ConversationHeaderProvider
    extends
        $FunctionalProvider<
          AsyncValue<ConversationHeader?>,
          ConversationHeader?,
          FutureOr<ConversationHeader?>
        >
    with
        $FutureModifier<ConversationHeader?>,
        $FutureProvider<ConversationHeader?> {
  ConversationHeaderProvider._({
    required ConversationHeaderFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'conversationHeaderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$conversationHeaderHash();

  @override
  String toString() {
    return r'conversationHeaderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ConversationHeader?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ConversationHeader?> create(Ref ref) {
    final argument = this.argument as String;
    return conversationHeader(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ConversationHeaderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$conversationHeaderHash() =>
    r'f28532a612f9dcfb603887304f70601f4a7bfd8f';

final class ConversationHeaderFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ConversationHeader?>, String> {
  ConversationHeaderFamily._()
    : super(
        retry: null,
        name: r'conversationHeaderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ConversationHeaderProvider call(String conversationId) =>
      ConversationHeaderProvider._(argument: conversationId, from: this);

  @override
  String toString() => r'conversationHeaderProvider';
}

/// Signed link to a photo or voice message, cached while the chat is open.

@ProviderFor(chatMediaUrl)
final chatMediaUrlProvider = ChatMediaUrlFamily._();

/// Signed link to a photo or voice message, cached while the chat is open.

final class ChatMediaUrlProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// Signed link to a photo or voice message, cached while the chat is open.
  ChatMediaUrlProvider._({
    required ChatMediaUrlFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatMediaUrlProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatMediaUrlHash();

  @override
  String toString() {
    return r'chatMediaUrlProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument = this.argument as String;
    return chatMediaUrl(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatMediaUrlProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatMediaUrlHash() => r'79228fcfc05e380d5ad4de7a77997524fbedf04c';

/// Signed link to a photo or voice message, cached while the chat is open.

final class ChatMediaUrlFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String>, String> {
  ChatMediaUrlFamily._()
    : super(
        retry: null,
        name: r'chatMediaUrlProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Signed link to a photo or voice message, cached while the chat is open.

  ChatMediaUrlProvider call(String path) =>
      ChatMediaUrlProvider._(argument: path, from: this);

  @override
  String toString() => r'chatMediaUrlProvider';
}

/// Members by id (names in group chat bubbles).

@ProviderFor(conversationMembers)
final conversationMembersProvider = ConversationMembersFamily._();

/// Members by id (names in group chat bubbles).

final class ConversationMembersProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, ConversationMember>>,
          Map<String, ConversationMember>,
          FutureOr<Map<String, ConversationMember>>
        >
    with
        $FutureModifier<Map<String, ConversationMember>>,
        $FutureProvider<Map<String, ConversationMember>> {
  /// Members by id (names in group chat bubbles).
  ConversationMembersProvider._({
    required ConversationMembersFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'conversationMembersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$conversationMembersHash();

  @override
  String toString() {
    return r'conversationMembersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, ConversationMember>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, ConversationMember>> create(Ref ref) {
    final argument = this.argument as String;
    return conversationMembers(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ConversationMembersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$conversationMembersHash() =>
    r'0a44e17d264116a21b6074a72924558c3d9c65ca';

/// Members by id (names in group chat bubbles).

final class ConversationMembersFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<String, ConversationMember>>,
          String
        > {
  ConversationMembersFamily._()
    : super(
        retry: null,
        name: r'conversationMembersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Members by id (names in group chat bubbles).

  ConversationMembersProvider call(String conversationId) =>
      ConversationMembersProvider._(argument: conversationId, from: this);

  @override
  String toString() => r'conversationMembersProvider';
}

/// One open conversation: messages (paginated), optimistic sending, read
/// receipts and typing (SPEC 9.1).

@ProviderFor(ConversationController)
final conversationControllerProvider = ConversationControllerFamily._();

/// One open conversation: messages (paginated), optimistic sending, read
/// receipts and typing (SPEC 9.1).
final class ConversationControllerProvider
    extends $AsyncNotifierProvider<ConversationController, ConversationState> {
  /// One open conversation: messages (paginated), optimistic sending, read
  /// receipts and typing (SPEC 9.1).
  ConversationControllerProvider._({
    required ConversationControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'conversationControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$conversationControllerHash();

  @override
  String toString() {
    return r'conversationControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ConversationController create() => ConversationController();

  @override
  bool operator ==(Object other) {
    return other is ConversationControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$conversationControllerHash() =>
    r'ff1dbf6aa5f90687943d6454d6395cdcab88789f';

/// One open conversation: messages (paginated), optimistic sending, read
/// receipts and typing (SPEC 9.1).

final class ConversationControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ConversationController,
          AsyncValue<ConversationState>,
          ConversationState,
          FutureOr<ConversationState>,
          String
        > {
  ConversationControllerFamily._()
    : super(
        retry: null,
        name: r'conversationControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One open conversation: messages (paginated), optimistic sending, read
  /// receipts and typing (SPEC 9.1).

  ConversationControllerProvider call(String conversationId) =>
      ConversationControllerProvider._(argument: conversationId, from: this);

  @override
  String toString() => r'conversationControllerProvider';
}

/// One open conversation: messages (paginated), optimistic sending, read
/// receipts and typing (SPEC 9.1).

abstract class _$ConversationController
    extends $AsyncNotifier<ConversationState> {
  late final _$args = ref.$arg as String;
  String get conversationId => _$args;

  FutureOr<ConversationState> build(String conversationId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ConversationState>, ConversationState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ConversationState>, ConversationState>,
              AsyncValue<ConversationState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// Unmatch from the conversation menu (SPEC 9.1). Blocking and reporting
/// live in the safety feature.

@ProviderFor(ChatSafety)
final chatSafetyProvider = ChatSafetyProvider._();

/// Unmatch from the conversation menu (SPEC 9.1). Blocking and reporting
/// live in the safety feature.
final class ChatSafetyProvider
    extends $NotifierProvider<ChatSafety, AsyncValue<void>> {
  /// Unmatch from the conversation menu (SPEC 9.1). Blocking and reporting
  /// live in the safety feature.
  ChatSafetyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatSafetyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatSafetyHash();

  @$internal
  @override
  ChatSafety create() => ChatSafety();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$chatSafetyHash() => r'6f85b528341568faa8ec699970a3b17fab88f763';

/// Unmatch from the conversation menu (SPEC 9.1). Blocking and reporting
/// live in the safety feature.

abstract class _$ChatSafety extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Unread messages across conversations (badge on the Chats tab). Follows
/// the realtime inbox.

@ProviderFor(unreadMessageCount)
final unreadMessageCountProvider = UnreadMessageCountProvider._();

/// Unread messages across conversations (badge on the Chats tab). Follows
/// the realtime inbox.

final class UnreadMessageCountProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// Unread messages across conversations (badge on the Chats tab). Follows
  /// the realtime inbox.
  UnreadMessageCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unreadMessageCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unreadMessageCountHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return unreadMessageCount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$unreadMessageCountHash() =>
    r'884f045d150b8d8a328bc95d9adb047dc2ef4a7b';

@ProviderFor(poll)
final pollProvider = PollFamily._();

final class PollProvider
    extends $FunctionalProvider<AsyncValue<Poll>, Poll, FutureOr<Poll>>
    with $FutureModifier<Poll>, $FutureProvider<Poll> {
  PollProvider._({
    required PollFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'pollProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pollHash();

  @override
  String toString() {
    return r'pollProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Poll> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Poll> create(Ref ref) {
    final argument = this.argument as String;
    return poll(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PollProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pollHash() => r'f58550602235d379d4f174019319c39b0c54d186';

final class PollFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Poll>, String> {
  PollFamily._()
    : super(
        retry: null,
        name: r'pollProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PollProvider call(String pollId) =>
      PollProvider._(argument: pollId, from: this);

  @override
  String toString() => r'pollProvider';
}

@ProviderFor(pollVotes)
final pollVotesProvider = PollVotesFamily._();

final class PollVotesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PollVote>>,
          List<PollVote>,
          Stream<List<PollVote>>
        >
    with $FutureModifier<List<PollVote>>, $StreamProvider<List<PollVote>> {
  PollVotesProvider._({
    required PollVotesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'pollVotesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pollVotesHash();

  @override
  String toString() {
    return r'pollVotesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<PollVote>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<PollVote>> create(Ref ref) {
    final argument = this.argument as String;
    return pollVotes(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PollVotesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pollVotesHash() => r'd5ecc9a43088f77fa59063d2cf0db4eb63960336';

final class PollVotesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<PollVote>>, String> {
  PollVotesFamily._()
    : super(
        retry: null,
        name: r'pollVotesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PollVotesProvider call(String pollId) =>
      PollVotesProvider._(argument: pollId, from: this);

  @override
  String toString() => r'pollVotesProvider';
}

/// Create polls and vote (null option removes the vote).

@ProviderFor(PollEditor)
final pollEditorProvider = PollEditorProvider._();

/// Create polls and vote (null option removes the vote).
final class PollEditorProvider
    extends $NotifierProvider<PollEditor, AsyncValue<void>> {
  /// Create polls and vote (null option removes the vote).
  PollEditorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pollEditorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pollEditorHash();

  @$internal
  @override
  PollEditor create() => PollEditor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$pollEditorHash() => r'e846110212863bcc868ddd1c9da8a5df72aa17f5';

/// Create polls and vote (null option removes the vote).

abstract class _$PollEditor extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
