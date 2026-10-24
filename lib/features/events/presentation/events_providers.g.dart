// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The signed-in user's role (UI only; the database enforces permissions).

@ProviderFor(currentRole)
final currentRoleProvider = CurrentRoleProvider._();

/// The signed-in user's role (UI only; the database enforces permissions).

final class CurrentRoleProvider
    extends $FunctionalProvider<UserRole, UserRole, UserRole>
    with $Provider<UserRole> {
  /// The signed-in user's role (UI only; the database enforces permissions).
  CurrentRoleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentRoleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentRoleHash();

  @$internal
  @override
  $ProviderElement<UserRole> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UserRole create(Ref ref) {
    return currentRole(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserRole value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserRole>(value),
    );
  }
}

String _$currentRoleHash() => r'207191401b984e17828e4f41a74168d333936a85';

/// Search/filters of the "Próximos" tab.

@ProviderFor(EventListFilters)
final eventListFiltersProvider = EventListFiltersProvider._();

/// Search/filters of the "Próximos" tab.
final class EventListFiltersProvider
    extends $NotifierProvider<EventListFilters, EventFilters> {
  /// Search/filters of the "Próximos" tab.
  EventListFiltersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventListFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventListFiltersHash();

  @$internal
  @override
  EventListFilters create() => EventListFilters();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EventFilters value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EventFilters>(value),
    );
  }
}

String _$eventListFiltersHash() => r'443b64059ee43a91bee1896d227ec6b14a65f88b';

/// Search/filters of the "Próximos" tab.

