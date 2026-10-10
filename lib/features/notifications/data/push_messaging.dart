import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'push_messaging.g.dart';

/// Device side of push notifications. Firebase is only the carrier: the
/// token is stored in Supabase and the database decides what to send.
abstract interface class PushMessaging {
  /// Asks the system permission (Android 13+, iOS). Returns whether granted.
  Future<bool> requestPermission();

  Future<String?> getToken();

  Stream<String> get onTokenRefresh;

  Future<void> deleteToken();

  /// Data of the notification that opened the app from a closed state.
  Future<Map<String, dynamic>?> initialMessageData();

  /// Data of notifications tapped while the app was in the background.
  Stream<Map<String, dynamic>> get onMessageOpened;

  /// Data of notifications received while the app is open (the system does
  /// not show them).
  Stream<Map<String, dynamic>> get onForegroundMessage;
}

/// Used when Firebase is not configured (tests, iOS before its setup).
class DisabledPushMessaging implements PushMessaging {
  const new();

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<String?> getToken() async => null;

  @override
  Stream<String> get onTokenRefresh => const Stream.empty();

  @override
  Future<void> deleteToken() async {}

  @override
  Future<Map<String, dynamic>?> initialMessageData() async => null;

  @override
  Stream<Map<String, dynamic>> get onMessageOpened => const Stream.empty();

  @override
  Stream<Map<String, dynamic>> get onForegroundMessage => const Stream.empty();
}

class FirebasePushMessaging implements PushMessaging {
  new([FirebaseMessaging? messaging])
    : _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;

  @override
  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  @override
  Future<String?> getToken() => _messaging.getToken();

  @override
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  @override
  Future<void> deleteToken() => _messaging.deleteToken();

  @override
  Future<Map<String, dynamic>?> initialMessageData() async =>
      (await _messaging.getInitialMessage())?.data;

  @override
  Stream<Map<String, dynamic>> get onMessageOpened =>
      FirebaseMessaging.onMessageOpenedApp.map((message) => message.data);

  @override
  Stream<Map<String, dynamic>> get onForegroundMessage =>
      FirebaseMessaging.onMessage.map((message) => message.data);
}

/// Disabled by default; `main.dart` swaps in Firebase once it starts.
@Riverpod(keepAlive: true)
PushMessaging pushMessaging(Ref ref) => const DisabledPushMessaging();
