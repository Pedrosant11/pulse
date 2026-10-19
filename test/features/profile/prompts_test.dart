import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/profile/data/profile_repository.dart';
import 'package:pulse/features/profile/domain/profile_prompt.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/features/profile/presentation/widgets/profile_prompts.dart';
import 'package:pulse/l10n/app_localizations.dart';

class _FakeProfiles implements ProfileRepository {
  List<PromptAnswer>? saved;

  @override
  Future<void> setPrompts(List<PromptAnswer> answers) async => saved = answers;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget _app(Widget child, List<Object> overrides) => ProviderScope(
  overrides: overrides.cast(),
  child: MaterialApp(
    theme: AppTheme.dark(),
    locale: const Locale('pt', 'BR'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    home: Scaffold(body: SingleChildScrollView(child: child)),
  ),
);

Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  testWidgets('a profile shows its answers under the question', (tester) async {
    await tester.pumpWidget(
      _app(const ProfilePromptsView(userId: 'ana'), [
        profilePromptsProvider('ana').overrideWith(
          (ref) async => const [
            PromptAnswer(prompt: ProfilePrompt.dreamSet, answer: 'Amelie Lens'),
          ],
        ),
      ]),
    );
    await settle(tester);
    expect(find.text('Meu set dos sonhos é…'), findsOneWidget);
    expect(find.text('Amelie Lens'), findsOneWidget);
  });

  testWidgets('pick a question, answer it and save', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final repository = _FakeProfiles();
    var done = false;
    await tester.pumpWidget(
      _app(PromptsForm(initial: const [], onSaved: () => done = true), [
        profileRepositoryProvider.overrideWithValue(repository),
        // The editor needs the signed-in id to refresh the answers.
        currentUserIdProvider.overrideWithValue('me'),
        profilePromptsProvider('me').overrideWith((ref) async => const []),
      ]),
    );
    await settle(tester);

    await tester.tap(find.text('Adicionar pergunta'));
    await settle(tester);
    await tester.tap(find.text('Depois da festa, eu…'));
    await settle(tester);
    await tester.enterText(find.byType(TextField), '  Pão de queijo  ');
    await tester.tap(find.text('Salvar'));
    await settle(tester);

    expect(repository.saved, const [
      PromptAnswer(prompt: ProfilePrompt.afterParty, answer: 'Pão de queijo'),
    ]);
    expect(done, isTrue);
  });
}
