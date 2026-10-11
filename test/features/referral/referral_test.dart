import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/features/referral/data/referral_repository.dart';
import 'package:pulse/features/referral/domain/referral_models.dart';
import 'package:pulse/features/referral/presentation/referral_screen.dart';
import 'package:pulse/l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _FakeReferrals implements ReferralRepository {
  new({this.canRedeem = true});

  final bool canRedeem;
  final redeemed = <String>[];

  @override
  Future<ReferralInfo> mine() async => ReferralInfo(
    code: 'ANA7K2',
    invited: 2,
    rewarded: 1,
    canRedeem: canRedeem && redeemed.isEmpty,
    referrerSuperlikes: 3,
    referrerBoosts: 1,
    referredSuperlikes: 3,
  );

  @override
  Future<void> redeem(String code) async {
    if (code.toUpperCase() != 'BRU9X4') {
      throw AppFailure.from(
        const PostgrestException(
          message: 'unknown code',
          code: 'P0001',
          hint: 'referral_invalid',
        ),
      );
    }
    redeemed.add(code);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget _app(ReferralRepository repository) => ProviderScope(
  overrides: [referralRepositoryProvider.overrideWithValue(repository)],
  child: MaterialApp(
    theme: AppTheme.dark(),
    locale: const Locale('pt', 'BR'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    home: const ReferralScreen(),
  ),
);

Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  testWidgets('shows the code, the rewards and how it went', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_app(_FakeReferrals(canRedeem: false)));
    await settle(tester);

    expect(find.text('ANA7K2'), findsOneWidget);
    expect(
      find.textContaining('você ganha 3 superlikes e 1 boost'),
      findsOneWidget,
    );
    expect(find.text('amigos usaram seu código'), findsOneWidget);
    expect(find.text('deu match (recompensa sua)'), findsOneWidget);
    expect(find.text('Compartilhar convite'), findsOneWidget);
    // Already used a code or matched: no field.
    expect(find.text('Recebeu um convite?'), findsNothing);
  });

  testWidgets('a wrong code says why; a good one is applied', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final repository = _FakeReferrals();
    await tester.pumpWidget(_app(repository));
    await settle(tester);

    await tester.enterText(find.byType(TextField), 'XXXXXX');
    await tester.tap(find.text('Usar código'));
    await settle(tester);
    expect(
      find.text('Código não encontrado. Confira as letras e os números.'),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextField), 'bru9x4');
    await tester.tap(find.text('Usar código'));
    await settle(tester);
    expect(repository.redeemed, ['bru9x4']);
    expect(
      find.text('Código aplicado! 3 superlikes na sua carteira.'),
      findsOneWidget,
    );
    // The field goes away once used.
    expect(find.text('Recebeu um convite?'), findsNothing);
  });
}
