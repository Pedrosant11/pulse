// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievements_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(myAchievements)
final myAchievementsProvider = MyAchievementsProvider._();

final class MyAchievementsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Achievement>>,
          List<Achievement>,
          FutureOr<List<Achievement>>
        >
    with
        $FutureModifier<List<Achievement>>,
        $FutureProvider<List<Achievement>> {
  MyAchievementsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myAchievementsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myAchievementsHash();

  @$internal
  @override
  $FutureProviderElement<List<Achievement>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Achievement>> create(Ref ref) {
    return myAchievements(ref);
  }
}

String _$myAchievementsHash() => r'cb6957f42e5fabcd20fd5d38ef4f407712048304';

@ProviderFor(userAchievements)
final userAchievementsProvider = UserAchievementsFamily._();

final class UserAchievementsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AchievementKey>>,
          List<AchievementKey>,
          FutureOr<List<AchievementKey>>
        >
    with
        $FutureModifier<List<AchievementKey>>,
        $FutureProvider<List<AchievementKey>> {
  UserAchievementsProvider._({
    required UserAchievementsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userAchievementsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userAchievementsHash();

  @override
  String toString() {
    return r'userAchievementsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<AchievementKey>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AchievementKey>> create(Ref ref) {
    final argument = this.argument as String;
    return userAchievements(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserAchievementsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userAchievementsHash() => r'35717fdae8f09ca4c065036b26d2c93974ecd993';

final class UserAchievementsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<AchievementKey>>, String> {
  UserAchievementsFamily._()
    : super(
        retry: null,
        name: r'userAchievementsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserAchievementsProvider call(String userId) =>
      UserAchievementsProvider._(argument: userId, from: this);

  @override
  String toString() => r'userAchievementsProvider';
}

@ProviderFor(myPassport)
final myPassportProvider = MyPassportProvider._();

final class MyPassportProvider
    extends
        $FunctionalProvider<AsyncValue<Passport>, Passport, FutureOr<Passport>>
    with $FutureModifier<Passport>, $FutureProvider<Passport> {
  MyPassportProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myPassportProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myPassportHash();

  @$internal
  @override
  $FutureProviderElement<Passport> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Passport> create(Ref ref) {
    return myPassport(ref);
  }
}

String _$myPassportHash() => r'3b9014116f44f47d2c2e485c72c5e354c8c9135f';
