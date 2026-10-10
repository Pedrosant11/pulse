import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/features/admin/data/moderation_repository.dart';
import 'package:pulse/features/admin/domain/moderation_models.dart';
import 'package:pulse/features/admin/presentation/moderation_providers.dart';
import 'package:pulse/features/admin/presentation/reports_screen.dart';
import 'package:pulse/features/auth/domain/account_state.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/features/safety/data/safety_repository.dart';
import 'package:pulse/features/safety/domain/safety_models.dart';
import 'package:pulse/features/safety/presentation/account_restricted_screen.dart';
import 'package:pulse/features/safety/presentation/blocked_users_screen.dart';
import 'package:pulse/features/safety/presentation/safety_actions.dart';
import 'package:pulse/features/safety/presentation/safety_providers.dart';
import 'package:pulse/l10n/app_localizations.dart';

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
    home: child,
  ),
);

Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Scrolls the open bottom sheet until [finder] is on screen.
Future<void> scrollSheetTo(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    100,
    scrollable: find
        .descendant(
          of: find.byType(BottomSheet),
          matching: find.byType(Scrollable),
        )
        .first,
  );
  await settle(tester);
}

class FakeSafetyRepository implements SafetyRepository {
  final calls = <String>[];

  @override
  Future<void> report({
    required ReportTarget target,
    required String targetId,
    required ReportReason reason,
    String? details,
  }) async => calls.add('report:${target.name}:$targetId:${reason.name}');

  @override
  Future<void> block({
    required String blockerId,
    required String userId,
  }) async => calls.add('block:$userId');

  @override
  Future<void> unblock({
    required String blockerId,
    required String userId,
  }) async => calls.add('unblock:$userId');

