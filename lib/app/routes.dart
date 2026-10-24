import 'package:pulse/features/auth/domain/session_status.dart';
import 'package:pulse/features/legal/domain/legal_document.dart';
import 'package:pulse/features/plans/domain/plan_models.dart';

/// Route paths. Use the helpers for paths with parameters.
abstract final class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const signup = '/signup';
  static const checkEmail = '/signup/check-email';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  static const accountSetup = '/account-setup';
  static const onboarding = '/onboarding';

  static const discover = '/discover';
  static const match = '/match';
  static const events = '/events';
  static const newEvent = '/events/new';
  static const eventQueue = '/events/queue';
  static const chats = '/chats';
  static const profile = '/profile';
  static const editProfile = '/profile/edit';
  static const crews = '/crews';
  static const settings = '/settings';
  static const roleRequest = '/settings/role-request';
  static const badgeRequest = '/settings/badge-request';
  static const verification = '/settings/verification';
  static const referral = '/settings/referral';
  static const blockedUsers = '/settings/blocked';
  static const deleteAccount = '/settings/delete-account';
  static const activateModes = '/activate-modes';
  static const plans = '/plans';
  static const likesYou = '/likes';
  static const safetyTips = '/safety-tips';
  static const accountRestricted = '/account-restricted';
  static const admin = '/admin';
  static const adminReports = '/admin/reports';
  static const adminRestricted = '/admin/restricted';
  static const adminBadges = '/admin/badges';
  static const adminVerifications = '/admin/verifications';
  static const adminFeatured = '/admin/featured';
  static const adminAds = '/admin/ads';
  static const adminAdForm = '/admin/ads/edit';
  static const legalPrefix = '/legal';

  static const venues = '/events/venues';
  static const newVenue = '/events/venues/new';
  static String newVenueNamed(String name) => Uri(
    path: newVenue,
    queryParameters: {if (name.isNotEmpty) 'name': name},
  ).toString();
  static String venue(String venueId) => '$venues/$venueId';
  static String editVenue(String venueId) => '$venues/$venueId/edit';
  static String afterParty(String eventId) => '$discover/after-party/$eventId';
  static String eventDetail(String eventId) => '$events/$eventId';
  static String editEvent(String eventId) => '$events/$eventId/edit';
  static String duplicateEvent(String eventId) =>
      Uri(path: newEvent, queryParameters: {'from': eventId}).toString();
  static String eventInsights(String eventId) => '$events/$eventId/insights';
  static String checkInScan(String eventId) =>
      '$events/$eventId/check-in/scan';
  static String checkInQr(String eventId) => '$events/$eventId/check-in/qr';
  static String conversation(String conversationId) => '$chats/$conversationId';
  static String editProfileSection(String section) => '$editProfile/$section';
  static String crew(String crewId) => '$crews/$crewId';
  static String editCrew(String crewId) => '$crews/$crewId/edit';
  static String newCrew({
    required String eventId,
    String? eventName,
    String? inviteUserId,
    String? inviteName,
  }) => Uri(
    path: '$crews/new',
    queryParameters: {
      'event': eventId,
      'event_name': ?eventName,
      'invite': ?inviteUserId,
      'invite_name': ?inviteName,
    },
  ).toString();
  static String legal(LegalDocument doc) => '$legalPrefix/${doc.slug}';
  static String plansFor(PlanFeature feature) =>
      Uri(path: plans, queryParameters: {'feature': feature.name}).toString();
  static String checkEmailFor(String email) =>
      Uri(path: checkEmail, queryParameters: {'email': email}).toString();

  /// Reachable without a session.
  static const Set<String> publicPaths = {
    login,
    signup,
    checkEmail,
    forgotPassword,
  };
}

/// Pure redirect rule, kept apart from GoRouter so it can be unit tested.
/// Returns the path to go to, or `null` to stay on [location]. [home] is
/// where a ready user lands (Events for "events only" profiles).
String? resolveRedirect({
  required SessionStatus status,
  required String location,
  String home = AppRoutes.discover,
}) {
  // Legal documents are readable in any state (sign-up terms step, stores).
  if (location.startsWith('${AppRoutes.legalPrefix}/')) return null;
  final isPublic = AppRoutes.publicPaths.contains(location);
  String? only(String path) => location == path ? null : path;

  switch (status) {
    case SessionStatus.unknown:
      return only(AppRoutes.splash);
    case SessionStatus.signedOut:
      return isPublic ? null : AppRoutes.login;
    case SessionStatus.passwordRecovery:
      return only(AppRoutes.resetPassword);
    case SessionStatus.restricted:
      // Deleting the account stays possible (LGPD, store rules).
      return location == AppRoutes.deleteAccount
          ? null
          : only(AppRoutes.accountRestricted);
    case SessionStatus.needsAccountSetup:
      return only(AppRoutes.accountSetup);
    case SessionStatus.needsOnboarding:
      return only(AppRoutes.onboarding);
    case SessionStatus.ready:
      final isEntryFlow =
          isPublic ||
          location == AppRoutes.splash ||
          location == AppRoutes.resetPassword ||
          location == AppRoutes.accountRestricted ||
          location == AppRoutes.accountSetup ||
          location == AppRoutes.onboarding;
      return isEntryFlow ? home : null;
  }
}
