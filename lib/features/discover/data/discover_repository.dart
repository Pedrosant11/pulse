import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/models/app_mode.dart';
import 'package:pulse/core/supabase/supabase_providers.dart';
import 'package:pulse/features/discover/domain/discover_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'discover_repository.g.dart';

class DiscoverRepository {
  new(this._client);

  final SupabaseClient _client;

  Future<List<DiscoverCandidate>> feed(AppMode mode, {int limit = 20}) =>
      guardFailures(() async {
        final rows = await _client.rpc<List<dynamic>>(
          'get_discover_feed',
          params: {'p_mode': mode.name, 'p_limit': limit},
        );
        return rows
            .map((r) => DiscoverCandidate.fromJson(r as Map<String, dynamic>))
            .toList();
      });

  /// Matches are created by the database; this only reports them.
  Future<SwipeResult> swipe({
    required String targetId,
    required AppMode mode,
    required SwipeDirection direction,
    bool superLike = false,
  }) => guardFailures(() async {
    final rows = await _client.rpc<List<dynamic>>(
      'swipe',
      params: {
        'p_target': targetId,
        'p_mode': mode.name,
        'p_direction': direction.name,
        'p_super': superLike,
      },
    );
    return SwipeResult.fromJson(rows.first as Map<String, dynamic>);
  });

  /// Returns the profile id whose swipe was undone, or null (nothing to
  /// undo, or that swipe already produced a match).
  Future<String?> undoLast(AppMode mode) => guardFailures(
    () =>
        _client.rpc<String?>('undo_last_swipe', params: {'p_mode': mode.name}),
  );
}

@Riverpod(keepAlive: true)
DiscoverRepository discoverRepository(Ref ref) =>
    DiscoverRepository(ref.watch(supabaseClientProvider));
