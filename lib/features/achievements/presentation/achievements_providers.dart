import 'package:pulse/features/achievements/data/achievements_repository.dart';
import 'package:pulse/features/achievements/domain/achievement.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'achievements_providers.g.dart';

@riverpod
Future<List<Achievement>> myAchievements(Ref ref) {
  ref.watch(currentUserIdProvider);
  return ref.watch(achievementsRepositoryProvider).mine();
}

@riverpod
Future<List<AchievementKey>> userAchievements(Ref ref, String userId) =>
    ref.watch(achievementsRepositoryProvider).ofUser(userId);

@riverpod
Future<Passport> myPassport(Ref ref) {
  ref.watch(currentUserIdProvider);
  return ref.watch(achievementsRepositoryProvider).passport();
}
