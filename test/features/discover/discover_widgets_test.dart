import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/core/models/app_mode.dart';
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
    }) => [
      myProfileProvider.overrideWith(
        (ref) async => MyProfile(
          id: 'me',
          modes: modes ?? [mode],
          musicGenres: const [MusicGenre.techno, MusicGenre.house],
        ),
      ),
      discoverDeckProvider(mode)
          .overrideWith(() => _FixedDeck(DeckState(cards: cards))),
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
      expect(find.textContaining('Você já viu todo mundo'), findsOneWidget);
    });

    testWidgets('Crew without events points to the Events tab', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          const DiscoverScreen(),
          overrides: overrides(
            const [],
            hasEvents: false,
            mode: AppMode.crew,
          ),
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
  });
}

class _FixedDeck extends DiscoverDeck {
  new(this._state);

  final DeckState _state;

  @override
  Future<DeckState> build(AppMode mode) async => _state;
}
