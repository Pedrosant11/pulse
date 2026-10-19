// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ads_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Ads for the signed-in person (asked again when the plan changes).

@ProviderFor(adsConfig)
final adsConfigProvider = AdsConfigProvider._();

/// Ads for the signed-in person (asked again when the plan changes).

final class AdsConfigProvider
    extends
        $FunctionalProvider<
          AsyncValue<AdsConfig>,
          AdsConfig,
          FutureOr<AdsConfig>
        >
    with $FutureModifier<AdsConfig>, $FutureProvider<AdsConfig> {
  /// Ads for the signed-in person (asked again when the plan changes).
  AdsConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adsConfigProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adsConfigHash();

  @$internal
  @override
  $FutureProviderElement<AdsConfig> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AdsConfig> create(Ref ref) {
    return adsConfig(ref);
  }
}

String _$adsConfigHash() => r'c60657a8f812cef41b75d757a4bed33a692e85f3';

/// Whether slots of [placement] can be filled right now.

@ProviderFor(adsReady)
final adsReadyProvider = AdsReadyFamily._();

/// Whether slots of [placement] can be filled right now.

final class AdsReadyProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether slots of [placement] can be filled right now.
  AdsReadyProvider._({
    required AdsReadyFamily super.from,
    required AdPlacement super.argument,
  }) : super(
         retry: null,
         name: r'adsReadyProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$adsReadyHash();

  @override
  String toString() {
    return r'adsReadyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as AdPlacement;
    return adsReady(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AdsReadyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$adsReadyHash() => r'6d7e40b8b38d1a701068c2f9e3c8c3fab9132a2c';

/// Whether slots of [placement] can be filled right now.

final class AdsReadyFamily extends $Family
    with $FunctionalFamilyOverride<bool, AdPlacement> {
  AdsReadyFamily._()
    : super(
        retry: null,
        name: r'adsReadyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Whether slots of [placement] can be filled right now.

  AdsReadyProvider call(AdPlacement placement) =>
      AdsReadyProvider._(argument: placement, from: this);

  @override
  String toString() => r'adsReadyProvider';
}

@ProviderFor(adminAds)
final adminAdsProvider = AdminAdsProvider._();

final class AdminAdsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AdminAd>>,
          List<AdminAd>,
          FutureOr<List<AdminAd>>
        >
    with $FutureModifier<List<AdminAd>>, $FutureProvider<List<AdminAd>> {
  AdminAdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminAdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminAdsHash();

  @$internal
  @override
  $FutureProviderElement<List<AdminAd>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AdminAd>> create(Ref ref) {
    return adminAds(ref);
  }
}

String _$adminAdsHash() => r'93e70dd9eda901a580fce67e15584bbe580e609b';

@ProviderFor(AdEditor)
final adEditorProvider = AdEditorProvider._();

final class AdEditorProvider
    extends $NotifierProvider<AdEditor, AsyncValue<void>> {
  AdEditorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adEditorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adEditorHash();

  @$internal
  @override
  AdEditor create() => AdEditor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$adEditorHash() => r'd02be6c72542ab843696cb7e4aa6873279b2e0b2';

abstract class _$AdEditor extends $Notifier<AsyncValue<void>> {
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
