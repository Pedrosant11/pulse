// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discover_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommonEvent _$CommonEventFromJson(Map<String, dynamic> json) => _CommonEvent(
  id: json['id'] as String,
  name: json['name'] as String,
  startsAt: DateTime.parse(json['starts_at'] as String),
);

Map<String, dynamic> _$CommonEventToJson(_CommonEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'starts_at': instance.startsAt.toIso8601String(),
    };

_DiscoverCandidate _$DiscoverCandidateFromJson(Map<String, dynamic> json) =>
    _DiscoverCandidate(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      age: (json['age'] as num).toInt(),
      city: json['city'] as String?,
      state: json['state'] as String?,
      occupation: json['occupation'] as String?,
      bio: json['bio'] as String?,
      gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
      isVerified: json['is_verified'] as bool? ?? false,
      musicGenres:
          (json['music_genres'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$MusicGenreEnumMap, e))
              .toList() ??
          const [],
      photoPaths:
          (json['photo_paths'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      commonEvents:
          (json['common_events'] as List<dynamic>?)
              ?.map((e) => CommonEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      commonEventCount: (json['common_event_count'] as num?)?.toInt() ?? 0,
      isFallback: json['is_fallback'] as bool? ?? false,
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      favoriteDjs:
          (json['favorite_djs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      dateLookingFor: $enumDecodeNullable(
        _$DateIntentEnumMap,
        json['date_looking_for'],
      ),
      crewSize: (json['crew_size'] as num?)?.toInt(),
      superLikedMe: json['super_liked_me'] as bool? ?? false,
    );

Map<String, dynamic> _$DiscoverCandidateToJson(_DiscoverCandidate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'age': instance.age,
      'city': instance.city,
      'state': instance.state,
      'occupation': instance.occupation,
      'bio': instance.bio,
      'gender': _$GenderEnumMap[instance.gender],
      'is_verified': instance.isVerified,
      'music_genres': instance.musicGenres
          .map((e) => _$MusicGenreEnumMap[e]!)
          .toList(),
      'photo_paths': instance.photoPaths,
      'common_events': instance.commonEvents.map((e) => e.toJson()).toList(),
      'common_event_count': instance.commonEventCount,
      'is_fallback': instance.isFallback,
      'distance_km': instance.distanceKm,
      'favorite_djs': instance.favoriteDjs,
      'date_looking_for': _$DateIntentEnumMap[instance.dateLookingFor],
      'crew_size': instance.crewSize,
      'super_liked_me': instance.superLikedMe,
    };

const _$GenderEnumMap = {
  Gender.woman: 'woman',
  Gender.man: 'man',
  Gender.nonBinary: 'non_binary',
  Gender.other: 'other',
  Gender.preferNotSay: 'prefer_not_say',
};

const _$MusicGenreEnumMap = {
  MusicGenre.techno: 'techno',
  MusicGenre.house: 'house',
  MusicGenre.techHouse: 'tech_house',
  MusicGenre.melodicTechno: 'melodic_techno',
  MusicGenre.psytrance: 'psytrance',
  MusicGenre.trance: 'trance',
  MusicGenre.drumAndBass: 'drum_and_bass',
  MusicGenre.dubstep: 'dubstep',
  MusicGenre.afroHouse: 'afro_house',
  MusicGenre.minimal: 'minimal',
  MusicGenre.hardTechno: 'hard_techno',
  MusicGenre.discoNuDisco: 'disco_nu_disco',
  MusicGenre.edm: 'edm',
  MusicGenre.other: 'other',
};

const _$DateIntentEnumMap = {
  DateIntent.casual: 'casual',
  DateIntent.dating: 'dating',
  DateIntent.relationship: 'relationship',
  DateIntent.figuringOut: 'figuring_out',
};

_SwipeResult _$SwipeResultFromJson(Map<String, dynamic> json) => _SwipeResult(
  matched: json['matched'] as bool,
  matchId: json['match_id'] as String?,
  conversationId: json['conversation_id'] as String?,
);

Map<String, dynamic> _$SwipeResultToJson(_SwipeResult instance) =>
    <String, dynamic>{
      'matched': instance.matched,
      'match_id': instance.matchId,
      'conversation_id': instance.conversationId,
    };
