import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/events/data/event_chat_repository.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/domain/event_chat.dart';
import 'package:pulse/features/events/presentation/event_chat_providers.dart';
import 'package:pulse/features/events/presentation/event_chat_screen.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/events/presentation/widgets/event_chat_card.dart';
import 'package:pulse/l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _NoSubscription implements EventChatSubscription {
  @override
  Future<void> close() async {}
}

class _FakeChat implements EventChatRepository {
  new({this.refuse});

  final String? refuse;
  final sent = <String>[];
  final page = <EventChatMessage>[
    EventChatMessage(
      id: 'm2',
      senderId: 'p',
      firstName: 'Pedro',
      isTeam: true,
      content: 'Portas abrem às 23h!',
      createdAt: DateTime(2026, 11, 6, 20),
    ),
    EventChatMessage(
      id: 'm1',
      senderId: 'b',
      firstName: 'Bia',
      isVerified: true,
      content: 'Alguém de carona saindo de Botafogo?',
      createdAt: DateTime(2026, 11, 6, 19),
    ),
  ];

  @override
  Future<List<EventChatMessage>> messages(
    String eventId, {
    DateTime? before,
    int limit = 50,
  }) async => before == null ? page : const [];

  @override
  Future<void> send(String eventId, String content) async {
    if (refuse != null) {
      throw AppFailure.from(
        PostgrestException(message: 'no', code: 'P0001', hint: refuse),
      );
    }
    sent.add(content);
  }

  @override
  EventChatSubscription subscribe(String eventId, void Function() onChange) =>
      _NoSubscription();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _open = EventChatInfo(
  state: EventChatState.open,
  inChat: true,
  canModerate: false,
  muted: false,
  people: 42,
  messages: 2,
);

Widget _app(
  Widget home, {
  required _FakeChat repository,
  EventChatInfo info = _open,
}) => ProviderScope(
  overrides: [
    eventChatRepositoryProvider.overrideWithValue(repository),
    currentUserIdProvider.overrideWithValue('me'),
    eventChatInfoProvider('e1').overrideWith((ref) async => info),
    // The event name is optional in the header: never loads here.
    eventDetailProvider('e1')
        .overrideWith((ref) => Completer<EventDetail>().future),
  ],
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
  test('a fresh page replaces its range and keeps older messages', () {
    EventChatMessage m(String id, int hour) => EventChatMessage(
      id: id,
      senderId: 's',
      firstName: 'A',
      content: id,
      createdAt: DateTime(2026, 11, 6, hour),
    );
    final loaded = [m('old', 18), m('a', 19), m('deleted', 20)];
    final merged = mergeEventChat(loaded, [m('new', 21), m('a', 19)]);
    expect([for (final x in merged) x.id], ['old', 'a', 'new']);
  });

  testWidgets('shows who wrote, the team tag, and sends', (tester) async {
    final repository = _FakeChat();
    await tester.pumpWidget(
      _app(const EventChatScreen(eventId: 'e1'), repository: repository),
    );
    await settle(tester);
    expect(find.text('Alguém de carona saindo de Botafogo?'), findsOneWidget);
    expect(find.text('PRODUÇÃO'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '  Bora!  ');
    await tester.pump();
    await tester.tap(find.byTooltip('Enviar'));
    await settle(tester);
    expect(repository.sent, ['Bora!']);
  });

  testWidgets('muted: no composer, explains why', (tester) async {
    await tester.pumpWidget(
      _app(
        const EventChatScreen(eventId: 'e1'),
        repository: _FakeChat(),
        info: const EventChatInfo(
          state: EventChatState.open,
          inChat: true,
          canModerate: false,
          muted: true,
          people: 42,
          messages: 2,
        ),
      ),
    );
    await settle(tester);
    expect(find.byType(TextField), findsNothing);
    expect(find.text('A produção silenciou você neste chat.'), findsOneWidget);
  });

  testWidgets('a refused message explains it', (tester) async {
    await tester.pumpWidget(
      _app(
        const EventChatScreen(eventId: 'e1'),
        repository: _FakeChat(refuse: 'event_chat_closed'),
      ),
    );
    await settle(tester);
    await tester.enterText(find.byType(TextField), 'oi');
    await tester.pump();
    await tester.tap(find.byTooltip('Enviar'));
    await settle(tester);
    expect(find.text('O chat dessa festa está fechado.'), findsOneWidget);
  });

  testWidgets('event page: who is not going is invited to mark "Eu vou"', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const Scaffold(body: EventChatCard(eventId: 'e1')),
        repository: _FakeChat(),
        info: const EventChatInfo(
          state: EventChatState.open,
          inChat: false,
          canModerate: false,
          muted: false,
          people: 42,
          messages: 7,
        ),
      ),
    );
    await settle(tester);
    expect(find.text('Chat da festa · 42 pessoas vão'), findsOneWidget);
    expect(
      find.text('Marque "Eu vou" para entrar no chat da festa.'),
      findsOneWidget,
    );
  });
}
