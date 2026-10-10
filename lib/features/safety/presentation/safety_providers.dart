import 'package:pulse/core/utils/run_action.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/chat/presentation/chat_providers.dart';
import 'package:pulse/features/safety/data/safety_repository.dart';
import 'package:pulse/features/safety/domain/safety_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'safety_providers.g.dart';

String _requireUserId(Ref ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) throw StateError('No signed-in user');
  return userId;
}

@riverpod
Future<List<BlockedUser>> blockedUsers(Ref ref) {
  ref.watch(currentUserIdProvider);
  return ref.watch(safetyRepositoryProvider).blockedUsers();
}

/// Warning to show once, or the reason of a suspension/ban.
@riverpod
Future<ModerationNotice?> moderationNotice(Ref ref) {
  ref.watch(currentUserIdProvider);
  return ref.watch(safetyRepositoryProvider).moderationNotice();
}

/// Block, unblock and report (SPEC 10).
@riverpod
class SafetyActions extends _$SafetyActions {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  SafetyRepository get _repository => ref.read(safetyRepositoryProvider);

  Future<bool?> block(String userId) =>
      runAction(ref, (s) => state = s, () async {
        await _repository.block(blockerId: _requireUserId(ref), userId: userId);
        ref
          ..invalidate(blockedUsersProvider)
          ..invalidate(conversationsProvider);
        return true;
      });

  Future<bool?> unblock(String userId) => runAction(
    ref,
    (s) => state = s,
    () async {
      await _repository.unblock(blockerId: _requireUserId(ref), userId: userId);
      ref.invalidate(blockedUsersProvider);
      return true;
    },
  );

  Future<bool?> report({
    required ReportTarget target,
    required String targetId,
    required ReportReason reason,
    String? details,
  }) => runAction(ref, (s) => state = s, () async {
    final text = details?.trim();
    await _repository.report(
      target: target,
      targetId: targetId,
      reason: reason,
      details: text == null || text.isEmpty ? null : text,
    );
    return true;
  });

  Future<void> acknowledge(String actionId) async {
    await _repository.acknowledgeNotice(actionId);
    ref.invalidate(moderationNoticeProvider);
  }
}
