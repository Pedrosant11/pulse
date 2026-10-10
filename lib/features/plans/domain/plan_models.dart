import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pulse/core/models/app_mode.dart';

part 'plan_models.freezed.dart';
part 'plan_models.g.dart';

/// Benefit that sent the person to the plans screen (shown on top).
enum PlanFeature {
  likes,
  rewind,
  superlikes,
  travel,
  likedYou,
  boost,
  incognito,
}

/// Matches the database enum `plan_tier`.
enum PlanTier { plus, black }

/// What the store sells. Ids must match Play Console / App Store Connect,
/// RevenueCat and `private.store_products` (packs).
enum StoreItem {
  plusMonthly('pulse_plus_monthly', subscription: true),
  blackMonthly('pulse_black_monthly', subscription: true),
  superlikes5('pulse_superlikes_5'),
  superlikes15('pulse_superlikes_15'),
  boost1('pulse_boost_1'),
  boosts5('pulse_boosts_5');

  new(this.productId, {this.subscription = false});

  final String productId;
  final bool subscription;

  /// Google subscriptions come back as "productId:basePlan".
  static StoreItem? fromStoreId(String id) {
    final base = id.split(':').first;
    for (final item in values) {
      if (item.productId == base) return item;
    }
    return null;
  }
}

/// Plan, limits left and wallet (`get_my_entitlements()`).
@freezed
abstract class Entitlements with _$Entitlements {
  const factory({
    PlanTier? tier,
    String? source,
    DateTime? expiresAt,
    @Default(false) bool willRenew,

    /// null = unlimited.
    int? likesLeftToday,
    @Default(0) int freeSuperlikesLeft,
    @Default(0) int superlikeBalance,
    @Default(0) int freeBoostsLeft,
    @Default(0) int boostBalance,
    DateTime? boostEndsAt,
    String? travelCity,
    String? travelState,
    @Default(false) bool incognito,
  }) = _Entitlements;

  const new _();

  factory fromJson(Map<String, dynamic> json) => _$EntitlementsFromJson(json);

  bool get hasPlan => tier != null;
  bool get isBlack => tier == PlanTier.black;
  bool get canRewind => hasPlan;
  int get superlikesLeft => freeSuperlikesLeft + superlikeBalance;
  int get boostsLeft => freeBoostsLeft + boostBalance;

  /// Travel mode only works with a plan (the city is kept without one).
  bool get isTraveling => hasPlan && travelCity != null;

  bool boostRunning(DateTime now) =>
      boostEndsAt != null && boostEndsAt!.isAfter(now);
}

/// Someone who liked the user and is waiting for an answer (Black).
@freezed
abstract class LikedYou with _$LikedYou {
  const factory({
    required String userId,
    required String firstName,
    required int age,
    required AppMode mode,
    required DateTime likedAt,
    String? city,
    String? photoPath,
    @Default(false) bool isSuper,
  }) = _LikedYou;

  factory fromJson(Map<String, dynamic> json) => _$LikedYouFromJson(json);
}

/// Admin view of someone's plan and wallet.
@freezed
abstract class AdminPlan with _$AdminPlan {
  const factory({
    PlanTier? tier,
    String? source,
    DateTime? expiresAt,
    @Default(0) int superlikeBalance,
    @Default(0) int boostBalance,
  }) = _AdminPlan;

  factory fromJson(Map<String, dynamic> json) => _$AdminPlanFromJson(json);
}
