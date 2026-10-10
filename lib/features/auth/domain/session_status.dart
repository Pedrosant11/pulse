import 'package:pulse/features/auth/domain/account_state.dart';

/// Where the user is in the auth funnel. Drives the router redirect.
enum SessionStatus {
  /// Restoring the session / loading the account at startup.
  unknown,
  signedOut,

  /// Opened a password-reset link: must choose a new password.
  passwordRecovery,

  /// Suspended or banned by the moderation (SPEC 10): only the notice,
  /// sign-out and account deletion are reachable.
  restricted,

  /// Signed in, but the phone or the terms acceptance is missing
  /// (sign-up steps 2–3).
  needsAccountSetup,

  /// Account set up, but the profile onboarding is not completed.
  needsOnboarding,
  ready,
}

/// Pure mapping from auth/account data to [SessionStatus].
SessionStatus resolveSessionStatus({
  required bool hasSession,
  required bool isPasswordRecovery,
  required AccountState? account,
}) {
  if (!hasSession) return SessionStatus.signedOut;
  if (isPasswordRecovery) return SessionStatus.passwordRecovery;
  if (account == null) return SessionStatus.unknown;
  if (account.status != AccountStatus.active) return SessionStatus.restricted;
  if (!account.hasPhone || !account.termsAccepted) {
    return SessionStatus.needsAccountSetup;
  }
  if (!account.onboardingCompleted) return SessionStatus.needsOnboarding;
  return SessionStatus.ready;
}
