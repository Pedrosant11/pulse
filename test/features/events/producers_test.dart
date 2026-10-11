import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/presentation/event_insights_screen.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/events/presentation/widgets/event_visuals.dart';
import 'package:pulse/features/profile/domain/profile_enums.dart';
import 'package:pulse/l10n/app_localizations.dart';

Widget _app(Widget home, List<Object> overrides) => ProviderScope(
  overrides: overrides.cast(),
  child: MaterialApp(
    theme: AppTheme.dark(),
    locale: const Locale('pt', 'BR'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    home: home,
  ),
);

Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

final _event = EventDetail(
  id: 'e1',
  name: 'Noite Ácida',
  venueName: 'D-Edge',
  city: 'São Paulo',
  state: 'SP',
  startsAt: DateTime(2026, 10, 17, 23),
  endsAt: DateTime(2026, 10, 18, 8),
  status: EventStatus.approved,
);

void main() {
  test('insights parse the database numbers and breakdowns', () {
    final insights = EventInsights.fromJson({
      'going': 7,
      'going_date': 5,
      'going_crew': 4,
      'ticket_clicks': 3,
      'crews': 1,
      'breakdowns_hidden': false,
      'genres': [
        {'genre': 'hard_techno', 'count': 4},
      ],
      'cities': [
        {'city': 'São Paulo', 'state': 'SP', 'count': 6},
      ],
      'genders': {'woman': 4, 'man': 3},
      'ages': {'18_24': 2, '25_34': 4, '35_plus': 1},
    });
    expect(insights.going, 7);
    expect(insights.genres.single.genre, MusicGenre.hardTechno);
    expect(insights.cities.single.label, 'São Paulo, SP');
    expect(insights.ages['25_34'], 4);
  });

  testWidgets('the panel shows totals and breakdowns', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      _app(const EventInsightsScreen(eventId: 'e1'), [
        eventDetailProvider('e1').overrideWith((ref) async => _event),
        eventInsightsProvider('e1').overrideWith(
          (ref) async => const EventInsights(
            going: 7,
            goingDate: 5,
            goingCrew: 4,
            ticketClicks: 3,
            crews: 1,
            breakdownsHidden: false,
            genres: [(genre: MusicGenre.techno, count: 6)],
            cities: [(label: 'São Paulo, SP', count: 6)],
            genders: {'woman': 4, 'man': 3},
            ages: {'18_24': 2, '25_34': 4, '35_plus': 1},
          ),
        ),
      ]),
    );
    await settle(tester);
    expect(find.text('Pessoas vão'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
    expect(find.text('Techno'), findsOneWidget);
    expect(find.text('São Paulo, SP'), findsOneWidget);
    expect(find.text('25–34'), findsOneWidget);
  });

  testWidgets('few people: breakdowns are hidden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      _app(const EventInsightsScreen(eventId: 'e1'), [
        eventDetailProvider('e1').overrideWith((ref) async => _event),
        eventInsightsProvider('e1').overrideWith(
          (ref) async => const EventInsights(
            going: 2,
            goingDate: 1,
            goingCrew: 1,
            ticketClicks: 0,
            crews: 0,
            breakdownsHidden: true,
          ),
        ),
      ]),
    );
    await settle(tester);
    expect(
      find.text(
        'Os detalhes do público aparecem a partir de 5 pessoas confirmadas.',
      ),
      findsOneWidget,
    );
    expect(find.text('IDADE'), findsNothing);
  });

  testWidgets('a featured event card shows the highlight', (tester) async {
    await tester.pumpWidget(
      _app(
        Scaffold(
          body: EventCard(
            event: EventListEntry(
              id: 'e1',
              name: 'Noite Ácida',
              venueName: 'D-Edge',
              city: 'São Paulo',
              state: 'SP',
              startsAt: DateTime(2026, 10, 17, 23),
              endsAt: DateTime(2026, 10, 18, 8),
              status: EventStatus.approved,
              isFeatured: true,
            ),
            onTap: () {},
          ),
        ),
        const [],
      ),
    );
    await settle(tester);
    expect(find.text('Destaque'), findsOneWidget);
  });
}
