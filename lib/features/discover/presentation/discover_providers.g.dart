// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discover_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Modes the user enabled in the profile (SPEC 6.1).

@ProviderFor(enabledModes)
final enabledModesProvider = EnabledModesProvider._();

/// Modes the user enabled in the profile (SPEC 6.1).

final class EnabledModesProvider
    extends $FunctionalProvider<List<AppMode>, List<AppMode>, List<AppMode>>
    with $Provider<List<AppMode>> {
  /// Modes the user enabled in the profile (SPEC 6.1).
  EnabledModesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'enabledModesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$enabledModesHash();

  @$internal
  @override
  $ProviderElement<List<AppMode>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<AppMode> create(Ref ref) {
    return enabledModes(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<AppMode> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<AppMode>>(value),
    );
  }
}

String _$enabledModesHash() => r'a04ea3ff9c86ce327a10d4965c9a85c23bb9e618';

/// Selected mode in the Discover tab.

@ProviderFor(DiscoverMode)
final discoverModeProvider = DiscoverModeProvider._();

/// Selected mode in the Discover tab.
final class DiscoverModeProvider
    extends $NotifierProvider<DiscoverMode, AppMode> {
  /// Selected mode in the Discover tab.
  DiscoverModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'discoverModeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discoverModeHash();

  @$internal
  @override
  DiscoverMode create() => DiscoverMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppMode>(value),
    );
  }
}

String _$discoverModeHash() => r'2325fbfd1772b6dfdaf3de673c74da08090c25bd';

/// Selected mode in the Discover tab.

abstract class _$DiscoverMode extends $Notifier<AppMode> {
  AppMode build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppMode, AppMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppMode, AppMode>,
              AppMode,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The card deck of one mode. Swipes are optimistic: the card leaves at
/// once and comes back if the server refuses (e.g. rate limit).

@ProviderFor(DiscoverDeck)
final discoverDeckProvider = DiscoverDeckFamily._();

/// The card deck of one mode. Swipes are optimistic: the card leaves at
/// once and comes back if the server refuses (e.g. rate limit).
final class DiscoverDeckProvider
    extends $AsyncNotifierProvider<DiscoverDeck, DeckState> {
  /// The card deck of one mode. Swipes are optimistic: the card leaves at
  /// once and comes back if the server refuses (e.g. rate limit).
  DiscoverDeckProvider._({
    required DiscoverDeckFamily super.from,
    required (AppMode, {String? eventId}) super.argument,
  }) : super(
         retry: null,
         name: r'discoverDeckProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$discoverDeckHash();

  @override
  String toString() {
    return r'discoverDeckProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  DiscoverDeck create() => DiscoverDeck();

  @override
  bool operator ==(Object other) {
    return other is DiscoverDeckProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$discoverDeckHash() => r'b9bcb28e0a1fa9c2fc42bdd3a98206ed9ee2ff6e';

/// The card deck of one mode. Swipes are optimistic: the card leaves at
/// once and comes back if the server refuses (e.g. rate limit).

final class DiscoverDeckFamily extends $Family
    with
        $ClassFamilyOverride<
          DiscoverDeck,
          AsyncValue<DeckState>,
          DeckState,
          FutureOr<DeckState>,
          (AppMode, {String? eventId})
        > {
  DiscoverDeckFamily._()
    : super(
        retry: null,
        name: r'discoverDeckProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The card deck of one mode. Swipes are optimistic: the card leaves at
  /// once and comes back if the server refuses (e.g. rate limit).

  DiscoverDeckProvider call(AppMode mode, {String? eventId}) =>
      DiscoverDeckProvider._(argument: (mode, eventId: eventId), from: this);

  @override
  String toString() => r'discoverDeckProvider';
}

/// The card deck of one mode. Swipes are optimistic: the card leaves at
/// once and comes back if the server refuses (e.g. rate limit).

abstract class _$DiscoverDeck extends $AsyncNotifier<DeckState> {
  late final _$args = ref.$arg as (AppMode, {String? eventId});
  AppMode get mode => _$args.$1;
  String? get eventId => _$args.eventId;

  FutureOr<DeckState> build(AppMode mode, {String? eventId});
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<DeckState>, DeckState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DeckState>, DeckState>,
              AsyncValue<DeckState>,
              Object?,
              Object?
            >;
    return element.handleCreate(
      ref,
      () => build(_$args.$1, eventId: _$args.eventId),
    );
  }
}

/// Parties I went to whose "Depois da festa" is open.

@ProviderFor(myAfterParties)
final myAfterPartiesProvider = MyAfterPartiesProvider._();

/// Parties I went to whose "Depois da festa" is open.

final class MyAfterPartiesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AfterParty>>,
          List<AfterParty>,
          FutureOr<List<AfterParty>>
        >
    with $FutureModifier<List<AfterParty>>, $FutureProvider<List<AfterParty>> {
  /// Parties I went to whose "Depois da festa" is open.
  MyAfterPartiesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myAfterPartiesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myAfterPartiesHash();

  @$internal
  @override
  $FutureProviderElement<List<AfterParty>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AfterParty>> create(Ref ref) {
    return myAfterParties(ref);
  }
}

String _$myAfterPartiesHash() => r'2b0bb3cf7b883ba23e37aed48aff680e5124376c';
