import 'dart:async';

import 'package:pulse/core/utils/run_action.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/plans/data/plans_repository.dart';
import 'package:pulse/features/plans/data/store_purchases.dart';
import 'package:pulse/features/plans/domain/plan_models.dart';
import 'package:pulse/features/profile/domain/city.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'plans_providers.g.dart';

@riverpod
Future<Entitlements> entitlements(Ref ref) {
  ref.watch(currentUserIdProvider);
  return ref.watch(plansRepositoryProvider).entitlements();
}

@riverpod
Future<int> likesReceivedCount(Ref ref) {
  ref.watch(currentUserIdProvider);
  return ref.watch(plansRepositoryProvider).likesReceivedCount();
}

/// Only fetched for Black (the database refuses others).
@riverpod
Future<List<LikedYou>> likesReceived(Ref ref) async {
  final entitlements = await ref.watch(entitlementsProvider.future);
  if (!entitlements.isBlack) return const [];
  return await ref.watch(plansRepositoryProvider).likesReceived();
}

@riverpod
Future<int> sameNightCount(Ref ref) {
  ref.watch(currentUserIdProvider);
  return ref.watch(plansRepositoryProvider).sameNightCount();
}

/// Only fetched for Black (the database refuses others).
@riverpod
Future<List<SameNightPerson>> sameNight(Ref ref) async {
  final entitlements = await ref.watch(entitlementsProvider.future);
  if (!entitlements.isBlack) return const [];
  return await ref.watch(plansRepositoryProvider).sameNight();
}

@riverpod
Future<List<StoreOffer>> storeOffers(Ref ref) =>
    ref.watch(storePurchasesProvider).offers();

/// Paid features and purchases. Errors stay in `state` for the UI.
@riverpod
class PlanActions extends _$PlanActions {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  PlansRepository get _repository => ref.read(plansRepositoryProvider);

  String _userId() {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) throw StateError('Not signed in');
    return userId;
  }

  Future<DateTime?> activateBoost() =>
      runAction(ref, (s) => state = s, () async {
        final endsAt = await _repository.activateBoost();
        ref.invalidate(entitlementsProvider);
        return endsAt;
      });

  Future<bool?> setTravel(City? city) =>
      runAction(ref, (s) => state = s, () async {
        final userId = _userId();
        city == null
            ? await _repository.clearTravel(userId)
            : await _repository.setTravel(userId, city);
        ref.invalidate(entitlementsProvider);
        return true;
      });

  Future<bool?> setIncognito({required bool enabled}) =>
      runAction(ref, (s) => state = s, () async {
        await _repository.setIncognito(_userId(), enabled: enabled);
        ref.invalidate(entitlementsProvider);
        return true;
      });

  /// Returns false when the person closed the store sheet.
  Future<bool?> buy(StoreOffer offer) =>
      runAction(ref, (s) => state = s, () async {
        try {
          await ref.read(storePurchasesProvider).buy(offer);
        } on PurchaseCancelled {
          return false;
        }
        await _awaitStoreUpdate();
        return true;
      });

  Future<bool?> restore() => runAction(ref, (s) => state = s, () async {
    await ref.read(storePurchasesProvider).restore();
    await _awaitStoreUpdate();
    return true;
  });

  /// The store confirms to RevenueCat, which calls our webhook; the plan
  /// shows up a few seconds later. Re-reads a few times.
  Future<void> _awaitStoreUpdate() async {
    final before = ref.read(entitlementsProvider).value;
    for (var i = 0; i < 5; i++) {
      await Future<void>.delayed(const Duration(seconds: 2));
      if (!ref.mounted) return;
      ref.invalidate(entitlementsProvider);
      final now = await ref.read(entitlementsProvider.future);
      if (now != before) return;
    }
  }
}

// Admin ---------------------------------------------------------------------

@riverpod
Future<AdminPlan> adminPlan(Ref ref, String userId) =>
    ref.watch(plansRepositoryProvider).adminPlan(userId);

@riverpod
class AdminPlanEditor extends _$AdminPlanEditor {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool?> grantPlan(String userId, PlanTier? tier, {int? days}) =>
      runAction(ref, (s) => state = s, () async {
        await ref
            .read(plansRepositoryProvider)
            .adminGrantPlan(userId, tier, days: days);
        ref.invalidate(adminPlanProvider(userId));
        return true;
      });

  Future<bool?> grantWallet(
    String userId, {
    int superlikes = 0,
    int boosts = 0,
  }) => runAction(ref, (s) => state = s, () async {
    await ref
        .read(plansRepositoryProvider)
        .adminGrantWallet(userId, superlikes: superlikes, boosts: boosts);
    ref.invalidate(adminPlanProvider(userId));
    return true;
  });
}
