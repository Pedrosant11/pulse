// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discover_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(discoverRepository)
final discoverRepositoryProvider = DiscoverRepositoryProvider._();

final class DiscoverRepositoryProvider
    extends
        $FunctionalProvider<
          DiscoverRepository,
          DiscoverRepository,
          DiscoverRepository
        >
    with $Provider<DiscoverRepository> {
  DiscoverRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'discoverRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discoverRepositoryHash();

  @$internal
  @override
  $ProviderElement<DiscoverRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DiscoverRepository create(Ref ref) {
    return discoverRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiscoverRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiscoverRepository>(value),
    );
  }
}

String _$discoverRepositoryHash() =>
    r'ef3f864b6e6890551d0ec62661cd0131a4333ac9';
