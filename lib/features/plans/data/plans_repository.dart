import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/supabase/supabase_providers.dart';
import 'package:pulse/core/utils/enum_json.dart';
import 'package:pulse/features/plans/domain/plan_models.dart';
import 'package:pulse/features/profile/domain/city.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'plans_repository.g.dart';

/// Plans, limits and paid features. The database enforces every rule; this
/// only reads and asks.
class PlansRepository {
  new(this._client);

  final SupabaseClient _client;

  Future<Entitlements> entitlements() => guardFailures(() async {
    final rows = await _client.rpc<List<dynamic>>('get_my_entitlements');
    return rows.isEmpty
        ? const Entitlements()
        : Entitlements.fromJson(rows.first as Map<String, dynamic>);
  });

  Future<int> likesReceivedCount() =>
      guardFailures(() => _client.rpc<int>('get_likes_received_count'));

  /// Pulse Black only (PlanRequiredFailure otherwise).
  Future<List<LikedYou>> likesReceived() => guardFailures(() async {
    final rows = await _client.rpc<List<dynamic>>('get_likes_received');
    return rows
        .map((r) => LikedYou.fromJson(r as Map<String, dynamic>))
        .toList();
  });

  /// Returns when the boost ends.
  Future<DateTime> activateBoost() => guardFailures(() async {
    final endsAt = await _client.rpc<String>('activate_boost');
    return DateTime.parse(endsAt).toLocal();
  });

  Future<void> setTravel(String userId, City city) => guardFailures(
    () => _client.from('travel_locations').upsert({
      'user_id': userId,
      'city': city.name,
      'state': city.state,
      'lat': city.lat,
      'lng': city.lng,
    }),
  );

  Future<void> clearTravel(String userId) => guardFailures(
    () => _client.from('travel_locations').delete().eq('user_id', userId),
  );

  /// Takes effect with Pulse Black only (database check).
  Future<void> setIncognito(String userId, {required bool enabled}) =>
      guardFailures(
        () => _client
            .from('profiles')
            .update({'incognito': enabled})
            .eq('id', userId),
      );

  // Admin ---------------------------------------------------------------

  Future<AdminPlan> adminPlan(String userId) => guardFailures(() async {
    final rows = await _client.rpc<List<dynamic>>(
      'admin_get_plan',
      params: {'p_user': userId},
    );
    return rows.isEmpty
        ? const AdminPlan()
        : AdminPlan.fromJson(rows.first as Map<String, dynamic>);
  });

  /// [tier] null removes a granted plan.
  Future<void> adminGrantPlan(String userId, PlanTier? tier, {int? days}) =>
      guardFailures(
        () => _client.rpc<void>(
          'admin_grant_plan',
          params: {
            'p_user': userId,
            'p_tier': tier == null ? null : enumToDb(tier),
            'p_days': days,
          },
        ),
      );

  Future<void> adminGrantWallet(
    String userId, {
    int superlikes = 0,
    int boosts = 0,
  }) => guardFailures(
    () => _client.rpc<void>(
      'admin_grant_wallet',
      params: {
        'p_user': userId,
        'p_superlikes': superlikes,
        'p_boosts': boosts,
      },
    ),
  );
}

@Riverpod(keepAlive: true)
PlansRepository plansRepository(Ref ref) =>
    PlansRepository(ref.watch(supabaseClientProvider));
