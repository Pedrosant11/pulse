import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pulse/features/events/domain/event.dart';

part 'venue.freezed.dart';
part 'venue.g.dart';

/// Mirrors the database enum `venue_status`.
enum VenueStatus { pending, approved, rejected }

/// Row of `list_venues()`: the "Casas" list and the event form picker.
@freezed
abstract class Venue with _$Venue {
  const factory({
    required String id,
    required String name,
    required String city,
    required String state,
    String? neighborhood,
    String? address,
    double? lat,
    double? lng,
    String? photoPath,
    double? rating,
    @Default(0) int ratingCount,
    @Default(0) int followers,
    @Default(0) int upcoming,
    @Default(false) bool isFollowing,
    @Default(VenueStatus.approved) VenueStatus status,
  }) = _Venue;

  factory fromJson(Map<String, dynamic> json) => _$VenueFromJson(json);
}

/// `get_venue()`: the venue page.
@freezed
abstract class VenueDetail with _$VenueDetail {
  const factory({
    required String id,
    required String name,
    required String city,
    required String state,
    required VenueStatus status,
    String? description,
    String? neighborhood,
    String? address,
    double? lat,
    double? lng,
    String? photoPath,
    String? instagram,
    String? rejectionReason,
    double? rating,
    @Default(0) int ratingCount,
    @Default(0) int followers,
    @Default(false) bool isFollowing,

    /// Went to a party there, so can rate it.
    @Default(false) bool canReview,
    int? myRating,
    String? myComment,
    @Default(0) int pastEvents,
    @Default(false) bool canEdit,
    @Default([]) List<EventSummary> upcoming,
    @Default([]) List<VenueReview> reviews,
  }) = _VenueDetail;

  factory fromJson(Map<String, dynamic> json) => _$VenueDetailFromJson(json);
}

@freezed
abstract class VenueReview with _$VenueReview {
  const factory({
    required String userId,
    required String firstName,
    required int rating,
    required DateTime updatedAt,
    String? comment,
  }) = _VenueReview;

  factory fromJson(Map<String, dynamic> json) => _$VenueReviewFromJson(json);
}
