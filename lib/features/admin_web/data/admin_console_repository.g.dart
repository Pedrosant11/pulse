// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_console_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adminConsoleRepository)
final adminConsoleRepositoryProvider = AdminConsoleRepositoryProvider._();

final class AdminConsoleRepositoryProvider
    extends
        $FunctionalProvider<
          AdminConsoleRepository,
          AdminConsoleRepository,
          AdminConsoleRepository
        >
    with $Provider<AdminConsoleRepository> {
  AdminConsoleRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminConsoleRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminConsoleRepositoryHash();

  @$internal
  @override
  $ProviderElement<AdminConsoleRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AdminConsoleRepository create(Ref ref) {
    return adminConsoleRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminConsoleRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminConsoleRepository>(value),
    );
  }
}

String _$adminConsoleRepositoryHash() =>
    r'565b4dfcfae480433859dc935d7aebd845f7d00e';
