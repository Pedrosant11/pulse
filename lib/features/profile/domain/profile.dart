import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pulse/core/models/app_mode.dart';
import 'package:pulse/core/models/user_role.dart';
import 'package:pulse/features/profile/domain/profile_enums.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

/// The signed-in user's full profile row (`profiles`, owner-only via RLS).
@freezed
abstract class MyProfile with _$MyProfile {
  const factory({
    required String id,
    String? firstName,
    String? lastName,
    DateTime? birthDate,
    Gender? gender,
    SexualOrientation? orientation,
    @Default(false) bool showOrientation,
    String? city,
    String? state,
    double? lat,
    double? lng,
    String? occupation,
    String? bio,
    int? heightCm,
    @Default([]) List<String> languages,
    ZodiacSign? zodiac,
    HabitFrequency? drinks,
    HabitFrequency? smokes,
    @Default([]) List<Pet> pets,
    @Default([]) List<MusicGenre> musicGenres,
    @Default([]) List<String> favoriteDjs,
    @Default([]) List<AppMode> modes,
    DateIntent? dateLookingFor,
    @Default([]) List<Gender> dateShowMe,
    @Default(18) int dateAgeMin,
    @Default(99) int dateAgeMax,
    @Default(false) bool crewSameGenderOnly,
    @Default(50) int discoveryRadiusKm,
    @Default(UserRole.user) UserRole role,
    @Default(false) bool isVerified,
    @Default(false) bool onboardingCompleted,
    @Default(0) int onboardingStep,

    /// "Pausar conta": hidden from Discover while set.
    DateTime? pausedAt,

    /// Pushes about new parties nearby and reminders.
    @Default(true) bool notifyEvents,
  }) = _MyProfile;

  const new _();

  factory fromJson(Map<String, dynamic> json) => _$MyProfileFromJson(json);

  bool get isPaused => pausedAt != null;
}

/// What other users see (`public_profiles` view, SPEC 5.4): first name,
/// age and city — never last name, birth date or coordinates.
@freezed
abstract class PublicProfile with _$PublicProfile {
  const factory({
    required String id,
    required String firstName,
    required int age,
    Gender? gender,
    SexualOrientation? orientation,
    String? city,
    String? state,
    String? occupation,
    String? bio,
    int? heightCm,
    @Default([]) List<String> languages,
    ZodiacSign? zodiac,
    HabitFrequency? drinks,
    HabitFrequency? smokes,
    @Default([]) List<Pet> pets,
    @Default([]) List<MusicGenre> musicGenres,
    @Default([]) List<String> favoriteDjs,
    @Default([]) List<AppMode> modes,
    DateIntent? dateLookingFor,
    @Default(false) bool isVerified,
  }) = _PublicProfile;

  factory fromJson(Map<String, dynamic> json) => _$PublicProfileFromJson(json);
}

@freezed
abstract class ProfilePhoto with _$ProfilePhoto {
  const factory({
    required String id,
    required String userId,
    required String storagePath,
    required int position,
  }) = _ProfilePhoto;

  factory fromJson(Map<String, dynamic> json) => _$ProfilePhotoFromJson(json);
}

/// Onboarding steps (`profiles.onboarding_step` stores the index; the length
/// means done). Each person walks one of the [onboardingPath]s.
enum OnboardingStep {
  intent,
  photos,
  basics,
  location,
  about,
  music,
  modes,
  firstEvent,
}

/// Steps for what the person chose first. "Events only" (no mode) skips the
/// dating profile: no photos, gender or "about me".
List<OnboardingStep> onboardingPath({required bool eventsOnly}) => eventsOnly
    ? const [
        OnboardingStep.intent,
        OnboardingStep.location,
        OnboardingStep.music,
        OnboardingStep.firstEvent,
      ]
    : const [
        OnboardingStep.intent,
        OnboardingStep.photos,
        OnboardingStep.basics,
        OnboardingStep.about,
        OnboardingStep.music,
        OnboardingStep.modes,
        OnboardingStep.firstEvent,
      ];
