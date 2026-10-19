import 'package:freezed_annotation/freezed_annotation.dart';

part 'featured.freezed.dart';
part 'featured.g.dart';

/// A highlight length on sale (`featured_prices`). Longer is cheaper per day.
@freezed
abstract class FeaturedPrice with _$FeaturedPrice {
  const factory({
    required int days,
    required int priceCents,
    required String storeProductId,
  }) = _FeaturedPrice;

  const new _();

  factory fromJson(Map<String, dynamic> json) => _$FeaturedPriceFromJson(json);

  double get price => priceCents / 100;
  double get perDay => price / days;
}

/// How a producer pays a highlight.
@JsonEnum()
enum FeaturedMethod {
  /// In the app, through Google Play / App Store.
  store,

  /// Settled with the Pulse team (packages, several parties).
  team,
}

/// The producer's open request for one party.
@freezed
abstract class FeaturedRequest with _$FeaturedRequest {
  const factory({
    required String id,
    required String eventId,
    required int days,
    required int priceCents,
    required FeaturedMethod method,
    required DateTime createdAt,
  }) = _FeaturedRequest;

  factory fromJson(Map<String, dynamic> json) =>
      _$FeaturedRequestFromJson(json);
}

/// An open team request in the admin queue.
@freezed
abstract class AdminFeaturedRequest with _$AdminFeaturedRequest {
  const factory({
    required String id,
    required String eventId,
    required String eventName,
    required DateTime eventStartsAt,
    required String city,
    required int days,
    required int priceCents,
    required DateTime createdAt,
    String? requesterName,
  }) = _AdminFeaturedRequest;

  factory fromJson(Map<String, dynamic> json) =>
      _$AdminFeaturedRequestFromJson(json);
}
