import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/core/models/user_role.dart';
import 'package:pulse/features/admin/data/role_requests_repository.dart';
import 'package:pulse/features/admin/presentation/admin_screen.dart';
import 'package:pulse/features/admin/presentation/role_request_providers.dart';
import 'package:pulse/features/events/presentation/event_form_screen.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/profile/domain/profile.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/l10n/app_localizations.dart';

/// Buttons inside rows/positioned widgets used to get an infinite minimum
/// width from the theme and silently disappear (Phase 4 test feedback).
void main() {
  Future<void> pump(
    WidgetTester tester,
    Widget screen, {
    UserRole role = UserRole.user,
    List<Override> overrides = const [],
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          myProfileProvider.overrideWith(
            (ref) async => MyProfile(id: 'u1', role: role),
          ),
          ...overrides,
        ],
        child: MaterialApp(
          theme: AppTheme.dark(),
          locale: const Locale('pt', 'BR'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          home: screen,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('admin sees who asks for a role, with actions', (tester) async {
    await pump(
      tester,
      const AdminScreen(),
      role: UserRole.admin,
      overrides: [
        pendingRoleRequestsProvider.overrideWith(
          (ref) async => [
            RoleRequest(
              id: 'r1',
              userId: 'u4',
              requestedRole: UserRole.producer,
              justification: 'Produzo festas há 5 anos.',
              status: RequestStatus.pending,
              createdAt: DateTime(2026, 10, 3),
              requesterName: 'Carla Mendes',
              requesterPlace: 'São Paulo, SP',
            ),
          ],
        ),
        pendingEventsProvider.overrideWith((ref) async => const []),
      ],
    );
    expect(tester.takeException(), isNull);
    // The admin list grew (Verificações); bring the request into view.
    await tester.ensureVisible(find.text('Aprovar'));
    await tester.pumpAndSettle();
    expect(find.text('Carla Mendes'), findsOneWidget);
    expect(find.text('São Paulo, SP'), findsOneWidget);
    expect(find.text('Ver perfil').hitTestable(), findsOneWidget);
    expect(find.text('Produzo festas há 5 anos.'), findsOneWidget);
    expect(find.text('Aprovar').hitTestable(), findsOneWidget);
    expect(find.text('Recusar').hitTestable(), findsOneWidget);
  });

  testWidgets('event form shows a tappable cover button', (tester) async {
    await pump(tester, const EventFormScreen());
    expect(tester.takeException(), isNull);
    expect(find.text('Importar').hitTestable(), findsOneWidget);
    await tester.drag(find.byType(ListView).first, const Offset(0, -200));
    await tester.pumpAndSettle();
    expect(find.text('Adicionar capa').hitTestable(), findsOneWidget);
  });
}
