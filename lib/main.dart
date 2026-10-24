import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/app.dart';
import 'package:pulse/core/config/env.dart';
import 'package:pulse/core/config/env_provider.dart';
import 'package:pulse/core/errors/crash_reporter.dart';
import 'package:pulse/features/ads/data/ad_network.dart';
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
  final firebase = await _startFirebase();
  if (firebase) await _startCrashReports();

  runApp(
    ProviderScope(
      overrides: [
        envProvider.overrideWithValue(env),
        if (firebase)
          pushMessagingProvider.overrideWithValue(FirebasePushMessaging()),
        if (await _startStore(env))
          storePurchasesProvider.overrideWithValue(const RevenueCatPurchases()),
        if (await _startAds(env) case final ads?)
          adNetworkProvider.overrideWithValue(ads),
      ],
      child: const PulseApp(),
    ),
  );
}

/// Crash reports (Firebase Crashlytics), only in release builds: Flutter
/// and platform errors, plus unexpected server errors (`guardFailures`).
/// Tagged with the account's random id so a report can be traced to a
/// support request; nothing else about the person.
Future<void> _startCrashReports() async {
  try {
    final crashlytics = FirebaseCrashlytics.instance;
    await crashlytics.setCrashlyticsCollectionEnabled(kReleaseMode);
    if (!kReleaseMode) return;
    const reporter = FirebaseCrashReporter();
    crashReporter = reporter;
    FlutterError.onError = crashlytics.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stackTrace) {
      reporter.record(error, stackTrace, fatal: true);
      return true;
    };
    final auth = Supabase.instance.client.auth;
    reporter.setUser(auth.currentUser?.id);
    auth.onAuthStateChange.listen(
      (state) => reporter.setUser(state.session?.user.id),
    );
  } on Object catch (error) {
    debugPrint('Crashlytics unavailable: $error');
  }
}

/// Firebase: push notifications and crash reports. On Android it reads
/// `google-services.json`; without a config (e.g. iOS for now) the app runs
/// without them.
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

/// Google ads fill the ad slots when there's no own ad. Without an ad unit
/// id (local dev, before the AdMob account exists) only own ads show.
Future<AdNetwork?> _startAds(Env env) async {
  final unit = switch (defaultTargetPlatform) {
    TargetPlatform.android => env.admobNativeAndroid,
    TargetPlatform.iOS => env.admobNativeIos,
    _ => null,
  };
  if (unit == null) return null;
  try {
    return await GoogleAdNetwork.start(unit);
  } on Object catch (error) {
    debugPrint('AdMob unavailable, own ads only: $error');
    return null;
  }
}
