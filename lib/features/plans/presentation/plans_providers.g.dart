// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plans_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(entitlements)
final entitlementsProvider = EntitlementsProvider._();

final class EntitlementsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Entitlements>,
          Entitlements,
          FutureOr<Entitlements>
        >
    with $FutureModifier<Entitlements>, $FutureProvider<Entitlements> {
  EntitlementsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'entitlementsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$entitlementsHash();

  @$internal
  @override
  $FutureProviderElement<Entitlements> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Entitlements> create(Ref ref) {
    return entitlements(ref);
  }
}

String _$entitlementsHash() => r'7dc0297058caca46eede0067db3c9ec500cdb3d8';

@ProviderFor(likesReceivedCount)
final likesReceivedCountProvider = LikesReceivedCountProvider._();

final class LikesReceivedCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  LikesReceivedCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'likesReceivedCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$likesReceivedCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return likesReceivedCount(ref);
  }
}

String _$likesReceivedCountHash() =>
    r'aa860babd6cd7d7e531ad7a5efdd3780091cf4c0';

/// Only fetched for Black (the database refuses others).

@ProviderFor(likesReceived)
final likesReceivedProvider = LikesReceivedProvider._();

/// Only fetched for Black (the database refuses others).

final class LikesReceivedProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LikedYou>>,
          List<LikedYou>,
          FutureOr<List<LikedYou>>
        >
    with $FutureModifier<List<LikedYou>>, $FutureProvider<List<LikedYou>> {
  /// Only fetched for Black (the database refuses others).
  LikesReceivedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'likesReceivedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$likesReceivedHash();

  @$internal
  @override
  $FutureProviderElement<List<LikedYou>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LikedYou>> create(Ref ref) {
    return likesReceived(ref);
  }
}

String _$likesReceivedHash() => r'3b1b554caf9e384fc851db8ddc3bbdb36c151812';

@ProviderFor(sameNightCount)
final sameNightCountProvider = SameNightCountProvider._();

final class SameNightCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  SameNightCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sameNightCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sameNightCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return sameNightCount(ref);
  }
}

String _$sameNightCountHash() => r'668e396c002269efaaa38bcd0737de073d9b5901';

/// Only fetched for Black (the database refuses others).

@ProviderFor(sameNight)
final sameNightProvider = SameNightProvider._();

/// Only fetched for Black (the database refuses others).

final class SameNightProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SameNightPerson>>,
          List<SameNightPerson>,
          FutureOr<List<SameNightPerson>>
        >
    with
        $FutureModifier<List<SameNightPerson>>,
        $FutureProvider<List<SameNightPerson>> {
  /// Only fetched for Black (the database refuses others).
  SameNightProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sameNightProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sameNightHash();

  @$internal
  @override
  $FutureProviderElement<List<SameNightPerson>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SameNightPerson>> create(Ref ref) {
    return sameNight(ref);
  }
}

String _$sameNightHash() => r'3568223269f91810bf2523fc0b34ba0656d929a7';

@ProviderFor(storeOffers)
final storeOffersProvider = StoreOffersProvider._();

final class StoreOffersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<StoreOffer>>,
          List<StoreOffer>,
          FutureOr<List<StoreOffer>>
        >
    with $FutureModifier<List<StoreOffer>>, $FutureProvider<List<StoreOffer>> {
  StoreOffersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storeOffersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storeOffersHash();

  @$internal
  @override
  $FutureProviderElement<List<StoreOffer>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<StoreOffer>> create(Ref ref) {
    return storeOffers(ref);
  }
}

String _$storeOffersHash() => r'4080fa95e74209b58404ed34dd66acc1b3feaf12';

/// Paid features and purchases. Errors stay in `state` for the UI.

@ProviderFor(PlanActions)
final planActionsProvider = PlanActionsProvider._();

/// Paid features and purchases. Errors stay in `state` for the UI.
final class PlanActionsProvider
    extends $NotifierProvider<PlanActions, AsyncValue<void>> {
  /// Paid features and purchases. Errors stay in `state` for the UI.
  PlanActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'planActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$planActionsHash();

  @$internal
  @override
  PlanActions create() => PlanActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$planActionsHash() => r'c5db4af48fd22458d69e6fd4f911fc1e9ab7f23b';

/// Paid features and purchases. Errors stay in `state` for the UI.

abstract class _$PlanActions extends $Notifier<AsyncValue<void>> {
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

@ProviderFor(adminPlan)
final adminPlanProvider = AdminPlanFamily._();

final class AdminPlanProvider
    extends
        $FunctionalProvider<
          AsyncValue<AdminPlan>,
          AdminPlan,
          FutureOr<AdminPlan>
        >
    with $FutureModifier<AdminPlan>, $FutureProvider<AdminPlan> {
  AdminPlanProvider._({
    required AdminPlanFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'adminPlanProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$adminPlanHash();

  @override
  String toString() {
    return r'adminPlanProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<AdminPlan> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<AdminPlan> create(Ref ref) {
    final argument = this.argument as String;
    return adminPlan(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AdminPlanProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$adminPlanHash() => r'd407371354e9f9895e9db5db0920eb36ef656a81';

final class AdminPlanFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<AdminPlan>, String> {
  AdminPlanFamily._()
    : super(
        retry: null,
        name: r'adminPlanProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AdminPlanProvider call(String userId) =>
      AdminPlanProvider._(argument: userId, from: this);

  @override
  String toString() => r'adminPlanProvider';
}

@ProviderFor(AdminPlanEditor)
final adminPlanEditorProvider = AdminPlanEditorProvider._();

final class AdminPlanEditorProvider
    extends $NotifierProvider<AdminPlanEditor, AsyncValue<void>> {
  AdminPlanEditorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminPlanEditorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminPlanEditorHash();

  @$internal
  @override
  AdminPlanEditor create() => AdminPlanEditor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$adminPlanEditorHash() => r'513fb313e6a6d7e75c61b92b879bf01a1f6c1882';

abstract class _$AdminPlanEditor extends $Notifier<AsyncValue<void>> {
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
