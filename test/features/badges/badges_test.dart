import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/features/admin/data/role_requests_repository.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/badges/data/badges_repository.dart';
import 'package:pulse/features/badges/domain/badge_models.dart';
import 'package:pulse/features/badges/presentation/admin_badges_screen.dart';
import 'package:pulse/features/badges/presentation/badge_request_screen.dart';
import 'package:pulse/features/badges/presentation/widgets/profile_badges.dart';
import 'package:pulse/l10n/app_localizations.dart';

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
    home: Scaffold(body: home),
  ),
);

Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

class FakeBadgesRepository implements BadgesRepository {
  new({this.badges = const {}, this.requests = const []});

  final Map<String, List<UserBadge>> badges;
  final List<BadgeRequest> requests;
  final calls = <String>[];

  @override
  Future<List<UserBadge>> badgesOf(String userId) async =>
      badges[userId] ?? const [];

  @override
  Future<List<BadgeRequest>> myRequests(String userId) async => requests;

  @override
  Future<void> request({
    required String userId,
    required ProfileBadgeType badge,
    required String justification,
    required List<String> links,
  }) async => calls.add('request:${badge.name}:${links.join(',')}');

  @override
  Future<void> grant({
    required String userId,
    required ProfileBadgeType badge,
    String? title,
  }) async => calls.add('grant:$userId:${badge.name}:$title');

  @override
  Future<void> revoke({
    required String userId,
    required ProfileBadgeType badge,
  }) async => calls.add('revoke:$userId:${badge.name}');

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  void usePhoneSize(WidgetTester tester) {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  testWidgets('badges show the name, the title and respect the limit', (
    tester,
  ) async {
    final repository = FakeBadgesRepository(
      badges: {
        'ana': const [
          UserBadge(badge: ProfileBadgeType.team, title: 'CEO'),
          UserBadge(badge: ProfileBadgeType.dj),
          UserBadge(badge: ProfileBadgeType.producer),
        ],
      },
    );
    await tester.pumpWidget(
      _app(const ProfileBadges(userId: 'ana', max: 2), [
        badgesRepositoryProvider.overrideWithValue(repository),
      ]),
    );
    await settle(tester);

    expect(find.text('Equipe Pulse · CEO'), findsOneWidget);
    expect(find.text('DJ'), findsOneWidget);
    expect(find.text('Produtor'), findsNothing);
  });

  testWidgets('people ask only for badges they do not have or asked for', (
    tester,
  ) async {
    usePhoneSize(tester);
    final repository = FakeBadgesRepository(
      requests: [
        BadgeRequest(
          id: 'r1',
          userId: 'me',
          badge: ProfileBadgeType.publicFigure,
          justification: 'Tenho muitos seguidores',
          status: RequestStatus.pending,
          createdAt: DateTime.utc(2026, 10, 3),
        ),
      ],
    );
    await tester.pumpWidget(
      _app(const BadgeRequestScreen(), [
        badgesRepositoryProvider.overrideWithValue(repository),
        currentUserIdProvider.overrideWithValue('me'),
      ]),
    );
    await settle(tester);

    expect(
      find.text('Seu pedido do selo Figura pública está em análise.'),
      findsOneWidget,
    );
    // Equipe Pulse is never requestable; Figura pública is pending.
    expect(find.widgetWithText(ChoiceChip, 'Equipe Pulse'), findsNothing);
    expect(find.widgetWithText(ChoiceChip, 'Figura pública'), findsNothing);

    await tester.tap(find.widgetWithText(ChoiceChip, 'DJ'));
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Conte quem você é'),
      'Toco techno há 5 anos em SP',
    );
    await tester.enterText(
      find.widgetWithText(
        TextFormField,
        'Links (Instagram, site, Resident Advisor…)',
      ),
      'https://soundcloud.com/eu',
    );
    await tester.ensureVisible(find.text('Enviar pedido'));
    await tester.tap(find.text('Enviar pedido'));
    await settle(tester);

    expect(repository.calls, ['request:dj:https://soundcloud.com/eu']);
  });

  testWidgets('admins grant a badge with a title', (tester) async {
    usePhoneSize(tester);
    final repository = FakeBadgesRepository();
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => TextButton(
            onPressed: () =>
                showManageBadges(context, userId: 'bruno', name: 'Bruno'),
            child: const Text('abrir'),
          ),
        ),
        [badgesRepositoryProvider.overrideWithValue(repository)],
      ),
    );
    await tester.tap(find.text('abrir'));
    await settle(tester);

    expect(find.text('SELOS DE BRUNO'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'CEO');
    await tester.tap(find.byType(Switch).first);
    await settle(tester);

    expect(repository.calls, ['grant:bruno:team:CEO']);
  });
}
