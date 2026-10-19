import 'package:freezed_annotation/freezed_annotation.dart';

part 'ad_models.freezed.dart';
part 'ad_models.g.dart';

/// Where ads may appear (matches the `ads.placements` check).
enum AdPlacement { events, discover }

/// An own ad: a party or partner sold directly (ads migration).
@freezed
abstract class HouseAd with _$HouseAd {
  const factory({
    required String id,
    required String title,
    String? body,
    String? imagePath,
    String? cta,

    /// A tap opens this party in the app...
    String? eventId,

    /// ...or this website.
    String? linkUrl,
    @Default(AdPlacement.values) List<AdPlacement> placements,
  }) = _HouseAd;

  factory fromJson(Map<String, dynamic> json) => _$HouseAdFromJson(json);
}

/// What `get_ads()` says for the signed-in person.
@freezed
abstract class AdsConfig with _$AdsConfig {
  const factory({
    @Default(false) bool enabled,
    @Default(6) int eventsEvery,
    @Default(20) int discoverEvery,
    @Default([]) List<HouseAd> ads,
  }) = _AdsConfig;

  const new _();

  factory fromJson(Map<String, dynamic> json) => _$AdsConfigFromJson(json);

  List<HouseAd> adsFor(AdPlacement placement) => [
    for (final ad in ads)
      if (ad.placements.contains(placement)) ad,
  ];

  /// How many items go between two ads.
  int every(AdPlacement placement) => switch (placement) {
    AdPlacement.events => eventsEvery,
    AdPlacement.discover => discoverEvery,
  };
}

/// An ad as the admin manages it, with its numbers.
@freezed
abstract class AdminAd with _$AdminAd {
  const factory({
    required String id,
    required String title,
    required DateTime startsAt,
    String? body,
    String? imagePath,
    String? cta,
    String? eventId,
    String? linkUrl,
    @Default(AdPlacement.values) List<AdPlacement> placements,
    DateTime? endsAt,
    @Default(true) bool active,
    @JsonKey(includeToJson: false) @Default(0) int impressions,
    @JsonKey(includeToJson: false) @Default(0) int clicks,
  }) = _AdminAd;

  const new _();

  factory fromJson(Map<String, dynamic> json) => _$AdminAdFromJson(json);

  bool runningAt(DateTime now) =>
      active &&
      !startsAt.isAfter(now) &&
      (endsAt == null || endsAt!.isAfter(now));
}
