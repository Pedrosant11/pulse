// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(myProfile)
final myProfileProvider = MyProfileProvider._();

final class MyProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<MyProfile>,
          MyProfile,
          FutureOr<MyProfile>
        >
    with $FutureModifier<MyProfile>, $FutureProvider<MyProfile> {
  MyProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myProfileHash();

  @$internal
  @override
  $FutureProviderElement<MyProfile> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<MyProfile> create(Ref ref) {
    return myProfile(ref);
  }
}

String _$myProfileHash() => r'a4c375ae13cb5a3d1fb35602ee2cc6c6c9bab192';

/// The user as others see them (public_profiles view).

@ProviderFor(myPublicProfile)
final myPublicProfileProvider = MyPublicProfileProvider._();

/// The user as others see them (public_profiles view).

final class MyPublicProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<PublicProfile>,
          PublicProfile,
          FutureOr<PublicProfile>
        >
    with $FutureModifier<PublicProfile>, $FutureProvider<PublicProfile> {
  /// The user as others see them (public_profiles view).
  MyPublicProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myPublicProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myPublicProfileHash();

  @$internal
  @override
  $FutureProviderElement<PublicProfile> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PublicProfile> create(Ref ref) {
    return myPublicProfile(ref);
  }
}

String _$myPublicProfileHash() => r'c6ae07282de6336397ec211806dc62e78610d634';

/// Another user as shown to others (public_profiles view).

@ProviderFor(publicProfile)
final publicProfileProvider = PublicProfileFamily._();

/// Another user as shown to others (public_profiles view).

