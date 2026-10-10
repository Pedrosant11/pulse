import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/models/app_mode.dart';
import 'package:pulse/features/plans/data/store_purchases.dart';
import 'package:pulse/features/plans/domain/plan_models.dart';
import 'package:pulse/features/plans/presentation/likes_you_screen.dart';
import 'package:pulse/features/plans/presentation/plans_providers.dart';
import 'package:pulse/features/plans/presentation/plans_screen.dart';
import 'package:pulse/l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    home: home,
  ),
);

Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

class _FakeStore implements StorePurchases {
  @override
  bool get isAvailable => true;

  @override
  Future<List<StoreOffer>> offers() async => const [
    StoreOffer(item: StoreItem.plusMonthly, price: r'R$ 24,90', raw: 'plus'),
    StoreOffer(item: StoreItem.blackMonthly, price: r'R$ 44,90', raw: 'black'),
  ];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('domain', () {
    test('Google subscription ids map back to the catalog', () {
      expect(
        StoreItem.fromStoreId('pulse_plus_monthly:monthly'),
        StoreItem.plusMonthly,
      );
      expect(StoreItem.fromStoreId('pulse_boost_1'), StoreItem.boost1);
      expect(StoreItem.fromStoreId('something_else'), isNull);
    });

    test('entitlements add the weekly allowance to the wallet', () {
      const free = Entitlements(freeSuperlikesLeft: 1, superlikeBalance: 2);
      expect(free.superlikesLeft, 3);
      expect(free.canRewind, isFalse);
      // The travel city is kept but only works with a plan.
      expect(
        const Entitlements(travelCity: 'Florianópolis').isTraveling,
        isFalse,
      );
      expect(
        const Entitlements(
          tier: PlanTier.plus,
          travelCity: 'Florianópolis',
        ).isTraveling,
        isTrue,
      );
    });

    test('plan limits from the database have their own failures', () {
      AppFailure fail(String hint) => AppFailure.from(
        PostgrestException(message: 'x', code: 'P0001', hint: hint),
      );
      expect(fail('like_limit'), isA<LikeLimitFailure>());
      expect(fail('superlike_limit'), isA<SuperlikeLimitFailure>());
      expect(fail('plan_required'), isA<PlanRequiredFailure>());
      expect(fail('boost_unavailable'), isA<BoostUnavailableFailure>());
    });
  });

  testWidgets('plans show store prices and the current plan', (tester) async {
    await tester.pumpWidget(
      _app(const PlansScreen(feature: PlanFeature.likedYou), [
        storePurchasesProvider.overrideWithValue(_FakeStore()),
        entitlementsProvider.overrideWith(
          (ref) async =>
              const Entitlements(tier: PlanTier.plus, source: 'admin'),
        ),
      ]),
    );
    await settle(tester);

    expect(find.text('Veja quem curtiu você'), findsOneWidget);
    expect(find.text('Você tem o Pulse+'), findsOneWidget);
    expect(find.text('Liberado pela equipe Pulse'), findsOneWidget);
    expect(find.text(r'R$ 24,90/mês'), findsOneWidget);
    expect(find.text('Seu plano atual'), findsOneWidget);
    expect(find.text('Assinar'), findsOneWidget);
  });

  testWidgets('without the store the plans say "em breve"', (tester) async {
    await tester.pumpWidget(
      _app(const PlansScreen(), [
        entitlementsProvider.overrideWith((ref) async => const Entitlements()),
      ]),
    );
    await settle(tester);
    expect(
      find.text('As compras ainda não estão disponíveis nesta versão do app.'),
      findsOneWidget,
    );
    expect(find.text('Em breve'), findsWidgets);
  });

  testWidgets('who liked you: free sees only how many', (tester) async {
    await tester.pumpWidget(
      _app(const LikesYouScreen(), [
        entitlementsProvider.overrideWith((ref) async => const Entitlements()),
        likesReceivedCountProvider.overrideWith((ref) async => 2),
      ]),
    );
    await settle(tester);
    expect(find.text('2 pessoas curtiram você'), findsOneWidget);
    expect(find.text('Ver quem são com o Pulse Black'), findsOneWidget);
  });

  testWidgets('who liked you: Black sees the people', (tester) async {
    await tester.pumpWidget(
      _app(const LikesYouScreen(), [
        entitlementsProvider.overrideWith(
          (ref) async => const Entitlements(tier: PlanTier.black),
        ),
        likesReceivedProvider.overrideWith(
          (ref) async => [
            LikedYou(
              userId: 'u22',
              firstName: 'Xavier',
              age: 38,
              mode: AppMode.crew,
              likedAt: DateTime(2026, 10, 10),
              isSuper: true,
            ),
          ],
        ),
      ]),
    );
    await settle(tester);
    expect(find.text('Xavier, 38'), findsOneWidget);
    expect(find.byIcon(Icons.star_rounded), findsOneWidget);
  });
}
