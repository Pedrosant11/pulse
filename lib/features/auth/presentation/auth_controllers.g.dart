// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoginController)
final loginControllerProvider = LoginControllerProvider._();

final class LoginControllerProvider
    extends $NotifierProvider<LoginController, AsyncValue<void>> {
  LoginControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginControllerHash();

  @$internal
  @override
  LoginController create() => LoginController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$loginControllerHash() => r'407f18e1f3ff839f20b07168eac4533ff1dd6f3a';

abstract class _$LoginController extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(SignupController)
final signupControllerProvider = SignupControllerProvider._();

final class SignupControllerProvider
    extends $NotifierProvider<SignupController, AsyncValue<void>> {
  SignupControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signupControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signupControllerHash();

  @$internal
  @override
  SignupController create() => SignupController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$signupControllerHash() => r'91a1c3de606d8aeecb08bf4467f24afaf4316905';

abstract class _$SignupController extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(PasswordResetController)
final passwordResetControllerProvider = PasswordResetControllerProvider._();

final class PasswordResetControllerProvider
    extends $NotifierProvider<PasswordResetController, AsyncValue<void>> {
  PasswordResetControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'passwordResetControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$passwordResetControllerHash();

  @$internal
  @override
  PasswordResetController create() => PasswordResetController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$passwordResetControllerHash() =>
    r'6e4908558340de76b3d8b373e5786d19ff6ae2b6';

abstract class _$PasswordResetController extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Sign-up steps 2–3: phone and terms.

@ProviderFor(AccountSetupController)
final accountSetupControllerProvider = AccountSetupControllerProvider._();

/// Sign-up steps 2–3: phone and terms.
final class AccountSetupControllerProvider
    extends $NotifierProvider<AccountSetupController, AsyncValue<void>> {
  /// Sign-up steps 2–3: phone and terms.
  AccountSetupControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountSetupControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountSetupControllerHash();

  @$internal
  @override
  AccountSetupController create() => AccountSetupController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$accountSetupControllerHash() =>
    r'98b50e11201c629992afcb1075e287d4926d0f60';

/// Sign-up steps 2–3: phone and terms.

abstract class _$AccountSetupController extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(SignOutController)
final signOutControllerProvider = SignOutControllerProvider._();

final class SignOutControllerProvider
    extends $NotifierProvider<SignOutController, AsyncValue<void>> {
  SignOutControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signOutControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signOutControllerHash();

  @$internal
  @override
  SignOutController create() => SignOutController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$signOutControllerHash() => r'c54195d3c125ae1bdc83b5f4fb33246c10b9bf2c';

abstract class _$SignOutController extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Deletes the account (SPEC 5.2) and drops the local session.

@ProviderFor(DeleteAccountController)
final deleteAccountControllerProvider = DeleteAccountControllerProvider._();

/// Deletes the account (SPEC 5.2) and drops the local session.
final class DeleteAccountControllerProvider
    extends $NotifierProvider<DeleteAccountController, AsyncValue<void>> {
  /// Deletes the account (SPEC 5.2) and drops the local session.
  DeleteAccountControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteAccountControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteAccountControllerHash();

  @$internal
  @override
  DeleteAccountController create() => DeleteAccountController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$deleteAccountControllerHash() =>
    r'40fb9a040c6ed8435d6227ad38c7781e1bc26a74';

/// Deletes the account (SPEC 5.2) and drops the local session.

abstract class _$DeleteAccountController extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
