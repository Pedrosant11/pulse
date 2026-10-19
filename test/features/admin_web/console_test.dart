import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/features/admin_web/data/admin_console_repository.dart';
import 'package:pulse/features/admin_web/domain/admin_console_models.dart';
import 'package:pulse/features/admin_web/presentation/admin_console_providers.dart';
import 'package:pulse/features/admin_web/presentation/admin_settings_screen.dart';
import 'package:pulse/features/admin_web/presentation/dashboard_screen.dart';
import 'package:pulse/features/events/domain/featured.dart';
import 'package:pulse/l10n/app_localizations.dart';

class _FakeConsole implements AdminConsoleRepository {
  final saved = <String>[];

  @override
  Future<void> setSetting(String key, int value) async =>
      saved.add('$key=$value');

  @override
  Future<List<AppSetting>> settings() async => const [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

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
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  test('the dashboard reads the database names (new_7d, revenue_30d...)', () {
    final d = AdminDashboard.fromJson({
      'users': {'total': 120, 'new_today': 3, 'new_7d': 20, 'active_24h': 40},
      'activity': {'matches_24h': 7, 'messages_7d': 300},
      'pending': {'events': 2, 'reports': 1},
      'plans': {'plus': 5, 'black': 2, 'trial': 9},
      'revenue_30d': {'store_usd': 41.5, 'featured_team_cents': 24900},
      'daily': [
        {'day': '2026-10-18', 'signups': 4, 'matches': 1},
      ],
    });
    expect(d.users.new7d, 20);
    expect(d.users.active24h, 40);
    expect(d.activity.matches24h, 7);
    expect(d.pending.total, 3);
    expect(d.revenue30d.featuredTeamCents, 24900);
    expect(d.daily.single.signups, 4);
  });

  testWidgets('the dashboard shows the numbers and what is pending', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1300, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      _app(const DashboardScreen(), [
        adminDashboardProvider.overrideWith(
          (ref) async => AdminDashboard(
            users: const DashboardUsers(total: 1234, new7d: 56, newToday: 7),
            activity: const DashboardActivity(matches24h: 12),
            pending: const DashboardPending(reports: 2),
            plans: const DashboardPlans(black: 3),
            revenue30d: const DashboardRevenue(featuredTeamCents: 44900),
            daily: [
              for (var i = 0; i < 30; i++)
                DashboardDay(day: DateTime(2026, 9, 20 + i), signups: i),
            ],
          ),
        ),
      ]),
    );
    await settle(tester);
    expect(find.text('1.234'), findsOneWidget);
    expect(find.text('7 hoje'), findsOneWidget);
    expect(find.text('Denúncias'), findsOneWidget);
    expect(find.text('435 no período'), findsOneWidget);
    expect(find.textContaining('449,00'), findsOneWidget);
  });

  testWidgets('a setting is saved only after it changes', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1000, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final console = _FakeConsole();
    await tester.pumpWidget(
      _app(const AdminSettingsScreen(), [
        adminConsoleRepositoryProvider.overrideWithValue(console),
        adminSettingsProvider.overrideWith(
          (ref) async => const [AppSetting(key: 'trial_days', value: '3')],
        ),
        adminFeaturedPricesProvider.overrideWith(
          (ref) async => const <FeaturedPrice>[],
        ),
      ]),
    );
    await settle(tester);
    expect(find.text('Dias de teste grátis do Black'), findsOneWidget);
    final save = find.widgetWithText(FilledButton, 'Salvar');
    expect(tester.widget<FilledButton>(save).onPressed, isNull);

    await tester.enterText(find.byType(TextField), '5');
    await settle(tester);
    await tester.tap(save);
    await settle(tester);
    expect(console.saved, ['trial_days=5']);
  });
}
