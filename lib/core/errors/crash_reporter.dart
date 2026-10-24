import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// Where unexpected errors go: Firebase Crashlytics in release builds, a
/// no-op otherwise (debug, tests, iOS until Firebase is set up there).
/// Only the error, the stack trace, the device model/OS and the account's
/// random id are sent; never names, messages or profile data.
abstract interface class CrashReporter {
  void record(Object error, StackTrace? stackTrace, {bool fatal = false});

  /// The signed-in account's id (a random uuid), or `null` after sign-out.
  void setUser(String? userId);
}

final class NoCrashReporter implements CrashReporter {
  const new();

  @override
  void record(Object error, StackTrace? stackTrace, {bool fatal = false}) {}

  @override
  void setUser(String? userId) {}
}

final class FirebaseCrashReporter implements CrashReporter {
  const new();

  @override
  void record(Object error, StackTrace? stackTrace, {bool fatal = false}) =>
      FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: fatal);

  @override
  void setUser(String? userId) =>
      FirebaseCrashlytics.instance.setUserIdentifier(userId ?? '');
}

/// Set once by `main()`; `guardFailures` reports unexpected errors here.
CrashReporter crashReporter = const NoCrashReporter();
