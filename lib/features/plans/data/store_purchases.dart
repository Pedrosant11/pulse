import 'package:flutter/services.dart';
import 'package:pulse/features/plans/domain/plan_models.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'store_purchases.g.dart';

/// A product as the store sells it (localized price).
class StoreOffer {
  const new({
    required this.item,
    required this.price,
    required this.raw,
    this.amount = 0,
  });

  final StoreItem item;

  /// e.g. "R$ 24,90".
  final String price;

  /// Numeric price in the store currency (to compare periods).
  final double amount;

  /// The SDK product, used to buy it.
  final Object raw;
}

/// Thrown when the person closes the store sheet; not an error to show.
class PurchaseCancelled implements Exception {
  const new();
}

/// Store side of purchases (Google Play / App Store through RevenueCat).
/// What a person can use comes from the database, never from here: the
/// webhook updates it after each purchase.
abstract interface class StorePurchases {
  bool get isAvailable;

  /// Links purchases to the Supabase user id (the webhook's app_user_id).
  Future<void> logIn(String userId);

  Future<void> logOut();

  Future<List<StoreOffer>> offers();

  Future<void> buy(StoreOffer offer);

  Future<void> restore();
}

/// No RevenueCat key (local dev, tests, before the stores are set up).
class UnavailableStorePurchases implements StorePurchases {
  const new();

  @override
  bool get isAvailable => false;

  @override
  Future<void> logIn(String userId) async {}

  @override
  Future<void> logOut() async {}

  @override
  Future<List<StoreOffer>> offers() async => const [];

  @override
  Future<void> buy(StoreOffer offer) async =>
      throw UnsupportedError('Store unavailable');

  @override
  Future<void> restore() async {}
}

class RevenueCatPurchases implements StorePurchases {
  const new();

  /// Called once from `main.dart`.
  static Future<void> configure(String apiKey) =>
      Purchases.configure(PurchasesConfiguration(apiKey));

  @override
  bool get isAvailable => true;

  @override
  Future<void> logIn(String userId) => Purchases.logIn(userId);

  @override
  Future<void> logOut() async {
    // RevenueCat refuses to log out an anonymous user; nothing to undo then.
    if (!await Purchases.isAnonymous) await Purchases.logOut();
  }

  @override
  Future<List<StoreOffer>> offers() async {
    final subscriptions = await Purchases.getProducts([
      for (final item in StoreItem.values)
        if (item.subscription) item.productId,
    ]);
    final packs = await Purchases.getProducts([
      for (final item in StoreItem.values)
        if (!item.subscription) item.productId,
    ], productCategory: ProductCategory.nonSubscription);
    return [
      for (final product in [...subscriptions, ...packs])
        if (StoreItem.fromStoreId(product.identifier) case final item?)
          StoreOffer(
            item: item,
            price: product.priceString,
            amount: product.price,
            raw: product,
          ),
    ];
  }

  @override
  Future<void> buy(StoreOffer offer) async {
    try {
      await Purchases.purchase(
        PurchaseParams.storeProduct(offer.raw as StoreProduct),
      );
    } on PlatformException catch (error) {
      if (PurchasesErrorHelper.getErrorCode(error) ==
          PurchasesErrorCode.purchaseCancelledError) {
        throw const PurchaseCancelled();
      }
      rethrow;
    }
  }

  @override
  Future<void> restore() => Purchases.restorePurchases();
}

/// Unavailable by default; `main.dart` swaps in RevenueCat when a key is set.
@Riverpod(keepAlive: true)
StorePurchases storePurchases(Ref ref) => const UnavailableStorePurchases();
