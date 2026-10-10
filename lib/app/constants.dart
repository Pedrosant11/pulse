/// App-wide constants. The product name is provisional (SPEC header):
/// to rename, change [AppConstants.appName], `appTitle` in the ARB files and
/// the platform labels (AndroidManifest.xml and Info.plist).
abstract final class AppConstants {
  static const appName = 'Pulse';

  /// Minimum age to use the app (also enforced in the database).
  static const minAge = 18;

  /// Version of the Terms of Use / Privacy Policy the user accepts (SPEC 5.1).
  static const termsVersion = '2026-10-04';

  static const minProfilePhotos = 2;
  static const maxProfilePhotos = 6;
  static const maxBioLength = 500;
  static const maxFavoriteDjs = 10;
  static const maxCrewMembers = 8;
  static const maxMessageLength = 2000;
  static const messagesPageSize = 30;

  /// Deep link that e-mail links (confirmation, password reset) open.
  /// Must be listed in Supabase Auth → URL Configuration → Redirect URLs.
  static const authRedirectUrl = 'com.pulseapp.pulse://login-callback';

  /// Extra code step after password login (SPEC 5.2). Off until the launch
  /// phase, when phone MFA is enabled in Supabase.
  static const loginSecondFactorEnabled = false;
}
