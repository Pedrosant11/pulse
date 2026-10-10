/// Build-time configuration, injected with
/// `flutter run --dart-define-from-file=env.json`.
///
/// Only public values belong here. Never put the service role key in the app.
class Env {
  const new({required this.supabaseUrl, required this.supabasePublishableKey});

  /// Reads and validates the values compiled into the app.
  factory fromEnvironment() => Env.parse(
    supabaseUrl: const String.fromEnvironment('SUPABASE_URL'),
    supabasePublishableKey: const String.fromEnvironment(
      'SUPABASE_PUBLISHABLE_KEY',
    ),
  );

  /// Validates raw values, failing fast with a message aimed at developers.
  factory parse({
    required String supabaseUrl,
    required String supabasePublishableKey,
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
    return Env(
      supabaseUrl: supabaseUrl.trim(),
      supabasePublishableKey: supabasePublishableKey.trim(),
    );
  }

  final String supabaseUrl;
  final String supabasePublishableKey;
}
