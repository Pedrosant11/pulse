// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'safety_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(blockedUsers)
final blockedUsersProvider = BlockedUsersProvider._();

final class BlockedUsersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BlockedUser>>,
          List<BlockedUser>,
          FutureOr<List<BlockedUser>>
        >
    with
        $FutureModifier<List<BlockedUser>>,
        $FutureProvider<List<BlockedUser>> {
  BlockedUsersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'blockedUsersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$blockedUsersHash();

  @$internal
  @override
  $FutureProviderElement<List<BlockedUser>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BlockedUser>> create(Ref ref) {
    return blockedUsers(ref);
  }
}

String _$blockedUsersHash() => r'cd207879b2cb9759f435d16291cffebba3443f7d';

/// Warning to show once, or the reason of a suspension/ban.

@ProviderFor(moderationNotice)
final moderationNoticeProvider = ModerationNoticeProvider._();

/// Warning to show once, or the reason of a suspension/ban.

final class ModerationNoticeProvider
    extends
        $FunctionalProvider<
          AsyncValue<ModerationNotice?>,
          ModerationNotice?,
          FutureOr<ModerationNotice?>
        >
    with
        $FutureModifier<ModerationNotice?>,
        $FutureProvider<ModerationNotice?> {
  /// Warning to show once, or the reason of a suspension/ban.
  ModerationNoticeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'moderationNoticeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$moderationNoticeHash();

  @$internal
  @override
  $FutureProviderElement<ModerationNotice?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ModerationNotice?> create(Ref ref) {
    return moderationNotice(ref);
  }
}

String _$moderationNoticeHash() => r'1abbdc81ac250962da500c2622f9bada35099f33';

/// Block, unblock and report (SPEC 10).

@ProviderFor(SafetyActions)
final safetyActionsProvider = SafetyActionsProvider._();

/// Block, unblock and report (SPEC 10).
final class SafetyActionsProvider
    extends $NotifierProvider<SafetyActions, AsyncValue<void>> {
  /// Block, unblock and report (SPEC 10).
  SafetyActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'safetyActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$safetyActionsHash();

  @$internal
  @override
  SafetyActions create() => SafetyActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$safetyActionsHash() => r'0a53ddd9c98b7fc46c83217d4565e5a23e23edef';

/// Block, unblock and report (SPEC 10).

abstract class _$SafetyActions extends $Notifier<AsyncValue<void>> {
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
