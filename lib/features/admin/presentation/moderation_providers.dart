import 'package:pulse/core/utils/run_action.dart';
import 'package:pulse/features/admin/data/moderation_repository.dart';
import 'package:pulse/features/admin/domain/moderation_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'moderation_providers.g.dart';

@riverpod
Future<List<AdminReport>> pendingReports(Ref ref) =>
    ref.watch(moderationRepositoryProvider).pendingReports();

@riverpod
Future<List<RestrictedUser>> restrictedUsers(Ref ref) =>
    ref.watch(moderationRepositoryProvider).restrictedUsers();

/// Admin decisions on reports and accounts.
@riverpod
class ModerationEditor extends _$ModerationEditor {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  ModerationRepository get _repository =>
      ref.read(moderationRepositoryProvider);

  Future<bool?> resolve({
    required String reportId,
    required ReportOutcome outcome,
    String? note,
    int? suspensionDays,
    bool removeContent = false,
  }) => runAction(ref, (s) => state = s, () async {
    final text = note?.trim();
    await _repository.resolve(
      reportId: reportId,
      outcome: outcome,
      note: text == null || text.isEmpty ? null : text,
      suspensionDays: outcome == ReportOutcome.suspension
          ? suspensionDays
          : null,
      removeContent: removeContent,
    );
    ref
      ..invalidate(pendingReportsProvider)
      ..invalidate(restrictedUsersProvider);
    return true;
  });

  Future<bool?> reactivate(String userId, String reason) =>
      runAction(ref, (s) => state = s, () async {
        await _repository.reactivate(userId, reason);
        ref.invalidate(restrictedUsersProvider);
        return true;
      });
}
