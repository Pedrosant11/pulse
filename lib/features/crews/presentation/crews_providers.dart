import 'package:pulse/core/utils/run_action.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/chat/presentation/chat_providers.dart';
import 'package:pulse/features/crews/data/crews_repository.dart';
import 'package:pulse/features/crews/domain/crew_models.dart';
import 'package:pulse/features/discover/domain/discover_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crews_providers.g.dart';

String _requireUserId(Ref ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) throw StateError('No signed-in user');
  return userId;
}

/// Parties both go to, to start a crew with a Crew match.
@riverpod
Future<List<CommonEvent>> commonEvents(Ref ref, String userId) =>
    ref.watch(crewsRepositoryProvider).commonEvents(userId);

@riverpod
Future<List<CrewSummary>> eventCrews(Ref ref, String eventId) =>
    ref.watch(crewsRepositoryProvider).eventCrews(eventId);

@riverpod
Future<CrewDetail?> crew(Ref ref, String crewId) =>
    ref.watch(crewsRepositoryProvider).crew(crewId);

@riverpod
Future<List<CrewMember>> crewMembers(Ref ref, String crewId) =>
    ref.watch(crewsRepositoryProvider).members(crewId);

@riverpod
Future<List<CrewPending>> crewPending(Ref ref, String crewId) =>
    ref.watch(crewsRepositoryProvider).pending(crewId);

@riverpod
Future<List<CrewInviteCandidate>> crewInviteCandidates(
  Ref ref,
  String crewId,
) => ref.watch(crewsRepositoryProvider).inviteCandidates(crewId);

@riverpod
Future<List<MyCrewInvite>> myCrewInvites(Ref ref) {
  ref.watch(currentUserIdProvider);
  return ref.watch(crewsRepositoryProvider).myInvites();
}

/// Every crew action; refreshes the affected views.
@riverpod
class CrewEditor extends _$CrewEditor {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  CrewsRepository get _repository => ref.read(crewsRepositoryProvider);

  void _refresh(String crewId, {String? eventId}) {
    ref
      ..invalidate(crewProvider(crewId))
      ..invalidate(crewMembersProvider(crewId))
      ..invalidate(crewPendingProvider(crewId))
      ..invalidate(crewInviteCandidatesProvider(crewId))
      ..invalidate(myCrewInvitesProvider)
      ..invalidate(conversationsProvider);
    if (eventId != null) ref.invalidate(eventCrewsProvider(eventId));
  }

  /// Creates the crew (optionally inviting a Crew match right away, e.g.
  /// from the match screen). Returns the new crew id.
  Future<String?> create({
    required String eventId,
    required String name,
    required bool isOpen,
    required bool sameGenderOnly,
    String? description,
    String? inviteUserId,
  }) => runAction(ref, (s) => state = s, () async {
    final crewId = await _repository.create(
      eventId: eventId,
      ownerId: _requireUserId(ref),
      name: name,
      description: description,
      isOpen: isOpen,
      sameGenderOnly: sameGenderOnly,
    );
    if (inviteUserId != null) await _repository.invite(crewId, inviteUserId);
    _refresh(crewId, eventId: eventId);
    return crewId;
  });

  Future<bool?> save(String crewId, Map<String, Object?> fields) =>
      runAction(ref, (s) => state = s, () async {
        await _repository.update(crewId, fields);
        _refresh(crewId);
        return true;
      });

  Future<bool?> delete(String crewId, {required String eventId}) =>
      runAction(ref, (s) => state = s, () async {
        await _repository.delete(crewId);
        _refresh(crewId, eventId: eventId);
        return true;
      });

  Future<bool?> requestToJoin(String crewId, {required String eventId}) =>
      runAction(ref, (s) => state = s, () async {
        await _repository.requestToJoin(crewId, _requireUserId(ref));
        _refresh(crewId, eventId: eventId);
        return true;
      });

  Future<bool?> invite(String crewId, String userId) =>
      runAction(ref, (s) => state = s, () async {
        await _repository.invite(crewId, userId);
        _refresh(crewId);
        return true;
      });

  Future<bool?> answer(
    String requestId, {
    required String crewId,
    required bool accept,
  }) => runAction(ref, (s) => state = s, () async {
    await _repository.answer(requestId, accept: accept);
    _refresh(crewId);
    return true;
  });

  Future<bool?> cancel(String requestId, {required String crewId}) =>
      runAction(ref, (s) => state = s, () async {
        await _repository.cancel(requestId);
        _refresh(crewId);
        return true;
      });

  Future<bool?> leave(String crewId, {required String eventId}) =>
      runAction(ref, (s) => state = s, () async {
        await _repository.removeMember(crewId, _requireUserId(ref));
        _refresh(crewId, eventId: eventId);
        return true;
      });

  Future<bool?> removeMember(String crewId, String userId) =>
      runAction(ref, (s) => state = s, () async {
        await _repository.removeMember(crewId, userId);
        _refresh(crewId);
        return true;
      });

  Future<bool?> transfer(String crewId, String newOwnerId) =>
      runAction(ref, (s) => state = s, () async {
        await _repository.transferOwnership(crewId, newOwnerId);
        _refresh(crewId);
        return true;
      });
}
