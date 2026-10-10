import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pulse/core/models/app_mode.dart';
import 'package:pulse/features/profile/domain/profile.dart';
import 'package:pulse/features/profile/domain/profile_enums.dart';

part 'discover_models.freezed.dart';
part 'discover_models.g.dart';

/// Mirrors the database enum `swipe_direction`.
enum SwipeDirection { like, pass }

@freezed
abstract class CommonEvent with _$CommonEvent {
  const factory({
    required String id,
    required String name,
    required DateTime startsAt,
  }) = _CommonEvent;

  factory fromJson(Map<String, dynamic> json) => _$CommonEventFromJson(json);
}

/// A profile in the discovery feed (`get_discover_feed()`, SPEC 8.1).
@freezed
abstract class DiscoverCandidate with _$DiscoverCandidate {
  const factory({
    required String id,
    required String firstName,
    required int age,
    String? city,
    String? state,
    String? occupation,
    String? bio,
    Gender? gender,
    @Default(false) bool isVerified,
    @Default([]) List<MusicGenre> musicGenres,
    @Default([]) List<String> photoPaths,
    @Default([]) List<CommonEvent> commonEvents,
    @Default(0) int commonEventCount,
    @Default(false) bool isFallback,
    double? distanceKm,
    @Default([]) List<String> favoriteDjs,
    DateIntent? dateLookingFor,

    /// Crew mode: size of their crew for the first common event (null =
    /// going solo).
    int? crewSize,
  }) = _DiscoverCandidate;

  const new _();

  factory fromJson(Map<String, dynamic> json) =>
      _$DiscoverCandidateFromJson(json);

  /// Photos in the shape the shared carousel expects.
  List<ProfilePhoto> get photos => [
    for (var i = 0; i < photoPaths.length; i++)
      ProfilePhoto(
        id: photoPaths[i],
        userId: id,
        storagePath: photoPaths[i],
        position: i,
      ),
  ];

  /// What the card already knows, shown while the full profile loads (so
  /// the photo Hero has a target right away).
  PublicProfile get previewProfile => PublicProfile(
    id: id,
    firstName: firstName,
    age: age,
    gender: gender,
    city: city,
    state: state,
    occupation: occupation,
    bio: bio,
    musicGenres: musicGenres,
    favoriteDjs: favoriteDjs,
    dateLookingFor: dateLookingFor,
    isVerified: isVerified,
  );
}

@freezed
abstract class SwipeResult with _$SwipeResult {
  const factory({
    required bool matched,
    String? matchId,
    String? conversationId,
  }) = _SwipeResult;

  factory fromJson(Map<String, dynamic> json) => _$SwipeResultFromJson(json);
}

/// Cards for one mode plus the last swipe (for "voltar").
@freezed
abstract class DeckState with _$DeckState {
  const factory({
    required List<DiscoverCandidate> cards,
    DiscoverCandidate? lastSwiped,

    /// Last swipe/undo error, shown once by the screen.
    Object? error,
  }) = _DeckState;

  const new _();

  /// Fallback profiles ("mesma vibe") are only returned when nobody from the
  /// user's events is left.
  bool get isFallback => cards.isNotEmpty && cards.first.isFallback;
}

/// Data for the match screen.
class MatchArgs {
  const new({required this.other, required this.mode, this.conversationId});

  final DiscoverCandidate other;
  final AppMode mode;
  final String? conversationId;
}
