import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/features/onboarding/presentation/onboarding_screen.dart';
import 'package:pulse/features/profile/domain/profile.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/l10n/app_localizations.dart';

void main() {
  Future<void> pump(WidgetTester tester, MyProfile profile) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          myProfileProvider.overrideWith((ref) async => profile),
          myPhotosProvider.overrideWith((ref) async => const []),
        ],
        child: MaterialApp(
          theme: AppTheme.dark(),
          locale: const Locale('pt', 'BR'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          home: const OnboardingScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('starts at the photos step for new profiles', (tester) async {
    await pump(tester, const MyProfile(id: 'u1'));
    expect(find.text('SUAS FOTOS'), findsOneWidget);
    expect(find.text('Etapa 1 de 6'), findsOneWidget);
    expect(
      find.text('Adicione pelo menos 2 fotos para continuar.'),
      findsOneWidget,
    );
  });

  testWidgets('resumes at the saved step', (tester) async {
    await pump(
      tester,
      const MyProfile(id: 'u1', firstName: 'Ana', onboardingStep: 3),
    );
    expect(find.text('SUA MÚSICA'), findsOneWidget);
    expect(find.text('Etapa 4 de 6'), findsOneWidget);
    expect(find.text('Techno'), findsOneWidget);
  });

  testWidgets('music step requires at least one genre', (tester) async {
    await pump(tester, const MyProfile(id: 'u1', onboardingStep: 3));
    await tester.scrollUntilVisible(
      find.text('Continuar'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(find.text('Escolha pelo menos 1 gênero.'), findsOneWidget);
  });
}
