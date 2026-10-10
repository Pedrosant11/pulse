import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pulse/features/admin/data/role_requests_repository.dart';

part 'badge_models.freezed.dart';
part 'badge_models.g.dart';

/// Identification badges (SPEC 6.4). [producer] comes from the producer
/// role; the others mirror the database enum `profile_badge`.
@JsonEnum(fieldRename: FieldRename.snake)
enum ProfileBadgeType {
  team,
  dj,
  publicFigure,
  producer;

  /// Badges people can ask for in the app (Equipe Pulse is admin-only and
  /// Produtor comes from the role request).
  static const List<ProfileBadgeType> requestable = [dj, publicFigure];

  /// Badges an admin grants by hand.
  static const List<ProfileBadgeType> grantable = [team, dj, publicFigure];
}

/// A badge shown next to someone's name.
@freezed
abstract class UserBadge with _$UserBadge {
  const factory({required ProfileBadgeType badge, String? title}) = _UserBadge;

  factory fromJson(Map<String, dynamic> json) => _$UserBadgeFromJson(json);
}

/// "Quero um selo" request (admins review it).
@freezed
abstract class BadgeRequest with _$BadgeRequest {
  const factory({
    required String id,
    required String userId,
    required ProfileBadgeType badge,
    required String justification,
    required RequestStatus status,
    required DateTime createdAt,
    @Default([]) List<String> links,

    /// Filled for admins (requester's name).
    String? requesterName,
  }) = _BadgeRequest;

  factory fromJson(Map<String, dynamic> json) => _$BadgeRequestFromJson(json);
}

/// Result of the admin people search.
@freezed
abstract class AdminUserResult with _$AdminUserResult {
  const factory({
    required String userId,
    required String firstName,
    String? lastName,
    String? city,
    String? state,
    String? photoPath,
  }) = _AdminUserResult;

  const new _();

  factory fromJson(Map<String, dynamic> json) =>
      _$AdminUserResultFromJson(json);

  String get fullName => [firstName, ?lastName].join(' ');
}
