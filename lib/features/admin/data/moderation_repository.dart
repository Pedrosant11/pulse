import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/supabase/supabase_providers.dart';
import 'package:pulse/features/admin/domain/moderation_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'moderation_repository.g.dart';

/// Reports and account actions for the admin panel (SPEC 10). The RPCs
/// return nothing / refuse for anyone who isn't an admin.
class ModerationRepository {
  new(this._client);

  final SupabaseClient _client;

  /// Pending reports, oldest first.
  Future<List<AdminReport>> pendingReports() => guardFailures(() async {
    final rows = await _client.rpc<List<dynamic>>('admin_list_reports');
    return rows.cast<Map<String, dynamic>>().map(AdminReport.fromJson).toList();
  });

  /// One step: optional account action ([note] is shown to the person),
  /// optional take-down of the message/event, and closing the related
  /// pending reports.
  Future<void> resolve({
    required String reportId,
    required ReportOutcome outcome,
    String? note,
    int? suspensionDays,
    bool removeContent = false,
  }) => guardFailures(
    () => _client.rpc<void>(
      'admin_resolve_report',
      params: {
        'p_report_id': reportId,
        'p_outcome': outcome.name,
        'p_note': note,
        'p_suspension_days': suspensionDays,
        'p_remove_content': removeContent,
      },
    ),
  );

  Future<List<RestrictedUser>> restrictedUsers() => guardFailures(() async {
    final rows = await _client.rpc<List<dynamic>>(
      'admin_list_restricted_users',
    );
    return rows
        .cast<Map<String, dynamic>>()
        .map(RestrictedUser.fromJson)
        .toList();
  });

  /// Lifts a suspension or ban (database trigger updates the status).
  Future<void> reactivate(String userId, String reason) => guardFailures(
    () => _client.from('moderation_actions').insert({
      'target_user_id': userId,
      'action': 'reactivation',
      'reason': reason.trim(),
    }),
  );
}

@Riverpod(keepAlive: true)
ModerationRepository moderationRepository(Ref ref) =>
    ModerationRepository(ref.watch(supabaseClientProvider));
