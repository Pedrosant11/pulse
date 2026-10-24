import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/core/models/user_role.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/venues/data/venues_repository.dart';
import 'package:pulse/features/venues/domain/venue.dart';
import 'package:pulse/features/venues/presentation/venue_screen.dart';
import 'package:pulse/features/venues/presentation/venues_providers.dart';
import 'package:pulse/l10n/app_localizations.dart';

class _FakeVenues implements VenuesRepository {
  final calls = <String>[];

  @override
  Future<void> setFollowing(
    String venueId, {
    required String userId,
    required bool following,
  }) async => calls.add('follow:$following');

  @override
  Future<void> rate(
    String venueId, {
    required String userId,
    required int rating,
    String? comment,
  }) async => calls.add('rate:$rating:$comment');

  @override
  String photoUrl(String path) => 'https://example.com/$path';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

VenueDetail _venue({bool canReview = false, bool following = false}) =>
    VenueDetail(
      id: 'v1',
      name: 'D-EDGE Rio',
      city: 'Rio de Janeiro',
      state: 'RJ',
      status: VenueStatus.approved,
      neighborhood: 'Saúde',
      address: 'Av. Rodrigues Alves, 293',
      rating: 4.5,
      ratingCount: 12,
      followers: 340,
      isFollowing: following,
      canReview: canReview,
      upcoming: [
        EventSummary(
          id: 'e1',
          name: 'Beltran na D-EDGE Rio',
          venueName: 'D-EDGE Rio',
          city: 'Rio de Janeiro',
          state: 'RJ',
          startsAt: DateTime(2026, 11, 6, 23),
          endsAt: DateTime(2026, 11, 7, 6),
        ),
      ],
      reviews: [
        VenueReview(
          userId: 'u2',
          firstName: 'Bia',
          rating: 5,
          comment: 'Som absurdo',
          updatedAt: DateTime(2026, 10, 2),
        ),
      ],
    );

Widget _app(VenueDetail venue, _FakeVenues repository) => ProviderScope(
  overrides: [
    venuesRepositoryProvider.overrideWithValue(repository),
    venueDetailProvider('v1').overrideWith((ref) async => venue),
    currentUserIdProvider.overrideWithValue('me'),
    currentRoleProvider.overrideWithValue(UserRole.user),
  ],
  child: MaterialApp(
    theme: AppTheme.dark(),
    locale: const Locale('pt', 'BR'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    home: const VenueScreen(venueId: 'v1'),
  ),
);

Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  testWidgets('the page shows rating, followers, parties and reviews', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(420, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final repository = _FakeVenues();
    await tester.pumpWidget(_app(_venue(), repository));
    await settle(tester);

    expect(find.text('D-EDGE RIO'), findsOneWidget);
    expect(find.text('4,5 (12)'), findsOneWidget);
    expect(find.text('340 seguidores'), findsOneWidget);
    expect(find.text('Beltran na D-EDGE Rio'), findsOneWidget);
    expect(find.text('Som absurdo'), findsOneWidget);
    // Never went: no rating button, just the rule.
    expect(find.text('Avaliar a casa'), findsNothing);
    expect(
      find.text('Só quem foi a uma festa aqui pelo app pode avaliar.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Seguir casa'));
    await settle(tester);
    expect(repository.calls, ['follow:true']);
  });

  testWidgets('who went rates it with stars and a comment', (tester) async {
    await tester.binding.setSurfaceSize(const Size(420, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final repository = _FakeVenues();
    await tester.pumpWidget(
      _app(_venue(canReview: true, following: true), repository),
    );
    await settle(tester);

    expect(find.text('Seguindo'), findsOneWidget);
    await tester.tap(find.text('Avaliar a casa'));
    await settle(tester);
    await tester.tap(find.byTooltip('4 estrelas'));
    await tester.enterText(find.byType(TextField), 'Pista boa');
    await tester.tap(find.text('Salvar'));
    await settle(tester);
    expect(repository.calls, ['rate:4:Pista boa']);
  });
}
