// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_request_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(myRoleRequests)
final myRoleRequestsProvider = MyRoleRequestsProvider._();

final class MyRoleRequestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RoleRequest>>,
          List<RoleRequest>,
          FutureOr<List<RoleRequest>>
        >
    with
        $FutureModifier<List<RoleRequest>>,
        $FutureProvider<List<RoleRequest>> {
  MyRoleRequestsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myRoleRequestsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myRoleRequestsHash();

  @$internal
  @override
  $FutureProviderElement<List<RoleRequest>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RoleRequest>> create(Ref ref) {
    return myRoleRequests(ref);
  }
}

String _$myRoleRequestsHash() => r'4bcfac734fca7ad6529bf83f3e627bf53f70bd81';

@ProviderFor(pendingRoleRequests)
final pendingRoleRequestsProvider = PendingRoleRequestsProvider._();

final class PendingRoleRequestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RoleRequest>>,
          List<RoleRequest>,
          FutureOr<List<RoleRequest>>
        >
    with
        $FutureModifier<List<RoleRequest>>,
        $FutureProvider<List<RoleRequest>> {
  PendingRoleRequestsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingRoleRequestsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingRoleRequestsHash();

  @$internal
  @override
  $FutureProviderElement<List<RoleRequest>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RoleRequest>> create(Ref ref) {
    return pendingRoleRequests(ref);
  }
}

String _$pendingRoleRequestsHash() =>
    r'dd3e76b7c3513cc8ab368d3a61089e07d2503401';

@ProviderFor(RoleRequestEditor)
final roleRequestEditorProvider = RoleRequestEditorProvider._();

final class RoleRequestEditorProvider
    extends $NotifierProvider<RoleRequestEditor, AsyncValue<void>> {
  RoleRequestEditorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roleRequestEditorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roleRequestEditorHash();

  @$internal
  @override
  RoleRequestEditor create() => RoleRequestEditor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$roleRequestEditorHash() => r'17a43485ac57a24930053c7fc20bf2fa9acb85a4';

abstract class _$RoleRequestEditor extends $Notifier<AsyncValue<void>> {
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
