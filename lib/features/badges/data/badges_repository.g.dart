// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badges_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(badgesRepository)
final badgesRepositoryProvider = BadgesRepositoryProvider._();

final class BadgesRepositoryProvider
    extends
        $FunctionalProvider<
          BadgesRepository,
          BadgesRepository,
          BadgesRepository
        >
    with $Provider<BadgesRepository> {
  BadgesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'badgesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$badgesRepositoryHash();

  @$internal
  @override
  $ProviderElement<BadgesRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BadgesRepository create(Ref ref) {
    return badgesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BadgesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BadgesRepository>(value),
    );
  }
}

String _$badgesRepositoryHash() => r'187eae0dad51b8e36941eca64fcf4f240fa12ef8';
