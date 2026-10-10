import 'package:pulse/core/utils/run_action.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/badges/data/badges_repository.dart';
import 'package:pulse/features/badges/domain/badge_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'badges_providers.g.dart';

String _requireUserId(Ref ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) throw StateError('No signed-in user');
  return userId;
}

/// Badges of one person (cached while shown).
@riverpod
Future<List<UserBadge>> userBadges(Ref ref, String userId) =>
    ref.watch(badgesRepositoryProvider).badgesOf(userId);

@riverpod
Future<List<BadgeRequest>> myBadgeRequests(Ref ref) =>
    ref.watch(badgesRepositoryProvider).myRequests(_requireUserId(ref));

@riverpod
Future<List<BadgeRequest>> pendingBadgeRequests(Ref ref) =>
    ref.watch(badgesRepositoryProvider).pendingRequests();

@riverpod
Future<List<AdminUserResult>> adminUserSearch(Ref ref, String query) =>
    query.trim().length < 2
    ? Future.value(const [])
    : ref.watch(badgesRepositoryProvider).searchUsers(query.trim());

/// Requests, reviews and admin grants.
@riverpod
class BadgeEditor extends _$BadgeEditor {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  BadgesRepository get _repository => ref.read(badgesRepositoryProvider);

  Future<bool?> request({
    required ProfileBadgeType badge,
    required String justification,
    required List<String> links,
  }) => runAction(ref, (s) => state = s, () async {
    await _repository.request(
      userId: _requireUserId(ref),
      badge: badge,
      justification: justification,
      links: links,
    );
    ref.invalidate(myBadgeRequestsProvider);
    return true;
  });

  Future<bool?> review(BadgeRequest request, {required bool approve}) =>
      runAction(ref, (s) => state = s, () async {
        await _repository.review(request.id, approve: approve);
        ref
          ..invalidate(pendingBadgeRequestsProvider)
          ..invalidate(userBadgesProvider(request.userId));
        return true;
      });

  Future<bool?> grant({
    required String userId,
    required ProfileBadgeType badge,
    String? title,
  }) => runAction(ref, (s) => state = s, () async {
    final text = title?.trim();
    await _repository.grant(
      userId: userId,
      badge: badge,
      title: text == null || text.isEmpty ? null : text,
    );
    ref.invalidate(userBadgesProvider(userId));
    return true;
  });

  Future<bool?> revoke({
    required String userId,
    required ProfileBadgeType badge,
  }) => runAction(ref, (s) => state = s, () async {
    await _repository.revoke(userId: userId, badge: badge);
    ref.invalidate(userBadgesProvider(userId));
    return true;
  });
}
