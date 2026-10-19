// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HouseAd _$HouseAdFromJson(Map<String, dynamic> json) => _HouseAd(
  id: json['id'] as String,
  title: json['title'] as String,
  body: json['body'] as String?,
  imagePath: json['image_path'] as String?,
  cta: json['cta'] as String?,
  eventId: json['event_id'] as String?,
  linkUrl: json['link_url'] as String?,
  placements:
      (json['placements'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$AdPlacementEnumMap, e))
          .toList() ??
      AdPlacement.values,
);

Map<String, dynamic> _$HouseAdToJson(_HouseAd instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'body': instance.body,
  'image_path': instance.imagePath,
  'cta': instance.cta,
  'event_id': instance.eventId,
  'link_url': instance.linkUrl,
  'placements': instance.placements
      .map((e) => _$AdPlacementEnumMap[e]!)
      .toList(),
};

const _$AdPlacementEnumMap = {
  AdPlacement.events: 'events',
  AdPlacement.discover: 'discover',
};

_AdsConfig _$AdsConfigFromJson(Map<String, dynamic> json) => _AdsConfig(
  enabled: json['enabled'] as bool? ?? false,
  eventsEvery: (json['events_every'] as num?)?.toInt() ?? 6,
  discoverEvery: (json['discover_every'] as num?)?.toInt() ?? 20,
  ads:
      (json['ads'] as List<dynamic>?)
          ?.map((e) => HouseAd.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$AdsConfigToJson(_AdsConfig instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'events_every': instance.eventsEvery,
      'discover_every': instance.discoverEvery,
      'ads': instance.ads.map((e) => e.toJson()).toList(),
    };

_AdminAd _$AdminAdFromJson(Map<String, dynamic> json) => _AdminAd(
  id: json['id'] as String,
  title: json['title'] as String,
  startsAt: DateTime.parse(json['starts_at'] as String),
  body: json['body'] as String?,
  imagePath: json['image_path'] as String?,
  cta: json['cta'] as String?,
  eventId: json['event_id'] as String?,
  linkUrl: json['link_url'] as String?,
  placements:
      (json['placements'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$AdPlacementEnumMap, e))
          .toList() ??
      AdPlacement.values,
  endsAt: json['ends_at'] == null
      ? null
      : DateTime.parse(json['ends_at'] as String),
  active: json['active'] as bool? ?? true,
  impressions: (json['impressions'] as num?)?.toInt() ?? 0,
  clicks: (json['clicks'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AdminAdToJson(_AdminAd instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'starts_at': instance.startsAt.toIso8601String(),
  'body': instance.body,
  'image_path': instance.imagePath,
  'cta': instance.cta,
  'event_id': instance.eventId,
  'link_url': instance.linkUrl,
  'placements': instance.placements
      .map((e) => _$AdPlacementEnumMap[e]!)
      .toList(),
  'ends_at': instance.endsAt?.toIso8601String(),
  'active': instance.active,
};
