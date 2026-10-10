import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pulse/features/auth/domain/account_state.dart';
import 'package:pulse/features/safety/domain/safety_models.dart';

part 'moderation_models.freezed.dart';
part 'moderation_models.g.dart';

/// What the admin decides about a report (`admin_resolve_report`).
enum ReportOutcome { dismiss, resolve, warning, suspension, ban }

/// A pending report in the admin panel, with the content as it was when
/// reported (SPEC 10).
@freezed
abstract class AdminReport with _$AdminReport {
  const factory({
    required String id,
    required ReportTarget targetType,
    required String targetId,
    required ReportReason reason,
    required DateTime createdAt,
    @Default(<String, dynamic>{}) Map<String, dynamic> snapshot,
    String? details,
    String? reporterId,
    String? reporterFirstName,
    String? reportedUserId,
    String? reportedFirstName,
    String? reportedPhotoPath,
    AccountStatus? reportedStatus,
    @Default(0) int reportsAgainstUser,
    @Default(0) int previousActions,
  }) = _AdminReport;

  const new _();

  factory fromJson(Map<String, dynamic> json) => _$AdminReportFromJson(json);

  /// Message text, event name or person's name at report time.
  String? get snapshotText => switch (targetType) {
    ReportTarget.message => snapshot['content'] as String?,
    ReportTarget.event => snapshot['name'] as String?,
    ReportTarget.user => snapshot['first_name'] as String?,
  };

  /// Messages and events can be taken down; people are handled with an
  /// account action.
  bool get hasRemovableContent => targetType != ReportTarget.user;
}

/// A suspended or banned account (admin panel, for reactivation).
@freezed
abstract class RestrictedUser with _$RestrictedUser {
  const factory({
    required String userId,
    required String firstName,
    required AccountStatus status,
    String? photoPath,
    String? reason,
    DateTime? expiresAt,
    DateTime? actedAt,
  }) = _RestrictedUser;

  factory fromJson(Map<String, dynamic> json) => _$RestrictedUserFromJson(json);
}
