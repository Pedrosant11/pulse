import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/supabase/supabase_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'push_repository.g.dart';

/// Device tokens in Supabase (`push_tokens`, only through RPCs).
class PushRepository {
  new(this._client);

  final SupabaseClient _client;

  Future<void> register(String token, {required String platform}) =>
      guardFailures(
        () => _client.rpc<void>(
          'register_push_token',
          params: {'p_token': token, 'p_platform': platform},
        ),
      );

  Future<void> unregister(String token) => guardFailures(
    () =>
        _client.rpc<void>('unregister_push_token', params: {'p_token': token}),
  );

  Future<void> unregisterAll() =>
      guardFailures(() => _client.rpc<void>('unregister_all_push_tokens'));
}

@riverpod
PushRepository pushRepository(Ref ref) =>
    PushRepository(ref.watch(supabaseClientProvider));
