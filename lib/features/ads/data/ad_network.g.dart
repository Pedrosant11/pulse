// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_network.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Unavailable by default; `main.dart` swaps in AdMob when a unit id is set.

@ProviderFor(adNetwork)
final adNetworkProvider = AdNetworkProvider._();

/// Unavailable by default; `main.dart` swaps in AdMob when a unit id is set.

final class AdNetworkProvider
    extends $FunctionalProvider<AdNetwork, AdNetwork, AdNetwork>
    with $Provider<AdNetwork> {
  /// Unavailable by default; `main.dart` swaps in AdMob when a unit id is set.
  AdNetworkProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adNetworkProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adNetworkHash();

  @$internal
  @override
  $ProviderElement<AdNetwork> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AdNetwork create(Ref ref) {
    return adNetwork(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdNetwork value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdNetwork>(value),
    );
  }
}

String _$adNetworkHash() => r'6a4124258de7eb167ada220a408368f2e06971e3';
