import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/features/events/data/place_search_repository.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/events/presentation/widgets/event_location.dart';
import 'package:pulse/features/events/presentation/widgets/event_map.dart';
import 'package:pulse/features/events/presentation/widgets/events_map_view.dart';
import 'package:pulse/features/profile/domain/profile.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/l10n/app_localizations.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart' as vmt;

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
    // flutter_map still reads the legacy Material theme.
    // ignore: deprecated_member_use
    builder: (context, child) => MaterialUiCompatibilityBridge(child: child!),
    home: Scaffold(body: home),
  ),
);

Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

EventListEntry entry(
  String id,
  String name, {
  required double lat,
  required double lng,
  bool exact = true,
}) => EventListEntry(
  id: id,
  name: name,
  venueName: 'Clube',
  city: 'São Paulo',
  state: 'SP',
  startsAt: DateTime.utc(2026, 10, 10, 2),
  endsAt: DateTime.utc(2026, 10, 10, 10),
  status: EventStatus.approved,
  pinLat: lat,
  pinLng: lng,
  pinExact: exact,
);

/// The base map never loads in tests (no network): pins still render.
final Object _noStyle = mapStyleProvider.overrideWith(
  (ref) => Completer<vmt.Style>().future,
);

void main() {
  group('PlaceSearchRepository', () {
    const saoPaulo = (name: 'São Paulo', state: 'SP', lat: -23.5, lng: -46.6);

    http.Response json(Object body) =>
        http.Response.bytes(utf8.encode(jsonEncode(body)), 200);

    Map<String, Object> place(
      Map<String, String> properties,
      double lng,
      double lat,
    ) => {
      'properties': {'countrycode': 'BR', ...properties},
      'geometry': {
        'coordinates': [lng, lat],
      },
    };

    test('searches Photon in Brazil near the city and builds labels', () async {
      late http.Request sent;
      final client = MockClient((request) async {
        sent = request;
        return json({
          'features': [
            place(
              {
                'name': 'Blitz Haus',
                'street': 'Rua Augusta',
                'housenumber': '657',
                'district': 'Higienópolis',
                'city': 'São Paulo',
              },
              -46.6521,
              -23.5520,
            ),
            // Outside Brazil: dropped.
            {
              'properties': {'countrycode': 'PT', 'name': 'Lisboa'},
              'geometry': {
                'coordinates': [-9.1, 38.7],
              },
            },
          ],
        });
      });

      final places = await PlaceSearchRepository(client: client)
          .search('Rua Augusta 657', city: saoPaulo);

      expect(sent.url.host, 'photon.komoot.io');
      expect(sent.url.queryParameters['q'], 'Rua Augusta 657, São Paulo');
      expect(sent.url.queryParameters['lat'], '-23.5');
      expect(sent.url.queryParameters['lon'], '-46.6');
      expect(sent.url.queryParameters['bbox'], isNotNull);
      expect(sent.headers['User-Agent'], contains('com.pulseapp.pulse'));
      expect(
        places.single.label,
        'Blitz Haus, Rua Augusta 657, Higienópolis, São Paulo',
      );
      expect(places.single.lat, -23.5520);
    });

    test(
      'a CEP gets the street from ViaCEP and its point from Photon',
      () async {
        final client = MockClient((request) async {
          if (request.url.host == 'viacep.com.br') {
            expect(request.url.path, '/ws/03109001/json/');
            return json({
              'logradouro': 'Avenida Henry Ford',
              'bairro': 'Parque da Mooca',
              'localidade': 'São Paulo',
              'uf': 'SP',
            });
          }
          expect(
            request.url.queryParameters['q'],
            'Avenida Henry Ford, São Paulo',
          );
          return json({
            'features': [
              place({'street': 'Avenida Henry Ford'}, -46.604, -23.555),
            ],
          });
        });

        final places = await PlaceSearchRepository(client: client)
            .search('03109-001', city: saoPaulo);

        expect(
          places.single.label,
          'Avenida Henry Ford, Parque da Mooca, São Paulo - SP',
        );
        expect(places.single.lat, -23.555);
      },
    );

    test('unknown CEPs find nothing', () async {
      final client = MockClient((_) async => json({'erro': 'true'}));
      expect(
        await PlaceSearchRepository(client: client).search('00000-000'),
        isEmpty,
      );
    });

    test('a map tap is named by reverse geocoding', () async {
      final client = MockClient((request) async {
        expect(request.url.path, '/reverse');
        expect(request.url.queryParameters['lat'], '-23.5');
        return json({
          'features': [
            place(
              {
                'street': 'Rua da Mooca',
                'housenumber': '1000',
                'city': 'São Paulo',
              },
              -46.6,
              -23.5,
            ),
          ],
        });
      });
      expect(
        await PlaceSearchRepository(client: client).reverse(-23.5, -46.6),
        'Rua da Mooca 1000, São Paulo',
      );
    });

    test('short queries do nothing', () async {
      final client = MockClient((_) async => fail('no request expected'));
      expect(await PlaceSearchRepository(client: client).search('ab'), isEmpty);
    });
  });

  testWidgets('pins show the events; tapping one shows its card', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      _app(const EventsMapView(), [
        _noStyle,
        // No profile coordinates: the map frames the pins.
        myProfileProvider.overrideWith((ref) => Completer<MyProfile>().future),
        eventMapProvider.overrideWith(
          (ref) async => [
            entry('e1', 'Noite Ácida', lat: -23.5262, lng: -46.6658),
            entry('e3', 'Mamba Negra', lat: -23.56, lng: -46.60, exact: false),
          ],
        ),
      ]),
    );
    await settle(tester);

    expect(find.byType(EventPin), findsNWidgets(2));
    expect(
      tester
          .widgetList<EventPin>(find.byType(EventPin))
          .where((pin) => pin.approximate),
      hasLength(1),
    );

    await tester.tap(find.bySemanticsLabel('Noite Ácida'));
    await settle(tester);
    expect(find.text('Noite Ácida'), findsOneWidget);
  });

  testWidgets('if the base map fails, it says so and keeps the pins', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(const EventsMapView(), [
        mapStyleProvider.overrideWith((ref) => Future.error('offline')),
        myProfileProvider.overrideWith((ref) => Completer<MyProfile>().future),
        eventMapProvider.overrideWith(
          (ref) async => [entry('e1', 'Noite Ácida', lat: -23.5, lng: -46.6)],
        ),
      ]),
    );
    await settle(tester);

    expect(find.byType(MapUnavailable), findsOneWidget);
    expect(find.byType(EventPin), findsOneWidget);
  });

  testWidgets('a secret location says when it will be revealed', (
    tester,
  ) async {
    final event = EventDetail(
      id: 'e3',
      name: 'Mamba Negra',
      venueName: 'Galpão',
      city: 'São Paulo',
      state: 'SP',
      startsAt: DateTime.now().add(const Duration(days: 8)),
      endsAt: DateTime.now().add(const Duration(days: 8, hours: 6)),
      status: EventStatus.approved,
      locationRevealHours: 24,
    );
    await tester.pumpWidget(
      _app(EventLocationSection(event: event), [
        _noStyle,
        eventVenueProvider('e3').overrideWith((ref) async => null),
      ]),
    );
    await settle(tester);

    expect(find.text('Local secreto'), findsOneWidget);
    expect(find.textContaining('O endereço aparece em'), findsOneWidget);
    expect(find.text('Como chegar'), findsNothing);
  });
}
