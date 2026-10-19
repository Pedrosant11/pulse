// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_console_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adminDashboard)
final adminDashboardProvider = AdminDashboardProvider._();

final class AdminDashboardProvider
    extends
        $FunctionalProvider<
          AsyncValue<AdminDashboard>,
          AdminDashboard,
          FutureOr<AdminDashboard>
        >
    with $FutureModifier<AdminDashboard>, $FutureProvider<AdminDashboard> {
  AdminDashboardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminDashboardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminDashboardHash();

  @$internal
  @override
  $FutureProviderElement<AdminDashboard> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AdminDashboard> create(Ref ref) {
    return adminDashboard(ref);
  }
}

String _$adminDashboardHash() => r'fea131a3e7250f58e10cdd3d7714f7317438cf6c';

@ProviderFor(adminSettings)
final adminSettingsProvider = AdminSettingsProvider._();

final class AdminSettingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AppSetting>>,
          List<AppSetting>,
          FutureOr<List<AppSetting>>
        >
    with $FutureModifier<List<AppSetting>>, $FutureProvider<List<AppSetting>> {
  AdminSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminSettingsHash();

  @$internal
  @override
  $FutureProviderElement<List<AppSetting>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AppSetting>> create(Ref ref) {
    return adminSettings(ref);
  }
}

String _$adminSettingsHash() => r'39c3905515a40d5b2d25b3333a6326bf3496fc54';

@ProviderFor(adminFeaturedPrices)
final adminFeaturedPricesProvider = AdminFeaturedPricesProvider._();

final class AdminFeaturedPricesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FeaturedPrice>>,
          List<FeaturedPrice>,
          FutureOr<List<FeaturedPrice>>
        >
    with
        $FutureModifier<List<FeaturedPrice>>,
        $FutureProvider<List<FeaturedPrice>> {
  AdminFeaturedPricesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminFeaturedPricesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminFeaturedPricesHash();

  @$internal
  @override
  $FutureProviderElement<List<FeaturedPrice>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<FeaturedPrice>> create(Ref ref) {
    return adminFeaturedPrices(ref);
  }
}

String _$adminFeaturedPricesHash() =>
    r'317f06641a7e52390c6d1b419bff609f4ffb3ade';

/// Saving settings and prices from the console.

@ProviderFor(AdminSettingsEditor)
final adminSettingsEditorProvider = AdminSettingsEditorProvider._();

/// Saving settings and prices from the console.
final class AdminSettingsEditorProvider
    extends $NotifierProvider<AdminSettingsEditor, AsyncValue<void>> {
  /// Saving settings and prices from the console.
  AdminSettingsEditorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminSettingsEditorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminSettingsEditorHash();

  @$internal
  @override
  AdminSettingsEditor create() => AdminSettingsEditor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$adminSettingsEditorHash() =>
    r'89272ee3ce0bc987feeca0f4b313a8d829cbe919';

/// Saving settings and prices from the console.

abstract class _$AdminSettingsEditor extends $Notifier<AsyncValue<void>> {
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
