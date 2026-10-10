import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/core/models/app_mode.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/chat/domain/chat_models.dart';
import 'package:pulse/features/chat/presentation/chat_providers.dart';
import 'package:pulse/features/chat/presentation/chats_screen.dart';
import 'package:pulse/features/crews/data/crews_repository.dart';
import 'package:pulse/features/crews/domain/crew_models.dart';
import 'package:pulse/features/crews/presentation/crew_screen.dart';
import 'package:pulse/features/crews/presentation/crews_providers.dart';
import 'package:pulse/features/discover/domain/discover_models.dart';
import 'package:pulse/features/discover/presentation/match_screen.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
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

final _starts = DateTime.utc(2026, 10, 10, 2);

CrewDetail crewDetail({
  CrewRelation? status,
  int members = 2,
  bool isOpen = true,
}) => CrewDetail(
  id: 'k1',
  name: 'Crew de Ana',
  maxMembers: 8,
  memberCount: members,
  ownerId: 'ana',
  eventId: 'e1',
  eventName: 'Noite Ácida',
  eventStartsAt: _starts,
  isOpen: isOpen,
  myStatus: status,
  myRequestId: status == CrewRelation.invited ? 'r1' : null,
  conversationId: status == CrewRelation.owner ? 'c9' : null,
);

List<Object> crewOverrides(CrewDetail crew) => [
  currentUserIdProvider.overrideWithValue('me'),
  crewProvider('k1').overrideWith((ref) async => crew),
  crewMembersProvider('k1').overrideWith(
    (ref) async => [
      CrewMember(
        userId: 'ana',
        role: CrewRole.owner,
        joinedAt: _starts,
        firstName: 'Ana',
      ),
    ],
  ),
  crewPendingProvider('k1').overrideWith((ref) async => const []),
  photoUrlProvider.overrideWith((ref, path) async => 'https://x/$path'),
];

class FakeCrewsRepository implements CrewsRepository {
  final calls = <String>[];

  @override
  Future<String> create({
    required String eventId,
    required String ownerId,
    required String name,
    required bool isOpen,
    required bool sameGenderOnly,
    String? description,
  }) async {
    calls.add('create:$eventId:$ownerId:$name');
    return 'new-crew';
  }

  @override
  Future<void> invite(String crewId, String userId) async =>
      calls.add('invite:$crewId:$userId');

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('CrewScreen', () {
    testWidgets('owner opens the group chat and can invite', (tester) async {
      await tester.pumpWidget(
        _app(
          const CrewScreen(crewId: 'k1'),
          crewOverrides(crewDetail(status: CrewRelation.owner)),
        ),
      );
      await settle(tester);
      expect(find.text('CREW DE ANA'), findsOneWidget);
      expect(find.text('Abrir chat do grupo'), findsOneWidget);
      expect(find.text('Convidar'), findsOneWidget);
      expect(find.text('Apagar crew'), findsOneWidget);
    });

    testWidgets('invited users accept or decline', (tester) async {
      await tester.pumpWidget(
        _app(
          const CrewScreen(crewId: 'k1'),
          crewOverrides(crewDetail(status: CrewRelation.invited)),
        ),
      );
      await settle(tester);
      expect(find.text('Você tem um convite para esta crew'), findsOneWidget);
      expect(find.text('Aceitar convite'), findsOneWidget);
      expect(find.text('Abrir chat do grupo'), findsNothing);
    });

    testWidgets('attendees can ask to join open crews', (tester) async {
      await tester.pumpWidget(
        _app(const CrewScreen(crewId: 'k1'), crewOverrides(crewDetail())),
      );
      await settle(tester);
      expect(find.text('Pedir pra entrar'), findsOneWidget);
    });

    testWidgets('full crews say so instead of offering to join', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          const CrewScreen(crewId: 'k1'),
          crewOverrides(crewDetail(members: 8)),
        ),
      );
      await settle(tester);
      expect(find.text('Lotada'), findsOneWidget);
      expect(find.text('Pedir pra entrar'), findsNothing);
    });
  });

  testWidgets('Groups tab lists crew invites and group chats', (tester) async {
    await tester.pumpWidget(
      _app(const ChatsScreen(), [
        currentUserIdProvider.overrideWithValue('me'),
        conversationsProvider.overrideWith(
          () => _FixedConversations([
            ConversationSummary(
              id: 'c9',
              type: ConversationType.crew,
              createdAt: _starts,
              crewId: 'k2',
              crewName: 'Galera do Psy',
              eventName: 'Psy Rio',
              memberCount: 4,
            ),
          ]),
        ),
        myCrewInvitesProvider.overrideWith(
          (ref) async => [
            MyCrewInvite(
              requestId: 'r1',
              crewId: 'k1',
              crewName: 'Crew de Ana',
              eventName: 'Noite Ácida',
              eventStartsAt: _starts,
              memberCount: 2,
              invitedByName: 'Ana',
            ),
          ],
        ),
      ]),
    );
    await settle(tester);
    await tester.tap(find.text('Grupos'));
    await settle(tester);
    expect(find.text('CONVITES DE CREW'), findsOneWidget);
    expect(find.text('Ana te convidou · 2/8'), findsOneWidget);
    expect(find.text('Galera do Psy'), findsOneWidget);
    expect(find.text('Psy Rio · 4 pessoas'), findsOneWidget);
  });

  testWidgets('Crew match offers to build a crew for the event', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        MatchScreen(
          args: MatchArgs(
            mode: AppMode.crew,
            conversationId: 'c1',
            other: DiscoverCandidate(
              id: 'elisa',
              firstName: 'Elisa',
              age: 27,
              commonEvents: [
                CommonEvent(id: 'e1', name: 'Noite Ácida', startsAt: _starts),
              ],
            ),
          ),
        ),
        [
          myPhotosProvider.overrideWith((ref) async => const []),
          photoUrlProvider.overrideWith((ref, path) async => 'https://x/$path'),
        ],
      ),
    );
    await settle(tester);
    expect(find.text('Montar crew para Noite Ácida'), findsOneWidget);
    expect(find.text('Mandar mensagem'), findsOneWidget);
  });

  test('creating from a match invites the person in the same step', () async {
    final repository = FakeCrewsRepository();
    final container = ProviderContainer(
      overrides: [
        crewsRepositoryProvider.overrideWithValue(repository),
        currentUserIdProvider.overrideWithValue('me'),
      ],
    );
    addTearDown(container.dispose);
    container.listen(crewEditorProvider, (_, _) {});

    final crewId = await container
        .read(crewEditorProvider.notifier)
        .create(
          eventId: 'e1',
          name: 'Crew de Ana',
          isOpen: true,
          sameGenderOnly: false,
          inviteUserId: 'elisa',
        );
    expect(crewId, 'new-crew');
    expect(repository.calls, [
      'create:e1:me:Crew de Ana',
      'invite:new-crew:elisa',
    ]);
  });
}

class _FixedConversations extends Conversations {
  new(this._items);

  final List<ConversationSummary> _items;

  @override
  Future<List<ConversationSummary>> build() async => _items;
}
