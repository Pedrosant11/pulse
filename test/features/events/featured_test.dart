import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/features/events/data/events_repository.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/domain/featured.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/events/presentation/widgets/featured_promo.dart';
import 'package:pulse/l10n/app_localizations.dart';

class _FakeEvents implements EventsRepository {
  final requests = <String>[];

  @override
  Future<void> requestFeatured(
    String eventId, {
    required int days,
    required FeaturedMethod method,
  }) async => requests.add('$eventId:$days:${method.name}');

  @override
  Future<FeaturedRequest?> openFeaturedRequest(String eventId) async => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _prices = [
  FeaturedPrice(days: 3, priceCents: 7900, storeProductId: 'pulse_featured_3'),
  FeaturedPrice(days: 7, priceCents: 14900, storeProductId: 'pulse_featured_7'),
  FeaturedPrice(
    days: 14,
    priceCents: 24900,
    storeProductId: 'pulse_featured_14',
  ),
  FeaturedPrice(
    days: 30,
    priceCents: 44900,
    storeProductId: 'pulse_featured_30',
  ),
];

EventDetail _event({DateTime? featuredUntil}) => EventDetail(
  id: 'e1',
  name: 'Disco Inferno',
  venueName: 'Blitz Haus',
  city: 'São Paulo',
  state: 'SP',
  startsAt: DateTime.now().add(const Duration(days: 10)),
  endsAt: DateTime.now().add(const Duration(days: 10, hours: 8)),
  status: EventStatus.approved,
  createdBy: 'me',
  featuredUntil: featuredUntil,
);

Widget _app(EventDetail event, EventsRepository repository) => ProviderScope(
  overrides: [
    eventsRepositoryProvider.overrideWithValue(repository),
    featuredPricesProvider.overrideWith((ref) async => _prices),
  ],
  child: MaterialApp(
    theme: AppTheme.dark(),
    locale: const Locale('pt', 'BR'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    home: Scaffold(body: FeaturedPromoCard(event: event)),
  ),
);

Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  test('longer highlights are cheaper per day', () {
    expect(_prices.first.perDay, closeTo(26.33, 0.01));
    expect(_prices.last.perDay, closeTo(14.97, 0.01));
  });

  testWidgets('the producer picks the days and asks the team', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final repository = _FakeEvents();
    await tester.pumpWidget(_app(_event(), repository));
    await settle(tester);
    expect(find.text('Coloque sua festa no topo'), findsOneWidget);

    await tester.tap(find.text('Destacar festa'));
    await settle(tester);
    expect(find.text('Por quantos dias?'), findsOneWidget);
    expect(find.textContaining('79,00'), findsOneWidget);
    expect(find.textContaining('449,00'), findsOneWidget);
    expect(find.text('Melhor preço por dia'), findsOneWidget);
    // No store in tests: only the team option.
    expect(find.textContaining('Destacar agora'), findsNothing);

    await tester.tap(find.text('14 dias'));
    await settle(tester);
    await tester.tap(find.text('Pedir pela equipe Pulse'));
    await settle(tester);
    expect(repository.requests, ['e1:14:team']);
    expect(
      find.text('Pedido enviado! A equipe Pulse vai te chamar para combinar.'),
      findsOneWidget,
    );
  });

  testWidgets('a running highlight says until when', (tester) async {
    await tester.pumpWidget(
      _app(
        _event(featuredUntil: DateTime(2026, 12, 24, 18, 30)),
        _FakeEvents(),
      ),
    );
    await settle(tester);
    expect(find.text('Sua festa está em destaque'), findsOneWidget);
    expect(
      find.text('No topo de Próximos até 24/12 às 18:30.'),
      findsOneWidget,
    );
    expect(find.text('Estender destaque'), findsOneWidget);
  });
}
