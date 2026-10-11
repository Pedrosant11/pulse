// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Entitlements _$EntitlementsFromJson(Map<String, dynamic> json) =>
    _Entitlements(
      tier: $enumDecodeNullable(_$PlanTierEnumMap, json['tier']),
      source: json['source'] as String?,
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      willRenew: json['will_renew'] as bool? ?? false,
      likesLeftToday: (json['likes_left_today'] as num?)?.toInt(),
      freeSuperlikesLeft: (json['free_superlikes_left'] as num?)?.toInt() ?? 0,
      superlikeBalance: (json['superlike_balance'] as num?)?.toInt() ?? 0,
      freeBoostsLeft: (json['free_boosts_left'] as num?)?.toInt() ?? 0,
      boostBalance: (json['boost_balance'] as num?)?.toInt() ?? 0,
      boostEndsAt: json['boost_ends_at'] == null
          ? null
          : DateTime.parse(json['boost_ends_at'] as String),
      travelCity: json['travel_city'] as String?,
      travelState: json['travel_state'] as String?,
      incognito: json['incognito'] as bool? ?? false,
    );

Map<String, dynamic> _$EntitlementsToJson(_Entitlements instance) =>
    <String, dynamic>{
      'tier': _$PlanTierEnumMap[instance.tier],
      'source': instance.source,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'will_renew': instance.willRenew,
      'likes_left_today': instance.likesLeftToday,
      'free_superlikes_left': instance.freeSuperlikesLeft,
      'superlike_balance': instance.superlikeBalance,
      'free_boosts_left': instance.freeBoostsLeft,
      'boost_balance': instance.boostBalance,
      'boost_ends_at': instance.boostEndsAt?.toIso8601String(),
      'travel_city': instance.travelCity,
      'travel_state': instance.travelState,
      'incognito': instance.incognito,
    };

const _$PlanTierEnumMap = {PlanTier.plus: 'plus', PlanTier.black: 'black'};

_LikedYou _$LikedYouFromJson(Map<String, dynamic> json) => _LikedYou(
  userId: json['user_id'] as String,
  firstName: json['first_name'] as String,
  age: (json['age'] as num).toInt(),
  mode: $enumDecode(_$AppModeEnumMap, json['mode']),
  likedAt: DateTime.parse(json['liked_at'] as String),
  city: json['city'] as String?,
  photoPath: json['photo_path'] as String?,
  isSuper: json['is_super'] as bool? ?? false,
);

Map<String, dynamic> _$LikedYouToJson(_LikedYou instance) => <String, dynamic>{
  'user_id': instance.userId,
  'first_name': instance.firstName,
  'age': instance.age,
  'mode': _$AppModeEnumMap[instance.mode]!,
  'liked_at': instance.likedAt.toIso8601String(),
  'city': instance.city,
  'photo_path': instance.photoPath,
  'is_super': instance.isSuper,
};

const _$AppModeEnumMap = {AppMode.date: 'date', AppMode.crew: 'crew'};

_AdminPlan _$AdminPlanFromJson(Map<String, dynamic> json) => _AdminPlan(
  tier: $enumDecodeNullable(_$PlanTierEnumMap, json['tier']),
  source: json['source'] as String?,
  expiresAt: json['expires_at'] == null
      ? null
      : DateTime.parse(json['expires_at'] as String),
  superlikeBalance: (json['superlike_balance'] as num?)?.toInt() ?? 0,
  boostBalance: (json['boost_balance'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AdminPlanToJson(_AdminPlan instance) =>
    <String, dynamic>{
      'tier': _$PlanTierEnumMap[instance.tier],
      'source': instance.source,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'superlike_balance': instance.superlikeBalance,
      'boost_balance': instance.boostBalance,
    };

_SameNightPerson _$SameNightPersonFromJson(Map<String, dynamic> json) =>
    _SameNightPerson(
      userId: json['user_id'] as String,
      firstName: json['first_name'] as String,
      age: (json['age'] as num).toInt(),
      eventName: json['event_name'] as String,
      photoPath: json['photo_path'] as String?,
    );

Map<String, dynamic> _$SameNightPersonToJson(_SameNightPerson instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'first_name': instance.firstName,
      'age': instance.age,
      'event_name': instance.eventName,
      'photo_path': instance.photoPath,
    };
