import 'package:pulse/core/utils/run_action.dart';
import 'package:pulse/features/plans/presentation/plans_providers.dart';
import 'package:pulse/features/referral/data/referral_repository.dart';
import 'package:pulse/features/referral/domain/referral_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'referral_providers.g.dart';

@riverpod
Future<ReferralInfo> myReferral(Ref ref) =>
    ref.watch(referralRepositoryProvider).mine();

@riverpod
class ReferralController extends _$ReferralController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool?> redeem(String code) =>
      runAction(ref, (s) => state = s, () async {
        await ref.read(referralRepositoryProvider).redeem(code);
        ref
          ..invalidate(myReferralProvider)
          // The superlikes land in the wallet.
          ..invalidate(entitlementsProvider);
        return true;
      });
}
