import 'dart:async';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Runs [body] converting any thrown error into an [AppFailure] (keeping the
/// original stack trace). Repositories wrap every remote call with it.
Future<T> guardFailures<T>(Future<T> Function() body) async {
  try {
    return await body();
  } on Object catch (error, stackTrace) {
    Error.throwWithStackTrace(AppFailure.from(error), stackTrace);
  }
}

/// App-level error. Repositories convert any exception into an [AppFailure]
/// with [AppFailure.from]; the UI turns it into a friendly message with
/// `failure.message(l10n)` (see `app_failure_message.dart`).
sealed class AppFailure implements Exception {
  const new([this.cause]);

  /// Maps exceptions thrown by Supabase, the network or Dart itself.
  factory from(Object error) {
    return switch (error) {
      AppFailure() => error,
      SocketException() || TimeoutException() => NetworkFailure(error),
      AuthException() => _fromAuth(error),
      PostgrestException() => _fromPostgrest(error),
      FunctionException() => _fromFunction(error),
      StorageException(:final statusCode) when statusCode == '404' =>
        NotFoundFailure(error),
      StorageException(:final statusCode) when statusCode == '403' =>
        PermissionDeniedFailure(error),
      _ => UnknownFailure(error),
    };
  }

  static AppFailure _fromAuth(AuthException error) {
    return switch (error.code) {
      'invalid_credentials' => InvalidCredentialsFailure(error),
      'email_not_confirmed' => EmailNotConfirmedFailure(error),
      'weak_password' => WeakPasswordFailure(error),
      'same_password' => SamePasswordFailure(error),
      'user_already_exists' || 'email_exists' => EmailInUseFailure(error),
      'over_email_send_rate_limit' ||
      'over_request_rate_limit' => RateLimitedFailure(error),
      'session_expired' ||
      'session_not_found' ||
      'refresh_token_not_found' => SessionExpiredFailure(error),
      _ => switch (error.statusCode) {
        '401' => SessionExpiredFailure(error),
        '429' => RateLimitedFailure(error),
        // gotrue also wraps 5xx answers in this exception; only the ones
        // without a status are real network failures.
        _
            when error is AuthRetryableFetchException &&
                error.statusCode == null =>
          NetworkFailure(error),
        _ => UnknownFailure(error),
      },
    };
  }

  static AppFailure _fromPostgrest(PostgrestException error) {
    return switch ((error.code, error.hint)) {
      // Profile photo rules (onboarding migration).
      ('P0001', 'min_photos') => MinPhotosFailure(error),
      // Crews without Crew mode ("events only" migration).
      ('P0001', 'crew_mode_required') => CrewModeRequiredFailure(error),
      ('P0001', 'crew_needs_event') => CrewNeedsEventFailure(error),
      // Selfie verification.
      ('P0001', 'verification_pending') => VerificationPendingFailure(error),
      ('P0001', 'already_verified') => AlreadyVerifiedFailure(error),
      // Featured events: 5 at once per region.
      ('P0001', 'featured_limit') => FeaturedLimitFailure(error),
      ('P0001', 'account_paused') => AccountPausedFailure(error),
      ('P0001', 'on_not_now') => OnNotNowFailure(error),
      ('P0001', 'featured_unavailable') => FeaturedUnavailableFailure(error),
      // Casas (venues migration).
      ('P0001', 'venue_unavailable') => VenueUnavailableFailure(error),
      ('P0001', 'venue_review_not_allowed') => VenueReviewNotAllowedFailure(
        error,
      ),
      // Referral codes.
      ('P0001', 'referral_invalid') => ReferralFailure(.invalid, error),
      ('P0001', 'referral_own') => ReferralFailure(.own, error),
      ('P0001', 'referral_used') => ReferralFailure(.used, error),
      ('P0001', 'referral_too_late') => ReferralFailure(.tooLate, error),
      // Plans (monetization migration).
      ('P0001', 'like_limit') => LikeLimitFailure(error),
      ('P0001', 'superlike_limit') => SuperlikeLimitFailure(error),
      ('P0001', 'plan_required') => PlanRequiredFailure(error),
      ('P0001', 'boost_unavailable') => BoostUnavailableFailure(error),
      ('P0001', 'boost_active') => BoostActiveFailure(error),
      // Sexual orientation without consent (lgpd migration).
      ('22023', 'sensitive_consent') => SensitiveConsentFailure(error),
      // unique_violation on user_private.phone.
      ('23505', _) when error.message.contains('phone') => PhoneInUseFailure(
        error,
      ),
      // insufficient_privilege / RLS violation.
      ('42501', _) => PermissionDeniedFailure(error),
      // No rows for .single().
      ('PGRST116', _) => NotFoundFailure(error),
      // JWT expired.
      ('PGRST301' || 'PGRST303', _) => SessionExpiredFailure(error),
      // Raised by the rate-limit triggers (SPEC 10).
      ('P0429', _) => RateLimitedFailure(error),
      _ => UnknownFailure(error),
    };
  }

  /// Edge Functions answer `{ "error": "<code>" }` with an HTTP status.
  static AppFailure _fromFunction(FunctionException error) {
    final details = error.details;
    final code = details is Map ? details['error'] : null;
    return switch ((error.status, code)) {
      (_, 'invalid_password') => WrongPasswordFailure(error),
      (_, 'invalid_url') => EventLinkFailure(EventLinkProblem.invalid, error),
      (_, 'page_unavailable') => EventLinkFailure(
        EventLinkProblem.unavailable,
        error,
      ),
      (401, _) => SessionExpiredFailure(error),
      (403, _) => PermissionDeniedFailure(error),
      (429, _) => RateLimitedFailure(error),
      _ => UnknownFailure(error),
    };
  }

  /// Original exception, kept for logging.
  final Object? cause;

  @override
  String toString() => 'AppFailure(cause: $cause)';
}

final class NetworkFailure extends AppFailure {
  const new([super.cause]);
}

final class SessionExpiredFailure extends AppFailure {
  const new([super.cause]);
}

final class PermissionDeniedFailure extends AppFailure {
  const new([super.cause]);
}

final class NotFoundFailure extends AppFailure {
  const new([super.cause]);
}

final class RateLimitedFailure extends AppFailure {
  const new([super.cause]);
}

final class InvalidCredentialsFailure extends AppFailure {
  const new([super.cause]);
}

/// Sensitive data (sexual orientation) sent without the user's consent.
final class SensitiveConsentFailure extends AppFailure {
  const new([super.cause]);
}

/// Re-authentication failed (e.g. deleting the account).
final class WrongPasswordFailure extends AppFailure {
  const new([super.cause]);
}

final class EmailNotConfirmedFailure extends AppFailure {
  const new([super.cause]);
}

final class EmailInUseFailure extends AppFailure {
  const new([super.cause]);
}

final class WeakPasswordFailure extends AppFailure {
  const new([super.cause]);
}

final class SamePasswordFailure extends AppFailure {
  const new([super.cause]);
}

final class PhoneInUseFailure extends AppFailure {
  const new([super.cause]);
}

final class MinPhotosFailure extends AppFailure {
  const new([super.cause]);
}

final class UnknownFailure extends AppFailure {
  const new([super.cause]);
}

/// Creating or joining a crew without Crew mode on.
final class CrewModeRequiredFailure extends AppFailure {
  const new([super.cause]);
}

/// Free daily likes used up.
final class LikeLimitFailure extends AppFailure {
  const new([super.cause]);
}

/// No weekly superlike left and none in the wallet.
final class SuperlikeLimitFailure extends AppFailure {
  const new([super.cause]);
}

/// A plan benefit (rewind, who liked you).
final class PlanRequiredFailure extends AppFailure {
  const new([super.cause]);
}

final class BoostUnavailableFailure extends AppFailure {
  const new([super.cause]);
}

final class BoostActiveFailure extends AppFailure {
  const new([super.cause]);
}

/// A Crew like without a party in common.
final class CrewNeedsEventFailure extends AppFailure {
  const new([super.cause]);
}

/// A verification selfie is already waiting for review.
final class VerificationPendingFailure extends AppFailure {
  const new([super.cause]);
}

final class AlreadyVerifiedFailure extends AppFailure {
  const new([super.cause]);
}

/// The region already has the most highlights allowed at once.
final class FeaturedLimitFailure extends AppFailure {
  const new([super.cause]);
}

/// Swiping while the account is paused.
final class AccountPausedFailure extends AppFailure {
  const new([super.cause]);
}

/// Only approved parties that haven't happened can be highlighted.
final class FeaturedUnavailableFailure extends AppFailure {
  const new([super.cause]);
}

/// Why a friend's referral code was refused.
enum ReferralProblem { invalid, own, used, tooLate }

final class ReferralFailure extends AppFailure {
  const new(this.problem, [super.cause]);

  final ReferralProblem problem;
}

/// Why "Importar de um link" could not read a ticket page.
enum EventLinkProblem { invalid, unavailable, noData }

final class EventLinkFailure extends AppFailure {
  const new(this.problem, [super.cause]);

  final EventLinkProblem problem;
}

/// The event points to a venue that isn't approved (or not theirs).
final class VenueUnavailableFailure extends AppFailure {
  const new([super.cause]);
}

/// Only people who went to a party at the venue can rate it.
final class VenueReviewNotAllowedFailure extends AppFailure {
  const new([super.cause]);
}

/// "Tô ON" only works on the night of a party the person is going to.
final class OnNotNowFailure extends AppFailure {
  const new([super.cause]);
}
