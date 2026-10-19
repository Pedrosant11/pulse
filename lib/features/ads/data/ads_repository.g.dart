// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ads_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adsRepository)
final adsRepositoryProvider = AdsRepositoryProvider._();

final class AdsRepositoryProvider
    extends $FunctionalProvider<AdsRepository, AdsRepository, AdsRepository>
    with $Provider<AdsRepository> {
  AdsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adsRepositoryHash();

  @$internal
  @override
  $ProviderElement<AdsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AdsRepository create(Ref ref) {
    return adsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdsRepository>(value),
    );
  }
}

String _$adsRepositoryHash() => r'0497294b31b0817eccca40e2afe5cd15080e35b0';
