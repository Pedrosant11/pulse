// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Supabase auth events (the first one is the restored session).

@ProviderFor(authChanges)
final authChangesProvider = AuthChangesProvider._();

/// Supabase auth events (the first one is the restored session).

final class AuthChangesProvider
    extends
        $FunctionalProvider<AsyncValue<AuthState>, AuthState, Stream<AuthState>>
    with $FutureModifier<AuthState>, $StreamProvider<AuthState> {
  /// Supabase auth events (the first one is the restored session).
  AuthChangesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authChangesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authChangesHash();

  @$internal
  @override
  $StreamProviderElement<AuthState> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<AuthState> create(Ref ref) {
    return authChanges(ref);
  }
}

String _$authChangesHash() => r'e2c13758abaae2b7e6a7ba7f5eb73acf06c9df8c';

@ProviderFor(currentUserId)
final currentUserIdProvider = CurrentUserIdProvider._();

final class CurrentUserIdProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  CurrentUserIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserIdHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return currentUserId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$currentUserIdHash() => r'6e6ede1c5bbc9e48ad57fa55c24fc0c6abe011d8';

/// Set when the app is opened from a password-reset link; cleared once the
/// new password is saved or the user signs out.

@ProviderFor(PasswordRecovery)
final passwordRecoveryProvider = PasswordRecoveryProvider._();

/// Set when the app is opened from a password-reset link; cleared once the
/// new password is saved or the user signs out.
final class PasswordRecoveryProvider
    extends $NotifierProvider<PasswordRecovery, bool> {
  /// Set when the app is opened from a password-reset link; cleared once the
  /// new password is saved or the user signs out.
  PasswordRecoveryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'passwordRecoveryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$passwordRecoveryHash();

  @$internal
  @override
  PasswordRecovery create() => PasswordRecovery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$passwordRecoveryHash() => r'51be8c51b616f932f72a59b0563956aaab7bdfb8';

/// Set when the app is opened from a password-reset link; cleared once the
/// new password is saved or the user signs out.

abstract class _$PasswordRecovery extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The signed-in user's account checklist. Invalidate after changing it.

@ProviderFor(account)
final accountProvider = AccountProvider._();

/// The signed-in user's account checklist. Invalidate after changing it.

final class AccountProvider
    extends
        $FunctionalProvider<
          AsyncValue<AccountState?>,
          AccountState?,
          FutureOr<AccountState?>
        >
    with $FutureModifier<AccountState?>, $FutureProvider<AccountState?> {
  /// The signed-in user's account checklist. Invalidate after changing it.
  AccountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountHash();

  @$internal
  @override
  $FutureProviderElement<AccountState?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AccountState?> create(Ref ref) {
    return account(ref);
  }
}

String _$accountHash() => r'43d94c533e1ee92df27c8c43e9156686e2452904';

@ProviderFor(sessionStatus)
final sessionStatusProvider = SessionStatusProvider._();

final class SessionStatusProvider
    extends $FunctionalProvider<SessionStatus, SessionStatus, SessionStatus>
    with $Provider<SessionStatus> {
  SessionStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionStatusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionStatusHash();

  @$internal
  @override
  $ProviderElement<SessionStatus> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SessionStatus create(Ref ref) {
    return sessionStatus(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionStatus>(value),
    );
  }
}

String _$sessionStatusHash() => r'e2c1c01490d3ca69b9be02257cf1cd1933e28e07';
