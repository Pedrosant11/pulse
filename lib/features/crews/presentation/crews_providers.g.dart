// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crews_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(eventCrews)
final eventCrewsProvider = EventCrewsFamily._();

final class EventCrewsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CrewSummary>>,
          List<CrewSummary>,
          FutureOr<List<CrewSummary>>
        >
    with
        $FutureModifier<List<CrewSummary>>,
        $FutureProvider<List<CrewSummary>> {
  EventCrewsProvider._({
    required EventCrewsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'eventCrewsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$eventCrewsHash();

  @override
  String toString() {
    return r'eventCrewsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CrewSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CrewSummary>> create(Ref ref) {
    final argument = this.argument as String;
    return eventCrews(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EventCrewsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventCrewsHash() => r'ab457947b3fc586c9ac1a5e2cc4eba54cad7f900';

final class EventCrewsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<CrewSummary>>, String> {
  EventCrewsFamily._()
    : super(
        retry: null,
        name: r'eventCrewsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EventCrewsProvider call(String eventId) =>
      EventCrewsProvider._(argument: eventId, from: this);

  @override
  String toString() => r'eventCrewsProvider';
}

@ProviderFor(crew)
final crewProvider = CrewFamily._();

final class CrewProvider
    extends
        $FunctionalProvider<
          AsyncValue<CrewDetail?>,
          CrewDetail?,
          FutureOr<CrewDetail?>
        >
    with $FutureModifier<CrewDetail?>, $FutureProvider<CrewDetail?> {
  CrewProvider._({
    required CrewFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'crewProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$crewHash();

  @override
  String toString() {
    return r'crewProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<CrewDetail?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CrewDetail?> create(Ref ref) {
    final argument = this.argument as String;
    return crew(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CrewProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$crewHash() => r'9cf38fbb0ff77d96531e08efe2d3554dc8efce66';

final class CrewFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CrewDetail?>, String> {
  CrewFamily._()
    : super(
        retry: null,
        name: r'crewProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CrewProvider call(String crewId) =>
      CrewProvider._(argument: crewId, from: this);

  @override
  String toString() => r'crewProvider';
}

@ProviderFor(crewMembers)
final crewMembersProvider = CrewMembersFamily._();

final class CrewMembersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CrewMember>>,
          List<CrewMember>,
          FutureOr<List<CrewMember>>
        >
    with $FutureModifier<List<CrewMember>>, $FutureProvider<List<CrewMember>> {
  CrewMembersProvider._({
    required CrewMembersFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'crewMembersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$crewMembersHash();

  @override
  String toString() {
    return r'crewMembersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CrewMember>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CrewMember>> create(Ref ref) {
    final argument = this.argument as String;
    return crewMembers(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CrewMembersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$crewMembersHash() => r'0e7f1d411ad53da075b9c5d88f9ebd41a632bd75';

final class CrewMembersFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<CrewMember>>, String> {
  CrewMembersFamily._()
    : super(
        retry: null,
        name: r'crewMembersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CrewMembersProvider call(String crewId) =>
      CrewMembersProvider._(argument: crewId, from: this);

  @override
  String toString() => r'crewMembersProvider';
}

@ProviderFor(crewPending)
final crewPendingProvider = CrewPendingFamily._();

final class CrewPendingProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CrewPending>>,
          List<CrewPending>,
          FutureOr<List<CrewPending>>
        >
    with
        $FutureModifier<List<CrewPending>>,
        $FutureProvider<List<CrewPending>> {
  CrewPendingProvider._({
    required CrewPendingFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'crewPendingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$crewPendingHash();

  @override
  String toString() {
    return r'crewPendingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CrewPending>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CrewPending>> create(Ref ref) {
    final argument = this.argument as String;
    return crewPending(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CrewPendingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$crewPendingHash() => r'09f06fd9dd89af8af326bafbf87c5a9d55847ee0';

final class CrewPendingFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<CrewPending>>, String> {
  CrewPendingFamily._()
    : super(
        retry: null,
        name: r'crewPendingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CrewPendingProvider call(String crewId) =>
      CrewPendingProvider._(argument: crewId, from: this);

  @override
  String toString() => r'crewPendingProvider';
}

@ProviderFor(crewInviteCandidates)
final crewInviteCandidatesProvider = CrewInviteCandidatesFamily._();

final class CrewInviteCandidatesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CrewInviteCandidate>>,
          List<CrewInviteCandidate>,
          FutureOr<List<CrewInviteCandidate>>
        >
    with
        $FutureModifier<List<CrewInviteCandidate>>,
        $FutureProvider<List<CrewInviteCandidate>> {
  CrewInviteCandidatesProvider._({
    required CrewInviteCandidatesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'crewInviteCandidatesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$crewInviteCandidatesHash();

  @override
  String toString() {
    return r'crewInviteCandidatesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CrewInviteCandidate>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CrewInviteCandidate>> create(Ref ref) {
    final argument = this.argument as String;
    return crewInviteCandidates(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CrewInviteCandidatesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$crewInviteCandidatesHash() =>
    r'b2acc5b636c07d843729ef6000f75069eee55839';

final class CrewInviteCandidatesFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<List<CrewInviteCandidate>>, String> {
  CrewInviteCandidatesFamily._()
    : super(
        retry: null,
        name: r'crewInviteCandidatesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CrewInviteCandidatesProvider call(String crewId) =>
      CrewInviteCandidatesProvider._(argument: crewId, from: this);

  @override
  String toString() => r'crewInviteCandidatesProvider';
}

@ProviderFor(myCrewInvites)
final myCrewInvitesProvider = MyCrewInvitesProvider._();

final class MyCrewInvitesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MyCrewInvite>>,
          List<MyCrewInvite>,
          FutureOr<List<MyCrewInvite>>
        >
    with
        $FutureModifier<List<MyCrewInvite>>,
        $FutureProvider<List<MyCrewInvite>> {
  MyCrewInvitesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myCrewInvitesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myCrewInvitesHash();

  @$internal
  @override
  $FutureProviderElement<List<MyCrewInvite>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MyCrewInvite>> create(Ref ref) {
    return myCrewInvites(ref);
  }
}

String _$myCrewInvitesHash() => r'61151c70a185242f5c0a3169d2b8861f9562fa50';

/// Every crew action; refreshes the affected views.

@ProviderFor(CrewEditor)
final crewEditorProvider = CrewEditorProvider._();

/// Every crew action; refreshes the affected views.
final class CrewEditorProvider
    extends $NotifierProvider<CrewEditor, AsyncValue<void>> {
  /// Every crew action; refreshes the affected views.
  CrewEditorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'crewEditorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$crewEditorHash();

  @$internal
  @override
  CrewEditor create() => CrewEditor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$crewEditorHash() => r'5b24cc91d9f3045cba0554f54f34fca4920d0c08';

/// Every crew action; refreshes the affected views.

abstract class _$CrewEditor extends $Notifier<AsyncValue<void>> {
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
