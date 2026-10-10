// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(privacyRepository)
final privacyRepositoryProvider = PrivacyRepositoryProvider._();

final class PrivacyRepositoryProvider
    extends
        $FunctionalProvider<
          PrivacyRepository,
          PrivacyRepository,
          PrivacyRepository
        >
    with $Provider<PrivacyRepository> {
  PrivacyRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'privacyRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$privacyRepositoryHash();

  @$internal
  @override
  $ProviderElement<PrivacyRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PrivacyRepository create(Ref ref) {
    return privacyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrivacyRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrivacyRepository>(value),
    );
  }
}

String _$privacyRepositoryHash() => r'53c0d93c0bdf01d1e11450424cd6c15e466f7eb4';
