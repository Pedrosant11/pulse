import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/errors/app_failure_message.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/models/app_mode.dart';
import 'package:pulse/core/utils/run_action.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/chat/presentation/widgets/chat_avatar.dart';
import 'package:pulse/features/discover/data/discover_repository.dart';
import 'package:pulse/features/discover/domain/discover_models.dart';
import 'package:pulse/features/plans/domain/plan_models.dart';
import 'package:pulse/features/plans/presentation/plans_providers.dart';
import 'package:pulse/features/profile/presentation/widgets/user_profile_sheet.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'same_night_screen.g.dart';

/// Liking someone from the same party (Date, like any other swipe).
@riverpod
class SameNightActions extends _$SameNightActions {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<SwipeResult?> answer(SameNightPerson person, {required bool liked}) =>
      runAction(ref, (s) => state = s, () async {
        final result = await ref
            .read(discoverRepositoryProvider)
            .swipe(
              targetId: person.userId,
              mode: AppMode.date,
              direction: liked ? SwipeDirection.like : SwipeDirection.pass,
            );
        ref
          ..invalidate(sameNightProvider)
          ..invalidate(sameNightCountProvider);
        return result;
      });
}

/// "Mesmo rolê": the 24 h after a party, people who were there too.
class SameNightScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final entitlements = ref.watch(entitlementsProvider);

    ref.listen(sameNightActionsProvider, (_, next) {
      if (next case AsyncError(:final error)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(friendlyErrorMessage(error, l10n))),
        );
      }
    });

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(l10n.sameNightTitle.toUpperCase())),
      body: SafeArea(
        child: AsyncValueView(
          value: entitlements,
          onRetry: () => ref.invalidate(entitlementsProvider),
          data: (me) => me.isBlack ? const _People() : const _Locked(),
        ),
      ),
    );
  }
}

class _Locked extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final count = ref.watch(sameNightCountProvider).value ?? 0;
    return ListView(
      padding: EdgeInsets.all(spacing.lg),
      children: [
        SizedBox(height: spacing.lg),
        Icon(Icons.nightlight_round, size: 72, color: colors.lime),
        SizedBox(height: spacing.md),
        Text(
          count == 0 ? l10n.sameNightEmpty : l10n.sameNightCount(count),
          textAlign: TextAlign.center,
          style: context.textTheme.headlineSmall,
        ),
        SizedBox(height: spacing.sm),
        Text(
          l10n.sameNightExplain,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium?.copyWith(
            color: colors.textSecondary,
          ),
        ),
        if (count > 0) ...[
          SizedBox(height: spacing.xl),
          NeonButton(
            label: l10n.sameNightUnlock,
            icon: Icons.workspace_premium_rounded,
            gradient: colors.blackGradient,
            onPressed: () =>
                context.push(AppRoutes.plansFor(PlanFeature.sameNight)),
          ),
        ],
      ],
    );
  }
}

class _People extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final people = ref.watch(sameNightProvider);
    final busy = ref.watch(sameNightActionsProvider).isLoading;

    Future<void> answer(SameNightPerson person, {required bool liked}) async {
      final result = await ref
          .read(sameNightActionsProvider.notifier)
          .answer(person, liked: liked);
      if (result == null || !result.matched || !context.mounted) return;
      final router = GoRouter.maybeOf(context);
      final conversationId = result.conversationId;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            persist: false,
            duration: const Duration(seconds: 5),
            content: Text(l10n.likesYouMatched(person.firstName)),
            action: SnackBarAction(
              label: l10n.likesYouOpenChat,
              onPressed: () => conversationId == null
                  ? router?.go(AppRoutes.chats)
                  : router?.push(AppRoutes.conversation(conversationId)),
            ),
          ),
        );
    }

    return AsyncValueView(
      value: people,
      onRetry: () => ref.invalidate(sameNightProvider),
      data: (people) => people.isEmpty
          ? EmptyView(
              icon: Icons.nightlight_outlined,
              title: l10n.sameNightEmpty,
              message: l10n.sameNightExplain,
            )
          : ListView.separated(
              padding: EdgeInsets.all(spacing.md),
              itemCount: people.length + 1,
              separatorBuilder: (_, _) => SizedBox(height: spacing.sm),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Text(
                    l10n.sameNightCount(people.length),
                    style: context.textTheme.headlineSmall,
                  );
                }
                final person = people[index - 1];
                return GlassCard(
                  padding: EdgeInsets.all(spacing.sm),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => showUserProfile(context, person.userId),
                        child: ChatAvatar(
                          photoPath: person.photoPath,
                          size: 56,
                          ring: colors.magenta,
                        ),
                      ),
                      SizedBox(width: spacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.profileNameAge(person.firstName, person.age),
                              style: context.textTheme.titleMedium,
                            ),
                            Text(
                              l10n.sameNightWasAt(person.eventName),
                              style: context.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: l10n.actionPass,
                        onPressed: busy
                            ? null
                            : () => answer(person, liked: false),
                        icon: Icon(Icons.close_rounded, color: colors.error),
                      ),
                      IconButton(
                        tooltip: l10n.actionLike,
                        onPressed: busy
                            ? null
                            : () => answer(person, liked: true),
                        icon: Icon(
                          Icons.favorite_rounded,
                          color: colors.magenta,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
