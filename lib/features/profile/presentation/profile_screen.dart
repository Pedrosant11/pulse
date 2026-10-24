import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/achievements/presentation/achievements_providers.dart';
import 'package:pulse/features/achievements/presentation/widgets/achievements.dart';
import 'package:pulse/features/events/presentation/widgets/event_attend_tile.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/features/profile/presentation/widgets/profile_view.dart';

/// Profile tab (SPEC 6.3): preview exactly as others see it, edit button,
/// verified badge and upcoming events.
class ProfileScreen extends ConsumerWidget {
  const new({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref
      ..invalidate(myPublicProfileProvider)
      ..invalidate(myPhotosProvider)
      ..invalidate(myAttendingEventsProvider)
      ..invalidate(myAchievementsProvider)
      ..invalidate(myPassportProvider);
    await ref.read(myPublicProfileProvider.future);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final profile = ref.watch(myPublicProfileProvider);
    final photos = ref.watch(myPhotosProvider);
    final events = ref.watch(myAttendingEventsProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(l10n.profileTitle.toUpperCase()),
        actions: [
          IconButton(
            tooltip: l10n.openSettings,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _refresh(ref),
          child: AsyncValueView(
            value: profile,
            onRetry: () => _refresh(ref),
            data: (profile) => ListView(
              padding: EdgeInsets.all(spacing.md),
              children: [
                Text(
                  l10n.profilePreviewHint,
                  style: context.textTheme.bodySmall,
                ),
                SizedBox(height: spacing.sm),
                ProfileView(profile: profile, photos: photos.value ?? const []),
                SizedBox(height: spacing.lg),
                NeonButton(
                  label: l10n.profileEdit,
                  icon: Icons.edit_outlined,
                  onPressed: () => context.push(AppRoutes.editProfile),
                ),
                SizedBox(height: spacing.xl),
                const AchievementsSection(),
                SizedBox(height: spacing.xl),
                const PassportCard(),
                SizedBox(height: spacing.xl),
                Text(
                  l10n.profileUpcomingEvents.toUpperCase(),
                  style: context.textTheme.titleLarge,
                ),
                SizedBox(height: spacing.sm),
                AsyncValueView(
                  value: events,
                  onRetry: () => ref.invalidate(myAttendingEventsProvider),
                  loading: const LoadingView(itemCount: 1),
                  data: (events) => events.isEmpty
                      ? Text(
                          l10n.profileNoEvents,
                          style: context.textTheme.bodyMedium,
                        )
                      : Column(
                          children: [
                            for (final event in events)
                              Padding(
                                padding: EdgeInsets.only(bottom: spacing.sm),
                                child: EventAttendTile(event: event),
                              ),
                          ],
                        ),
                ),
                SizedBox(height: spacing.lg),
                OutlinedButton.icon(
                  onPressed: () => context.push(AppRoutes.safetyTips),
                  icon: const Icon(Icons.health_and_safety_outlined),
                  label: Text(l10n.safetyTipsEntry),
                ),
                // Clears the floating bottom navigation.
                SizedBox(height: spacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
