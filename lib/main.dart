import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/app.dart';
import 'package:pulse/core/config/env.dart';
import 'package:pulse/core/config/env_provider.dart';
import 'package:pulse/features/notifications/data/push_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      overrides: [
        envProvider.overrideWithValue(env),
        if (await _startFirebase())
          pushMessagingProvider.overrideWithValue(FirebasePushMessaging()),
      ],
      child: const PulseApp(),
    ),
  );
}

/// Firebase is used only for push notifications. On Android it reads
/// `google-services.json`; without a config (e.g. iOS for now) the app runs
/// without notifications.
Future<bool> _startFirebase() async {
  try {
    await Firebase.initializeApp();
    return true;
  } on Object catch (error) {
    debugPrint('Firebase unavailable, push disabled: $error');
    return false;
  }
}
