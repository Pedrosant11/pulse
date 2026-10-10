// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_purchases.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Unavailable by default; `main.dart` swaps in RevenueCat when a key is set.

@ProviderFor(storePurchases)
final storePurchasesProvider = StorePurchasesProvider._();

/// Unavailable by default; `main.dart` swaps in RevenueCat when a key is set.

final class StorePurchasesProvider
    extends $FunctionalProvider<StorePurchases, StorePurchases, StorePurchases>
    with $Provider<StorePurchases> {
  /// Unavailable by default; `main.dart` swaps in RevenueCat when a key is set.
  StorePurchasesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storePurchasesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storePurchasesHash();

  @$internal
  @override
  $ProviderElement<StorePurchases> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StorePurchases create(Ref ref) {
    return storePurchases(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StorePurchases value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StorePurchases>(value),
    );
  }
}

String _$storePurchasesHash() => r'2fa1af2603053c785c4b73372962b04f30586ca0';
