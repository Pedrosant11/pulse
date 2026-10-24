import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pulse/core/models/app_mode.dart';
import 'package:pulse/core/models/user_role.dart';
import 'package:pulse/core/utils/enum_json.dart';
import 'package:pulse/features/profile/domain/profile_enums.dart';

part 'event.freezed.dart';
part 'event.g.dart';

/// Mirrors the database enum `event_status`.
enum EventStatus { pending, approved, rejected, cancelled }

/// Event fields used in compact lists (profile, onboarding).
@freezed
abstract class EventSummary with _$EventSummary {
  const factory({
    required String id,
    required String name,
    required String venueName,
    required String city,
    required String state,
    required DateTime startsAt,
    required DateTime endsAt,
    String? coverPath,
    @Default([]) List<MusicGenre> genres,
    @Default(false) bool isOfficial,
  }) = _EventSummary;

  factory fromJson(Map<String, dynamic> json) => _$EventSummaryFromJson(json);
}

/// Row of `list_events()` (SPEC 7.3 list cards).
@freezed
abstract class EventListEntry with _$EventListEntry {
  const factory({
    required String id,
    required String name,
    required String venueName,
    required String city,
    required String state,
    required DateTime startsAt,
    required DateTime endsAt,
    required EventStatus status,
    String? coverPath,
    @Default([]) List<MusicGenre> genres,
    @Default(false) bool isOfficial,
    @Default(false) bool isMine,
    @Default(false) bool isGoing,

    /// Saved for later ("Salvar").
    @Default(false) bool isSaved,
    @Default(0) int goingCount,
    double? distanceKm,

    /// Where to draw it on the map (SPEC 7.4): the venue when [pinExact],
    /// otherwise an approximate area (secret location or no venue yet).
    double? pinLat,
    double? pinLng,
    @Default(false) bool pinExact,

    /// Secret location: when the venue is revealed.
    DateTime? locationRevealAt,

    /// Featured by an admin (paid by the producer): first in the list.
    @Default(false) bool isFeatured,
  }) = _EventListEntry;

  factory fromJson(Map<String, dynamic> json) => _$EventListEntryFromJson(json);
}

/// Full event row (detail and edit screens).
@freezed
abstract class EventDetail with _$EventDetail {
  const factory({
    required String id,
    required String name,
    required String venueName,
    required String city,
    required String state,
    required DateTime startsAt,
    required DateTime endsAt,
    required EventStatus status,
    String? description,
    String? coverPath,

    /// City centroid (radius filter). The venue is in [EventVenue].
    double? lat,
    double? lng,

    /// Secret location: venue revealed this many hours before the start.
    int? locationRevealHours,
    @Default([]) List<MusicGenre> genres,
    @Default([]) List<String> lineup,
    String? ticketUrl,

    /// Affiliate/promoter code shown next to the ticket link.
    String? ticketCoupon,
    @Default(18) int minAge,
    @Default(false) bool isOfficial,
    String? createdBy,
    String? rejectionReason,

    /// Featured until this moment (admins set it).
    DateTime? featuredUntil,

    /// Its casa (venues migration), when linked.
    String? venueId,
  }) = _EventDetail;

  factory fromJson(Map<String, dynamic> json) => _$EventDetailFromJson(json);
}

/// Address and exact point of an event (`event_venues`). Only readable once
/// the location is public (SPEC 7.4).
@freezed
abstract class EventVenue with _$EventVenue {
  const factory({
    required String eventId,
    String? address,
    double? lat,
    double? lng,
  }) = _EventVenue;

  const new _();

  factory fromJson(Map<String, dynamic> json) => _$EventVenueFromJson(json);

  bool get hasPoint => lat != null && lng != null;
}

/// Row of `get_event_attendees()`: anonymous unless it's a match.
@freezed
abstract class EventAttendee with _$EventAttendee {
  const factory({
    required String userId,
    String? firstName,
    String? photoPath,
    @Default([]) List<AppMode> modes,
    @Default(false) bool isMatch,
  }) = _EventAttendee;

  factory fromJson(Map<String, dynamic> json) => _$EventAttendeeFromJson(json);
}

@freezed
abstract class AttendeeCounts with _$AttendeeCounts {
  const factory({
    @Default(0) int total,
    @Default(0) int dateCount,
    @Default(0) int crewCount,
  }) = _AttendeeCounts;

  factory fromJson(Map<String, dynamic> json) => _$AttendeeCountsFromJson(json);
}

/// Possible duplicate returned by `find_similar_events()` (SPEC 7.2).
@freezed
abstract class SimilarEvent with _$SimilarEvent {
  const factory({
    required String id,
    required String name,
    required String venueName,
    required String city,
    required DateTime startsAt,
    required EventStatus status,
  }) = _SimilarEvent;

