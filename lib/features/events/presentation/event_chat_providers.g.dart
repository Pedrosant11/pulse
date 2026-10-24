// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_chat_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(eventChatInfo)
final eventChatInfoProvider = EventChatInfoFamily._();

final class EventChatInfoProvider
    extends
        $FunctionalProvider<
          AsyncValue<EventChatInfo>,
          EventChatInfo,
          FutureOr<EventChatInfo>
        >
    with $FutureModifier<EventChatInfo>, $FutureProvider<EventChatInfo> {
  EventChatInfoProvider._({
    required EventChatInfoFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'eventChatInfoProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$eventChatInfoHash();

  @override
  String toString() {
    return r'eventChatInfoProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<EventChatInfo> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<EventChatInfo> create(Ref ref) {
    final argument = this.argument as String;
    return eventChatInfo(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EventChatInfoProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventChatInfoHash() => r'00792a3de4e5e7dd1ac8a96d3e43346e261a2091';

final class EventChatInfoFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<EventChatInfo>, String> {
  EventChatInfoFamily._()
    : super(
        retry: null,
        name: r'eventChatInfoProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EventChatInfoProvider call(String eventId) =>
      EventChatInfoProvider._(argument: eventId, from: this);

  @override
  String toString() => r'eventChatInfoProvider';
}

/// The chat, live: the newest page, kept fresh by Realtime, plus older
/// pages loaded on demand.

@ProviderFor(EventChat)
final eventChatProvider = EventChatFamily._();

/// The chat, live: the newest page, kept fresh by Realtime, plus older
/// pages loaded on demand.
final class EventChatProvider
    extends $AsyncNotifierProvider<EventChat, EventChatView> {
  /// The chat, live: the newest page, kept fresh by Realtime, plus older
  /// pages loaded on demand.
  EventChatProvider._({
    required EventChatFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'eventChatProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$eventChatHash();

  @override
  String toString() {
    return r'eventChatProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  EventChat create() => EventChat();

  @override
  bool operator ==(Object other) {
    return other is EventChatProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventChatHash() => r'406a909288e2264b32a7f1811108f8f76719a591';

/// The chat, live: the newest page, kept fresh by Realtime, plus older
/// pages loaded on demand.

final class EventChatFamily extends $Family
    with
        $ClassFamilyOverride<
          EventChat,
          AsyncValue<EventChatView>,
          EventChatView,
          FutureOr<EventChatView>,
          String
        > {
  EventChatFamily._()
    : super(
        retry: null,
        name: r'eventChatProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The chat, live: the newest page, kept fresh by Realtime, plus older
  /// pages loaded on demand.

  EventChatProvider call(String eventId) =>
      EventChatProvider._(argument: eventId, from: this);

  @override
  String toString() => r'eventChatProvider';
}

/// The chat, live: the newest page, kept fresh by Realtime, plus older
/// pages loaded on demand.

abstract class _$EventChat extends $AsyncNotifier<EventChatView> {
  late final _$args = ref.$arg as String;
  String get eventId => _$args;

  FutureOr<EventChatView> build(String eventId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<EventChatView>, EventChatView>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<EventChatView>, EventChatView>,
              AsyncValue<EventChatView>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// Send, delete and mute in a party's chat.

@ProviderFor(EventChatEditor)
final eventChatEditorProvider = EventChatEditorProvider._();

/// Send, delete and mute in a party's chat.
final class EventChatEditorProvider
    extends $NotifierProvider<EventChatEditor, AsyncValue<void>> {
  /// Send, delete and mute in a party's chat.
  EventChatEditorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventChatEditorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventChatEditorHash();

  @$internal
  @override
  EventChatEditor create() => EventChatEditor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$eventChatEditorHash() => r'5479aef33e1fe3fb44367c937045329b699f2ee5';

/// Send, delete and mute in a party's chat.

abstract class _$EventChatEditor extends $Notifier<AsyncValue<void>> {
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
