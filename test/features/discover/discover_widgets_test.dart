import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/core/models/app_mode.dart';
import 'package:pulse/features/ads/data/ads_repository.dart';
import 'package:pulse/features/ads/domain/ad_models.dart';
import 'package:pulse/features/ads/presentation/ads_providers.dart';
import 'package:pulse/features/discover/domain/discover_models.dart';
import 'package:pulse/features/discover/presentation/discover_providers.dart';
import 'package:pulse/features/discover/presentation/discover_screen.dart';
import 'package:pulse/features/discover/presentation/widgets/swipe_card.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/profile/domain/profile.dart';
import 'package:pulse/features/profile/domain/profile_enums.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/l10n/app_localizations.dart';

/// Lets async providers resolve and the following frames rebuild.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Widget _app(Widget child, {List<Object> overrides = const []}) {
  return ProviderScope(
    overrides: overrides.cast(),
    child: MaterialApp(
      theme: AppTheme.dark(),
      locale: const Locale('pt', 'BR'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      home: child,
    ),
  );
}

void main() {
  group('SwipeCard', () {
    Future<List<SwipeDirection>> pumpCard(
      WidgetTester tester, {
      SwipeCardController? controller,
    }) async {
      final swiped = <SwipeDirection>[];
      await tester.pumpWidget(
        _app(
          Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: SwipeCard(
                controller: controller,
                likeStamp: 'CURTI',
                passStamp: 'PASSO',
                likeColor: Colors.pink,
                onSwiped: swiped.add,
                onOpenProfile: () {},
                child: const ColoredBox(color: Colors.blue),
              ),
            ),
          ),
        ),
      );
      return swiped;
    }

    testWidgets('a long drag right likes, showing the stamp', (tester) async {
      final swiped = await pumpCard(tester);
      final gesture = await tester.startGesture(const Offset(200, 300));
      await gesture.moveBy(const Offset(80, 0));
      await tester.pump();
      expect(find.text('CURTI'), findsOneWidget);
      await gesture.moveBy(const Offset(120, 0));
      await gesture.up();
      await tester.pumpAndSettle();
      expect(swiped, [SwipeDirection.like]);
    });

    testWidgets('a short drag springs back', (tester) async {
      final swiped = await pumpCard(tester);
      await tester.timedDrag(
        find.byType(SwipeCard),
        const Offset(-40, 0),
        const Duration(milliseconds: 600),
      );
      await tester.pumpAndSettle();
      expect(swiped, isEmpty);
    });

    testWidgets('the controller flings the card (buttons)', (tester) async {
      final controller = SwipeCardController();
      final swiped = await pumpCard(tester, controller: controller);
      final done = controller.swipe(SwipeDirection.pass);
      await tester.pumpAndSettle();
      await done;
      expect(swiped, [SwipeDirection.pass]);
    });
  });

  group('DiscoverScreen', () {
    final ana = DiscoverCandidate(
      id: 'ana',
      firstName: 'Ana',
      age: 32,
      city: 'São Paulo',
      distanceKm: 3,
      commonEvents: [
        CommonEvent(
          id: 'e1',
          name: 'Noite Ácida',
          startsAt: DateTime(2026, 10, 10),
        ),
        CommonEvent(
          id: 'e2',
          name: 'Mamba Negra',
          startsAt: DateTime(2026, 10, 12),
        ),
      ],
      commonEventCount: 2,
    );

    List<Object> overrides(
      List<DiscoverCandidate> cards, {
      bool hasEvents = true,
      AppMode mode = AppMode.date,
      List<AppMode>? modes,
      DiscoverDeck Function()? deck,
      DateTime? pausedAt,
    }) => [
      myProfileProvider.overrideWith(
        (ref) async => MyProfile(
          id: 'me',
          pausedAt: pausedAt,
          modes: modes ?? [mode],
          musicGenres: const [MusicGenre.techno, MusicGenre.house],
        ),
      ),
      discoverDeckProvider(mode)
          .overrideWith(deck ?? () => _FixedDeck(DeckState(cards: cards))),
      myPhotosProvider.overrideWith((ref) async => const []),
      myAttendingEventsProvider.overrideWith(
        (ref) async => hasEvents
            ? [
                EventSummary(
                  id: 'e1',
                  name: 'Noite Ácida',
                  venueName: 'D-Edge',
                  city: 'São Paulo',
                  state: 'SP',
                  startsAt: DateTime(2026, 10, 10),
                  endsAt: DateTime(2026, 10, 11),
                ),
              ]
            : const <EventSummary>[],
      ),
      photoUrlProvider.overrideWith((ref, path) async => 'https://x/$path'),
    ];

    testWidgets('shows the card with the common event chip', (tester) async {
      await tester.pumpWidget(
        _app(const DiscoverScreen(), overrides: overrides([ana])),
      );
      await settle(tester);
      expect(find.text('Ana, 32'), findsOneWidget);
      expect(find.text('Vocês vão: Noite Ácida +1'), findsOneWidget);
      expect(find.bySemanticsLabel('Curtir'), findsWidgets);
    });

    testWidgets('crew cards highlight the event and music affinity', (
      tester,
    ) async {
      final crewAna = ana.copyWith(
        favoriteDjs: ['Charlotte de Witte', 'Amelie Lens'],
        musicGenres: [MusicGenre.techno],
        crewSize: 3,
      );
      await tester.pumpWidget(
        _app(
          const DiscoverScreen(),
          overrides: overrides([crewAna], mode: AppMode.crew),
        ),
      );
      await settle(tester);
      expect(find.text('Procurando crew para: Noite Ácida +1'), findsOneWidget);
      expect(
        find.text('Curte: Charlotte de Witte, Amelie Lens'),
        findsOneWidget,
      );
      expect(find.text('Vocês vão: Noite Ácida +1'), findsNothing);
      expect(find.text('Já tem crew de 3'), findsOneWidget);
    });

    testWidgets('fallback cards explain the shared taste', (tester) async {
      const vibe = DiscoverCandidate(
        id: 'felipe',
        firstName: 'Felipe',
        age: 31,
        isFallback: true,
        musicGenres: [MusicGenre.techno, MusicGenre.minimal],
      );
      await tester.pumpWidget(
        _app(const DiscoverScreen(), overrides: overrides([vibe])),
      );
      await settle(tester);
      expect(find.text('Vocês curtem: Techno'), findsOneWidget);
      // No banner: in Date, nearby people simply follow the event ones.
      expect(find.textContaining('Você já viu todo mundo'), findsNothing);
    });

    testWidgets('Crew without events points to the Events tab', (tester) async {
      await tester.pumpWidget(
        _app(
          const DiscoverScreen(),
          overrides: overrides(const [], hasEvents: false, mode: AppMode.crew),
        ),
      );
      await settle(tester);
      expect(find.text('Marque presença em um evento'), findsOneWidget);
      expect(find.text('Ver eventos'), findsOneWidget);
    });

    testWidgets('Date has its own empty message (no events needed)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          const DiscoverScreen(),
          overrides: overrides(const [], hasEvents: false),
        ),
      );
      await settle(tester);
      expect(find.text('Ninguém novo por perto agora'), findsOneWidget);
      expect(find.text('Marque presença em um evento'), findsNothing);
    });

    testWidgets('Crew has no superlike button', (tester) async {
      await tester.pumpWidget(
        _app(
          const DiscoverScreen(),
          overrides: overrides([ana], mode: AppMode.crew),
        ),
      );
      await settle(tester);
      expect(find.byTooltip('Superlike'), findsNothing);
    });

    testWidgets('mode off in the profile explains how to enable it', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(const DiscoverScreen(), overrides: overrides([ana])),
      );
      await settle(tester);
      await tester.tap(find.text('CREW'));
      await settle(tester);
      expect(
        find.text('O modo Crew está desligado no seu perfil.'),
        findsOneWidget,
      );
    });

    testWidgets('a paused account sees how to come back', (tester) async {
      await tester.pumpWidget(
        _app(
          const DiscoverScreen(),
          overrides: overrides([ana], pausedAt: DateTime(2026, 10, 19)),
        ),
      );
      await settle(tester);
      expect(find.text('Sua conta está pausada'), findsOneWidget);
      expect(find.text('Voltar a aparecer'), findsOneWidget);
      expect(find.text('Ana, 32'), findsNothing);
    });

    testWidgets('"events only" sees an invite instead of the deck', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(const DiscoverScreen(), overrides: overrides([ana], modes: [])),
      );
      await settle(tester);
      expect(find.text('Conheça gente nas festas'), findsOneWidget);
      expect(find.text('Ativar Date ou Crew'), findsOneWidget);
      expect(find.text('CREW'), findsNothing);
    });

    testWidgets('an ad card comes every N swipes and any swipe skips it', (
      tester,
    ) async {
      final bruno = ana.copyWith(id: 'bruno', firstName: 'Bruno');
      final carla = ana.copyWith(id: 'carla', firstName: 'Carla');
      await tester.pumpWidget(
        _app(
          const DiscoverScreen(),
          overrides: [
            ...overrides(
              const [],
              deck: () => _LocalDeck(DeckState(cards: [ana, bruno, carla])),
            ),
            adsRepositoryProvider.overrideWithValue(_NoopAds()),
            adsConfigProvider.overrideWith(
              (ref) async => const AdsConfig(
                enabled: true,
                discoverEvery: 1,
                ads: [
                  HouseAd(
                    id: 'ad1',
                    title: 'Sunset Club',
                    placements: [AdPlacement.discover],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
      await settle(tester);
      expect(find.text('Ana, 32'), findsOneWidget);

      await tester.tap(find.byTooltip('Passar'));
      await settle(tester);
      expect(find.text('Sunset Club'), findsOneWidget);
      expect(find.text('Patrocinado'), findsOneWidget);

      // Skipping the ad doesn't swipe anyone: Bruno is still next.
      await tester.tap(find.byTooltip('Passar'));
      await settle(tester);
      expect(find.text('Sunset Club'), findsNothing);
      expect(find.text('Bruno, 32'), findsOneWidget);
    });
  });
}

/// Swipes without a server.
class _LocalDeck extends DiscoverDeck {
  new(this._state);

  final DeckState _state;

  @override
  Future<DeckState> build(AppMode mode, {String? eventId}) async => _state;

  @override
  Future<SwipeResult?> swipe(
    DiscoverCandidate candidate,
    SwipeDirection direction, {
    bool superLike = false,
  }) async {
    final now = state.requireValue;
    state = AsyncData(
      now.copyWith(cards: [...now.cards.where((c) => c.id != candidate.id)]),
    );
    return const SwipeResult(matched: false);
  }
}

class _NoopAds implements AdsRepository {
  @override
  Future<void> log(String adId, {required bool click}) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FixedDeck extends DiscoverDeck {
  new(this._state);

  final DeckState _state;

  @override
  Future<DeckState> build(AppMode mode, {String? eventId}) async => _state;
}
