import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_state.freezed.dart';

/// Matches the database enum `account_status`.
enum AccountStatus { active, suspended, banned }

/// What the signed-in user still has to do before using the app.
@freezed
abstract class AccountState with _$AccountState {
  const factory({
    required String userId,

    /// A phone number is saved (required, unique per account; no code).
    required bool hasPhone,

    /// Accepted the current terms version (AppConstants.termsVersion).
    required bool termsAccepted,
    required bool onboardingCompleted,
    required AccountStatus status,
  }) = _AccountState;
}
