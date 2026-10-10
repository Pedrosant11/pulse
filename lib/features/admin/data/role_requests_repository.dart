import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/models/user_role.dart';
import 'package:pulse/core/supabase/supabase_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'role_requests_repository.freezed.dart';
part 'role_requests_repository.g.dart';

/// Mirrors the database enum `request_status`.
enum RequestStatus { pending, approved, rejected, cancelled }

/// Request to become curator or producer (SPEC 4).
@freezed
abstract class RoleRequest with _$RoleRequest {
  const factory({
    required String id,
    required String userId,
    required UserRole requestedRole,
    required String justification,
    required RequestStatus status,
    required DateTime createdAt,
    @Default([]) List<String> links,

    /// Filled for admins: who is asking (name and "City, UF").
    String? requesterName,
    String? requesterPlace,
  }) = _RoleRequest;

  factory fromJson(Map<String, dynamic> json) => _$RoleRequestFromJson(json);
}

class RoleRequestsRepository {
  new(this._client);

  final SupabaseClient _client;

  static const _columns =
      'id, user_id, requested_role, justification, status, created_at, links';

  /// The user's requests, newest first.
  Future<List<RoleRequest>> mine(String userId) => guardFailures(() async {
    final rows = await _client
        .from('role_requests')
        .select(_columns)
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return rows.map(RoleRequest.fromJson).toList();
  });

  Future<void> submit({
    required String userId,
    required UserRole role,
    required String justification,
    required List<String> links,
  }) => guardFailures(
    () => _client.from('role_requests').insert({
      'user_id': userId,
      'requested_role': role.name,
      'justification': justification.trim(),
      'links': links,
    }),
  );

  /// Pending requests with who is asking (admins only, enforced by RLS).
  Future<List<RoleRequest>> pending() => guardFailures(() async {
    final rows = await _client
        .from('role_requests')
        .select(
          '$_columns, '
          'requester:profiles!role_requests_user_id_fkey'
          '(first_name, last_name, city, state)',
        )
        .eq('status', 'pending')
        .order('created_at');
    return [
      for (final row in rows)
        RoleRequest.fromJson({
          ...row,
          ...switch (row['requester']) {
            {
              'first_name': final String? first,
              'last_name': final String? last,
              'city': final String? city,
              'state': final String? state,
            } =>
              {
                'requester_name': [?first, ?last].join(' '),
                'requester_place': city == null ? null : '$city, $state',
              },
            _ => const <String, Object?>{},
          },
        }),
    ];
  });

  /// Approving grants the role (database trigger).
  Future<void> review(String requestId, {required bool approve}) =>
      guardFailures(
        () => _client
            .from('role_requests')
            .update({'status': approve ? 'approved' : 'rejected'})
            .eq('id', requestId),
      );
}

@Riverpod(keepAlive: true)
RoleRequestsRepository roleRequestsRepository(Ref ref) =>
    RoleRequestsRepository(ref.watch(supabaseClientProvider));
