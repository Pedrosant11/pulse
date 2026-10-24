import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/l10n/app_localizations.dart';

extension AppFailureMessage on AppFailure {
  /// Friendly pt-BR message for the user.
  String message(AppLocalizations l10n) {
    return switch (this) {
      NetworkFailure() => l10n.errorNetwork,
      SessionExpiredFailure() => l10n.errorSessionExpired,
      PermissionDeniedFailure() => l10n.errorPermissionDenied,
      NotFoundFailure() => l10n.errorNotFound,
      RateLimitedFailure() => l10n.errorRateLimited,
      InvalidCredentialsFailure() => l10n.errorInvalidCredentials,
      WrongPasswordFailure() => l10n.errorWrongPassword,
      SensitiveConsentFailure() => l10n.orientationConsentRequired,
      EmailNotConfirmedFailure() => l10n.errorEmailNotConfirmed,
      EmailInUseFailure() => l10n.errorEmailInUse,
      WeakPasswordFailure() => l10n.errorWeakPassword,
      SamePasswordFailure() => l10n.errorSamePassword,
      PhoneInUseFailure() => l10n.errorPhoneInUse,
      MinPhotosFailure() => l10n.errorMinPhotos,
      CrewModeRequiredFailure() => l10n.errorCrewModeRequired,
      CrewNeedsEventFailure() => l10n.errorCrewNeedsEvent,
      VerificationPendingFailure() => l10n.verificationPendingBody,
      AlreadyVerifiedFailure() => l10n.verificationApprovedTitle,
      ReferralFailure(:final problem) => l10n.referralError(problem.name),
      EventLinkFailure(:final problem) => l10n.eventImportError(problem.name),
      VenueUnavailableFailure() => l10n.errorVenueUnavailable,
      VenueReviewNotAllowedFailure() => l10n.venueRateOnlyWent,
      FeaturedLimitFailure() => l10n.errorFeaturedLimit,
      AccountPausedFailure() => l10n.errorAccountPaused,
      FeaturedUnavailableFailure() => l10n.errorFeaturedUnavailable,
      LikeLimitFailure() => l10n.errorLikeLimit,
      SuperlikeLimitFailure() => l10n.errorSuperlikeLimit,
      PlanRequiredFailure() => l10n.errorPlanRequired,
      BoostUnavailableFailure() => l10n.errorBoostUnavailable,
      BoostActiveFailure() => l10n.errorBoostActive,
      UnknownFailure() => l10n.errorUnknown,
    };
  }
}

/// Friendly message for any error caught by the UI (e.g. `AsyncValue.error`).
String friendlyErrorMessage(Object error, AppLocalizations l10n) =>
    AppFailure.from(error).message(l10n);