abstract class _$EventListFilters extends $Notifier<EventFilters> {
  EventFilters build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<EventFilters, EventFilters>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EventFilters, EventFilters>,
              EventFilters,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Discovery radius (km). Only notifies listeners when the value changes.

@ProviderFor(discoveryRadius)
final discoveryRadiusProvider = DiscoveryRadiusProvider._();

/// Discovery radius (km). Only notifies listeners when the value changes.

final class DiscoveryRadiusProvider
    extends $FunctionalProvider<int?, int?, int?>
    with $Provider<int?> {
  /// Discovery radius (km). Only notifies listeners when the value changes.
  DiscoveryRadiusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'discoveryRadiusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$discoveryRadiusHash();

  @$internal
  @override
  $ProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int? create(Ref ref) {
    return discoveryRadius(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$discoveryRadiusHash() => r'cc47fd666cee71f59f99d51943937cce150e0e52';

@ProviderFor(eventList)
final eventListProvider = EventListFamily._();

final class EventListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<EventListEntry>>,
          List<EventListEntry>,
          FutureOr<List<EventListEntry>>
        >
    with
        $FutureModifier<List<EventListEntry>>,
        $FutureProvider<List<EventListEntry>> {
  EventListProvider._({
    required EventListFamily super.from,
    required EventListScope super.argument,
  }) : super(
         retry: null,
         name: r'eventListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$eventListHash();

  @override
  String toString() {
    return r'eventListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<EventListEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<EventListEntry>> create(Ref ref) {
    final argument = this.argument as EventListScope;
    return eventList(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EventListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventListHash() => r'241151dcd60e9384ec66648e253422656d5d91f1';

final class EventListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<EventListEntry>>,
          EventListScope
        > {
  EventListFamily._()
    : super(
        retry: null,
        name: r'eventListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EventListProvider call(EventListScope scope) =>
      EventListProvider._(argument: scope, from: this);

  @override
  String toString() => r'eventListProvider';
}

@ProviderFor(eventDetail)
final eventDetailProvider = EventDetailFamily._();

final class EventDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<EventDetail>,
          EventDetail,
          FutureOr<EventDetail>
        >
    with $FutureModifier<EventDetail>, $FutureProvider<EventDetail> {
  EventDetailProvider._({
    required EventDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'eventDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$eventDetailHash();

  @override
  String toString() {
    return r'eventDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<EventDetail> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<EventDetail> create(Ref ref) {
    final argument = this.argument as String;
    return eventDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EventDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventDetailHash() => r'55c68c1e8c986bf80dd7b935dc762282f193d2da';

final class EventDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<EventDetail>, String> {
  EventDetailFamily._()
    : super(
        retry: null,
        name: r'eventDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EventDetailProvider call(String eventId) =>
      EventDetailProvider._(argument: eventId, from: this);

  @override
  String toString() => r'eventDetailProvider';
}

@ProviderFor(isAttending)
final isAttendingProvider = IsAttendingFamily._();

final class IsAttendingProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  IsAttendingProvider._({
    required IsAttendingFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'isAttendingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isAttendingHash();

  @override
  String toString() {
    return r'isAttendingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as String;
    return isAttending(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is IsAttendingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isAttendingHash() => r'1286f2c115eea0f07a1b9a5ff0056e532944ef1c';

final class IsAttendingFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, String> {
  IsAttendingFamily._()
    : super(
        retry: null,
        name: r'isAttendingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IsAttendingProvider call(String eventId) =>
      IsAttendingProvider._(argument: eventId, from: this);

  @override
  String toString() => r'isAttendingProvider';
}

@ProviderFor(eventAttendees)
final eventAttendeesProvider = EventAttendeesFamily._();

final class EventAttendeesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<EventAttendee>>,
          List<EventAttendee>,
          FutureOr<List<EventAttendee>>
        >
    with
        $FutureModifier<List<EventAttendee>>,
        $FutureProvider<List<EventAttendee>> {
  EventAttendeesProvider._({
    required EventAttendeesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'eventAttendeesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$eventAttendeesHash();

  @override
  String toString() {
    return r'eventAttendeesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<EventAttendee>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<EventAttendee>> create(Ref ref) {
    final argument = this.argument as String;
    return eventAttendees(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EventAttendeesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventAttendeesHash() => r'62a62c14952bf4d619ff42f7286714d9bd3c2fc1';

final class EventAttendeesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<EventAttendee>>, String> {
  EventAttendeesFamily._()
    : super(
        retry: null,
        name: r'eventAttendeesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EventAttendeesProvider call(String eventId) =>
      EventAttendeesProvider._(argument: eventId, from: this);

  @override
  String toString() => r'eventAttendeesProvider';
}

@ProviderFor(eventAttendeeCounts)
final eventAttendeeCountsProvider = EventAttendeeCountsFamily._();

final class EventAttendeeCountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<AttendeeCounts>,
          AttendeeCounts,
          FutureOr<AttendeeCounts>
        >
    with $FutureModifier<AttendeeCounts>, $FutureProvider<AttendeeCounts> {
  EventAttendeeCountsProvider._({
    required EventAttendeeCountsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'eventAttendeeCountsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$eventAttendeeCountsHash();

  @override
  String toString() {
    return r'eventAttendeeCountsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<AttendeeCounts> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AttendeeCounts> create(Ref ref) {
    final argument = this.argument as String;
    return eventAttendeeCounts(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EventAttendeeCountsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventAttendeeCountsHash() =>
    r'af81f2389b57b0e01b3a468215ee766b2a5a5555';

final class EventAttendeeCountsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<AttendeeCounts>, String> {
  EventAttendeeCountsFamily._()
    : super(
        retry: null,
        name: r'eventAttendeeCountsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EventAttendeeCountsProvider call(String eventId) =>
      EventAttendeeCountsProvider._(argument: eventId, from: this);

  @override
  String toString() => r'eventAttendeeCountsProvider';
}

@ProviderFor(eventCreator)
final eventCreatorProvider = EventCreatorFamily._();

final class EventCreatorProvider
    extends
        $FunctionalProvider<
          AsyncValue<EventCreator?>,
          EventCreator?,
          FutureOr<EventCreator?>
        >
    with $FutureModifier<EventCreator?>, $FutureProvider<EventCreator?> {
  EventCreatorProvider._({
    required EventCreatorFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'eventCreatorProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$eventCreatorHash();

  @override
  String toString() {
    return r'eventCreatorProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<EventCreator?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<EventCreator?> create(Ref ref) {
    final argument = this.argument as String;
    return eventCreator(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EventCreatorProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventCreatorHash() => r'06dab6bde4581c133fb9705aa43d81408450e1c8';

final class EventCreatorFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<EventCreator?>, String> {
  EventCreatorFamily._()
    : super(
        retry: null,
        name: r'eventCreatorProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EventCreatorProvider call(String eventId) =>
      EventCreatorProvider._(argument: eventId, from: this);

  @override
  String toString() => r'eventCreatorProvider';
}

@ProviderFor(pendingEvents)
final pendingEventsProvider = PendingEventsProvider._();

final class PendingEventsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<EventDetail>>,
          List<EventDetail>,
          FutureOr<List<EventDetail>>
        >
    with
        $FutureModifier<List<EventDetail>>,
        $FutureProvider<List<EventDetail>> {
  PendingEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingEventsHash();

  @$internal
  @override
  $FutureProviderElement<List<EventDetail>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<EventDetail>> create(Ref ref) {
    return pendingEvents(ref);
  }
}

String _$pendingEventsHash() => r'be4b06ef83d3ac361b787b27753557f303595246';

/// "Eu vou" (free in any city, SPEC 15).

@ProviderFor(AttendanceEditor)
final attendanceEditorProvider = AttendanceEditorProvider._();

/// "Eu vou" (free in any city, SPEC 15).
final class AttendanceEditorProvider
    extends $NotifierProvider<AttendanceEditor, AsyncValue<void>> {
  /// "Eu vou" (free in any city, SPEC 15).
  AttendanceEditorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'attendanceEditorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attendanceEditorHash();

  @$internal
  @override
  AttendanceEditor create() => AttendanceEditor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$attendanceEditorHash() => r'473732e81dd3f8aae96b13acfccacd01cc09b0c4';

/// "Eu vou" (free in any city, SPEC 15).

abstract class _$AttendanceEditor extends $Notifier<AsyncValue<void>> {
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

/// Create/edit/moderate events (SPEC 7.2/7.3).

@ProviderFor(EventEditor)
final eventEditorProvider = EventEditorProvider._();

/// Create/edit/moderate events (SPEC 7.2/7.3).
final class EventEditorProvider
    extends $NotifierProvider<EventEditor, AsyncValue<void>> {
  /// Create/edit/moderate events (SPEC 7.2/7.3).
  EventEditorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventEditorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventEditorHash();

  @$internal
  @override
  EventEditor create() => EventEditor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$eventEditorHash() => r'40fc5c8726d5d452711d2696f2078df8b146d821';

/// Create/edit/moderate events (SPEC 7.2/7.3).

abstract class _$EventEditor extends $Notifier<AsyncValue<void>> {
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

@ProviderFor(EventsView)
final eventsViewProvider = EventsViewProvider._();

final class EventsViewProvider
    extends $NotifierProvider<EventsView, EventsViewMode> {
  EventsViewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventsViewProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventsViewHash();

  @$internal
  @override
  EventsView create() => EventsView();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EventsViewMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EventsViewMode>(value),
    );
  }
}

String _$eventsViewHash() => r'8767ab59cb3c89c8c37e16ba20c418beef4ef139';

abstract class _$EventsView extends $Notifier<EventsViewMode> {
  EventsViewMode build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<EventsViewMode, EventsViewMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EventsViewMode, EventsViewMode>,
              EventsViewMode,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Same filters and radius as the list, with room for more pins.

@ProviderFor(eventMap)
final eventMapProvider = EventMapProvider._();

/// Same filters and radius as the list, with room for more pins.

final class EventMapProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<EventListEntry>>,
          List<EventListEntry>,
          FutureOr<List<EventListEntry>>
        >
    with
        $FutureModifier<List<EventListEntry>>,
        $FutureProvider<List<EventListEntry>> {
  /// Same filters and radius as the list, with room for more pins.
  EventMapProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventMapProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventMapHash();

  @$internal
  @override
  $FutureProviderElement<List<EventListEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<EventListEntry>> create(Ref ref) {
    return eventMap(ref);
  }
}

String _$eventMapHash() => r'48b2b5dacc3721aedfd8dca30427eaa0c1b623d1';

/// The venue of an event; null while secret or not set.

@ProviderFor(eventVenue)
final eventVenueProvider = EventVenueFamily._();

/// The venue of an event; null while secret or not set.

final class EventVenueProvider
    extends
        $FunctionalProvider<
          AsyncValue<EventVenue?>,
          EventVenue?,
          FutureOr<EventVenue?>
        >
    with $FutureModifier<EventVenue?>, $FutureProvider<EventVenue?> {
  /// The venue of an event; null while secret or not set.
  EventVenueProvider._({
    required EventVenueFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'eventVenueProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$eventVenueHash();

  @override
  String toString() {
    return r'eventVenueProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<EventVenue?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<EventVenue?> create(Ref ref) {
    final argument = this.argument as String;
    return eventVenue(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EventVenueProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventVenueHash() => r'b7c7e31d8b61f8cb206585744c8552e08aa4fa29';

/// The venue of an event; null while secret or not set.

final class EventVenueFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<EventVenue?>, String> {
  EventVenueFamily._()
    : super(
        retry: null,
        name: r'eventVenueProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The venue of an event; null while secret or not set.

  EventVenueProvider call(String eventId) =>
      EventVenueProvider._(argument: eventId, from: this);

  @override
  String toString() => r'eventVenueProvider';
}

@ProviderFor(eventInsights)
final eventInsightsProvider = EventInsightsFamily._();

final class EventInsightsProvider
    extends
        $FunctionalProvider<
          AsyncValue<EventInsights>,
          EventInsights,
          FutureOr<EventInsights>
        >
    with $FutureModifier<EventInsights>, $FutureProvider<EventInsights> {
  EventInsightsProvider._({
    required EventInsightsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'eventInsightsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$eventInsightsHash();

  @override
  String toString() {
    return r'eventInsightsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<EventInsights> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<EventInsights> create(Ref ref) {
    final argument = this.argument as String;
    return eventInsights(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EventInsightsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventInsightsHash() => r'bd7aa04749251afce7cbfc1dad103636f7444db8';

final class EventInsightsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<EventInsights>, String> {
  EventInsightsFamily._()
    : super(
        retry: null,
        name: r'eventInsightsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EventInsightsProvider call(String eventId) =>
      EventInsightsProvider._(argument: eventId, from: this);

  @override
  String toString() => r'eventInsightsProvider';
}

@ProviderFor(FeatureEditor)
final featureEditorProvider = FeatureEditorProvider._();

final class FeatureEditorProvider
    extends $NotifierProvider<FeatureEditor, AsyncValue<void>> {
  FeatureEditorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'featureEditorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$featureEditorHash();

  @$internal
  @override
  FeatureEditor create() => FeatureEditor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$featureEditorHash() => r'd959be1db5be50a5a3be49f030af43986d061df7';

abstract class _$FeatureEditor extends $Notifier<AsyncValue<void>> {
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

@ProviderFor(featuredPrices)
final featuredPricesProvider = FeaturedPricesProvider._();

final class FeaturedPricesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FeaturedPrice>>,
          List<FeaturedPrice>,
          FutureOr<List<FeaturedPrice>>
        >
    with
        $FutureModifier<List<FeaturedPrice>>,
        $FutureProvider<List<FeaturedPrice>> {
  FeaturedPricesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'featuredPricesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$featuredPricesHash();

  @$internal
  @override
  $FutureProviderElement<List<FeaturedPrice>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<FeaturedPrice>> create(Ref ref) {
    return featuredPrices(ref);
  }
}

String _$featuredPricesHash() => r'1d36dbcdb448622ebf35813c925b570ee6fe5e52';

@ProviderFor(openFeaturedRequest)
final openFeaturedRequestProvider = OpenFeaturedRequestFamily._();

final class OpenFeaturedRequestProvider
    extends
        $FunctionalProvider<
          AsyncValue<FeaturedRequest?>,
          FeaturedRequest?,
          FutureOr<FeaturedRequest?>
        >
    with $FutureModifier<FeaturedRequest?>, $FutureProvider<FeaturedRequest?> {
  OpenFeaturedRequestProvider._({
    required OpenFeaturedRequestFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'openFeaturedRequestProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$openFeaturedRequestHash();

  @override
  String toString() {
    return r'openFeaturedRequestProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<FeaturedRequest?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<FeaturedRequest?> create(Ref ref) {
    final argument = this.argument as String;
    return openFeaturedRequest(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is OpenFeaturedRequestProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$openFeaturedRequestHash() =>
    r'c4b218c515d6da4a35a9ad27aca6baf4e54e973d';

final class OpenFeaturedRequestFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<FeaturedRequest?>, String> {
  OpenFeaturedRequestFamily._()
    : super(
        retry: null,
        name: r'openFeaturedRequestProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  OpenFeaturedRequestProvider call(String eventId) =>
      OpenFeaturedRequestProvider._(argument: eventId, from: this);

  @override
  String toString() => r'openFeaturedRequestProvider';
}

@ProviderFor(adminFeaturedRequests)
final adminFeaturedRequestsProvider = AdminFeaturedRequestsProvider._();

final class AdminFeaturedRequestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AdminFeaturedRequest>>,
          List<AdminFeaturedRequest>,
          FutureOr<List<AdminFeaturedRequest>>
        >
    with
        $FutureModifier<List<AdminFeaturedRequest>>,
        $FutureProvider<List<AdminFeaturedRequest>> {
  AdminFeaturedRequestsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminFeaturedRequestsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminFeaturedRequestsHash();

  @$internal
  @override
  $FutureProviderElement<List<AdminFeaturedRequest>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AdminFeaturedRequest>> create(Ref ref) {
    return adminFeaturedRequests(ref);
  }
}

String _$adminFeaturedRequestsHash() =>
    r'31b2a1ef2204844c9c554ed1a3456c53a9884532';

/// A producer asking for a highlight, and the admin settling team requests.

@ProviderFor(FeaturedSales)
final featuredSalesProvider = FeaturedSalesProvider._();

/// A producer asking for a highlight, and the admin settling team requests.
final class FeaturedSalesProvider
    extends $NotifierProvider<FeaturedSales, AsyncValue<void>> {
  /// A producer asking for a highlight, and the admin settling team requests.
  FeaturedSalesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'featuredSalesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$featuredSalesHash();

  @$internal
  @override
  FeaturedSales create() => FeaturedSales();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$featuredSalesHash() => r'89dea4e29ce313e0a6ace8a62982a256e34a4859';

/// A producer asking for a highlight, and the admin settling team requests.

abstract class _$FeaturedSales extends $Notifier<AsyncValue<void>> {
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

@ProviderFor(isSaved)
final isSavedProvider = IsSavedFamily._();

final class IsSavedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  IsSavedProvider._({
    required IsSavedFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'isSavedProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isSavedHash();

  @override
  String toString() {
    return r'isSavedProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as String;
    return isSaved(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is IsSavedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isSavedHash() => r'6f686b83de34e6124ab9fd7c6c3173f5baa02766';

final class IsSavedFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, String> {
  IsSavedFamily._()
    : super(
        retry: null,
        name: r'isSavedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IsSavedProvider call(String eventId) =>
      IsSavedProvider._(argument: eventId, from: this);

  @override
  String toString() => r'isSavedProvider';
}

@ProviderFor(isOn)
final isOnProvider = IsOnFamily._();

final class IsOnProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  IsOnProvider._({
    required IsOnFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'isOnProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isOnHash();

  @override
  String toString() {
    return r'isOnProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as String;
    return isOn(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is IsOnProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isOnHash() => r'2a0357e60a6f9633f3708159f15aae5ed6e6dfb4';

final class IsOnFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, String> {
  IsOnFamily._()
    : super(
        retry: null,
        name: r'isOnProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IsOnProvider call(String eventId) =>
      IsOnProvider._(argument: eventId, from: this);

  @override
  String toString() => r'isOnProvider';
}

@ProviderFor(eventOnPeople)
final eventOnPeopleProvider = EventOnPeopleFamily._();

final class EventOnPeopleProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<OnPerson>>,
          List<OnPerson>,
          FutureOr<List<OnPerson>>
        >
    with $FutureModifier<List<OnPerson>>, $FutureProvider<List<OnPerson>> {
  EventOnPeopleProvider._({
    required EventOnPeopleFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'eventOnPeopleProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$eventOnPeopleHash();

  @override
  String toString() {
    return r'eventOnPeopleProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<OnPerson>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<OnPerson>> create(Ref ref) {
    final argument = this.argument as String;
    return eventOnPeople(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EventOnPeopleProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventOnPeopleHash() => r'3515ec1b8507521c3141f0cf7d03c463ce193ea0';

final class EventOnPeopleFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<OnPerson>>, String> {
  EventOnPeopleFamily._()
    : super(
        retry: null,
        name: r'eventOnPeopleProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EventOnPeopleProvider call(String eventId) =>
      EventOnPeopleProvider._(argument: eventId, from: this);

  @override
  String toString() => r'eventOnPeopleProvider';
}

@ProviderFor(eventSections)
final eventSectionsProvider = EventSectionsProvider._();

final class EventSectionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<EventSections>,
          EventSections,
          FutureOr<EventSections>
        >
    with $FutureModifier<EventSections>, $FutureProvider<EventSections> {
  EventSectionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventSectionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventSectionsHash();

  @$internal
  @override
  $FutureProviderElement<EventSections> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<EventSections> create(Ref ref) {
    return eventSections(ref);
  }
}

String _$eventSectionsHash() => r'a920f6cf21980515838e75321dd68c484152ff9d';

/// "Salvar" and "Tô ON".

@ProviderFor(EventNightEditor)
final eventNightEditorProvider = EventNightEditorProvider._();

/// "Salvar" and "Tô ON".
final class EventNightEditorProvider
    extends $NotifierProvider<EventNightEditor, AsyncValue<void>> {
  /// "Salvar" and "Tô ON".
  EventNightEditorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventNightEditorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventNightEditorHash();

  @$internal
  @override
  EventNightEditor create() => EventNightEditor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$eventNightEditorHash() => r'7b19f309e9881fc9a299505ba2bac9a01817dbe0';

/// "Salvar" and "Tô ON".

abstract class _$EventNightEditor extends $Notifier<AsyncValue<void>> {
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
