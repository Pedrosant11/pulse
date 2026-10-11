// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referral_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(referralRepository)
final referralRepositoryProvider = ReferralRepositoryProvider._();

final class ReferralRepositoryProvider
    extends
        $FunctionalProvider<
          ReferralRepository,
          ReferralRepository,
          ReferralRepository
        >
    with $Provider<ReferralRepository> {
  ReferralRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'referralRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$referralRepositoryHash();

  @$internal
  @override
  $ProviderElement<ReferralRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReferralRepository create(Ref ref) {
    return referralRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReferralRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReferralRepository>(value),
    );
  }
}

String _$referralRepositoryHash() =>
    r'fc5560c608921c3143d759e5ee20c6c52db63941';
