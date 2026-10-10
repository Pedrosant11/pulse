import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/features/auth/data/account_repository.dart';
import 'package:pulse/features/auth/domain/account_state.dart';
import 'package:pulse/features/auth/presentation/account_setup_screen.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/l10n/app_localizations.dart';

class FakeAccountRepository implements AccountRepository {
  new({this.phoneTaken = false});

  final bool phoneTaken;
  final saved = <String>[];

  @override
  Future<void> savePhone(String userId, String e164) async {
    if (phoneTaken) throw const PhoneInUseFailure();
    saved.add(e164);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Launch decision: the phone is saved without a code and must not belong
/// to another account.
void main() {
  Future<FakeAccountRepository> pump(
    WidgetTester tester, {
    bool phoneTaken = false,
  }) async {
    final repository = FakeAccountRepository(phoneTaken: phoneTaken);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          accountRepositoryProvider.overrideWithValue(repository),
          currentUserIdProvider.overrideWithValue('me'),
          accountProvider.overrideWith(
            (ref) async => const AccountState(
              userId: 'me',
              hasPhone: false,
              termsAccepted: false,
              onboardingCompleted: false,
              status: AccountStatus.active,
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
          home: const AccountSetupScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return repository;
  }

  testWidgets('saves the phone in E.164 and goes to the terms', (tester) async {
    final repository = await pump(tester);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Celular'),
      '11987654321',
    );
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    expect(repository.saved, ['+5511987654321']);
    expect(find.text('QUASE LÁ'), findsOneWidget);
  });

  testWidgets('a number used by another account is refused', (tester) async {
    await pump(tester, phoneTaken: true);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Celular'),
      '11987654321',
    );
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    expect(
      find.text('Esse celular já está vinculado a outra conta.'),
      findsOneWidget,
    );
    expect(find.text('SEU CELULAR'), findsOneWidget);
  });
}
