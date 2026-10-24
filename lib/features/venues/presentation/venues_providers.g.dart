// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venues_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// "Casas": by name anywhere, otherwise in [state] (null = everywhere).

@ProviderFor(venueList)
final venueListProvider = VenueListFamily._();

/// "Casas": by name anywhere, otherwise in [state] (null = everywhere).

final class VenueListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Venue>>,
          List<Venue>,
          FutureOr<List<Venue>>
        >
    with $FutureModifier<List<Venue>>, $FutureProvider<List<Venue>> {
  /// "Casas": by name anywhere, otherwise in [state] (null = everywhere).
  VenueListProvider._({
    required VenueListFamily super.from,
    required (String, String?) super.argument,
  }) : super(
         retry: null,
         name: r'venueListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$venueListHash();

  @override
  String toString() {
    return r'venueListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Venue>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Venue>> create(Ref ref) {
    final argument = this.argument as (String, String?);
    return venueList(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is VenueListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$venueListHash() => r'225c26243d3c865f545fa5d63ad0c90819ab0c54';

/// "Casas": by name anywhere, otherwise in [state] (null = everywhere).

final class VenueListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Venue>>, (String, String?)> {
  VenueListFamily._()
    : super(
        retry: null,
        name: r'venueListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// "Casas": by name anywhere, otherwise in [state] (null = everywhere).

  VenueListProvider call(String query, String? state) =>
      VenueListProvider._(argument: (query, state), from: this);

  @override
  String toString() => r'venueListProvider';
}

@ProviderFor(venueDetail)
final venueDetailProvider = VenueDetailFamily._();

final class VenueDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<VenueDetail?>,
          VenueDetail?,
          FutureOr<VenueDetail?>
        >
    with $FutureModifier<VenueDetail?>, $FutureProvider<VenueDetail?> {
  VenueDetailProvider._({
    required VenueDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'venueDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$venueDetailHash();

  @override
  String toString() {
    return r'venueDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<VenueDetail?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<VenueDetail?> create(Ref ref) {
    final argument = this.argument as String;
    return venueDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is VenueDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$venueDetailHash() => r'3e51e3c8b3f136d98f8330ef6a0b42510d385a29';

final class VenueDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<VenueDetail?>, String> {
  VenueDetailFamily._()
    : super(
        retry: null,
        name: r'venueDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  VenueDetailProvider call(String venueId) =>
      VenueDetailProvider._(argument: venueId, from: this);

  @override
  String toString() => r'venueDetailProvider';
}

/// Curators: suggested venues waiting for review.

@ProviderFor(pendingVenues)
final pendingVenuesProvider = PendingVenuesProvider._();

/// Curators: suggested venues waiting for review.

final class PendingVenuesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<VenueDetail>>,
          List<VenueDetail>,
          FutureOr<List<VenueDetail>>
        >
    with
        $FutureModifier<List<VenueDetail>>,
        $FutureProvider<List<VenueDetail>> {
  /// Curators: suggested venues waiting for review.
  PendingVenuesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingVenuesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingVenuesHash();

  @$internal
  @override
  $FutureProviderElement<List<VenueDetail>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<VenueDetail>> create(Ref ref) {
    return pendingVenues(ref);
  }
}

String _$pendingVenuesHash() => r'd5ac0d83880ef5d8046ff38a22e676bdee00cd1a';

/// Follow, rate, add/edit and review venues.

@ProviderFor(VenueEditor)
final venueEditorProvider = VenueEditorProvider._();

/// Follow, rate, add/edit and review venues.
final class VenueEditorProvider
    extends $NotifierProvider<VenueEditor, AsyncValue<void>> {
  /// Follow, rate, add/edit and review venues.
  VenueEditorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'venueEditorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$venueEditorHash();

  @$internal
  @override
  VenueEditor create() => VenueEditor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$venueEditorHash() => r'44cfbf4b8866fa4e23475011a6b88bf24c2faac4';

/// Follow, rate, add/edit and review venues.

abstract class _$VenueEditor extends $Notifier<AsyncValue<void>> {
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
