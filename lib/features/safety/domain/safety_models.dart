import 'package:freezed_annotation/freezed_annotation.dart';

part 'safety_models.freezed.dart';
part 'safety_models.g.dart';

/// Mirrors the database enum `report_target`.
enum ReportTarget { user, message, event }

/// Mirrors the database enum `report_reason` (order = order in the UI).
@JsonEnum(fieldRename: FieldRename.snake)
enum ReportReason {
  harassment,
  inappropriateContent,
  fakeProfile,
  scam,
  spam,
  underage,
  safetyConcern,
  other,
}

/// Mirrors the database enum `moderation_action_type`.
enum ModerationAction { warning, suspension, ban, reactivation }

/// Someone the user blocked (Settings → Bloqueados).
@freezed
abstract class BlockedUser with _$BlockedUser {
  const factory({
    required String userId,
    required String firstName,
    required DateTime blockedAt,
    String? photoPath,
  }) = _BlockedUser;

  factory fromJson(Map<String, dynamic> json) => _$BlockedUserFromJson(json);
}

/// A moderation decision the signed-in user must see: the suspension/ban
/// while the account is restricted, or a warning not yet acknowledged.
@freezed
abstract class ModerationNotice with _$ModerationNotice {
  const factory({
    required String id,
    required ModerationAction action,
    required String reason,
    required DateTime createdAt,
    DateTime? expiresAt,
  }) = _ModerationNotice;

  factory fromJson(Map<String, dynamic> json) =>
      _$ModerationNoticeFromJson(json);
}
