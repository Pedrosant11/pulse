// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Achievement _$AchievementFromJson(Map<String, dynamic> json) => _Achievement(
  key: $enumDecode(_$AchievementKeyEnumMap, json['key']),
  progress: (json['progress'] as num).toInt(),
  goal: (json['goal'] as num).toInt(),
  unlocked: json['unlocked'] as bool,
);

Map<String, dynamic> _$AchievementToJson(_Achievement instance) =>
    <String, dynamic>{
      'key': _$AchievementKeyEnumMap[instance.key]!,
      'progress': instance.progress,
      'goal': instance.goal,
      'unlocked': instance.unlocked,
    };

const _$AchievementKeyEnumMap = {
  AchievementKey.nightLegend: 'night_legend',
  AchievementKey.loyalToTheHouse: 'loyal_to_the_house',
  AchievementKey.marathoner: 'marathoner',
  AchievementKey.eclectic: 'eclectic',
  AchievementKey.explorer: 'explorer',
  AchievementKey.neverAlone: 'never_alone',
  AchievementKey.partyAnimal: 'party_animal',
  AchievementKey.firstParty: 'first_party',
};

_Passport _$PassportFromJson(Map<String, dynamic> json) => _Passport(
  parties: (json['parties'] as num?)?.toInt() ?? 0,
  venues: (json['venues'] as num?)?.toInt() ?? 0,
  cities: (json['cities'] as num?)?.toInt() ?? 0,
  genres: (json['genres'] as num?)?.toInt() ?? 0,
  full: json['full'] as bool? ?? false,
  entries:
      (json['entries'] as List<dynamic>?)
          ?.map((e) => EventSummary.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$PassportToJson(_Passport instance) => <String, dynamic>{
  'parties': instance.parties,
  'venues': instance.venues,
  'cities': instance.cities,
  'genres': instance.genres,
  'full': instance.full,
  'entries': instance.entries.map((e) => e.toJson()).toList(),
};
