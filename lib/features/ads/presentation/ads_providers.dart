import 'dart:typed_data';

import 'package:pulse/core/utils/run_action.dart';
import 'package:pulse/features/ads/data/ad_network.dart';
import 'package:pulse/features/ads/data/ads_repository.dart';
import 'package:pulse/features/ads/domain/ad_models.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/plans/presentation/plans_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ads_providers.g.dart';

/// Ads for the signed-in person (asked again when the plan changes).
@riverpod
Future<AdsConfig> adsConfig(Ref ref) {
  ref
    ..watch(currentUserIdProvider)
    // Not on every wallet refresh (each swipe), only when the plan changes.
    ..listen(entitlementsProvider, (previous, next) {
      if (previous?.value?.tier != next.value?.tier) ref.invalidateSelf();
    });
  return ref.watch(adsRepositoryProvider).config();
}

/// Whether slots of [placement] can be filled right now.
@riverpod
bool adsReady(Ref ref, AdPlacement placement) {
  final config = ref.watch(adsConfigProvider).value;
  if (config == null || !config.enabled) return false;
  return config.adsFor(placement).isNotEmpty ||
      ref.watch(adNetworkProvider).isAvailable;
}

@riverpod
Future<List<AdminAd>> adminAds(Ref ref) =>
    ref.watch(adsRepositoryProvider).all();

@riverpod
class AdEditor extends _$AdEditor {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool?> save(AdminAd ad, {Uint8List? image, bool isNew = false}) =>
      runAction(ref, (s) => state = s, () async {
        await ref
            .read(adsRepositoryProvider)
            .save(ad, image: image, isNew: isNew);
        _refresh();
        return true;
      });

  Future<bool?> delete(AdminAd ad) =>
      runAction(ref, (s) => state = s, () async {
        await ref.read(adsRepositoryProvider).delete(ad);
        _refresh();
        return true;
      });

  void _refresh() => ref
    ..invalidate(adminAdsProvider)
    ..invalidate(adsConfigProvider);
}
