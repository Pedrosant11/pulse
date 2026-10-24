import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/events/data/events_repository.dart';
import 'package:pulse/features/events/domain/check_in.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/events/presentation/widgets/event_night.dart';
import 'package:pulse/features/profile/data/location_repository.dart';
import 'package:pulse/l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _FakeEvents implements EventsRepository {
  new({this.refuse});

  /// Server hint to refuse with (e.g. `checkin_too_far`).
  final String? refuse;
  final calls = <String>[];

  @override
  Future<void> checkInGps(
    String eventId, {
    required double lat,
    required double lng,
    required double accuracy,
    required bool mocked,
  }) async {
    calls.add('gps:$lat,$lng,$accuracy,$mocked');
    if (refuse != null) {
      throw AppFailure.from(
        PostgrestException(message: 'no', code: 'P0001', hint: refuse),
      );
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeLocation implements LocationRepository {
  @override
  Future<({double lat, double lng, double accuracy, bool mocked})>
  precisePosition() async =>
      (lat: -22.8975, lng: -43.185, accuracy: 25.0, mocked: false);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final _start = DateTime(2026, 11, 6, 23);
final _event = EventDetail(
  id: 'e1',
  name: 'Beltran na D-EDGE Rio',
  venueName: 'D-EDGE Rio',
  city: 'Rio de Janeiro',
  state: 'RJ',
  startsAt: _start,
  endsAt: _start.add(const Duration(hours: 7)),
  status: EventStatus.approved,
);

Widget _app(_FakeEvents repository, {DateTime? checkedInAt}) => ProviderScope(
  overrides: [
    eventsRepositoryProvider.overrideWithValue(repository),
    locationRepositoryProvider.overrideWithValue(_FakeLocation()),
    currentUserIdProvider.overrideWithValue('me'),
    isAttendingProvider('e1').overrideWith((ref) async => false),
    isOnProvider('e1').overrideWith((ref) async => false),
    eventOnPeopleProvider('e1').overrideWith((ref) async => const []),
    myCheckInProvider('e1').overrideWith((ref) async => checkedInAt),
  ],
  child: MaterialApp(
    theme: AppTheme.dark(),
    locale: const Locale('pt', 'BR'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    home: Scaffold(
      body: SingleChildScrollView(
        child: EventNightSection(
          event: _event,
          now: _start.add(const Duration(hours: 2)),
        ),
      ),
    ),
  ),
);

Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  group('check-in rules shown by the app', () {
    test('opens 1 h before the start and closes at the end', () {
      bool open(DateTime now) =>
          checkInOpen(startsAt: _start, endsAt: _event.endsAt, now: now);
      expect(open(_start.subtract(const Duration(minutes: 61))), isFalse);
      expect(open(_start.subtract(const Duration(minutes: 59))), isTrue);
      expect(open(_event.endsAt.subtract(const Duration(minutes: 1))), isTrue);
      expect(open(_event.endsAt), isFalse);
    });

    test("reads only this party's QR, or a typed code", () {
      final payload = checkInQrPayload('e1', 'A1B2C3D4');
      expect(parseCheckInQr(payload, 'e1'), 'A1B2C3D4');
      expect(parseCheckInQr(payload, 'e2'), isNull);
      expect(parseCheckInQr(' a1b2c3d4 ', 'e1'), 'a1b2c3d4');
      expect(parseCheckInQr('https://instagram.com/dedge', 'e1'), isNull);
    });

    test('the producer panel counts check-ins', () {
      final insights = EventInsights.fromJson(const {
        'going': 40,
        'checked_in': 23,
        'breakdowns_hidden': false,
      });
      expect(insights.checkedIn, 23);
    });
  });

  testWidgets('"Tô aqui" sends one reading and confirms', (tester) async {
    final repository = _FakeEvents();
    await tester.pumpWidget(_app(repository));
    await settle(tester);
    expect(find.text('Check-in'), findsOneWidget);
    await tester.tap(find.text('Tô aqui'));
    await settle(tester);
    expect(repository.calls, ['gps:-22.8975,-43.185,25.0,false']);
    expect(
      find.text('Check-in feito! Essa festa conta para suas conquistas.'),
      findsOneWidget,
    );
  });

  testWidgets('far from the party: explains and offers the QR', (tester) async {
    await tester.pumpWidget(_app(_FakeEvents(refuse: 'checkin_too_far')));
    await settle(tester);
    await tester.tap(find.text('Tô aqui'));
    await settle(tester);
    expect(find.textContaining('longe da festa'), findsOneWidget);
  });

  testWidgets('already checked in: shows the time', (tester) async {
    await tester.pumpWidget(
      _app(_FakeEvents(), checkedInAt: DateTime(2026, 11, 7, 0, 42)),
    );
    await settle(tester);
    expect(find.text('Check-in feito às 00:42'), findsOneWidget);
    expect(find.text('Tô aqui'), findsNothing);
  });
}
