// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_registration.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Links this device to the signed-in account for push notifications.
/// Failures are only logged: notifications must never block the app or
/// signing out.

@ProviderFor(PushRegistration)
final pushRegistrationProvider = PushRegistrationProvider._();

/// Links this device to the signed-in account for push notifications.
/// Failures are only logged: notifications must never block the app or
/// signing out.
final class PushRegistrationProvider
    extends $NotifierProvider<PushRegistration, void> {
  /// Links this device to the signed-in account for push notifications.
  /// Failures are only logged: notifications must never block the app or
  /// signing out.
  PushRegistrationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushRegistrationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushRegistrationHash();

  @$internal
  @override
  PushRegistration create() => PushRegistration();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$pushRegistrationHash() => r'49d9dd1aa22b3e36add56332286f1656ea129146';

/// Links this device to the signed-in account for push notifications.
/// Failures are only logged: notifications must never block the app or
/// signing out.

abstract class _$PushRegistration extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
