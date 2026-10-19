import 'package:pulse/core/utils/run_action.dart';
import 'package:pulse/features/admin_web/data/admin_console_repository.dart';
import 'package:pulse/features/admin_web/domain/admin_console_models.dart';
import 'package:pulse/features/events/domain/featured.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_console_providers.g.dart';

@riverpod
Future<AdminDashboard> adminDashboard(Ref ref) =>
    ref.watch(adminConsoleRepositoryProvider).dashboard();

@riverpod
Future<List<AppSetting>> adminSettings(Ref ref) =>
    ref.watch(adminConsoleRepositoryProvider).settings();

@riverpod
Future<List<FeaturedPrice>> adminFeaturedPrices(Ref ref) =>
    ref.watch(adminConsoleRepositoryProvider).featuredPrices();

/// Saving settings and prices from the console.
@riverpod
class AdminSettingsEditor extends _$AdminSettingsEditor {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<bool?> setSetting(String key, int value) =>
      runAction(ref, (s) => state = s, () async {
        await ref.read(adminConsoleRepositoryProvider).setSetting(key, value);
        ref.invalidate(adminSettingsProvider);
        return true;
      });

  Future<bool?> setFeaturedPrice(int days, int priceCents) =>
      runAction(ref, (s) => state = s, () async {
        await ref
            .read(adminConsoleRepositoryProvider)
            .setFeaturedPrice(days, priceCents);
        ref
          ..invalidate(adminFeaturedPricesProvider)
          ..invalidate(featuredPricesProvider);
        return true;
      });
}
