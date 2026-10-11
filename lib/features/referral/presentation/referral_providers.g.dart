// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referral_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(myReferral)
final myReferralProvider = MyReferralProvider._();

final class MyReferralProvider
    extends
        $FunctionalProvider<
          AsyncValue<ReferralInfo>,
          ReferralInfo,
          FutureOr<ReferralInfo>
        >
    with $FutureModifier<ReferralInfo>, $FutureProvider<ReferralInfo> {
  MyReferralProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myReferralProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myReferralHash();

  @$internal
  @override
  $FutureProviderElement<ReferralInfo> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ReferralInfo> create(Ref ref) {
    return myReferral(ref);
  }
}

String _$myReferralHash() => r'54da97405bbd3b6d3c0c9f56bb7439150506be90';

@ProviderFor(ReferralController)
final referralControllerProvider = ReferralControllerProvider._();

final class ReferralControllerProvider
    extends $NotifierProvider<ReferralController, AsyncValue<void>> {
  ReferralControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'referralControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$referralControllerHash();

  @$internal
  @override
  ReferralController create() => ReferralController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$referralControllerHash() =>
    r'bd232c97b5e3aab69e78f49572d34f98e52071b0';

abstract class _$ReferralController extends $Notifier<AsyncValue<void>> {
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
