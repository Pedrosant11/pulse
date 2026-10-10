import 'package:pulse/app/constants.dart';
import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/supabase/supabase_providers.dart';
import 'package:pulse/features/auth/domain/account_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'account_repository.g.dart';

/// The signed-in user's own account rows (profiles + user_private).
class AccountRepository {
  new(this._client);

  final SupabaseClient _client;

  Future<AccountState> fetch(String userId) {
    return guardFailures(() async {
      final results = await Future.wait([
        _client
            .from('profiles')
            .select('terms_version, onboarding_completed, status')
            .eq('id', userId)
            .single(),
        _client
            .from('user_private')
            .select('phone')
            .eq('user_id', userId)
            .single(),
      ]);
      final profile = results[0];
      final private = results[1];
      return AccountState(
        userId: userId,
        hasPhone: private['phone'] != null,
        termsAccepted: profile['terms_version'] == AppConstants.termsVersion,
        onboardingCompleted: profile['onboarding_completed'] as bool,
        status: AccountStatus.values.byName(profile['status'] as String),
      );
    });
  }

  /// Stores the phone (E.164). No code is sent (launch decision); fails
  /// with PhoneInUseFailure if another account already uses the number.
  Future<void> savePhone(String userId, String e164) => guardFailures(
    () => _client
        .from('user_private')
        .update({'phone': e164})
        .eq('user_id', userId),
  );

  /// Records this use of the app (Marco Civil art. 15). The server reads
  /// the IP from the request and keeps at most one row per 10 minutes.
  Future<void> logAccess() =>
      guardFailures(() => _client.rpc<void>('log_access'));

  /// Deletes the account for good (SPEC 5.2) through the `delete-account`
  /// Edge Function, which re-checks the password. Fails with
  /// WrongPasswordFailure when it doesn't match.
  Future<void> deleteAccount(String password) => guardFailures(
    () => _client.functions.invoke(
      'delete-account',
      body: {'password': password},
    ),
  );

  /// Accepts the current Terms/Privacy/LGPD version. The acceptance time is
  /// set by the database clock.
  Future<void> acceptTerms(String userId) => guardFailures(
    () => _client
        .from('profiles')
        .update({'terms_version': AppConstants.termsVersion})
        .eq('id', userId),
  );
}

@Riverpod(keepAlive: true)
AccountRepository accountRepository(Ref ref) =>
    AccountRepository(ref.watch(supabaseClientProvider));
