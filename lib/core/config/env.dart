/// Build-time configuration, injected with
/// `flutter run --dart-define-from-file=env.json`.
///
/// Only public values belong here. Never put the service role key in the app.
class Env {
  const new({
    required this.supabaseUrl,
    required this.supabasePublishableKey,
    this.revenueCatGoogleKey,
    this.revenueCatAppleKey,
    this.admobNativeAndroid,
    this.admobNativeIos,
  });

  /// Reads and validates the values compiled into the app.
  factory fromEnvironment() => Env.parse(
    supabaseUrl: const String.fromEnvironment('SUPABASE_URL'),
    supabasePublishableKey: const String.fromEnvironment(
      'SUPABASE_PUBLISHABLE_KEY',
    ),
    revenueCatGoogleKey: const String.fromEnvironment('REVENUECAT_GOOGLE_KEY'),
    revenueCatAppleKey: const String.fromEnvironment('REVENUECAT_APPLE_KEY'),
    admobNativeAndroid: const String.fromEnvironment('ADMOB_NATIVE_ANDROID'),
    admobNativeIos: const String.fromEnvironment('ADMOB_NATIVE_IOS'),
  );

  /// Validates raw values, failing fast with a message aimed at developers.
  factory parse({
    required String supabaseUrl,
    required String supabasePublishableKey,
    String? revenueCatGoogleKey,
    String? revenueCatAppleKey,
    String? admobNativeAndroid,
    String? admobNativeIos,
  }) {
    final missing = [
      if (supabaseUrl.trim().isEmpty) 'SUPABASE_URL',
      if (supabasePublishableKey.trim().isEmpty) 'SUPABASE_PUBLISHABLE_KEY',
    ];
    if (missing.isNotEmpty) {
      throw StateError(
        'Configuração ausente: ${missing.join(', ')}. '
        'Copie env.example.json para env.json, preencha os valores e rode '
        'com --dart-define-from-file=env.json.',
      );
    }
    final uri = Uri.tryParse(supabaseUrl.trim());
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      throw StateError('SUPABASE_URL inválida: "$supabaseUrl".');
    }
    String? optional(String? value) =>
        (value ?? '').trim().isEmpty ? null : value!.trim();
    return Env(
      supabaseUrl: supabaseUrl.trim(),
      supabasePublishableKey: supabasePublishableKey.trim(),
      revenueCatGoogleKey: optional(revenueCatGoogleKey),
      revenueCatAppleKey: optional(revenueCatAppleKey),
      admobNativeAndroid: optional(admobNativeAndroid),
      admobNativeIos: optional(admobNativeIos),
    );
  }

  final String supabaseUrl;
  final String supabasePublishableKey;

  /// RevenueCat public SDK keys (safe in the app). Without them the plans
  /// screen shows the plans but purchases are unavailable.
  final String? revenueCatGoogleKey;
  final String? revenueCatAppleKey;

  /// AdMob native ad unit ids (public). "test" uses Google's test ads;
  /// without them only the own ads (from the database) are shown.
  final String? admobNativeAndroid;
  final String? admobNativeIos;
}
