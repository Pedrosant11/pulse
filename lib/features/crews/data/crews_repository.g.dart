// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crews_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(crewsRepository)
final crewsRepositoryProvider = CrewsRepositoryProvider._();

final class CrewsRepositoryProvider
    extends
        $FunctionalProvider<CrewsRepository, CrewsRepository, CrewsRepository>
    with $Provider<CrewsRepository> {
  CrewsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'crewsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$crewsRepositoryHash();

  @$internal
  @override
  $ProviderElement<CrewsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CrewsRepository create(Ref ref) {
    return crewsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CrewsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CrewsRepository>(value),
    );
  }
}

String _$crewsRepositoryHash() => r'6ff2f6d306ffb8192284912239e295f3bc759041';
