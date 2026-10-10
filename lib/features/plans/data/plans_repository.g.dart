// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plans_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(plansRepository)
final plansRepositoryProvider = PlansRepositoryProvider._();

final class PlansRepositoryProvider
    extends
        $FunctionalProvider<PlansRepository, PlansRepository, PlansRepository>
    with $Provider<PlansRepository> {
  PlansRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plansRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plansRepositoryHash();

  @$internal
  @override
  $ProviderElement<PlansRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PlansRepository create(Ref ref) {
    return plansRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlansRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlansRepository>(value),
    );
  }
}

String _$plansRepositoryHash() => r'3a0b190ede8c0cb0ffe04c15840903983fa5fbb5';
