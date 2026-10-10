import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/app.dart';
import 'package:pulse/core/widgets/pulse_bottom_nav.dart';
import 'package:pulse/features/auth/domain/session_status.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/discover/presentation/widgets/discover_widgets.dart';
import 'package:pulse/features/events/data/events_repository.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/profile/domain/profile.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';

/// Lets a test move the session between states.
class _TestSession extends Notifier<SessionStatus> {
  new(this._initial);

  final SessionStatus _initial;

  @override
  SessionStatus build() => _initial;

  // A method keeps the call site explicit in the tests.
  // ignore: use_setters_to_change_properties
  void set(SessionStatus status) => state = status;
}

void main() {
  Future<NotifierProvider<_TestSession, SessionStatus>> pumpWith(
    WidgetTester tester,
    SessionStatus initial,
  ) async {
    final session = NotifierProvider<_TestSession, SessionStatus>(
      () => _TestSession(initial),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionStatusProvider.overrideWith((ref) => ref.watch(session)),
          // Tabs that load data get fake backends.
          myProfileProvider.overrideWith(
            (ref) async => const MyProfile(id: 'u1', city: 'Rio de Janeiro'),
          ),
          for (final scope in EventListScope.values)
            eventListProvider(scope).overrideWith((ref) async => const []),
        ],
        child: const PulseApp(),
      ),
    );
    await tester.pumpAndSettle();
    return session;
  }

  testWidgets('signed out → login, with links to sign-up', (tester) async {
    await pumpWith(tester, SessionStatus.signedOut);
    expect(find.text('ENTRAR'), findsOneWidget);
    expect(find.text('Criar conta'), findsOneWidget);
    expect(find.text('Esqueci minha senha'), findsOneWidget);

    await tester.tap(find.text('Criar conta'));
    await tester.pumpAndSettle();
    expect(find.text('BORA COMEÇAR'), findsOneWidget);
    expect(find.text('Etapa 1 de 3'), findsOneWidget);
  });

  testWidgets('login validates the form before calling the server', (
    tester,
  ) async {
    await pumpWith(tester, SessionStatus.signedOut);
    await tester.tap(find.widgetWithText(GestureDetector, 'Entrar').last);
    await tester.pumpAndSettle();
    expect(find.text('Digite um e-mail válido'), findsOneWidget);
    expect(find.text('Campo obrigatório'), findsOneWidget);
  });

  testWidgets('account setup starts at the phone step', (tester) async {
    await pumpWith(tester, SessionStatus.needsAccountSetup);
    expect(find.text('SEU CELULAR'), findsOneWidget);
    expect(find.text('Etapa 2 de 3'), findsOneWidget);
    // No code: the phone is saved straight away (launch decision).
    expect(find.text('Continuar'), findsOneWidget);
    expect(find.text('WhatsApp'), findsNothing);
  });

  testWidgets('session changes drive navigation into the tabs', (tester) async {
    final session = await pumpWith(tester, SessionStatus.signedOut);
    expect(find.text('ENTRAR'), findsOneWidget);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(PulseApp)),
    );
    container.read(session.notifier).set(SessionStatus.ready);
    await tester.pumpAndSettle();

    expect(find.byType(PulseBottomNav), findsOneWidget);
    expect(find.byType(ModeSelector), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(PulseBottomNav),
        matching: find.text('Eventos'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('EVENTOS'), findsOneWidget);

    container.read(session.notifier).set(SessionStatus.signedOut);
    await tester.pumpAndSettle();
    expect(find.text('ENTRAR'), findsOneWidget);
  });
}
