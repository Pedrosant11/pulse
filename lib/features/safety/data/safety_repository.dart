import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/supabase/supabase_providers.dart';
import 'package:pulse/core/utils/enum_json.dart';
import 'package:pulse/features/safety/domain/safety_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'safety_repository.g.dart';

/// Blocking, reporting and moderation notices (SPEC 10). The rules (who can
/// be reported, rate limits, hiding blocked people) live in the database.
class SafetyRepository {
  new(this._client);

  final SupabaseClient _client;

  /// Hides both users from each other everywhere and undoes their matches
  /// (database trigger).
  Future<void> block({required String blockerId, required String userId}) =>
      guardFailures(
        () => _client.from('blocks').insert({
          'blocker_id': blockerId,
          'blocked_id': userId,
        }),
      );

  /// Matches undone by the block are not restored.
  Future<void> unblock({required String blockerId, required String userId}) =>
      guardFailures(
        () => _client
            .from('blocks')
            .delete()
            .eq('blocker_id', blockerId)
            .eq('blocked_id', userId),
      );

  Future<List<BlockedUser>> blockedUsers() => guardFailures(() async {
    final rows = await _client.rpc<List<dynamic>>('list_my_blocks');
    return rows.cast<Map<String, dynamic>>().map(BlockedUser.fromJson).toList();
  });

  /// The database checks the target, stores a snapshot of it and ignores
  /// repeated reports while the first one is pending.
  Future<void> report({
    required ReportTarget target,
    required String targetId,
    required ReportReason reason,
    String? details,
  }) => guardFailures(
    () => _client.from('reports').insert({
      'target_type': target.name,
      'target_id': targetId,
      'reason': enumToDb(reason),
      'details': ?details,
    }),
  );

  Future<ModerationNotice?> moderationNotice() => guardFailures(() async {
    final rows = await _client.rpc<List<dynamic>>('get_my_moderation_notice');
    if (rows.isEmpty) return null;
    return ModerationNotice.fromJson(rows.first as Map<String, dynamic>);
  });

  Future<void> acknowledgeNotice(String actionId) => guardFailures(
    () => _client.rpc<void>(
      'ack_moderation_notice',
      params: {'p_action_id': actionId},
    ),
  );
}

@Riverpod(keepAlive: true)
SafetyRepository safetyRepository(Ref ref) =>
    SafetyRepository(ref.watch(supabaseClientProvider));
