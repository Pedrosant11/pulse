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

/// "Comprar ingresso" taps (creator and moderators).

@ProviderFor(ticketClickCount)
final ticketClickCountProvider = TicketClickCountFamily._();

/// "Comprar ingresso" taps (creator and moderators).

final class TicketClickCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// "Comprar ingresso" taps (creator and moderators).
  TicketClickCountProvider._({
    required TicketClickCountFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'ticketClickCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ticketClickCountHash();

  @override
  String toString() {
    return r'ticketClickCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    final argument = this.argument as String;
    return ticketClickCount(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TicketClickCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ticketClickCountHash() => r'fae218296d508268e496bab1c9d2225c60ac8c60';

/// "Comprar ingresso" taps (creator and moderators).

final class TicketClickCountFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int>, String> {
  TicketClickCountFamily._()
    : super(
        retry: null,
        name: r'ticketClickCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// "Comprar ingresso" taps (creator and moderators).

  TicketClickCountProvider call(String eventId) =>
      TicketClickCountProvider._(argument: eventId, from: this);

  @override
  String toString() => r'ticketClickCountProvider';
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

String _$eventEditorHash() => r'4607972d61b3f588c399822d1b5f274ca453ac56';

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

@ProviderFor(isCheckedIn)
final isCheckedInProvider = IsCheckedInFamily._();

final class IsCheckedInProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  IsCheckedInProvider._({
    required IsCheckedInFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'isCheckedInProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isCheckedInHash();

  @override
  String toString() {
    return r'isCheckedInProvider'
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
    return isCheckedIn(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is IsCheckedInProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isCheckedInHash() => r'8625a3d6c5b2d17aabdae58b36c0e2e3402eddfe';

final class IsCheckedInFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, String> {
  IsCheckedInFamily._()
    : super(
        retry: null,
        name: r'isCheckedInProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IsCheckedInProvider call(String eventId) =>
      IsCheckedInProvider._(argument: eventId, from: this);

  @override
  String toString() => r'isCheckedInProvider';
}

@ProviderFor(hereCount)
final hereCountProvider = HereCountFamily._();

final class HereCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  HereCountProvider._({
    required HereCountFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hereCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hereCountHash();

  @override
  String toString() {
    return r'hereCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    final argument = this.argument as String;
    return hereCount(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HereCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hereCountHash() => r'd599ad8f22259b24c26aa15b5e0d3d1af9f862f5';

final class HereCountFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int>, String> {
  HereCountFamily._()
    : super(
        retry: null,
        name: r'hereCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HereCountProvider call(String eventId) =>
      HereCountProvider._(argument: eventId, from: this);

  @override
  String toString() => r'hereCountProvider';
}

@ProviderFor(hereFriends)
final hereFriendsProvider = HereFriendsFamily._();

final class HereFriendsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HereFriend>>,
          List<HereFriend>,
          FutureOr<List<HereFriend>>
        >
    with $FutureModifier<List<HereFriend>>, $FutureProvider<List<HereFriend>> {
  HereFriendsProvider._({
    required HereFriendsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hereFriendsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hereFriendsHash();

  @override
  String toString() {
    return r'hereFriendsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<HereFriend>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<HereFriend>> create(Ref ref) {
    final argument = this.argument as String;
    return hereFriends(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HereFriendsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hereFriendsHash() => r'0f87e8e285dcff251fbd49749aabe52b7c3e2191';

final class HereFriendsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<HereFriend>>, String> {
  HereFriendsFamily._()
    : super(
        retry: null,
        name: r'hereFriendsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HereFriendsProvider call(String eventId) =>
      HereFriendsProvider._(argument: eventId, from: this);

  @override
  String toString() => r'hereFriendsProvider';
}

@ProviderFor(CheckInEditor)
final checkInEditorProvider = CheckInEditorProvider._();

final class CheckInEditorProvider
    extends $NotifierProvider<CheckInEditor, AsyncValue<void>> {
  CheckInEditorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkInEditorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkInEditorHash();

  @$internal
  @override
  CheckInEditor create() => CheckInEditor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$checkInEditorHash() => r'd5d9ab4926c0806ff956e97ce5627c06442e738c';

abstract class _$CheckInEditor extends $Notifier<AsyncValue<void>> {
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
