// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venues_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(venuesRepository)
final venuesRepositoryProvider = VenuesRepositoryProvider._();

final class VenuesRepositoryProvider
    extends
        $FunctionalProvider<
          VenuesRepository,
          VenuesRepository,
          VenuesRepository
        >
    with $Provider<VenuesRepository> {
  VenuesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'venuesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$venuesRepositoryHash();

  @$internal
  @override
  $ProviderElement<VenuesRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VenuesRepository create(Ref ref) {
    return venuesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VenuesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VenuesRepository>(value),
    );
  }
}

String _$venuesRepositoryHash() => r'e4d394f84b9de4cd5f5fdfab971cbdc3637cfb28';
