// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moderation_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pendingReports)
final pendingReportsProvider = PendingReportsProvider._();

final class PendingReportsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AdminReport>>,
          List<AdminReport>,
          FutureOr<List<AdminReport>>
        >
    with
        $FutureModifier<List<AdminReport>>,
        $FutureProvider<List<AdminReport>> {
  PendingReportsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingReportsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingReportsHash();

  @$internal
  @override
  $FutureProviderElement<List<AdminReport>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AdminReport>> create(Ref ref) {
    return pendingReports(ref);
  }
}

String _$pendingReportsHash() => r'13ef665b3c1422fd9f8ade26434c1a5a628ece75';

@ProviderFor(restrictedUsers)
final restrictedUsersProvider = RestrictedUsersProvider._();

final class RestrictedUsersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RestrictedUser>>,
          List<RestrictedUser>,
          FutureOr<List<RestrictedUser>>
        >
    with
        $FutureModifier<List<RestrictedUser>>,
        $FutureProvider<List<RestrictedUser>> {
  RestrictedUsersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'restrictedUsersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$restrictedUsersHash();

  @$internal
  @override
  $FutureProviderElement<List<RestrictedUser>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RestrictedUser>> create(Ref ref) {
    return restrictedUsers(ref);
  }
}

String _$restrictedUsersHash() => r'7ef4046833a038d71b30dcb694518d286293c58e';

/// Admin decisions on reports and accounts.

@ProviderFor(ModerationEditor)
final moderationEditorProvider = ModerationEditorProvider._();

/// Admin decisions on reports and accounts.
final class ModerationEditorProvider
    extends $NotifierProvider<ModerationEditor, AsyncValue<void>> {
  /// Admin decisions on reports and accounts.
  ModerationEditorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'moderationEditorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$moderationEditorHash();

  @$internal
  @override
  ModerationEditor create() => ModerationEditor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$moderationEditorHash() => r'eda52eda155dca7adba94079e9041985f5da0f71';

/// Admin decisions on reports and accounts.

abstract class _$ModerationEditor extends $Notifier<AsyncValue<void>> {
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
