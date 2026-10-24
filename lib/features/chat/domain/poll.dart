import 'package:freezed_annotation/freezed_annotation.dart';

part 'poll.freezed.dart';
part 'poll.g.dart';

/// A crew chat poll (crew_polls migration).
@freezed
abstract class Poll with _$Poll {
  const factory({
    required String id,
    required String conversationId,
    required String question,
    required List<String> options,
    required DateTime closesAt,
    String? createdBy,
  }) = _Poll;

  factory fromJson(Map<String, dynamic> json) => _$PollFromJson(json);

  const new _();

  bool isOpen(DateTime now) => closesAt.isAfter(now);
}

@freezed
abstract class PollVote with _$PollVote {
  const factory({
    required String pollId,
    required String userId,
    required int option,
  }) = _PollVote;

  factory fromJson(Map<String, dynamic> json) => _$PollVoteFromJson(json);
}

/// Votes per option, in option order, and which one is mine.
({List<int> counts, int total, int? mine}) tallyVotes(
  Poll poll,
  List<PollVote> votes,
  String? userId,
) {
  final counts = List.filled(poll.options.length, 0);
  int? mine;
  for (final vote in votes) {
    if (vote.option < 0 || vote.option >= counts.length) continue;
    counts[vote.option]++;
    if (vote.userId == userId) mine = vote.option;
  }
  return (counts: counts, total: counts.fold(0, (a, b) => a + b), mine: mine);
}
