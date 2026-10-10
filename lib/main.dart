import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/app.dart';
import 'package:pulse/core/config/env.dart';
import 'package:pulse/core/config/env_provider.dart';
import 'package:pulse/features/notifications/data/push_messaging.dart';
import 'package:pulse/features/plans/data/store_purchases.dart';
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
        if (await _startStore(env))
          storePurchasesProvider.overrideWithValue(const RevenueCatPurchases()),
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

/// Store purchases go through RevenueCat. Without its key (local dev,
/// before the stores are set up) the plans show without buying.
Future<bool> _startStore(Env env) async {
  final key = switch (defaultTargetPlatform) {
    TargetPlatform.android => env.revenueCatGoogleKey,
    TargetPlatform.iOS => env.revenueCatAppleKey,
    _ => null,
  };
  if (key == null) return false;
  try {
    await RevenueCatPurchases.configure(key);
    return true;
  } on Object catch (error) {
    debugPrint('RevenueCat unavailable, purchases disabled: $error');
    return false;
  }
}
