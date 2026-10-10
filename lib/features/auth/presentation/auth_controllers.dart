import 'package:pulse/core/utils/run_action.dart';
import 'package:pulse/features/auth/data/account_repository.dart';
import 'package:pulse/features/auth/data/auth_repository.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/notifications/presentation/push_registration.dart';
import 'package:pulse/features/plans/data/store_purchases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controllers.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<SignInResult?> signIn({
    required String email,
    required String password,
  }) => runAction(
    ref,
    (s) => state = s,
    () => ref
        .read(authRepositoryProvider)
        .signIn(email: email, password: password),
  );

  Future<bool?> resendConfirmation(String email) =>
      runAction(ref, (s) => state = s, () async {
        await ref.read(authRepositoryProvider).resendConfirmation(email);
        return true;
      });
}

@riverpod
class SignupController extends _$SignupController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// Returns whether the e-mail must be confirmed before signing in.
  Future<bool?> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required DateTime birthDate,
  }) => runAction(
    ref,
    (s) => state = s,
    () => ref
        .read(authRepositoryProvider)
        .signUp(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          birthDate: birthDate,
        ),
  );

  Future<bool?> resendConfirmation(String email) =>
      runAction(ref, (s) => state = s, () async {
        await ref.read(authRepositoryProvider).resendConfirmation(email);
        return true;
      });
}

@riverpod
class PasswordResetController extends _$PasswordResetController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool?> sendLink(String email) =>
      runAction(ref, (s) => state = s, () async {
        await ref.read(authRepositoryProvider).sendPasswordReset(email);
        return true;
      });

  Future<bool?> saveNewPassword(String password) =>
      runAction(ref, (s) => state = s, () async {
        await ref.read(authRepositoryProvider).updatePassword(password);
        ref.read(passwordRecoveryProvider.notifier).complete();
        return true;
      });
}

/// Sign-up steps 2–3: phone and terms.
@riverpod
class AccountSetupController extends _$AccountSetupController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// Saves the phone (unique per account, no code). Fails with
  /// PhoneInUseFailure when another account has it.
  Future<bool?> savePhone(String e164) =>
      runAction(ref, (s) => state = s, () async {
        final userId = ref.read(currentUserIdProvider);
        if (userId == null) return false;
        await ref.read(accountRepositoryProvider).savePhone(userId, e164);
        ref.invalidate(accountProvider);
        return true;
      });

  Future<bool?> acceptTerms() => runAction(ref, (s) => state = s, () async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return false;
    await ref.read(accountRepositoryProvider).acceptTerms(userId);
    ref.invalidate(accountProvider);
    return true;
  });
}

@riverpod
class SignOutController extends _$SignOutController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool?> signOut({bool allDevices = false}) =>
      runAction(ref, (s) => state = s, () async {
        // While still signed in (the RPC needs the session).
        await ref
            .read(pushRegistrationProvider.notifier)
            .disable(allDevices: allDevices);
        try {
          await ref.read(storePurchasesProvider).logOut();
        } on Object {
          // Never blocks signing out.
        }
        await ref.read(authRepositoryProvider).signOut(allDevices: allDevices);
        return true;
      });
}

/// Deletes the account (SPEC 5.2) and drops the local session.
@riverpod
class DeleteAccountController extends _$DeleteAccountController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool?> delete(String password) =>
      runAction(ref, (s) => state = s, () async {
        await ref.read(accountRepositoryProvider).deleteAccount(password);
        try {
          await ref.read(authRepositoryProvider).signOut();
        } on Object {
          // The user no longer exists; the local session is cleared anyway.
        }
        return true;
      });
}
