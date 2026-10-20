import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/supabase/supabase_providers.dart';
import 'package:pulse/core/utils/enum_json.dart';
import 'package:pulse/features/badges/domain/badge_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'badges_repository.g.dart';

const _requestColumns =
    'id, user_id, badge, justification, links, status, created_at';

/// Identification badges (SPEC 6.4). Granting, editing and reviewing are
/// admin-only in the database.
class BadgesRepository {
  new(this._client);

  final SupabaseClient _client;

  /// Badges shown on someone's profile, "Produtor" included.
  Future<List<UserBadge>> badgesOf(String userId) => guardFailures(() async {
    final rows = await _client.rpc<List<dynamic>>(
      'get_user_badges',
      params: {'p_user_id': userId},
    );
    return rows.cast<Map<String, dynamic>>().map(UserBadge.fromJson).toList();
  });

  Future<List<BadgeRequest>> myRequests(String userId) =>
      guardFailures(() async {
        final rows = await _client
            .from('badge_requests')
            .select(_requestColumns)
            .eq('user_id', userId)
            .order('created_at', ascending: false);
        return rows.map(BadgeRequest.fromJson).toList();
      });

  Future<void> request({
    required String userId,
    required ProfileBadgeType badge,
    required String justification,
    required List<String> links,
  }) => guardFailures(
    () => _client.from('badge_requests').insert({
      'user_id': userId,
      'badge': enumToDb(badge),
      'justification': justification.trim(),
      'links': links,
    }),
  );

  /// Pending requests with the requester's name (admins only, RLS).
  Future<List<BadgeRequest>> pendingRequests() => guardFailures(() async {
    final rows = await _client
        .from('badge_requests')
        .select(
          '$_requestColumns, '
          'requester:profiles!badge_requests_user_id_fkey'
          '(first_name, last_name)',
        )
        .eq('status', 'pending')
        .order('created_at', ascending: true);
    return [
      for (final row in rows)
        BadgeRequest.fromJson({
          ...row,
          'requester_name': switch (row['requester']) {
            {
              'first_name': final String first,
              'last_name': final String? last,
            } =>
              [first, ?last].join(' '),
            _ => null,
          },
        }),
    ];
  });

  /// Approving grants the badge (database trigger).
  Future<void> review(String requestId, {required bool approve}) =>
      guardFailures(
        () => _client
            .from('badge_requests')
            .update({'status': approve ? 'approved' : 'rejected'})
            .eq('id', requestId),
      );

  /// Grants or retitles a badge.
  Future<void> grant({
    required String userId,
    required ProfileBadgeType badge,
    String? title,
  }) => guardFailures(
    () => _client.from('profile_badges').upsert({
      'user_id': userId,
      'badge': enumToDb(badge),
      'title': title,
    }),
  );

  Future<void> revoke({
    required String userId,
    required ProfileBadgeType badge,
  }) => guardFailures(
    () => _client
        .from('profile_badges')
        .delete()
        .eq('user_id', userId)
        .eq('badge', enumToDb(badge)),
  );

  Future<List<AdminUserResult>> searchUsers(String query) =>
      guardFailures(() async {
        final rows = await _client.rpc<List<dynamic>>(
          'admin_search_users',
          params: {'p_query': query},
        );
        return rows
            .cast<Map<String, dynamic>>()
            .map(AdminUserResult.fromJson)
            .toList();
      });
}

@Riverpod(keepAlive: true)
BadgesRepository badgesRepository(Ref ref) =>
    BadgesRepository(ref.watch(supabaseClientProvider));
