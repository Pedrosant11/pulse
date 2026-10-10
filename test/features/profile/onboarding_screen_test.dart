import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/core/models/app_mode.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/onboarding/presentation/onboarding_screen.dart';
import 'package:pulse/features/profile/data/profile_repository.dart';
import 'package:pulse/features/profile/domain/profile.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/l10n/app_localizations.dart';

class FakeProfileRepository implements ProfileRepository {
  final saved = <Map<String, Object?>>[];

  @override
  Future<void> update(String userId, Map<String, Object?> fields) async =>
      saved.add(fields);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  Future<FakeProfileRepository> pump(
    WidgetTester tester,
    MyProfile profile,
  ) async {
    final repository = FakeProfileRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserIdProvider.overrideWithValue('u1'),
          profileRepositoryProvider.overrideWithValue(repository),
          myProfileProvider.overrideWith((ref) async => profile),
          myPhotosProvider.overrideWith((ref) async => const []),
          accountProvider.overrideWith((ref) async => null),
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
    return repository;
  }

  Future<void> tapContinue(WidgetTester tester) async {
    await tester.scrollUntilVisible(
      find.text('Continuar'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
  }

  testWidgets('starts by asking what the person wants', (tester) async {
    await pump(tester, const MyProfile(id: 'u1'));
    expect(find.text('O QUE VOCÊ BUSCA'), findsOneWidget);
    expect(find.text('SÓ EVENTOS'), findsOneWidget);

    await tapContinue(tester);
    expect(find.text('Escolha uma opção para continuar.'), findsOneWidget);
  });

  testWidgets('"events only" skips photos and goes to the city', (
    tester,
  ) async {
    final repository = await pump(tester, const MyProfile(id: 'u1'));
    await tester.tap(find.text('SÓ EVENTOS'));
    await tester.pump();
    await tapContinue(tester);

    expect(repository.saved.single, {
      'modes': <String>[],
      'onboarding_step': 3,
    });
    expect(find.text('SUA CIDADE'), findsOneWidget);
    expect(find.text('Etapa 2 de 4'), findsOneWidget);
    expect(find.text('Gênero'), findsNothing);
  });

  testWidgets('Date goes to the photos', (tester) async {
    final repository = await pump(tester, const MyProfile(id: 'u1'));
    await tester.tap(find.text('DATE'));
    await tester.pump();
    await tapContinue(tester);

    expect(repository.saved.single['modes'], ['date']);
    expect(find.text('SUAS FOTOS'), findsOneWidget);
    expect(find.text('Etapa 2 de 7'), findsOneWidget);
  });

  testWidgets('resumes at the saved step of each path', (tester) async {
    await pump(
      tester,
      MyProfile(
        id: 'u1',
        firstName: 'Ana',
        modes: const [AppMode.date],
        onboardingStep: OnboardingStep.music.index,
      ),
    );
    expect(find.text('SUA MÚSICA'), findsOneWidget);
    expect(find.text('Etapa 5 de 7'), findsOneWidget);
    expect(find.text('Techno'), findsOneWidget);
  });

  testWidgets('"events only" resumes in its shorter path', (tester) async {
    await pump(
      tester,
      MyProfile(id: 'u1', onboardingStep: OnboardingStep.music.index),
    );
    expect(find.text('SUA MÚSICA'), findsOneWidget);
    expect(find.text('Etapa 3 de 4'), findsOneWidget);
  });

  testWidgets('music step requires at least one genre', (tester) async {
    await pump(
      tester,
      MyProfile(id: 'u1', onboardingStep: OnboardingStep.music.index),
    );
    await tapContinue(tester);
    expect(find.text('Escolha pelo menos 1 gênero.'), findsOneWidget);
  });
}
