import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/core/models/user_role.dart';
import 'package:pulse/features/events/data/events_repository.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/events/presentation/events_screen.dart';
import 'package:pulse/features/profile/domain/profile.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/l10n/app_localizations.dart';

EventListEntry _event(String id, {int going = 0, bool isGoing = false}) =>
    EventListEntry(
      id: id,
      name: 'Festa $id',
      venueName: 'Galpão',
      city: 'Rio de Janeiro',
      state: 'RJ',
      startsAt: DateTime.utc(2026, 10, 10, 2),
      endsAt: DateTime.utc(2026, 10, 10, 10),
      status: EventStatus.approved,
      goingCount: going,
      isGoing: isGoing,
      distanceKm: 4,
    );

void main() {
  Future<void> pump(
    WidgetTester tester, {
    required List<EventListEntry> nearby,
    UserRole role = UserRole.user,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          myProfileProvider.overrideWith(
            (ref) async => MyProfile(
              id: 'u1',
              city: 'Rio de Janeiro',
              state: 'RJ',
              role: role,
            ),
          ),
          eventListProvider(EventListScope.nearby)
              .overrideWith((ref) async => nearby),
          eventListProvider(EventListScope.mine)
              .overrideWith((ref) async => const []),
        ],
        child: MaterialApp(
          theme: AppTheme.dark(),
          locale: const Locale('pt', 'BR'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          home: const EventsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('lists nearby events with the going count and radius', (
    tester,
  ) async {
    await pump(tester, nearby: [_event('A', going: 3, isGoing: true)]);
    expect(find.text('Festa A'), findsOneWidget);
    expect(find.text('3 pessoas vão'), findsOneWidget);
    expect(find.text('Vou!'), findsOneWidget);
    expect(find.text('Até 50 km de Rio de Janeiro'), findsOneWidget);
  });

  testWidgets('empty nearby list suggests creating an event', (tester) async {
    await pump(tester, nearby: const []);
    expect(find.text('Nenhum evento perto de você'), findsOneWidget);
    expect(find.text('Sugerir evento'), findsOneWidget);
  });

  testWidgets('regular users suggest events and see no queue', (tester) async {
    await pump(tester, nearby: const []);
    expect(find.byTooltip('Fila de aprovação'), findsNothing);
    expect(find.byTooltip('Sugerir evento'), findsOneWidget);
  });

  testWidgets('curators create events and see the queue', (tester) async {
    await pump(tester, nearby: const [], role: UserRole.curator);
    expect(find.byTooltip('Fila de aprovação'), findsOneWidget);
    expect(find.byTooltip('Criar evento'), findsOneWidget);
  });

  testWidgets('"Meus eventos" tab has its own empty state', (tester) async {
    await pump(tester, nearby: const []);
    await tester.tap(find.text('Meus eventos'));
    await tester.pumpAndSettle();
    expect(find.text('Você ainda não marcou nenhum evento'), findsOneWidget);
  });
}