  @override
  Future<List<BlockedUser>> blockedUsers() async => [
    BlockedUser(
      userId: 'elisa',
      firstName: 'Elisa',
      blockedAt: DateTime.utc(2026, 10),
    ),
  ];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeModerationRepository implements ModerationRepository {
  final calls = <String>[];

  @override
  Future<void> resolve({
    required String reportId,
    required ReportOutcome outcome,
    String? note,
    int? suspensionDays,
    bool removeContent = false,
  }) async => calls.add(
    'resolve:$reportId:${outcome.name}:$note:$suspensionDays:$removeContent',
  );

  @override
  Future<List<RestrictedUser>> restrictedUsers() async => const [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeSafetyRepository safety;

  setUp(() => safety = FakeSafetyRepository());

  // Phone-sized surface (the default 800x600 cuts the bottom sheets).
  void usePhoneSize(WidgetTester tester) {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  List<Object> safetyOverrides() => [
    safetyRepositoryProvider.overrideWithValue(safety),
    currentUserIdProvider.overrideWithValue('me'),
    photoUrlProvider.overrideWith((ref, path) async => 'https://x/$path'),
  ];

  testWidgets('reporting a message can also block the sender', (tester) async {
    bool? result;
    await tester.pumpWidget(
      _app(
        Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async => result = await showReportSheet(
                context,
                target: ReportTarget.message,
                targetId: 'm1',
                userId: 'elisa',
                userName: 'Elisa',
              ),
              child: const Text('abrir'),
            ),
          ),
        ),
        safetyOverrides(),
      ),
    );
    await tester.tap(find.text('abrir'));
    await settle(tester);

    expect(find.text('DENUNCIAR MENSAGEM'), findsOneWidget);
    expect(find.text('Também bloquear Elisa'), findsOneWidget);

    await tester.tap(find.text('Assédio ou ameaça'));
    await settle(tester);
    await scrollSheetTo(tester, find.text('Enviar denúncia'));
    await tester.tap(find.text('Enviar denúncia'));
    await settle(tester);

    expect(safety.calls, ['report:message:m1:harassment', 'block:elisa']);
    expect(result, isTrue);
    expect(
      find.text(
        'Denúncia enviada. Obrigado por ajudar a manter a pista segura.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('event reports offer event reasons and no block', (tester) async {
    await tester.pumpWidget(
      _app(
        Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => showReportSheet(
                context,
                target: ReportTarget.event,
                targetId: 'e1',
              ),
              child: const Text('abrir'),
            ),
          ),
        ),
        safetyOverrides(),
      ),
    );
    await tester.tap(find.text('abrir'));
    await settle(tester);

    expect(find.text('Evento falso ou duplicado'), findsOneWidget);
    expect(find.text('Menor de idade'), findsNothing);
    expect(find.byType(CheckboxListTile), findsNothing);
  });

  testWidgets('blocked users can be unblocked', (tester) async {
    await tester.pumpWidget(
      _app(const BlockedUsersScreen(), safetyOverrides()),
    );
    await settle(tester);

    expect(find.text('Elisa'), findsOneWidget);
    await tester.tap(find.text('Desbloquear'));
    await settle(tester);
    expect(find.text('Desbloquear Elisa?'), findsOneWidget);
    await tester.tap(find.text('Desbloquear').last);
    await settle(tester);

    expect(safety.calls, ['unblock:elisa']);
  });

  testWidgets('a suspended account sees why and until when', (tester) async {
    await tester.pumpWidget(
      _app(const AccountRestrictedScreen(), [
        accountProvider.overrideWith(
          (ref) async => const AccountState(
            userId: 'me',
            hasPhone: true,
            termsAccepted: true,
            onboardingCompleted: true,
            status: AccountStatus.suspended,
          ),
        ),
        moderationNoticeProvider.overrideWith(
          (ref) async => ModerationNotice(
            id: 'a1',
            action: ModerationAction.suspension,
            reason: 'Assédio no chat',
            createdAt: DateTime.utc(2026, 10, 3),
            expiresAt: DateTime.utc(2026, 10, 10, 15),
          ),
        ),
      ]),
    );
    await settle(tester);

    expect(find.text('CONTA SUSPENSA'), findsOneWidget);
    expect(find.text('Motivo: Assédio no chat'), findsOneWidget);
    expect(find.textContaining('Até '), findsOneWidget);
    expect(find.text('Excluir conta'), findsOneWidget);
  });

  testWidgets('admins resolve a report; account actions need a reason', (
    tester,
  ) async {
    usePhoneSize(tester);
    final moderation = FakeModerationRepository();
    await tester.pumpWidget(
      _app(const ReportsScreen(), [
        moderationRepositoryProvider.overrideWithValue(moderation),
        photoUrlProvider.overrideWith((ref, path) async => 'https://x/$path'),
        pendingReportsProvider.overrideWith(
          (ref) async => [
            AdminReport(
              id: 'r1',
              targetType: ReportTarget.message,
              targetId: 'm1',
              reason: ReportReason.harassment,
              createdAt: DateTime.utc(2026, 10, 3, 22),
              snapshot: const {'content': 'mensagem ofensiva'},
              reporterFirstName: 'Ana',
              reportedUserId: 'elisa',
              reportedFirstName: 'Elisa',
              reportsAgainstUser: 2,
            ),
          ],
        ),
      ]),
    );
    await settle(tester);

    expect(find.text('“mensagem ofensiva”'), findsOneWidget);
    await tester.tap(find.text('Assédio ou ameaça'));
    await settle(tester);

    expect(find.text('Conta denunciada: Elisa'), findsOneWidget);
    expect(find.text('2 denúncias · nenhuma punição'), findsOneWidget);

    // Warning (default) without a reason: Apply is disabled.
    await tester.tap(find.text('Aplicar'));
    await settle(tester);
    expect(moderation.calls, isEmpty);

    await tester.enterText(
      find.widgetWithText(TextField, 'Motivo (a pessoa vai ver)'),
      'Linguagem ofensiva',
    );
    await settle(tester);
    await scrollSheetTo(tester, find.text('Aplicar'));
    await tester.tap(find.text('Aplicar'));
    await settle(tester);

    expect(moderation.calls, [
      'resolve:r1:warning:Linguagem ofensiva:null:true',
    ]);
  });
}
