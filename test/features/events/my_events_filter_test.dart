import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/features/ads/domain/ad_models.dart';
import 'package:pulse/features/ads/presentation/ads_providers.dart';
import 'package:pulse/features/events/data/events_repository.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/events/presentation/events_screen.dart';
import 'package:pulse/features/profile/domain/profile.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/l10n/app_localizations.dart';

EventListEntry _event(String name, {bool going = false, bool saved = false}) =>
    EventListEntry(
      id: name,
      name: name,
      venueName: 'Galpão',
      city: 'Rio de Janeiro',
      state: 'RJ',
      startsAt: DateTime.utc(2026, 11, 10, 2),
      endsAt: DateTime.utc(2026, 11, 10, 10),
      status: EventStatus.approved,
      isGoing: going,
      isSaved: saved,
    );

void main() {
  testWidgets('"Meus eventos": Todos, Vou and Salvos', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 3000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          adsConfigProvider.overrideWith((ref) async => const AdsConfig()),
          myProfileProvider.overrideWith(
            (ref) async =>
                const MyProfile(id: 'u1', city: 'Rio de Janeiro', state: 'RJ'),
          ),
          eventListProvider(EventListScope.nearby)
              .overrideWith((ref) async => const []),
          eventListProvider(EventListScope.mine).overrideWith(
            (ref) async => [
              _event('Beltran', going: true),
              _event('BOMA', saved: true),
            ],
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
          home: const EventsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Meus eventos'));
    await tester.pumpAndSettle();

    expect(find.text('Beltran'), findsOneWidget);
    expect(find.text('BOMA'), findsOneWidget);
    expect(find.text('Salvo'), findsOneWidget);

    await tester.tap(find.text('Salvos'));
    await tester.pumpAndSettle();
    expect(find.text('BOMA'), findsOneWidget);
    expect(find.text('Beltran'), findsNothing);

    await tester.tap(find.text('Vou'));
    await tester.pumpAndSettle();
    expect(find.text('Beltran'), findsOneWidget);
    expect(find.text('BOMA'), findsNothing);
  });
}
