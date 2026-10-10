import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pulse/features/notifications/data/push_messaging.dart';
import 'package:pulse/features/notifications/data/push_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'push_registration.g.dart';

/// Links this device to the signed-in account for push notifications.
/// Failures are only logged: notifications must never block the app or
/// signing out.
@Riverpod(keepAlive: true)
class PushRegistration extends _$PushRegistration {
  StreamSubscription<String>? _refresh;
  String? _token;

  @override
  void build() {
    ref.onDispose(() => _refresh?.cancel());
  }

  String get _platform =>
      defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android';

  /// Asks permission and saves the token (on entering the app).
  Future<void> enable() async {
    final messaging = ref.read(pushMessagingProvider);
    try {
      if (!await messaging.requestPermission()) return;
      final token = await messaging.getToken();
      if (token == null) return;
      await _save(token);
      await _refresh?.cancel();
      _refresh = messaging.onTokenRefresh.listen(
        (token) => unawaited(_save(token)),
      );
    } on Object catch (error) {
      debugPrint('Push setup failed: $error');
    }
  }

  Future<void> _save(String token) async {
    try {
      await ref
          .read(pushRepositoryProvider)
          .register(token, platform: _platform);
      _token = token;
    } on Object catch (error) {
      debugPrint('Push token not saved: $error');
    }
  }

  /// Before signing out: this device (or every device) stops getting the
  /// account's notifications.
  Future<void> disable({bool allDevices = false}) async {
    await _refresh?.cancel();
    _refresh = null;
    final messaging = ref.read(pushMessagingProvider);
    try {
      final repository = ref.read(pushRepositoryProvider);
      if (allDevices) {
        await repository.unregisterAll();
      } else {
        final token = _token ?? await messaging.getToken();
        if (token != null) await repository.unregister(token);
      }
      await messaging.deleteToken();
    } on Object catch (error) {
      debugPrint('Push token not removed: $error');
    }
    _token = null;
  }
}
