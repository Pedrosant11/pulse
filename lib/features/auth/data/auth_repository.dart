import 'package:intl/intl.dart';
import 'package:pulse/app/constants.dart';
import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/supabase/supabase_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_repository.g.dart';

enum SignInResult {
  signedIn,

  /// Password accepted, but a second factor is required (launch phase).
  needsSecondFactor,
}

/// E-mail/password authentication (SPEC 5.1 and 5.2).
class AuthRepository {
  new(this._client);

  final SupabaseClient _client;

  GoTrueClient get _auth => _client.auth;

  Stream<AuthState> authStateChanges() => _auth.onAuthStateChange;

  Session? get currentSession => _auth.currentSession;

  /// Creates the account. The profile is created by the database from the
  /// metadata; a minor's birth date is rejected there too.
  ///
  /// Returns `true` when the e-mail must be confirmed before signing in.
  /// For privacy Supabase does not reveal whether the e-mail already exists,
  /// so that case also lands on the "check your e-mail" screen.
  Future<bool> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required DateTime birthDate,
  }) {
    return guardFailures(() async {
      final response = await _auth.signUp(
        email: email.trim(),
        password: password,
        emailRedirectTo: AppConstants.authRedirectUrl,
        data: {
          'first_name': firstName.trim(),
          'last_name': lastName.trim(),
          'birth_date': DateFormat('yyyy-MM-dd').format(birthDate),
        },
      );
      return response.session == null;
    });
  }

  Future<void> resendConfirmation(String email) => guardFailures(
    () => _auth.resend(
      type: OtpType.signup,
      email: email.trim(),
      emailRedirectTo: AppConstants.authRedirectUrl,
    ),
  );

  Future<SignInResult> signIn({
    required String email,
    required String password,
  }) {
    return guardFailures(() async {
      await _auth.signInWithPassword(email: email.trim(), password: password);
      if (!AppConstants.loginSecondFactorEnabled) return SignInResult.signedIn;

      final aal = _auth.mfa.getAuthenticatorAssuranceLevel();
      final needsMore =
          aal.nextLevel == AuthenticatorAssuranceLevels.aal2 &&
          aal.currentLevel != AuthenticatorAssuranceLevels.aal2;
      return needsMore ? SignInResult.needsSecondFactor : SignInResult.signedIn;
    });
  }

  /// Always succeeds for unknown e-mails (no account enumeration).
  Future<void> sendPasswordReset(String email) => guardFailures(
    () => _auth.resetPasswordForEmail(
      email.trim(),
      redirectTo: AppConstants.authRedirectUrl,
    ),
  );

  Future<void> updatePassword(String password) =>
      guardFailures(() => _auth.updateUser(UserAttributes(password: password)));

  /// [allDevices] revokes every session of the account (SPEC 5.2).
  Future<void> signOut({bool allDevices = false}) => guardFailures(
    () => _auth.signOut(
      scope: allDevices ? SignOutScope.global : SignOutScope.local,
    ),
  );
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    AuthRepository(ref.watch(supabaseClientProvider));
