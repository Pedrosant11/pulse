import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/supabase/supabase_providers.dart';
import 'package:pulse/features/achievements/domain/achievement.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'achievements_repository.g.dart';

/// Conquistas and the passport, computed by the database.
class AchievementsRepository {
  new(this._client);

  final SupabaseClient _client;

  Future<List<Achievement>> mine() => guardFailures(() async {
    final rows = await _client.rpc<List<dynamic>>('my_achievements');
    return [
      for (final row in rows) Achievement.fromJson(row as Map<String, dynamic>),
    ];
  });

  /// Someone's unlocked conquistas, rarest first (unknown keys skipped).
  Future<List<AchievementKey>> ofUser(String userId) => guardFailures(() async {
    final keys = await _client.rpc<List<dynamic>>(
      'user_achievements',
      params: {'p_user': userId},
    );
    return [
      for (final key in keys)
        ?AchievementKey.values.where((k) => _snake(k.name) == key).firstOrNull,
    ];
  });

  Future<Passport> passport() => guardFailures(() async {
    final json = await _client.rpc<Map<String, dynamic>>('my_passport');
    return Passport.fromJson(json);
  });
}

String _snake(String camel) =>
    camel.replaceAllMapped(RegExp('[A-Z]'), (m) => '_${m[0]!.toLowerCase()}');

@Riverpod(keepAlive: true)
AchievementsRepository achievementsRepository(Ref ref) =>
    AchievementsRepository(ref.watch(supabaseClientProvider));
