// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_search_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(placeSearchRepository)
final placeSearchRepositoryProvider = PlaceSearchRepositoryProvider._();

final class PlaceSearchRepositoryProvider
    extends
        $FunctionalProvider<
          PlaceSearchRepository,
          PlaceSearchRepository,
          PlaceSearchRepository
        >
    with $Provider<PlaceSearchRepository> {
  PlaceSearchRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'placeSearchRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$placeSearchRepositoryHash();

  @$internal
  @override
  $ProviderElement<PlaceSearchRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PlaceSearchRepository create(Ref ref) {
    return placeSearchRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlaceSearchRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlaceSearchRepository>(value),
    );
  }
}

String _$placeSearchRepositoryHash() =>
    r'e4c9be34f5480147cac6c9cbb8ed721e8ea6ba27';
