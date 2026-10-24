import 'package:pulse/core/models/app_mode.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/discover/data/discover_repository.dart';
import 'package:pulse/features/discover/domain/discover_models.dart';
import 'package:pulse/features/plans/presentation/plans_providers.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'discover_providers.g.dart';

/// Modes the user enabled in the profile (SPEC 6.1).
@riverpod
List<AppMode> enabledModes(Ref ref) =>
    ref.watch(myProfileProvider).value?.modes ?? const [];

/// Selected mode in the Discover tab.
@Riverpod(keepAlive: true)
class DiscoverMode extends _$DiscoverMode {
  @override
  AppMode build() {
    final enabled = ref.watch(enabledModesProvider);
    return enabled.isEmpty ? AppMode.date : enabled.first;
  }

  // A method reads better at call sites than a setter on a notifier.
  // ignore: use_setters_to_change_properties
  void select(AppMode mode) => state = mode;
}

/// The card deck of one mode. Swipes are optimistic: the card leaves at
/// once and comes back if the server refuses (e.g. rate limit).
@riverpod
class DiscoverDeck extends _$DiscoverDeck {
  static const _refillBelow = 3;

  DiscoverRepository get _repository => ref.read(discoverRepositoryProvider);

  @override
  Future<DeckState> build(AppMode mode, {String? eventId}) async {
    ref.watch(currentUserIdProvider);
    return DeckState(cards: await _repository.feed(mode, eventId: eventId));
  }

  /// Returns the server result, or null when it failed (the card is put
  /// back and the error goes to `state.error`).
  Future<SwipeResult?> swipe(
    DiscoverCandidate candidate,
    SwipeDirection direction, {
    bool superLike = false,
  }) async {
    final current = state.value;
    if (current == null) return null;
    final remaining = [
      for (final c in current.cards)
        if (c.id != candidate.id) c,
    ];
    state = AsyncData(
      current.copyWith(cards: remaining, lastSwiped: candidate, error: null),
    );

    try {
      final result = await _repository.swipe(
        targetId: candidate.id,
        mode: mode,
        direction: direction,
        superLike: superLike,
      );
      if (!ref.mounted) return result;
      // Likes and superlikes left (free limits, wallet), and "who liked
      // you" (answering someone here removes them from it).
      ref
        ..invalidate(entitlementsProvider)
        ..invalidate(likesReceivedCountProvider)
        ..invalidate(likesReceivedProvider);
      if (result.matched) {
        // A swipe that matched can't be undone.
        state = AsyncData(state.requireValue.copyWith(lastSwiped: null));
      }
      if (remaining.length < _refillBelow) await _refill();
      return result;
    } on Object catch (error) {
      if (ref.mounted) {
        final now = state.requireValue;
        state = AsyncData(
          now.copyWith(
            cards: [candidate, ...now.cards],
            lastSwiped: null,
            error: error,
          ),
        );
      }
      return null;
    }
  }

  /// Brings the last swiped card back (SPEC 8.2; a plan benefit).
  Future<bool> undo() async {
    final current = state.value;
    final last = current?.lastSwiped;
    if (current == null || last == null) return false;
    try {
      final undoneId = await _repository.undoLast(mode);
      if (!ref.mounted) return false;
      final now = state.requireValue;
      if (undoneId != last.id) {
        state = AsyncData(now.copyWith(lastSwiped: null));
        return false;
      }
      state = AsyncData(
        now.copyWith(
          cards: [last, ...now.cards.where((c) => c.id != last.id)],
          lastSwiped: null,
        ),
      );
      return true;
    } on Object catch (error) {
      if (ref.mounted) {
        state = AsyncData(state.requireValue.copyWith(error: error));
      }
      return false;
    }
  }

  /// Drops someone from the deck without swiping (e.g. after blocking).
  void remove(String userId) {
    final current = state.value;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        cards: [
          for (final c in current.cards)
            if (c.id != userId) c,
        ],
        lastSwiped: current.lastSwiped?.id == userId
            ? null
            : current.lastSwiped,
      ),
    );
  }

  void clearError() {
    final current = state.value;
    if (current?.error != null) {
      state = AsyncData(current!.copyWith(error: null));
    }
  }

  Future<void> _refill() async {
    try {
      final fresh = await _repository.feed(mode, eventId: eventId);
      if (!ref.mounted) return;
      final now = state.requireValue;
      final known = {for (final c in now.cards) c.id, now.lastSwiped?.id};
      state = AsyncData(
        now.copyWith(
          cards: [...now.cards, ...fresh.where((c) => !known.contains(c.id))],
        ),
      );
    } on Object {
      // Keep the current deck; the next swipe tries again.
    }
  }
}

/// Parties I went to whose "Depois da festa" is open.
@riverpod
Future<List<AfterParty>> myAfterParties(Ref ref) {
  ref.watch(currentUserIdProvider);
  return ref.watch(discoverRepositoryProvider).afterParties();
}
