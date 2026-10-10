import 'package:pulse/features/profile/domain/profile_enums.dart';
import 'package:pulse/l10n/app_localizations.dart';

/// pt-BR labels for the profile enums (texts live in the ARB files).
extension ProfileLabels on AppLocalizations {
  String gender(Gender value) => switch (value) {
    Gender.woman => genderWoman,
    Gender.man => genderMan,
    Gender.nonBinary => genderNonBinary,
    Gender.other => genderOther,
    Gender.preferNotSay => genderPreferNotSay,
  };

  /// Plural form used by the Date "show me" filter.
  String showMe(Gender value) => switch (value) {
    Gender.woman => showMeWomen,
    Gender.man => showMeMen,
    Gender.nonBinary => showMeNonBinary,
    Gender.other => genderOther,
    Gender.preferNotSay => genderPreferNotSay,
  };

  String orientation(SexualOrientation value) => switch (value) {
    SexualOrientation.straight => orientationStraight,
    SexualOrientation.gay => orientationGay,
    SexualOrientation.lesbian => orientationLesbian,
    SexualOrientation.bisexual => orientationBisexual,
    SexualOrientation.pansexual => orientationPansexual,
    SexualOrientation.asexual => orientationAsexual,
    SexualOrientation.queer => orientationQueer,
    SexualOrientation.questioning => orientationQuestioning,
    SexualOrientation.other => orientationOther,
  };

  String dateIntent(DateIntent value) => switch (value) {
    DateIntent.casual => intentCasual,
    DateIntent.dating => intentDating,
    DateIntent.relationship => intentRelationship,
    DateIntent.figuringOut => intentFiguringOut,
  };

  String habit(HabitFrequency value) => switch (value) {
    HabitFrequency.no => habitNo,
    HabitFrequency.socially => habitSocially,
    HabitFrequency.yes => habitYes,
  };

  String zodiac(ZodiacSign value) => switch (value) {
    ZodiacSign.aries => zodiacAries,
    ZodiacSign.taurus => zodiacTaurus,
    ZodiacSign.gemini => zodiacGemini,
    ZodiacSign.cancer => zodiacCancer,
    ZodiacSign.leo => zodiacLeo,
    ZodiacSign.virgo => zodiacVirgo,
    ZodiacSign.libra => zodiacLibra,
    ZodiacSign.scorpio => zodiacScorpio,
    ZodiacSign.sagittarius => zodiacSagittarius,
    ZodiacSign.capricorn => zodiacCapricorn,
    ZodiacSign.aquarius => zodiacAquarius,
    ZodiacSign.pisces => zodiacPisces,
  };

  String genre(MusicGenre value) => switch (value) {
    MusicGenre.techno => genreTechno,
    MusicGenre.house => genreHouse,
    MusicGenre.techHouse => genreTechHouse,
    MusicGenre.melodicTechno => genreMelodicTechno,
    MusicGenre.psytrance => genrePsytrance,
    MusicGenre.trance => genreTrance,
    MusicGenre.drumAndBass => genreDrumAndBass,
    MusicGenre.dubstep => genreDubstep,
    MusicGenre.afroHouse => genreAfroHouse,
    MusicGenre.minimal => genreMinimal,
    MusicGenre.hardTechno => genreHardTechno,
    MusicGenre.discoNuDisco => genreDiscoNuDisco,
    MusicGenre.edm => genreEdm,
    MusicGenre.other => genreOther,
  };

  String pet(Pet value) => switch (value) {
    Pet.dog => petDog,
    Pet.cat => petCat,
    Pet.other => petOther,
    Pet.none => petNone,
    Pet.want => petWant,
  };

  String language(String code) => switch (code) {
    'pt' => languagePt,
    'en' => languageEn,
    'es' => languageEs,
    'fr' => languageFr,
    'it' => languageIt,
    'de' => languageDe,
    'ja' => languageJa,
    'zh' => languageZh,
    'ko' => languageKo,
    'ru' => languageRu,
    'ar' => languageAr,
    'he' => languageHe,
    'nl' => languageNl,
    'libras' => languageLibras,
    _ => code,
  };
}
