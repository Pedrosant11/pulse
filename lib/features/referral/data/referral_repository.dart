import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/supabase/supabase_providers.dart';
import 'package:pulse/features/referral/domain/referral_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'referral_repository.g.dart';

/// Referral codes (referrals migration). The database checks every rule
/// and pays the rewards.
class ReferralRepository {
  new(this._client);

  final SupabaseClient _client;

  Future<ReferralInfo> mine() => guardFailures(() async {
    final rows = await _client.rpc<List<dynamic>>('get_my_referral');
    return ReferralInfo.fromJson(rows.first as Map<String, dynamic>);
  });

  /// A friend's code; refused with a [ReferralFailure].
  Future<void> redeem(String code) => guardFailures(
    () => _client.rpc<void>('redeem_referral', params: {'p_code': code}),
  );
}

@riverpod
ReferralRepository referralRepository(Ref ref) =>
    ReferralRepository(ref.watch(supabaseClientProvider));
