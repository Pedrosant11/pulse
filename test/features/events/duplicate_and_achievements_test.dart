import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/core/models/user_role.dart';
import 'package:pulse/features/achievements/domain/achievement.dart';
import 'package:pulse/features/achievements/presentation/achievements_providers.dart';
import 'package:pulse/features/achievements/presentation/widgets/achievements.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/presentation/event_form_screen.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/profile/domain/profile.dart';
import 'package:pulse/features/profile/domain/profile_enums.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/l10n/app_localizations.dart';

Widget _app(Widget home, List<Object> overrides) => ProviderScope(
  overrides: [
    myProfileProvider.overrideWith(
      (ref) async => const MyProfile(id: 'u1', role: UserRole.producer),
    ),
    ...overrides.cast(),
  ],
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

void main() {
  testWidgets('"Duplicar festa": a new event filled from the old one', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(420, 3200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final start = DateTime.now().add(const Duration(days: 1));
    final source = EventDetail(
      id: 'e1',
      name: 'Ritual',
      venueName: 'Galpão 23',
      city: 'São Paulo',
      state: 'SP',
      startsAt: DateTime(start.year, start.month, start.day, 23),
      endsAt: DateTime(start.year, start.month, start.day + 1, 7),
      status: EventStatus.approved,
      genres: const [MusicGenre.techno],
      lineup: const ['Charlotte de Witte'],
      ticketCoupon: 'SANT',
    );
    await tester.pumpWidget(
      _app(const EventFormScreen(copyOfId: 'e1'), [
        eventDetailProvider('e1').overrideWith((ref) async => source),
        eventVenueProvider('e1').overrideWith((ref) async => null),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.text('NOVA EDIÇÃO'), findsOneWidget);
    expect(find.text('Ritual'), findsOneWidget);
    expect(find.text('Galpão 23'), findsOneWidget);
    expect(find.text('Charlotte de Witte'), findsOneWidget);
    expect(find.text('SANT'), findsOneWidget);
    // A week later, same time: the date field shows the new day.
    final next = source.startsAt.add(const Duration(days: 7));
    expect(find.textContaining('${next.day} de'), findsWidgets);
    // Still a new event (create/suggest, not "Salvar").
    expect(find.text('Publicar evento'), findsOneWidget);
  });

  testWidgets('my profile: conquistas with progress, passport with totals', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(420, 2000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      _app(
        const Scaffold(
          body: SingleChildScrollView(
            child: Column(children: [AchievementsSection(), PassportCard()]),
          ),
        ),
        [
          myAchievementsProvider.overrideWith(
            (ref) async => const [
              Achievement(
                key: AchievementKey.firstParty,
                progress: 1,
                goal: 1,
                unlocked: true,
              ),
              Achievement(
                key: AchievementKey.partyAnimal,
                progress: 3,
                goal: 5,
                unlocked: false,
              ),
            ],
          ),
          myPassportProvider.overrideWith(
            (ref) async => Passport(
              parties: 5,
              venues: 2,
              cities: 1,
              genres: 3,
              entries: [
                EventSummary(
                  id: 'e1',
                  name: 'Ritual',
                  venueName: 'Galpão 23',
                  city: 'São Paulo',
                  state: 'SP',
                  startsAt: DateTime(2026, 9, 12, 23),
                  endsAt: DateTime(2026, 9, 13, 7),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('CONQUISTAS (1/2)'), findsOneWidget);
    expect(find.text('Primeira festa'), findsOneWidget);
    expect(find.text('3/5'), findsOneWidget);
    expect(find.text('PASSAPORTE'), findsOneWidget);
    expect(find.text('Ritual'), findsOneWidget);
    expect(find.text('Ver mais 4 festas com o Pulse Black'), findsOneWidget);
  });
}
