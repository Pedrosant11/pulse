import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/supabase/supabase_providers.dart';
import 'package:pulse/features/crews/domain/crew_models.dart';
import 'package:pulse/features/discover/domain/discover_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'crews_repository.g.dart';

/// Crews (SPEC 9.2). Membership rules (15 max, same gender, attendance,
/// Crew-match invites) are enforced by the database.
class CrewsRepository {
  new(this._client);

  final SupabaseClient _client;

  Future<List<T>> _rpcList<T>(
    String name,
    T Function(Map<String, dynamic>) fromJson, [
    Map<String, dynamic>? params,
  ]) => guardFailures(() async {
    final rows = await _client.rpc<List<dynamic>>(name, params: params);
    return rows.map((r) => fromJson(r as Map<String, dynamic>)).toList();
  });

  Future<List<CrewSummary>> eventCrews(String eventId) => _rpcList(
    'list_event_crews',
    CrewSummary.fromJson,
    {'p_event_id': eventId},
  );

  /// Null when the crew no longer exists or isn't visible.
  Future<CrewDetail?> crew(String crewId) async {
    final rows = await _rpcList('get_crew', CrewDetail.fromJson, {
      'p_crew_id': crewId,
    });
    return rows.firstOrNull;
  }

  Future<List<CrewMember>> members(String crewId) =>
      _rpcList('get_crew_members', CrewMember.fromJson, {'p_crew_id': crewId});

  Future<List<CrewPending>> pending(String crewId) =>
      _rpcList('get_crew_pending', CrewPending.fromJson, {'p_crew_id': crewId});

  Future<List<CrewInviteCandidate>> inviteCandidates(String crewId) => _rpcList(
    'get_crew_invite_candidates',
    CrewInviteCandidate.fromJson,
    {'p_crew_id': crewId},
  );

  Future<List<MyCrewInvite>> myInvites() =>
      _rpcList('list_my_crew_invites', MyCrewInvite.fromJson);

  /// Upcoming parties both go to (Crew matches only), to start a crew.
  Future<List<CommonEvent>> commonEvents(String userId) =>
      _rpcList('get_common_events', CommonEvent.fromJson, {'p_user': userId});

  /// The database adds the owner and creates the group chat.
  Future<String> create({
    required String eventId,
    required String ownerId,
    required String name,
    required bool isOpen,
    required bool sameGenderOnly,
    String? description,
  }) => guardFailures(() async {
    final row = await _client
        .from('crews')
        .insert({
          'event_id': eventId,
          'owner_id': ownerId,
          'name': name,
          'description': description,
          'is_open': isOpen,
          'same_gender_only': sameGenderOnly,
        })
        .select('id')
        .single();
    return row['id'] as String;
  });

  Future<void> update(String crewId, Map<String, Object?> fields) =>
      guardFailures(
        () => _client.from('crews').update(fields).eq('id', crewId),
      );

  Future<void> delete(String crewId) =>
      guardFailures(() => _client.from('crews').delete().eq('id', crewId));

  Future<void> requestToJoin(String crewId, String userId) => guardFailures(
    () => _client.from('crew_join_requests').insert({
      'crew_id': crewId,
      'user_id': userId,
      'kind': 'request',
    }),
  );

  Future<void> invite(String crewId, String userId) => guardFailures(
    () => _client.from('crew_join_requests').insert({
      'crew_id': crewId,
      'user_id': userId,
      'kind': 'invite',
    }),
  );

  /// Approve/reject a request (owner) or accept/decline an invite
  /// (invitee). Approving adds the member (database trigger).
  Future<void> answer(String requestId, {required bool accept}) =>
      guardFailures(
        () => _client
            .from('crew_join_requests')
            .update({'status': accept ? 'approved' : 'rejected'})
            .eq('id', requestId),
      );

  /// Withdraw a request (requester) or an invite (owner).
  Future<void> cancel(String requestId) => guardFailures(
    () => _client
        .from('crew_join_requests')
        .update({'status': 'cancelled'})
        .eq('id', requestId),
  );

  /// Leave (self) or remove a member (owner). The owner must transfer the
  /// crew first (database guard).
  Future<void> removeMember(String crewId, String userId) => guardFailures(
    () => _client
        .from('crew_members')
        .delete()
        .eq('crew_id', crewId)
        .eq('user_id', userId),
  );

  /// Members only (database check).
  Future<void> setMeetingPoint(String crewId, String text) => guardFailures(
    () => _client.rpc<void>(
      'set_crew_meeting_point',
      params: {'p_crew_id': crewId, 'p_text': text},
    ),
  );

  Future<void> transferOwnership(String crewId, String newOwnerId) =>
      guardFailures(
        () => _client.rpc<void>(
          'transfer_crew_ownership',
          params: {'p_crew_id': crewId, 'p_new_owner': newOwnerId},
        ),
      );
}

@Riverpod(keepAlive: true)
CrewsRepository crewsRepository(Ref ref) =>
    CrewsRepository(ref.watch(supabaseClientProvider));
