// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'same_night_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Liking someone from the same party (Date, like any other swipe).

@ProviderFor(SameNightActions)
final sameNightActionsProvider = SameNightActionsProvider._();

/// Liking someone from the same party (Date, like any other swipe).
final class SameNightActionsProvider
    extends $NotifierProvider<SameNightActions, AsyncValue<void>> {
  /// Liking someone from the same party (Date, like any other swipe).
  SameNightActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sameNightActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sameNightActionsHash();

  @$internal
  @override
  SameNightActions create() => SameNightActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$sameNightActionsHash() => r'059c4868cfe381643742de9cafdd2f973a96dc5e';

/// Liking someone from the same party (Date, like any other swipe).

abstract class _$SameNightActions extends $Notifier<AsyncValue<void>> {
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
