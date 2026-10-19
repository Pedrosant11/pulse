import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/supabase/supabase_providers.dart';
import 'package:pulse/features/admin_web/domain/admin_console_models.dart';
import 'package:pulse/features/events/domain/featured.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'admin_console_repository.g.dart';

/// Admin web console data (admin_console migration). The database checks
/// that the caller is an admin.
class AdminConsoleRepository {
  new(this._client);

  final SupabaseClient _client;

  Future<AdminDashboard> dashboard() => guardFailures(() async {
    final json = await _client.rpc<Map<String, dynamic>>('admin_dashboard');
    return AdminDashboard.fromJson(json);
  });

  Future<List<AppSetting>> settings() => guardFailures(() async {
    final rows = await _client.rpc<List<dynamic>>('admin_settings');
    return [
      for (final row in rows.cast<Map<String, dynamic>>())
        AppSetting.fromJson(row),
    ];
  });

  Future<void> setSetting(String key, int value) => guardFailures(
    () => _client.rpc<void>(
      'admin_set_setting',
      params: {'p_key': key, 'p_value': value},
    ),
  );

  Future<List<FeaturedPrice>> featuredPrices() => guardFailures(() async {
    final rows = await _client
        .from('featured_prices')
        .select()
        .order('days', ascending: true);
    return rows.map(FeaturedPrice.fromJson).toList();
  });

  /// Admins only (RLS). The store price changes in the store consoles.
  Future<void> setFeaturedPrice(int days, int priceCents) => guardFailures(
    () => _client
        .from('featured_prices')
        .update({'price_cents': priceCents})
        .eq('days', days),
  );
}

@riverpod
AdminConsoleRepository adminConsoleRepository(Ref ref) =>
    AdminConsoleRepository(ref.watch(supabaseClientProvider));
