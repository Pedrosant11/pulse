import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/events/data/events_repository.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/events/presentation/widgets/event_night.dart';
import 'package:pulse/features/events/presentation/widgets/event_sections.dart';
import 'package:pulse/l10n/app_localizations.dart';

class _FakeEvents implements EventsRepository {
  final calls = <String>[];

  @override
  Future<void> setOn(String eventId, {required bool on}) async =>
      calls.add('on:$on');

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

Widget _app(
  Widget child,
  _FakeEvents repository, {
  bool going = true,
  bool on = false,
  DateTime? checkedInAt,
  List<OnPerson> people = const [],
  EventSections? sections,
}) => ProviderScope(
  overrides: [
    eventsRepositoryProvider.overrideWithValue(repository),
    currentUserIdProvider.overrideWithValue('me'),
    isAttendingProvider('e1').overrideWith((ref) async => going),
    isOnProvider('e1').overrideWith((ref) async => on),
    myCheckInProvider('e1').overrideWith((ref) async => checkedInAt),
    eventOnPeopleProvider('e1').overrideWith((ref) async => people),
    if (sections != null)
      eventSectionsProvider.overrideWith((ref) async => sections),
  ],
  child: MaterialApp(
    theme: AppTheme.dark(),
    locale: const Locale('pt', 'BR'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    home: Scaffold(body: SingleChildScrollView(child: child)),
  ),
);

Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  testWidgets('tonight: "Tô ON" with who of my people is ON', (tester) async {
    final repository = _FakeEvents();
    await tester.pumpWidget(
      _app(
        EventNightSection(
          event: _event,
          now: _start.subtract(const Duration(hours: 2)),
        ),
        repository,
        people: const [
          OnPerson(userId: 'a', firstName: 'Rafael'),
          OnPerson(userId: 'b', firstName: 'Bia'),
          OnPerson(userId: 'c', firstName: 'Enzo'),
        ],
      ),
    );
    await settle(tester);
    expect(find.text('Tô ON hoje'), findsOneWidget);
    expect(find.text('Rafael e mais 2 estão ON'), findsOneWidget);
    await tester.tap(find.byType(Switch));
    await settle(tester);
    expect(repository.calls, ['on:true']);
  });

  testWidgets('the day after: "Veja quem estava lá"', (tester) async {
    await tester.pumpWidget(
      _app(
        EventNightSection(
          event: _event,
          now: _event.endsAt.add(const Duration(hours: 5)),
        ),
        _FakeEvents(),
      ),
    );
    await settle(tester);
    expect(find.text('Veja quem estava lá'), findsOneWidget);
    expect(find.text('Tô ON hoje'), findsNothing);
  });

  testWidgets('nothing days before the party', (tester) async {
    await tester.pumpWidget(
      _app(
        EventNightSection(
          event: _event,
          now: _start.subtract(const Duration(days: 2)),
        ),
        _FakeEvents(),
      ),
    );
    await settle(tester);
    expect(find.byType(Switch), findsNothing);
  });

  testWidgets('who is not going: only the check-in', (tester) async {
    await tester.pumpWidget(
      _app(
        EventNightSection(event: _event, now: _start),
        _FakeEvents(),
        going: false,
      ),
    );
    await settle(tester);
    expect(find.text('Tô ON hoje'), findsNothing);
    // The check-in is for anyone at the party (it marks "Eu vou" too).
    expect(find.text('Tô aqui'), findsOneWidget);
  });

  testWidgets('sections show only the rows with parties', (tester) async {
    await tester.pumpWidget(
      _app(
        const EventSectionsView(),
        _FakeEvents(),
        sections: EventSections(
          trending: [
            SectionEvent(
              id: 'e1',
              name: 'BOMA',
              venueName: 'Edifício Touring',
              city: 'Rio de Janeiro',
              state: 'RJ',
              startsAt: _start,
              endsAt: _start.add(const Duration(hours: 8)),
              goingCount: 12,
            ),
          ],
        ),
      ),
    );
    await settle(tester);
    expect(find.text('EM ALTA'), findsOneWidget);
    expect(find.text('ESTA SEMANA'), findsNothing);
    expect(find.text('BOMA'), findsOneWidget);
    expect(find.text('12 pessoas vão'), findsOneWidget);
  });
}
