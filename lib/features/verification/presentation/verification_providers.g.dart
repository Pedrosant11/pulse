// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(myVerification)
final myVerificationProvider = MyVerificationProvider._();

final class MyVerificationProvider
    extends
        $FunctionalProvider<
          AsyncValue<VerificationRequest?>,
          VerificationRequest?,
          FutureOr<VerificationRequest?>
        >
    with
        $FutureModifier<VerificationRequest?>,
        $FutureProvider<VerificationRequest?> {
  MyVerificationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myVerificationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myVerificationHash();

  @$internal
  @override
  $FutureProviderElement<VerificationRequest?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<VerificationRequest?> create(Ref ref) {
    return myVerification(ref);
  }
}

String _$myVerificationHash() => r'd99b80dda4098c965fd5c7763eb058822857def6';

@ProviderFor(pendingVerifications)
final pendingVerificationsProvider = PendingVerificationsProvider._();

final class PendingVerificationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PendingVerification>>,
          List<PendingVerification>,
          FutureOr<List<PendingVerification>>
        >
    with
        $FutureModifier<List<PendingVerification>>,
        $FutureProvider<List<PendingVerification>> {
  PendingVerificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingVerificationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingVerificationsHash();

  @$internal
  @override
  $FutureProviderElement<List<PendingVerification>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PendingVerification>> create(Ref ref) {
    return pendingVerifications(ref);
  }
}

String _$pendingVerificationsHash() =>
    r'1051dc491b063068bcaa797be7f955b36c56a96d';

@ProviderFor(verificationSelfieUrl)
final verificationSelfieUrlProvider = VerificationSelfieUrlFamily._();

final class VerificationSelfieUrlProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  VerificationSelfieUrlProvider._({
    required VerificationSelfieUrlFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'verificationSelfieUrlProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$verificationSelfieUrlHash();

  @override
  String toString() {
    return r'verificationSelfieUrlProvider'
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
    return verificationSelfieUrl(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is VerificationSelfieUrlProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$verificationSelfieUrlHash() =>
    r'19b835e2d335bf74c391e2e1b8fa132ff0b5a30a';

final class VerificationSelfieUrlFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String>, String> {
  VerificationSelfieUrlFamily._()
    : super(
        retry: null,
        name: r'verificationSelfieUrlProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  VerificationSelfieUrlProvider call(String path) =>
      VerificationSelfieUrlProvider._(argument: path, from: this);

  @override
  String toString() => r'verificationSelfieUrlProvider';
}

@ProviderFor(VerificationController)
final verificationControllerProvider = VerificationControllerProvider._();

final class VerificationControllerProvider
    extends $NotifierProvider<VerificationController, AsyncValue<void>> {
  VerificationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'verificationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$verificationControllerHash();

  @$internal
  @override
  VerificationController create() => VerificationController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$verificationControllerHash() =>
    r'f6aa4445b7b99cae142fc9a11f1646d26bf59ba4';

abstract class _$VerificationController extends $Notifier<AsyncValue<void>> {
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
