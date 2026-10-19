// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_web_app.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(consoleAccess)
final consoleAccessProvider = ConsoleAccessProvider._();

final class ConsoleAccessProvider
    extends $FunctionalProvider<ConsoleAccess?, ConsoleAccess?, ConsoleAccess?>
    with $Provider<ConsoleAccess?> {
  ConsoleAccessProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'consoleAccessProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$consoleAccessHash();

  @$internal
  @override
  $ProviderElement<ConsoleAccess?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ConsoleAccess? create(Ref ref) {
    return consoleAccess(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConsoleAccess? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConsoleAccess?>(value),
    );
  }
}

String _$consoleAccessHash() => r'006e85e79ec41e1dedc8419f2919cd6ede580e5c';

@ProviderFor(consoleRouter)
final consoleRouterProvider = ConsoleRouterProvider._();

final class ConsoleRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  ConsoleRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'consoleRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$consoleRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return consoleRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$consoleRouterHash() => r'72d4e2cbd4226956306ce9882e145bfac10d3a96';
