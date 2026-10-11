import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/features/safety/presentation/widgets/night_safety.dart';
import 'package:pulse/l10n/app_localizations.dart';

void main() {
  testWidgets('the event card opens tips and emergency numbers', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(400, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        locale: const Locale('pt', 'BR'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        home: Scaffold(
          body: NightSafetyCard(
            eventName: 'Noite Ácida',
            venue: 'D-Edge, São Paulo',
            startsAt: DateTime(2026, 10, 16, 23),
          ),
        ),
      ),
    );

    expect(find.text('Rolê seguro'), findsOneWidget);
    expect(find.text('Compartilhar meu rolê'), findsOneWidget);

    await tester.tap(find.text('Dicas e emergência'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Central de Atendimento à Mulher'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('SAMU'), findsOneWidget);
    expect(find.text('192'), findsOneWidget);
    expect(find.text('Central de Atendimento à Mulher'), findsOneWidget);
  });
}
