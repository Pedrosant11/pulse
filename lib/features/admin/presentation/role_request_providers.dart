import 'package:pulse/core/models/user_role.dart';
import 'package:pulse/core/utils/run_action.dart';
import 'package:pulse/features/admin/data/role_requests_repository.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'role_request_providers.g.dart';

String _requireUserId(Ref ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) throw StateError('No signed-in user');
  return userId;
}

@riverpod
Future<List<RoleRequest>> myRoleRequests(Ref ref) =>
    ref.watch(roleRequestsRepositoryProvider).mine(_requireUserId(ref));

@riverpod
Future<List<RoleRequest>> pendingRoleRequests(Ref ref) =>
    ref.watch(roleRequestsRepositoryProvider).pending();

@riverpod
class RoleRequestEditor extends _$RoleRequestEditor {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool?> submit({
    required UserRole role,
    required String justification,
    required List<String> links,
  }) => runAction(ref, (s) => state = s, () async {
    await ref
        .read(roleRequestsRepositoryProvider)
        .submit(
          userId: _requireUserId(ref),
          role: role,
          justification: justification,
          links: links,
        );
    ref.invalidate(myRoleRequestsProvider);
    return true;
  });

  /// Admin review; approving grants the role in the database.
  Future<bool?> review(String requestId, {required bool approve}) =>
      runAction(ref, (s) => state = s, () async {
        await ref
            .read(roleRequestsRepositoryProvider)
            .review(requestId, approve: approve);
        ref
          ..invalidate(pendingRoleRequestsProvider)
          ..invalidate(myProfileProvider);
        return true;
      });
}
