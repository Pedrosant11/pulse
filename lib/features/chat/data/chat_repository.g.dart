// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pollsRepository)
final pollsRepositoryProvider = PollsRepositoryProvider._();

final class PollsRepositoryProvider
    extends
        $FunctionalProvider<PollsRepository, PollsRepository, PollsRepository>
    with $Provider<PollsRepository> {
  PollsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pollsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pollsRepositoryHash();

  @$internal
  @override
  $ProviderElement<PollsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PollsRepository create(Ref ref) {
    return pollsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PollsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PollsRepository>(value),
    );
  }
}

String _$pollsRepositoryHash() => r'0d40134fc1205aef4e8d0c9847c1fa0fd6a47d11';

@ProviderFor(chatRepository)
final chatRepositoryProvider = ChatRepositoryProvider._();

final class ChatRepositoryProvider
    extends $FunctionalProvider<ChatRepository, ChatRepository, ChatRepository>
    with $Provider<ChatRepository> {
  ChatRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatRepository create(Ref ref) {
    return chatRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatRepository>(value),
    );
  }
}

String _$chatRepositoryHash() => r'065908b1363f12683733b88a74c59e856e4fdb0b';
