import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/features/ads/data/ads_repository.dart';
import 'package:pulse/features/ads/domain/ad_models.dart';
import 'package:pulse/features/ads/presentation/ads_providers.dart';
import 'package:pulse/features/events/data/events_repository.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/events/presentation/events_screen.dart';
import 'package:pulse/features/profile/domain/profile.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/l10n/app_localizations.dart';

class _FakeAds implements AdsRepository {
  final logged = <String>[];

  @override
  Future<void> log(String adId, {required bool click}) async =>
      logged.add('$adId:${click ? 'click' : 'view'}');

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

EventListEntry _event(int i) => EventListEntry(
  id: 'e$i',
  name: 'Festa $i',
  venueName: 'Galpão',
  city: 'Rio de Janeiro',
  state: 'RJ',
  startsAt: DateTime.utc(2026, 11, 10, 2),
  endsAt: DateTime.utc(2026, 11, 10, 10),
  status: EventStatus.approved,
  distanceKm: 4,
);

const _sunset = HouseAd(
  id: 'ad1',
  title: 'Sunset Club',
  body: 'Sábado no Arpoador',
  cta: 'Comprar ingresso',
  linkUrl: 'https://example.com',
  placements: [AdPlacement.events],
);

void main() {
  test('get_ads json: on/off, frequency and ads per place', () {
    final config = AdsConfig.fromJson({
      'enabled': true,
      'events_every': 6,
      'discover_every': 20,
      'ads': [
        {
          'id': 'ad1',
          'title': 'Sunset Club',
          'placements': ['events'],
        },
        {
          'id': 'ad2',
          'title': 'Parceiro',
          'placements': ['events', 'discover'],
        },
      ],
    });
    expect(config.enabled, isTrue);
    expect(config.every(AdPlacement.discover), 20);
    expect(config.adsFor(AdPlacement.discover).map((a) => a.id), ['ad2']);
    expect(config.adsFor(AdPlacement.events), hasLength(2));
  });

  Future<_FakeAds> pump(WidgetTester tester, AdsConfig config) async {
    await tester.binding.setSurfaceSize(const Size(400, 6000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final ads = _FakeAds();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          adsRepositoryProvider.overrideWithValue(ads),
          adsConfigProvider.overrideWith((ref) async => config),
          myProfileProvider.overrideWith(
            (ref) async =>
                const MyProfile(id: 'u1', city: 'Rio de Janeiro', state: 'RJ'),
          ),
          eventListProvider(EventListScope.nearby).overrideWith(
            (ref) async => [for (var i = 0; i < 5; i++) _event(i)],
          ),
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
    return ads;
  }

  testWidgets('own ads go between events, never after the last one', (
    tester,
  ) async {
    final ads = await pump(
      tester,
      const AdsConfig(enabled: true, eventsEvery: 2, ads: [_sunset]),
    );
    // 5 events, one ad every 2: after the 2nd and the 4th.
    expect(find.text('Sunset Club'), findsNWidgets(2));
    expect(find.text('Patrocinado'), findsNWidgets(2));
    expect(find.text('Comprar ingresso'), findsNWidgets(2));
    for (var i = 0; i < 5; i++) {
      expect(find.text('Festa $i'), findsOneWidget);
    }
    // Order: Festa 0, Festa 1, ad, Festa 2...
    expect(
      tester.getTopLeft(find.text('Sunset Club').first).dy,
      greaterThan(tester.getTopLeft(find.text('Festa 1')).dy),
    );
    expect(
      tester.getTopLeft(find.text('Sunset Club').first).dy,
      lessThan(tester.getTopLeft(find.text('Festa 2')).dy),
    );
    expect(ads.logged, contains('ad1:view'));
  });

  testWidgets('no ads when they are off for this person', (tester) async {
    await pump(tester, const AdsConfig(eventsEvery: 2, ads: [_sunset]));
    expect(find.text('Sunset Club'), findsNothing);
    expect(find.text('Patrocinado'), findsNothing);
  });
}
