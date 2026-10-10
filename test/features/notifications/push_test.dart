import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/features/notifications/data/push_messaging.dart';
import 'package:pulse/features/notifications/data/push_repository.dart';
import 'package:pulse/features/notifications/domain/push_route.dart';
import 'package:pulse/features/notifications/presentation/push_registration.dart';

class FakeMessaging extends DisabledPushMessaging {
  new({this.granted = true, this.token = 'tok-1'});

  final bool granted;
  String? token;
  bool deleted = false;
  final refresh = StreamController<String>.broadcast();

  @override
  Future<bool> requestPermission() async => granted;

  @override
  Future<String?> getToken() async => token;

  @override
  Stream<String> get onTokenRefresh => refresh.stream;

  @override
  Future<void> deleteToken() async => deleted = true;
}

class FakePushRepository implements PushRepository {
  final registered = <String>[];
  final unregistered = <String>[];
  bool unregisteredAll = false;
  bool fail = false;

  @override
  Future<void> register(String token, {required String platform}) async {
    if (fail) throw StateError('offline');
    registered.add('$platform:$token');
  }

  @override
  Future<void> unregister(String token) async {
    if (fail) throw StateError('offline');
    unregistered.add(token);
  }

  @override
  Future<void> unregisterAll() async => unregisteredAll = true;
}

void main() {
  group('routeFromPushData', () {
    const id = '00000000-0000-4000-c000-000000000017';

    test('opens the conversation, crew or inbox', () {
      expect(routeFromPushData({'route': '/chats/$id'}), '/chats/$id');
      expect(routeFromPushData({'route': '/crews/$id'}), '/crews/$id');
      expect(routeFromPushData({'route': '/chats'}), '/chats');
    });

    test('anything else falls back to the inbox', () {
      expect(routeFromPushData({}), '/chats');
      expect(routeFromPushData({'route': '/admin'}), '/chats');
      expect(routeFromPushData({'route': '/chats/not-an-id'}), '/chats');
      expect(routeFromPushData({'route': '/crews/$id/edit'}), '/chats');
      expect(routeFromPushData({'route': 42}), '/chats');
    });
  });

  group('PushRegistration', () {
    late FakeMessaging messaging;
    late FakePushRepository repository;

    ProviderContainer container() {
      final container = ProviderContainer(
        overrides: [
          pushMessagingProvider.overrideWithValue(messaging),
          pushRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      return container;
    }

    setUp(() {
      messaging = FakeMessaging();
      repository = FakePushRepository();
    });

    test('saves the token and follows refreshes', () async {
      final push = container().read(pushRegistrationProvider.notifier);
      await push.enable();
      expect(repository.registered, ['android:tok-1']);

      messaging.refresh.add('tok-2');
      await pumpEventQueue();
      expect(repository.registered, ['android:tok-1', 'android:tok-2']);
    });

    test('without permission nothing is saved', () async {
      messaging = FakeMessaging(granted: false);
      await container().read(pushRegistrationProvider.notifier).enable();
      expect(repository.registered, isEmpty);
    });

    test('signing out removes this device', () async {
      final push = container().read(pushRegistrationProvider.notifier);
      await push.enable();
      await push.disable();
      expect(repository.unregistered, ['tok-1']);
      expect(messaging.deleted, isTrue);
    });

    test('signing out of all devices removes every token', () async {
      await container()
          .read(pushRegistrationProvider.notifier)
          .disable(allDevices: true);
      expect(repository.unregisteredAll, isTrue);
    });

    test('failures never reach the caller', () async {
      repository.fail = true;
      final push = container().read(pushRegistrationProvider.notifier);
      await expectLater(push.enable(), completes);
      await expectLater(push.disable(), completes);
    });
  });
}
