import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/models/user_role.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/auth/presentation/login_screen.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/safety/presentation/safety_tips_screen.dart';
import 'package:pulse/features/settings/presentation/delete_account_screen.dart';
import 'package:pulse/features/settings/presentation/settings_screen.dart';
import 'package:pulse/l10n/app_localizations.dart';

/// Automated accessibility checks (SPEC 13): touch target sizes, labels on
/// tappable things, text contrast, and layouts that survive large fonts.
void main() {
  Widget app(Widget home, {double textScale = 1}) => ProviderScope(
    overrides: [currentRoleProvider.overrideWithValue(UserRole.admin)],
    child: MaterialApp(
      theme: AppTheme.dark(),
      locale: const Locale('pt', 'BR'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
      home: home,
    ),
  );

  final screens = <String, Widget>{
    'login': const LoginScreen(),
    'settings': const SettingsScreen(),
    'safety tips': const SafetyTipsScreen(),
    'delete account': const DeleteAccountScreen(),
    'empty state': const Scaffold(
      body: EmptyView(
        icon: Icons.groups_outlined,
        title: 'Nada por aqui',
        message: 'Quando tiver, aparece aqui.',
        actionLabel: 'Ver eventos',
        onAction: _noop,
      ),
    ),
    'crew button': Builder(
      builder: (context) => Scaffold(
        body: Center(
          child: NeonButton(
            label: 'Montar crew para Noite Ácida',
            icon: Icons.groups_rounded,
            gradient: context.colors.crewGradient,
            onPressed: _noop,
          ),
        ),
      ),
    ),
  };

  for (final MapEntry(key: name, value: screen) in screens.entries) {
    testWidgets('$name meets the accessibility guidelines', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(app(screen));
      await tester.pumpAndSettle();

      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      handle.dispose();
    });

    testWidgets('$name lays out with twice the font size', (tester) async {
      tester.view
        ..physicalSize = const Size(1080, 2400)
        ..devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(app(screen, textScale: 2));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}

void _noop() {}
