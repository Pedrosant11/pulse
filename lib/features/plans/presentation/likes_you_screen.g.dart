// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'likes_you_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Answering a like from this screen (same swipe as Discover).

@ProviderFor(LikesYouActions)
final likesYouActionsProvider = LikesYouActionsProvider._();

/// Answering a like from this screen (same swipe as Discover).
final class LikesYouActionsProvider
    extends $NotifierProvider<LikesYouActions, AsyncValue<void>> {
  /// Answering a like from this screen (same swipe as Discover).
  LikesYouActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'likesYouActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$likesYouActionsHash();

  @$internal
  @override
  LikesYouActions create() => LikesYouActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$likesYouActionsHash() => r'fd1a636df2180ae644b8f8ae7eaf1936dbccbeed';

/// Answering a like from this screen (same swipe as Discover).

abstract class _$LikesYouActions extends $Notifier<AsyncValue<void>> {
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
