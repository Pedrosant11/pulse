import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/models/app_mode.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/discover/data/discover_repository.dart';
import 'package:pulse/features/discover/domain/discover_models.dart';
import 'package:pulse/features/discover/presentation/discover_providers.dart';

DiscoverCandidate candidate(String id) =>
    DiscoverCandidate(id: id, firstName: 'P$id', age: 25);

class FakeDiscoverRepository implements DiscoverRepository {
  List<List<DiscoverCandidate>> feeds = [];
  final swipes = <(String, SwipeDirection)>[];
  Exception? swipeError;
  bool matchNext = false;
  String? undoResult;

  @override
  Future<List<DiscoverCandidate>> feed(
    AppMode mode, {
    int limit = 20,
    String? eventId,
  }) async => feeds.isEmpty ? [] : feeds.removeAt(0);

  @override
  Future<List<AfterParty>> afterParties() async => const [];

  @override
  Future<SwipeResult> swipe({
    required String targetId,
    required AppMode mode,
    required SwipeDirection direction,
    bool superLike = false,
  }) async {
    if (swipeError case final error?) throw error;
    swipes.add((targetId, direction));
    return SwipeResult(
      matched: matchNext,
      matchId: matchNext ? 'm1' : null,
      conversationId: matchNext ? 'c1' : null,
    );
  }

  @override
  Future<String?> undoLast(AppMode mode) async => undoResult;
}

void main() {
  late FakeDiscoverRepository repository;
  late ProviderContainer container;

  DiscoverDeck deck() =>
      container.read(discoverDeckProvider(AppMode.date).notifier);
  DeckState state() =>
      container.read(discoverDeckProvider(AppMode.date)).requireValue;

  setUp(() async {
    repository = FakeDiscoverRepository()
      ..feeds = [
        [
          for (final id in ['a', 'b', 'c', 'd', 'e']) candidate(id),
        ],
      ];
    container = ProviderContainer(
      overrides: [
        discoverRepositoryProvider.overrideWithValue(repository),
        currentUserIdProvider.overrideWithValue('me'),
      ],
    );
    addTearDown(container.dispose);
    // Keep the auto-dispose deck alive during the test.
    container.listen(discoverDeckProvider(AppMode.date), (_, _) {});
    await container.read(discoverDeckProvider(AppMode.date).future);
  });

  test('swiping removes the card and remembers it for undo', () async {
    final result = await deck().swipe(candidate('a'), SwipeDirection.like);
    expect(result?.matched, isFalse);
    expect(state().cards.map((c) => c.id), ['b', 'c', 'd', 'e']);
    expect(state().lastSwiped?.id, 'a');
    expect(repository.swipes, [('a', SwipeDirection.like)]);
  });

  test('a failed swipe puts the card back and exposes the error', () async {
    repository.swipeError = const RateLimitedFailure();
    final result = await deck().swipe(candidate('a'), SwipeDirection.pass);
    expect(result, isNull);
    expect(state().cards.first.id, 'a');
    expect(state().error, isA<RateLimitedFailure>());
    deck().clearError();
    expect(state().error, isNull);
  });

  test('a match cannot be undone', () async {
    repository.matchNext = true;
    final result = await deck().swipe(candidate('a'), SwipeDirection.like);
    expect(result?.conversationId, 'c1');
    expect(state().lastSwiped, isNull);
  });

  test('undo brings the last card back on top', () async {
    await deck().swipe(candidate('a'), SwipeDirection.pass);
    repository.undoResult = 'a';
    expect(await deck().undo(), isTrue);
    expect(state().cards.first.id, 'a');
    expect(state().lastSwiped, isNull);
  });

  test('undo refused by the server keeps the deck', () async {
    await deck().swipe(candidate('a'), SwipeDirection.pass);
    repository.undoResult = null;
    expect(await deck().undo(), isFalse);
    expect(state().cards.first.id, 'b');
  });

  test('refills below 3 cards without duplicates', () async {
    repository.feeds = [
      [candidate('d'), candidate('e'), candidate('f'), candidate('g')],
    ];
    await deck().swipe(candidate('a'), SwipeDirection.pass);
    await deck().swipe(candidate('b'), SwipeDirection.pass);
    await deck().swipe(candidate('c'), SwipeDirection.pass);
    expect(state().cards.map((c) => c.id), ['d', 'e', 'f', 'g']);
  });
}
