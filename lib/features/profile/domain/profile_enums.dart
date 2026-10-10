import 'package:json_annotation/json_annotation.dart';

// Mirrors of the database enums (supabase/migrations/..._foundation.sql).
// JSON values are the snake_case names stored in Postgres.

@JsonEnum(fieldRename: FieldRename.snake)
enum Gender { woman, man, nonBinary, other, preferNotSay }

@JsonEnum(fieldRename: FieldRename.snake)
enum SexualOrientation {
  straight,
  gay,
  lesbian,
  bisexual,
  pansexual,
  asexual,
  queer,
  questioning,
  other,
}

@JsonEnum(fieldRename: FieldRename.snake)
enum DateIntent { casual, dating, relationship, figuringOut }

@JsonEnum(fieldRename: FieldRename.snake)
enum HabitFrequency { no, socially, yes }

@JsonEnum(fieldRename: FieldRename.snake)
enum ZodiacSign {
  aries,
  taurus,
  gemini,
  cancer,
  leo,
  virgo,
  libra,
  scorpio,
  sagittarius,
  capricorn,
  aquarius,
  pisces,
}

@JsonEnum(fieldRename: FieldRename.snake)
enum MusicGenre {
  techno,
  house,
  techHouse,
  melodicTechno,
  psytrance,
  trance,
  drumAndBass,
  dubstep,
  afroHouse,
  minimal,
  hardTechno,
  discoNuDisco,
  edm,
  other,
}

/// `profiles.pets` values (text[] with a check constraint).
@JsonEnum(fieldRename: FieldRename.snake)
enum Pet { dog, cat, other, none, want }

/// Languages offered in "Sobre mim" (ISO 639-1 codes stored in
/// `profiles.languages`).
const profileLanguages = [
  'pt',
  'en',
  'es',
  'fr',
  'it',
  'de',
  'ja',
  'zh',
  'ko',
  'ru',
  'ar',
  'he',
  'nl',
  'libras',
];