  factory fromJson(Map<String, dynamic> json) => _$SimilarEventFromJson(json);
}

/// Who created an event (get_event_creator(), moderators only).
/// [email] is only filled for admins.
@freezed
abstract class EventCreator with _$EventCreator {
  const factory({
    required String userId,
    required UserRole role,
    required DateTime memberSince,
    String? firstName,
    String? photoPath,
    @Default(0) int eventsCreated,
    @Default(0) int eventsRejected,
    String? email,
  }) = _EventCreator;

  factory fromJson(Map<String, dynamic> json) => _$EventCreatorFromJson(json);
}

/// Filters of the "Próximos" tab.
@freezed
abstract class EventFilters with _$EventFilters {
  const factory({
    @Default('') String query,
    @Default(<MusicGenre>{}) Set<MusicGenre> genres,
    @Default(EventDateRange.any) EventDateRange dateRange,
  }) = _EventFilters;
}

enum EventDateRange { any, today, weekend, next30Days }

/// Aggregated numbers for the event's creator (`get_event_insights`).
/// Breakdowns are empty below 5 people (nobody can be singled out).
class EventInsights {
  const new({
    required this.going,
    required this.goingDate,
    required this.goingCrew,
    required this.ticketClicks,
    required this.crews,
    required this.breakdownsHidden,
    this.checkedIn = 0,
    this.genres = const [],
    this.cities = const [],
    this.genders = const {},
    this.ages = const {},
  });

  factory fromJson(Map<String, dynamic> json) {
    int n(Object? v) => (v as num?)?.toInt() ?? 0;
    return EventInsights(
      going: n(json['going']),
      goingDate: n(json['going_date']),
      goingCrew: n(json['going_crew']),
      ticketClicks: n(json['ticket_clicks']),
      crews: n(json['crews']),
      checkedIn: n(json['checked_in']),
      breakdownsHidden: json['breakdowns_hidden'] == true,
      genres: [
        for (final g in (json['genres'] as List?) ?? const [])
          (
            genre: MusicGenre.values
                .where((v) => enumToDb(v) == (g as Map)['genre'])
                .firstOrNull,
            count: n((g as Map)['count']),
          ),
      ],
      cities: [
        for (final c in (json['cities'] as List?) ?? const [])
          (label: '${(c as Map)['city']}, ${c['state']}', count: n(c['count'])),
      ],
      genders: {
        for (final e in ((json['genders'] as Map?) ?? const {}).entries)
          e.key as String: n(e.value),
      },
      ages: {
        for (final e in ((json['ages'] as Map?) ?? const {}).entries)
          e.key as String: n(e.value),
      },
    );
  }

  final int going;

  /// Who checked in at the party (really went).
  final int checkedIn;
  final int goingDate;
  final int goingCrew;
  final int ticketClicks;
  final int crews;
  final bool breakdownsHidden;
  final List<({MusicGenre? genre, int count})> genres;
  final List<({String label, int count})> cities;

  /// Database gender value (or "unknown") → people.
  final Map<String, int> genders;

  /// "18_24", "25_34", "35_plus" → people.
  final Map<String, int> ages;
}

/// A match or crew-mate who is ON at a party tonight (`event_on_people()`).
@freezed
abstract class OnPerson with _$OnPerson {
  const factory({
    required String userId,
    required String firstName,
    String? photoPath,
  }) = _OnPerson;

  factory fromJson(Map<String, dynamic> json) => _$OnPersonFromJson(json);
}

/// A card in the "Próximos" sections.
@freezed
abstract class SectionEvent with _$SectionEvent {
  const factory({
    required String id,
    required String name,
    required String venueName,
    required String city,
    required String state,
    required DateTime startsAt,
    required DateTime endsAt,
    String? coverPath,
    @Default([]) List<MusicGenre> genres,
    @Default(false) bool isOfficial,
    @Default(0) int goingCount,
  }) = _SectionEvent;

  factory fromJson(Map<String, dynamic> json) => _$SectionEventFromJson(json);
}

/// `event_sections()`: em alta, esta semana, das casas que você segue.
@freezed
abstract class EventSections with _$EventSections {
  const factory({
    /// Paid highlights near the person, in the daily rotation.
    @Default([]) List<SectionEvent> featured,
    @Default([]) List<SectionEvent> trending,
    @Default([]) List<SectionEvent> thisWeek,
    @Default([]) List<SectionEvent> followedVenues,
  }) = _EventSections;

  factory fromJson(Map<String, dynamic> json) => _$EventSectionsFromJson(json);

  const new _();

  bool get isEmpty =>
      featured.isEmpty &&
      trending.isEmpty &&
      thisWeek.isEmpty &&
      followedVenues.isEmpty;
}
