import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/core/models/app_mode.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/chat/domain/chat_models.dart';
import 'package:pulse/features/chat/presentation/chat_providers.dart';
import 'package:pulse/features/chat/presentation/chats_screen.dart';
import 'package:pulse/features/chat/presentation/conversation_screen.dart';
import 'package:pulse/features/discover/domain/discover_models.dart';
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

class _FixedConversations extends Conversations {
  new(this._items);

  final List<ConversationSummary> _items;

  @override
  Future<List<ConversationSummary>> build() async => _items;
}

class _FixedConversation extends ConversationController {
  new(this._state);

  final ConversationState _state;

  @override
  Future<ConversationState> build(String conversationId) async => _state;
}

void main() {
  final created = DateTime.utc(2026, 10, 4, 20);

  testWidgets('inbox separates new matches and shows unread counts', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(const ChatsScreen(), [
        currentUserIdProvider.overrideWithValue('me'),
        conversationsProvider.overrideWith(
          () => _FixedConversations([
            ConversationSummary(
              id: 'c1',
              type: ConversationType.direct,
              mode: AppMode.date,
              createdAt: created,
              otherFirstName: 'Diego',
            ),
            ConversationSummary(
              id: 'c2',
              type: ConversationType.direct,
              mode: AppMode.date,
              createdAt: created,
              otherFirstName: 'Marcos',
              lastMessage: 'Bora?',
              lastMessageSenderId: 'other',
              lastMessageAt: DateTime.now(),
              unreadCount: 2,
            ),
          ]),
        ),
      ]),
    );
    await settle(tester);
    expect(find.text('NOVOS MATCHES'), findsOneWidget);
    expect(find.text('Diego'), findsOneWidget);
    expect(find.text('Bora?'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('empty chats show icebreakers from the common event', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(const ConversationScreen(conversationId: 'c1'), [
        currentUserIdProvider.overrideWithValue('me'),
        conversationHeaderProvider('c1').overrideWith(
          (ref) async => ConversationHeader(
            id: 'c1',
            type: ConversationType.direct,
            mode: AppMode.crew,
            otherFirstName: 'Elisa',
            commonEvents: [
              CommonEvent(id: 'e1', name: 'Noite Ácida', startsAt: created),
            ],
          ),
        ),
        conversationControllerProvider('c1').overrideWith(
          () => _FixedConversation(const ConversationState(messages: [])),
        ),
      ]),
    );
    await settle(tester);
    expect(find.text('Elisa'), findsOneWidget);
    expect(find.text('Bora se encontrar na Noite Ácida?'), findsOneWidget);
  });

  testWidgets('messages show read status for the sender', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      _app(const ConversationScreen(conversationId: 'c1'), [
        currentUserIdProvider.overrideWithValue('me'),
        conversationHeaderProvider('c1').overrideWith(
          (ref) async => const ConversationHeader(
            id: 'c1',
            type: ConversationType.direct,
            mode: AppMode.date,
            otherFirstName: 'Diego',
          ),
        ),
        conversationControllerProvider('c1').overrideWith(
          () => _FixedConversation(
            ConversationState(
              hasMore: false,
              otherLastReadAt: created.add(const Duration(minutes: 5)),
              messages: [
                ChatMessage(
                  id: 'm1',
                  conversationId: 'c1',
                  senderId: 'me',
                  content: 'Oi!',
                  createdAt: created,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
    await settle(tester);
    expect(find.text('Oi!'), findsOneWidget);
    // The bubble merges its texts: "Oi!, <hora>, Lida".
    expect(tester.getSemantics(find.text('Oi!')).label, contains('Lida'));
    semantics.dispose();
  });
}
