import 'package:pulse/features/auth/data/account_repository.dart';
import 'package:pulse/features/auth/data/auth_repository.dart';
import 'package:pulse/features/auth/domain/account_state.dart';
import 'package:pulse/features/auth/domain/session_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'session_providers.g.dart';

/// Supabase auth events (the first one is the restored session).
@Riverpod(keepAlive: true)
Stream<AuthState> authChanges(Ref ref) =>
    ref.watch(authRepositoryProvider).authStateChanges();

@Riverpod(keepAlive: true)
String? currentUserId(Ref ref) {
  final auth = ref.watch(authChangesProvider);
  return auth.value?.session?.user.id;
}

/// Set when the app is opened from a password-reset link; cleared once the
/// new password is saved or the user signs out.
@Riverpod(keepAlive: true)
class PasswordRecovery extends _$PasswordRecovery {
  @override
  bool build() {
    ref.listen(authChangesProvider, (_, next) {
      final event = next.value?.event;
      if (event == AuthChangeEvent.passwordRecovery) state = true;
      if (event == AuthChangeEvent.signedOut) state = false;
    });
    return false;
  }

  void complete() => state = false;
}

/// The signed-in user's account checklist. Invalidate after changing it.
@Riverpod(keepAlive: true)
Future<AccountState?> account(Ref ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return null;
  return await ref.watch(accountRepositoryProvider).fetch(userId);
}

@Riverpod(keepAlive: true)
SessionStatus sessionStatus(Ref ref) {
  final auth = ref.watch(authChangesProvider);
  if (!auth.hasValue) return SessionStatus.unknown;

  return resolveSessionStatus(
    hasSession: auth.requireValue.session != null,
    isPasswordRecovery: ref.watch(passwordRecoveryProvider),
    account: ref.watch(accountProvider).value,
  );
}
