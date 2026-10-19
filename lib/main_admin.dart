import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/config/env.dart';
import 'package:pulse/core/config/env_provider.dart';
import 'package:pulse/features/admin_web/presentation/admin_web_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Admin web console (published at /admin next to the public site):
///
///   flutter build web -t lib/main_admin.dart --dart-define-from-file=env.json
///
/// Same Supabase project and the same admin RPCs as the app; the database
/// decides what an admin can do.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'pt_BR';

  final env = Env.fromEnvironment();
  await Supabase.initialize(
    url: env.supabaseUrl,
    publishableKey: env.supabasePublishableKey,
  );

  runApp(
    ProviderScope(
      overrides: [envProvider.overrideWithValue(env)],
      child: const AdminWebApp(),
    ),
  );
}
