// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// "Baixar meus dados" (LGPD art. 18: access and portability).

@ProviderFor(DataExport)
final dataExportProvider = DataExportProvider._();

/// "Baixar meus dados" (LGPD art. 18: access and portability).
final class DataExportProvider
    extends $NotifierProvider<DataExport, AsyncValue<void>> {
  /// "Baixar meus dados" (LGPD art. 18: access and portability).
  DataExportProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dataExportProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dataExportHash();

  @$internal
  @override
  DataExport create() => DataExport();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$dataExportHash() => r'bf63305dea2cc411abfede0c05fa502862f92df9';

/// "Baixar meus dados" (LGPD art. 18: access and portability).

abstract class _$DataExport extends $Notifier<AsyncValue<void>> {
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

/// Bundled text of a legal document (works offline and matches the version
/// the user accepts).

@ProviderFor(legalText)
final legalTextProvider = LegalTextFamily._();

/// Bundled text of a legal document (works offline and matches the version
/// the user accepts).

final class LegalTextProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// Bundled text of a legal document (works offline and matches the version
  /// the user accepts).
  LegalTextProvider._({
    required LegalTextFamily super.from,
    required LegalDocument super.argument,
  }) : super(
         retry: null,
         name: r'legalTextProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$legalTextHash();

  @override
  String toString() {
    return r'legalTextProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument = this.argument as LegalDocument;
    return legalText(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LegalTextProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$legalTextHash() => r'6d3b14a66f5510677142fefc04f0a5e2080b0a3c';

/// Bundled text of a legal document (works offline and matches the version
/// the user accepts).

final class LegalTextFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String>, LegalDocument> {
  LegalTextFamily._()
    : super(
        retry: null,
        name: r'legalTextProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Bundled text of a legal document (works offline and matches the version
  /// the user accepts).

  LegalTextProvider call(LegalDocument document) =>
      LegalTextProvider._(argument: document, from: this);

  @override
  String toString() => r'legalTextProvider';
}
