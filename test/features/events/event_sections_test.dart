import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/features/ads/data/ads_repository.dart';
import 'package:pulse/features/ads/domain/ad_models.dart';
import 'package:pulse/features/ads/domain/with_ads.dart';
import 'package:pulse/features/ads/presentation/ads_providers.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/events/presentation/widgets/event_sections.dart';
import 'package:pulse/l10n/app_localizations.dart';

class _FakeAds implements AdsRepository {
  @override
  Future<void> log(String adId, {required bool click}) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

SectionEvent _event(String id, String name) => SectionEvent(
  id: id,
  name: name,
  venueName: 'D-EDGE Rio',
  city: 'Rio de Janeiro',
  state: 'RJ',
  startsAt: DateTime(2026, 11, 6, 23),
  endsAt: DateTime(2026, 11, 7, 6),
  goingCount: 8,
);

Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  test('one ad after every N; short lists get one at the end', () {
    final seven = withAds(List.generate(7, (i) => i), 3);
    expect(
      [for (final x in seven) x.item ?? 'ad${x.ad}'],
      [0, 1, 2, 'ad0', 3, 4, 5, 'ad1', 6],
    );
    final two = withAds([0, 1], 6, firstTurn: 10);
    expect([for (final x in two) x.item ?? 'ad${x.ad}'], [0, 1, 'ad10']);
    expect(withAds(<int>[], 6), isEmpty);
    expect(withAds([0, 1], 0).every((x) => x.ad == null), isTrue);
  });

  testWidgets('"Em destaque" first, with an ad at the end of short rows', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(420, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          adsRepositoryProvider.overrideWithValue(_FakeAds()),
          adsConfigProvider.overrideWith(
            (ref) async => const AdsConfig(
              enabled: true,
              ads: [HouseAd(id: 'a1', title: 'Pulse Black', cta: 'Assinar')],
            ),
          ),
          adsReadyProvider(AdPlacement.events).overrideWithValue(true),
          eventSectionsProvider.overrideWith(
            (ref) async => EventSections(
              featured: [_event('f1', 'Beltran na D-EDGE Rio')],
              trending: [_event('t1', 'BOMA')],
            ),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.dark(),
          locale: const Locale('pt', 'BR'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          home: const Scaffold(
            body: SingleChildScrollView(child: EventSectionsView()),
          ),
        ),
      ),
    );
    await settle(tester);

    final featured = tester.getTopLeft(find.text('EM DESTAQUE'));
    final trending = tester.getTopLeft(find.text('EM ALTA'));
    expect(featured.dy, lessThan(trending.dy));
    expect(find.text('Beltran na D-EDGE Rio'), findsOneWidget);
    expect(find.text('Destaque'), findsOneWidget);
    // One ad at the end of the featured carousel and of "Em alta".
    expect(find.text('Patrocinado'), findsNWidgets(2));
  });
}
