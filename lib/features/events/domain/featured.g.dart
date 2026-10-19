// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'featured.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeaturedPrice _$FeaturedPriceFromJson(Map<String, dynamic> json) =>
    _FeaturedPrice(
      days: (json['days'] as num).toInt(),
      priceCents: (json['price_cents'] as num).toInt(),
      storeProductId: json['store_product_id'] as String,
    );

Map<String, dynamic> _$FeaturedPriceToJson(_FeaturedPrice instance) =>
    <String, dynamic>{
      'days': instance.days,
      'price_cents': instance.priceCents,
      'store_product_id': instance.storeProductId,
    };

_FeaturedRequest _$FeaturedRequestFromJson(Map<String, dynamic> json) =>
    _FeaturedRequest(
      id: json['id'] as String,
      eventId: json['event_id'] as String,
      days: (json['days'] as num).toInt(),
      priceCents: (json['price_cents'] as num).toInt(),
      method: $enumDecode(_$FeaturedMethodEnumMap, json['method']),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$FeaturedRequestToJson(_FeaturedRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'event_id': instance.eventId,
      'days': instance.days,
      'price_cents': instance.priceCents,
      'method': _$FeaturedMethodEnumMap[instance.method]!,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$FeaturedMethodEnumMap = {
  FeaturedMethod.store: 'store',
  FeaturedMethod.team: 'team',
};

_AdminFeaturedRequest _$AdminFeaturedRequestFromJson(
  Map<String, dynamic> json,
) => _AdminFeaturedRequest(
  id: json['id'] as String,
  eventId: json['event_id'] as String,
  eventName: json['event_name'] as String,
  eventStartsAt: DateTime.parse(json['event_starts_at'] as String),
  city: json['city'] as String,
  days: (json['days'] as num).toInt(),
  priceCents: (json['price_cents'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  requesterName: json['requester_name'] as String?,
);

Map<String, dynamic> _$AdminFeaturedRequestToJson(
  _AdminFeaturedRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'event_id': instance.eventId,
  'event_name': instance.eventName,
  'event_starts_at': instance.eventStartsAt.toIso8601String(),
  'city': instance.city,
  'days': instance.days,
  'price_cents': instance.priceCents,
  'created_at': instance.createdAt.toIso8601String(),
  'requester_name': instance.requesterName,
};
