import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/chat/data/chat_repository.dart';
import 'package:pulse/features/chat/domain/poll.dart';
import 'package:pulse/features/chat/presentation/chat_providers.dart';
import 'package:pulse/features/chat/presentation/widgets/chat_poll.dart';
import 'package:pulse/l10n/app_localizations.dart';

class _FakePolls implements PollsRepository {
  final calls = <String>[];

  @override
  Future<void> vote(
    String pollId, {
    required String userId,
    int? option,
  }) async => calls.add('vote:$option');

  @override
  Future<String> create({
    required String conversationId,
    required String question,
    required List<String> options,
    required int hours,
  }) async {
    calls.add('create:$question:${options.join('|')}:$hours');
    return 'p2';
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final _poll = Poll(
  id: 'p1',
  conversationId: 'c1',
  question: 'Que horas o esquenta?',
  options: const ['22h', '23h'],
  closesAt: DateTime.now().add(const Duration(hours: 5, minutes: 30)),
);

Widget _app(Widget child, _FakePolls repository, List<PollVote> votes) =>
    ProviderScope(
      overrides: [
        pollsRepositoryProvider.overrideWithValue(repository),
        pollProvider('p1').overrideWith((ref) async => _poll),
        pollVotesProvider('p1').overrideWith((ref) => Stream.value(votes)),
        currentUserIdProvider.overrideWithValue('me'),
      ],
      child: MaterialApp(
        theme: AppTheme.dark(),
        locale: const Locale('pt', 'BR'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        home: Scaffold(body: child),
      ),
    );

Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  test('tally: counts per option, total and my vote', () {
    final result = tallyVotes(_poll, const [
      PollVote(pollId: 'p1', userId: 'me', option: 1),
      PollVote(pollId: 'p1', userId: 'ana', option: 1),
      PollVote(pollId: 'p1', userId: 'bia', option: 0),
      PollVote(pollId: 'p1', userId: 'x', option: 7),
    ], 'me');
    expect(result.counts, [1, 2]);
    expect(result.total, 3);
    expect(result.mine, 1);
  });

  testWidgets('shows the votes; tapping votes, tapping mine again undoes', (
    tester,
  ) async {
    final repository = _FakePolls();
    await tester.pumpWidget(
      _app(
        const PollCard(pollId: 'p1', accent: Colors.cyan),
        repository,
        const [
          PollVote(pollId: 'p1', userId: 'me', option: 0),
          PollVote(pollId: 'p1', userId: 'ana', option: 0),
        ],
      ),
    );
    await settle(tester);
    expect(find.text('Que horas o esquenta?'), findsOneWidget);
    expect(find.text('2 votos · fecha em 5 h'), findsOneWidget);

    await tester.tap(find.text('23h'));
    await settle(tester);
    await tester.tap(find.text('22h'));
    await settle(tester);
    expect(repository.calls, ['vote:1', 'vote:null']);
  });

  testWidgets('creating: question, options (blanks dropped) and duration', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(420, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final repository = _FakePolls();
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showCreatePollSheet(context, 'c1'),
            child: const Text('abrir'),
          ),
        ),
        repository,
        const [],
      ),
    );
    await tester.tap(find.text('abrir'));
    await settle(tester);
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Qual festa?');
    await tester.enterText(fields.at(1), 'BOMA');
    await tester.enterText(fields.at(2), 'Privilege');
    await tester.tap(find.text('Adicionar opção'));
    await settle(tester);
    await tester.tap(find.text('48 h'));
    await tester.tap(find.text('Mandar enquete'));
    await settle(tester);
    expect(repository.calls, ['create:Qual festa?:BOMA|Privilege:48']);
  });
}
