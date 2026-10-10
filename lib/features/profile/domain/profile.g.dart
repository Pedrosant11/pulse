// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MyProfile _$MyProfileFromJson(Map<String, dynamic> json) => _MyProfile(
  id: json['id'] as String,
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  birthDate: json['birth_date'] == null
      ? null
      : DateTime.parse(json['birth_date'] as String),
  gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
  orientation: $enumDecodeNullable(
    _$SexualOrientationEnumMap,
    json['orientation'],
  ),
  showOrientation: json['show_orientation'] as bool? ?? false,
  city: json['city'] as String?,
  state: json['state'] as String?,
  lat: (json['lat'] as num?)?.toDouble(),
  lng: (json['lng'] as num?)?.toDouble(),
  occupation: json['occupation'] as String?,
  bio: json['bio'] as String?,
  heightCm: (json['height_cm'] as num?)?.toInt(),
  languages:
      (json['languages'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  zodiac: $enumDecodeNullable(_$ZodiacSignEnumMap, json['zodiac']),
  drinks: $enumDecodeNullable(_$HabitFrequencyEnumMap, json['drinks']),
  smokes: $enumDecodeNullable(_$HabitFrequencyEnumMap, json['smokes']),
  pets:
      (json['pets'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$PetEnumMap, e))
          .toList() ??
      const [],
  musicGenres:
      (json['music_genres'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$MusicGenreEnumMap, e))
          .toList() ??
      const [],
  favoriteDjs:
      (json['favorite_djs'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  modes:
      (json['modes'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$AppModeEnumMap, e))
          .toList() ??
      const [],
  dateLookingFor: $enumDecodeNullable(
    _$DateIntentEnumMap,
    json['date_looking_for'],
  ),
  dateShowMe:
      (json['date_show_me'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$GenderEnumMap, e))
          .toList() ??
      const [],
  dateAgeMin: (json['date_age_min'] as num?)?.toInt() ?? 18,
  dateAgeMax: (json['date_age_max'] as num?)?.toInt() ?? 99,
  crewSameGenderOnly: json['crew_same_gender_only'] as bool? ?? false,
  discoveryRadiusKm: (json['discovery_radius_km'] as num?)?.toInt() ?? 50,
  role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ?? UserRole.user,
  isVerified: json['is_verified'] as bool? ?? false,
  onboardingCompleted: json['onboarding_completed'] as bool? ?? false,
  onboardingStep: (json['onboarding_step'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$MyProfileToJson(
  _MyProfile instance,
) => <String, dynamic>{
  'id': instance.id,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'birth_date': instance.birthDate?.toIso8601String(),
  'gender': _$GenderEnumMap[instance.gender],
  'orientation': _$SexualOrientationEnumMap[instance.orientation],
  'show_orientation': instance.showOrientation,
  'city': instance.city,
  'state': instance.state,
  'lat': instance.lat,
  'lng': instance.lng,
  'occupation': instance.occupation,
  'bio': instance.bio,
  'height_cm': instance.heightCm,
  'languages': instance.languages,
  'zodiac': _$ZodiacSignEnumMap[instance.zodiac],
  'drinks': _$HabitFrequencyEnumMap[instance.drinks],
  'smokes': _$HabitFrequencyEnumMap[instance.smokes],
  'pets': instance.pets.map((e) => _$PetEnumMap[e]!).toList(),
  'music_genres': instance.musicGenres
      .map((e) => _$MusicGenreEnumMap[e]!)
      .toList(),
  'favorite_djs': instance.favoriteDjs,
  'modes': instance.modes.map((e) => _$AppModeEnumMap[e]!).toList(),
  'date_looking_for': _$DateIntentEnumMap[instance.dateLookingFor],
  'date_show_me': instance.dateShowMe.map((e) => _$GenderEnumMap[e]!).toList(),
  'date_age_min': instance.dateAgeMin,
  'date_age_max': instance.dateAgeMax,
  'crew_same_gender_only': instance.crewSameGenderOnly,
  'discovery_radius_km': instance.discoveryRadiusKm,
  'role': _$UserRoleEnumMap[instance.role]!,
  'is_verified': instance.isVerified,
  'onboarding_completed': instance.onboardingCompleted,
  'onboarding_step': instance.onboardingStep,
};

const _$GenderEnumMap = {
  Gender.woman: 'woman',
  Gender.man: 'man',
  Gender.nonBinary: 'non_binary',
  Gender.other: 'other',
  Gender.preferNotSay: 'prefer_not_say',
};

const _$SexualOrientationEnumMap = {
  SexualOrientation.straight: 'straight',
  SexualOrientation.gay: 'gay',
  SexualOrientation.lesbian: 'lesbian',
  SexualOrientation.bisexual: 'bisexual',
  SexualOrientation.pansexual: 'pansexual',
  SexualOrientation.asexual: 'asexual',
  SexualOrientation.queer: 'queer',
  SexualOrientation.questioning: 'questioning',
  SexualOrientation.other: 'other',
};

const _$ZodiacSignEnumMap = {
  ZodiacSign.aries: 'aries',
  ZodiacSign.taurus: 'taurus',
  ZodiacSign.gemini: 'gemini',
  ZodiacSign.cancer: 'cancer',
  ZodiacSign.leo: 'leo',
  ZodiacSign.virgo: 'virgo',
  ZodiacSign.libra: 'libra',
  ZodiacSign.scorpio: 'scorpio',
  ZodiacSign.sagittarius: 'sagittarius',
  ZodiacSign.capricorn: 'capricorn',
  ZodiacSign.aquarius: 'aquarius',
  ZodiacSign.pisces: 'pisces',
};

const _$HabitFrequencyEnumMap = {
  HabitFrequency.no: 'no',
  HabitFrequency.socially: 'socially',
  HabitFrequency.yes: 'yes',
};

const _$PetEnumMap = {
  Pet.dog: 'dog',
  Pet.cat: 'cat',
  Pet.other: 'other',
  Pet.none: 'none',
  Pet.want: 'want',
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

const _$AppModeEnumMap = {AppMode.date: 'date', AppMode.crew: 'crew'};

const _$DateIntentEnumMap = {
  DateIntent.casual: 'casual',
  DateIntent.dating: 'dating',
  DateIntent.relationship: 'relationship',
  DateIntent.figuringOut: 'figuring_out',
};

const _$UserRoleEnumMap = {
  UserRole.user: 'user',
  UserRole.curator: 'curator',
  UserRole.producer: 'producer',
  UserRole.admin: 'admin',
};

_PublicProfile _$PublicProfileFromJson(Map<String, dynamic> json) =>
    _PublicProfile(
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      age: (json['age'] as num).toInt(),
      gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
      orientation: $enumDecodeNullable(
        _$SexualOrientationEnumMap,
        json['orientation'],
      ),
      city: json['city'] as String?,
      state: json['state'] as String?,
      occupation: json['occupation'] as String?,
      bio: json['bio'] as String?,
      heightCm: (json['height_cm'] as num?)?.toInt(),
      languages:
          (json['languages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      zodiac: $enumDecodeNullable(_$ZodiacSignEnumMap, json['zodiac']),
      drinks: $enumDecodeNullable(_$HabitFrequencyEnumMap, json['drinks']),
      smokes: $enumDecodeNullable(_$HabitFrequencyEnumMap, json['smokes']),
      pets:
          (json['pets'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$PetEnumMap, e))
              .toList() ??
          const [],
      musicGenres:
          (json['music_genres'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$MusicGenreEnumMap, e))
              .toList() ??
          const [],
      favoriteDjs:
          (json['favorite_djs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      modes:
          (json['modes'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$AppModeEnumMap, e))
              .toList() ??
          const [],
      dateLookingFor: $enumDecodeNullable(
        _$DateIntentEnumMap,
        json['date_looking_for'],
      ),
      isVerified: json['is_verified'] as bool? ?? false,
    );

Map<String, dynamic> _$PublicProfileToJson(_PublicProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'age': instance.age,
      'gender': _$GenderEnumMap[instance.gender],
      'orientation': _$SexualOrientationEnumMap[instance.orientation],
      'city': instance.city,
      'state': instance.state,
      'occupation': instance.occupation,
      'bio': instance.bio,
      'height_cm': instance.heightCm,
      'languages': instance.languages,
      'zodiac': _$ZodiacSignEnumMap[instance.zodiac],
      'drinks': _$HabitFrequencyEnumMap[instance.drinks],
      'smokes': _$HabitFrequencyEnumMap[instance.smokes],
      'pets': instance.pets.map((e) => _$PetEnumMap[e]!).toList(),
      'music_genres': instance.musicGenres
          .map((e) => _$MusicGenreEnumMap[e]!)
          .toList(),
      'favorite_djs': instance.favoriteDjs,
      'modes': instance.modes.map((e) => _$AppModeEnumMap[e]!).toList(),
      'date_looking_for': _$DateIntentEnumMap[instance.dateLookingFor],
      'is_verified': instance.isVerified,
    };

_ProfilePhoto _$ProfilePhotoFromJson(Map<String, dynamic> json) =>
    _ProfilePhoto(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      storagePath: json['storage_path'] as String,
      position: (json['position'] as num).toInt(),
    );

Map<String, dynamic> _$ProfilePhotoToJson(_ProfilePhoto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'storage_path': instance.storagePath,
      'position': instance.position,
    };
