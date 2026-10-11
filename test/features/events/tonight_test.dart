import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/events/presentation/widgets/tonight_card.dart';
import 'package:pulse/features/notifications/domain/push_route.dart';
import 'package:pulse/features/plans/domain/plan_models.dart';
import 'package:pulse/features/plans/presentation/plans_providers.dart';
import 'package:pulse/features/plans/presentation/same_night_screen.dart';
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
    home: Scaffold(body: home),
  ),
);

Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

EventDetail _event(DateTime now) => EventDetail(
  id: 'e1',
  name: 'Noite Ácida',
  venueName: 'D-Edge',
  city: 'São Paulo',
  state: 'SP',
  startsAt: now.subtract(const Duration(hours: 1)),
  endsAt: now.add(const Duration(hours: 4)),
  status: EventStatus.approved,
);

void main() {
  final now = DateTime.now();

  test('the party night window: 2 h before until 2 h after', () {
    final event = _event(now);
    expect(TonightCard.isTonight(event, now), isTrue);
    expect(
      TonightCard.isTonight(event, now.add(const Duration(hours: 7))),
      isFalse,
    );
  });

  testWidgets('before checking in: "Tô na festa" and how many are here', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(TonightCard(event: _event(now)), [
        isCheckedInProvider('e1').overrideWith((ref) async => false),
        hereCountProvider('e1').overrideWith((ref) async => 12),
      ]),
    );
    await settle(tester);
    expect(find.text('Tô na festa'), findsOneWidget);
    expect(find.text('12 pessoas do Pulse aqui agora'), findsOneWidget);
  });

  testWidgets('checked in: matches and crew mates here', (tester) async {
    await tester.pumpWidget(
      _app(TonightCard(event: _event(now)), [
        isCheckedInProvider('e1').overrideWith((ref) async => true),
        hereCountProvider('e1').overrideWith((ref) async => 3),
        hereFriendsProvider('e1').overrideWith(
          (ref) async => const [
            HereFriend(userId: 'u2', firstName: 'Bruno', relation: 'match'),
            HereFriend(userId: 'u5', firstName: 'Elisa', relation: 'crew'),
          ],
        ),
      ]),
    );
    await settle(tester);
    expect(find.text('Você está na festa 🔥'), findsOneWidget);
    expect(find.text('Bruno'), findsOneWidget);
    expect(find.text('Elisa'), findsOneWidget);
    expect(find.text('Saí da festa'), findsOneWidget);
  });

  testWidgets('Mesmo rolê: free sees how many, Black sees who', (tester) async {
    await tester.pumpWidget(
      _app(const SameNightScreen(), [
        entitlementsProvider.overrideWith((ref) async => const Entitlements()),
        sameNightCountProvider.overrideWith((ref) async => 4),
      ]),
    );
    await settle(tester);
    expect(find.text('4 pessoas estavam na festa com você'), findsOneWidget);
    expect(find.text('Ver quem são com o Pulse Black'), findsOneWidget);
  });

  testWidgets('Mesmo rolê for Black lists the people and the party', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(const SameNightScreen(), [
        entitlementsProvider.overrideWith(
          (ref) async => const Entitlements(tier: PlanTier.black),
        ),
        sameNightProvider.overrideWith(
          (ref) async => const [
            SameNightPerson(
              userId: 'u4',
              firstName: 'Diego',
              age: 29,
              eventName: 'Noite Ácida',
            ),
          ],
        ),
      ]),
    );
    await settle(tester);
    expect(find.text('Diego, 29'), findsOneWidget);
    expect(find.text('Estava no Noite Ácida'), findsOneWidget);
  });

  test('the push opens Mesmo rolê', () {
    expect(routeFromPushData({'route': '/same-night'}), '/same-night');
  });
}
