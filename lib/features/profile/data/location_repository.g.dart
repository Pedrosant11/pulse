// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Bundled IBGE municipality list (MIT, see assets/data/LICENSE-br-cities.txt).

@ProviderFor(cityIndex)
final cityIndexProvider = CityIndexProvider._();

/// Bundled IBGE municipality list (MIT, see assets/data/LICENSE-br-cities.txt).

final class CityIndexProvider
    extends
        $FunctionalProvider<
          AsyncValue<CityIndex>,
          CityIndex,
          FutureOr<CityIndex>
        >
    with $FutureModifier<CityIndex>, $FutureProvider<CityIndex> {
  /// Bundled IBGE municipality list (MIT, see assets/data/LICENSE-br-cities.txt).
  CityIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cityIndexProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cityIndexHash();

  @$internal
  @override
  $FutureProviderElement<CityIndex> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<CityIndex> create(Ref ref) {
    return cityIndex(ref);
  }
}

String _$cityIndexHash() => r'a7d7ab531132fb64923cb8c792893d0c5cb5cbc7';

@ProviderFor(locationRepository)
final locationRepositoryProvider = LocationRepositoryProvider._();

final class LocationRepositoryProvider
    extends
        $FunctionalProvider<
          LocationRepository,
          LocationRepository,
          LocationRepository
        >
    with $Provider<LocationRepository> {
  LocationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationRepositoryHash();

  @$internal
  @override
  $ProviderElement<LocationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocationRepository create(Ref ref) {
    return locationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocationRepository>(value),
    );
  }
}

String _$locationRepositoryHash() =>
    r'701f763eb006e149a46b998407de5207b9fe84a9';