final class PublicProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<PublicProfile>,
          PublicProfile,
          FutureOr<PublicProfile>
        >
    with $FutureModifier<PublicProfile>, $FutureProvider<PublicProfile> {
  /// Another user as shown to others (public_profiles view).
  PublicProfileProvider._({
    required PublicProfileFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'publicProfileProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$publicProfileHash();

  @override
  String toString() {
    return r'publicProfileProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<PublicProfile> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PublicProfile> create(Ref ref) {
    final argument = this.argument as String;
    return publicProfile(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PublicProfileProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$publicProfileHash() => r'4bf28d9b00886c18bfcbfb87f2bd3c020fff8a6c';

/// Another user as shown to others (public_profiles view).

final class PublicProfileFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<PublicProfile>, String> {
  PublicProfileFamily._()
    : super(
        retry: null,
        name: r'publicProfileProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Another user as shown to others (public_profiles view).

  PublicProfileProvider call(String userId) =>
      PublicProfileProvider._(argument: userId, from: this);

  @override
  String toString() => r'publicProfileProvider';
}

@ProviderFor(profilePhotos)
final profilePhotosProvider = ProfilePhotosFamily._();

final class ProfilePhotosProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProfilePhoto>>,
          List<ProfilePhoto>,
          FutureOr<List<ProfilePhoto>>
        >
    with
        $FutureModifier<List<ProfilePhoto>>,
        $FutureProvider<List<ProfilePhoto>> {
  ProfilePhotosProvider._({
    required ProfilePhotosFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'profilePhotosProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$profilePhotosHash();

  @override
  String toString() {
    return r'profilePhotosProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ProfilePhoto>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ProfilePhoto>> create(Ref ref) {
    final argument = this.argument as String;
    return profilePhotos(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProfilePhotosProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$profilePhotosHash() => r'219753d44c3ed7236ca9ca2568f0ed4d1f5bc341';

final class ProfilePhotosFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ProfilePhoto>>, String> {
  ProfilePhotosFamily._()
    : super(
        retry: null,
        name: r'profilePhotosProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProfilePhotosProvider call(String userId) =>
      ProfilePhotosProvider._(argument: userId, from: this);

  @override
  String toString() => r'profilePhotosProvider';
}

@ProviderFor(myPhotos)
final myPhotosProvider = MyPhotosProvider._();

final class MyPhotosProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProfilePhoto>>,
          List<ProfilePhoto>,
          FutureOr<List<ProfilePhoto>>
        >
    with
        $FutureModifier<List<ProfilePhoto>>,
        $FutureProvider<List<ProfilePhoto>> {
  MyPhotosProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myPhotosProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myPhotosHash();

  @$internal
  @override
  $FutureProviderElement<List<ProfilePhoto>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ProfilePhoto>> create(Ref ref) {
    return myPhotos(ref);
  }
}

String _$myPhotosHash() => r'218c0576242cb01808bb32f1e373f4fc61c955d6';

/// Signed URL for a private photo. Kept for a while and refreshed before
/// it expires; images are cached by storage path, not by URL.

@ProviderFor(photoUrl)
final photoUrlProvider = PhotoUrlFamily._();

/// Signed URL for a private photo. Kept for a while and refreshed before
/// it expires; images are cached by storage path, not by URL.

final class PhotoUrlProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// Signed URL for a private photo. Kept for a while and refreshed before
  /// it expires; images are cached by storage path, not by URL.
  PhotoUrlProvider._({
    required PhotoUrlFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'photoUrlProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$photoUrlHash();

  @override
  String toString() {
    return r'photoUrlProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument = this.argument as String;
    return photoUrl(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PhotoUrlProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$photoUrlHash() => r'cb27a87e3dba99ea1f15debd6066983681334ca3';

/// Signed URL for a private photo. Kept for a while and refreshed before
/// it expires; images are cached by storage path, not by URL.

final class PhotoUrlFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String>, String> {
  PhotoUrlFamily._()
    : super(
        retry: null,
        name: r'photoUrlProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Signed URL for a private photo. Kept for a while and refreshed before
  /// it expires; images are cached by storage path, not by URL.

  PhotoUrlProvider call(String storagePath) =>
      PhotoUrlProvider._(argument: storagePath, from: this);

  @override
  String toString() => r'photoUrlProvider';
}

@ProviderFor(myAttendingEvents)
final myAttendingEventsProvider = MyAttendingEventsProvider._();

final class MyAttendingEventsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<EventSummary>>,
          List<EventSummary>,
          FutureOr<List<EventSummary>>
        >
    with
        $FutureModifier<List<EventSummary>>,
        $FutureProvider<List<EventSummary>> {
  MyAttendingEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myAttendingEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myAttendingEventsHash();

  @$internal
  @override
  $FutureProviderElement<List<EventSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<EventSummary>> create(Ref ref) {
    return myAttendingEvents(ref);
  }
}

String _$myAttendingEventsHash() => r'de67e405a40b16fa02c4b088b16d6c5e9b5edc3e';

@ProviderFor(upcomingEvents)
final upcomingEventsProvider = UpcomingEventsFamily._();

final class UpcomingEventsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<EventSummary>>,
          List<EventSummary>,
          FutureOr<List<EventSummary>>
        >
    with
        $FutureModifier<List<EventSummary>>,
        $FutureProvider<List<EventSummary>> {
  UpcomingEventsProvider._({
    required UpcomingEventsFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'upcomingEventsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$upcomingEventsHash();

  @override
  String toString() {
    return r'upcomingEventsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<EventSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<EventSummary>> create(Ref ref) {
    final argument = this.argument as String?;
    return upcomingEvents(ref, state: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UpcomingEventsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$upcomingEventsHash() => r'40a857784d49a29bd766082ab06a618aca4c116a';

final class UpcomingEventsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<EventSummary>>, String?> {
  UpcomingEventsFamily._()
    : super(
        retry: null,
        name: r'upcomingEventsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UpcomingEventsProvider call({String? state}) =>
      UpcomingEventsProvider._(argument: state, from: this);

  @override
  String toString() => r'upcomingEventsProvider';
}

/// Saves profile sections (onboarding steps and edit screens).

@ProviderFor(ProfileEditor)
final profileEditorProvider = ProfileEditorProvider._();

/// Saves profile sections (onboarding steps and edit screens).
final class ProfileEditorProvider
    extends $NotifierProvider<ProfileEditor, AsyncValue<void>> {
  /// Saves profile sections (onboarding steps and edit screens).
  ProfileEditorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileEditorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileEditorHash();

  @$internal
  @override
  ProfileEditor create() => ProfileEditor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$profileEditorHash() => r'b05b990e9e6b8cb8bec9f4fd66aa9ef5bac0d8b1';

/// Saves profile sections (onboarding steps and edit screens).

abstract class _$ProfileEditor extends $Notifier<AsyncValue<void>> {
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

@ProviderFor(PhotosEditor)
final photosEditorProvider = PhotosEditorProvider._();

final class PhotosEditorProvider
    extends $NotifierProvider<PhotosEditor, AsyncValue<void>> {
  PhotosEditorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'photosEditorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$photosEditorHash();

  @$internal
  @override
  PhotosEditor create() => PhotosEditor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$photosEditorHash() => r'a55a897f464cfd93b586cf95fae518ae3bb6c58c';

abstract class _$PhotosEditor extends $Notifier<AsyncValue<void>> {
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
