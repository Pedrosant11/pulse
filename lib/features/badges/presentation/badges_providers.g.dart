// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badges_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Badges of one person (cached while shown).

@ProviderFor(userBadges)
final userBadgesProvider = UserBadgesFamily._();

/// Badges of one person (cached while shown).

final class UserBadgesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UserBadge>>,
          List<UserBadge>,
          FutureOr<List<UserBadge>>
        >
    with $FutureModifier<List<UserBadge>>, $FutureProvider<List<UserBadge>> {
  /// Badges of one person (cached while shown).
  UserBadgesProvider._({
    required UserBadgesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userBadgesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userBadgesHash();

  @override
  String toString() {
    return r'userBadgesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<UserBadge>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<UserBadge>> create(Ref ref) {
    final argument = this.argument as String;
    return userBadges(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserBadgesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userBadgesHash() => r'dad5bc949c84ab44e1818c52b92419843218abdb';

/// Badges of one person (cached while shown).

final class UserBadgesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<UserBadge>>, String> {
  UserBadgesFamily._()
    : super(
        retry: null,
        name: r'userBadgesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Badges of one person (cached while shown).

  UserBadgesProvider call(String userId) =>
      UserBadgesProvider._(argument: userId, from: this);

  @override
  String toString() => r'userBadgesProvider';
}

@ProviderFor(myBadgeRequests)
final myBadgeRequestsProvider = MyBadgeRequestsProvider._();

final class MyBadgeRequestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BadgeRequest>>,
          List<BadgeRequest>,
          FutureOr<List<BadgeRequest>>
        >
    with
        $FutureModifier<List<BadgeRequest>>,
        $FutureProvider<List<BadgeRequest>> {
  MyBadgeRequestsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myBadgeRequestsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myBadgeRequestsHash();

  @$internal
  @override
  $FutureProviderElement<List<BadgeRequest>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BadgeRequest>> create(Ref ref) {
    return myBadgeRequests(ref);
  }
}

String _$myBadgeRequestsHash() => r'2b789f79d8fb8dc734a407669352d098b709cf98';

@ProviderFor(pendingBadgeRequests)
final pendingBadgeRequestsProvider = PendingBadgeRequestsProvider._();

final class PendingBadgeRequestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BadgeRequest>>,
          List<BadgeRequest>,
          FutureOr<List<BadgeRequest>>
        >
    with
        $FutureModifier<List<BadgeRequest>>,
        $FutureProvider<List<BadgeRequest>> {
  PendingBadgeRequestsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingBadgeRequestsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingBadgeRequestsHash();

  @$internal
  @override
  $FutureProviderElement<List<BadgeRequest>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BadgeRequest>> create(Ref ref) {
    return pendingBadgeRequests(ref);
  }
}

String _$pendingBadgeRequestsHash() =>
    r'dd153774578edf6ce57c9532bde8b7a4a1bf596e';

@ProviderFor(adminUserSearch)
final adminUserSearchProvider = AdminUserSearchFamily._();

final class AdminUserSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AdminUserResult>>,
          List<AdminUserResult>,
          FutureOr<List<AdminUserResult>>
        >
    with
        $FutureModifier<List<AdminUserResult>>,
        $FutureProvider<List<AdminUserResult>> {
  AdminUserSearchProvider._({
    required AdminUserSearchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'adminUserSearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$adminUserSearchHash();

  @override
  String toString() {
    return r'adminUserSearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<AdminUserResult>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AdminUserResult>> create(Ref ref) {
    final argument = this.argument as String;
    return adminUserSearch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AdminUserSearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$adminUserSearchHash() => r'e075febaf8d85b133a76d9092f00dae7947b6172';

final class AdminUserSearchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<AdminUserResult>>, String> {
  AdminUserSearchFamily._()
    : super(
        retry: null,
        name: r'adminUserSearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AdminUserSearchProvider call(String query) =>
      AdminUserSearchProvider._(argument: query, from: this);

  @override
  String toString() => r'adminUserSearchProvider';
}

/// Requests, reviews and admin grants.

@ProviderFor(BadgeEditor)
final badgeEditorProvider = BadgeEditorProvider._();

/// Requests, reviews and admin grants.
final class BadgeEditorProvider
    extends $NotifierProvider<BadgeEditor, AsyncValue<void>> {
  /// Requests, reviews and admin grants.
  BadgeEditorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'badgeEditorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$badgeEditorHash();

  @$internal
  @override
  BadgeEditor create() => BadgeEditor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$badgeEditorHash() => r'2de549b554ba8f493d8929be80b415f09f2514d3';

/// Requests, reviews and admin grants.

abstract class _$BadgeEditor extends $Notifier<AsyncValue<void>> {
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
