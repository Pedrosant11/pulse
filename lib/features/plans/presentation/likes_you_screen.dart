import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/errors/app_failure_message.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/models/app_mode.dart';
import 'package:pulse/core/utils/run_action.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/discover/data/discover_repository.dart';
import 'package:pulse/features/discover/domain/discover_models.dart';
import 'package:pulse/features/plans/domain/plan_models.dart';
import 'package:pulse/features/plans/presentation/plans_providers.dart';
import 'package:pulse/features/profile/presentation/widgets/profile_photo_image.dart';
import 'package:pulse/features/profile/presentation/widgets/user_profile_sheet.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'likes_you_screen.g.dart';

/// Answering a like from this screen (same swipe as Discover).
@riverpod
class LikesYouActions extends _$LikesYouActions {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// Returns whether it became a match.
  Future<bool?> answer(LikedYou like, {required bool liked}) =>
      runAction(ref, (s) => state = s, () async {
        final result = await ref
            .read(discoverRepositoryProvider)
            .swipe(
              targetId: like.userId,
              mode: like.mode,
              direction: liked ? SwipeDirection.like : SwipeDirection.pass,
            );
        ref
          ..invalidate(likesReceivedProvider)
          ..invalidate(likesReceivedCountProvider);
        return result.matched;
      });
}

/// Who liked you: the count for everyone, the people with Pulse Black.
class LikesYouScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final entitlements = ref.watch(entitlementsProvider);

    ref.listen(likesYouActionsProvider, (_, next) {
      if (next case AsyncError(:final error)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(friendlyErrorMessage(error, l10n))),
        );
      }
    });

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(l10n.likesYouTitle.toUpperCase())),
      body: SafeArea(
        child: AsyncValueView(
          value: entitlements,
          onRetry: () => ref.invalidate(entitlementsProvider),
          data: (me) => me.isBlack ? const _LikesGrid() : const _Locked(),
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
    final count = ref.watch(likesReceivedCountProvider).value ?? 0;

    return ListView(
      padding: EdgeInsets.all(spacing.md),
      children: [
        Text(
          count == 0 ? l10n.likesYouNoneYet : l10n.likesYouCount(count),
          style: context.textTheme.titleLarge,
        ),
        SizedBox(height: spacing.md),
        if (count > 0)
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: spacing.sm,
            crossAxisSpacing: spacing.sm,
            childAspectRatio: 3 / 4,
            children: [
              // Placeholders only: the app never receives who they are.
              for (var i = 0; i < count.clamp(0, 6); i++)
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: colors.blackGradient,
                    borderRadius: BorderRadius.circular(context.radii.md),
                  ),
                  child: Center(
                    child: Icon(Icons.lock_rounded, color: colors.textPrimary),
                  ),
                ),
            ],
          ),
        SizedBox(height: spacing.lg),
        NeonButton(
          label: l10n.likesYouUnlock,
          gradient: colors.blackGradient,
          onPressed: () =>
              context.push(AppRoutes.plansFor(PlanFeature.likedYou)),
        ),
      ],
    );
  }
}

class _LikesGrid extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final likes = ref.watch(likesReceivedProvider);
    final busy = ref.watch(likesYouActionsProvider).isLoading;

    Future<void> answer(LikedYou like, {required bool liked}) async {
      final matched = await ref
          .read(likesYouActionsProvider.notifier)
          .answer(like, liked: liked);
      if (matched == true && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.likesYouMatched(like.firstName)),
            action: SnackBarAction(
              label: l10n.likesYouOpenChats,
              onPressed: () => context.go(AppRoutes.chats),
            ),
          ),
        );
      }
    }

    return AsyncValueView(
      value: likes,
      onRetry: () => ref.invalidate(likesReceivedProvider),
      data: (likes) => likes.isEmpty
          ? EmptyView(
              icon: Icons.favorite_border_rounded,
              title: l10n.likesYouNoneYet,
            )
          : GridView.builder(
              padding: EdgeInsets.all(spacing.md),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: spacing.sm,
                crossAxisSpacing: spacing.sm,
                childAspectRatio: 3 / 4.4,
              ),
              itemCount: likes.length,
              itemBuilder: (context, index) => _LikeTile(
                like: likes[index],
                busy: busy,
                onAnswer: (liked) => answer(likes[index], liked: liked),
              ),
            ),
    );
  }
}

class _LikeTile extends StatelessWidget {
  const new({required this.like, required this.busy, required this.onAnswer});

  final LikedYou like;
  final bool busy;
  final ValueChanged<bool> onAnswer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final accent = colors.accentOf(like.mode);

    return ClipRRect(
      borderRadius: BorderRadius.circular(context.radii.md),
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () => showUserProfile(context, like.userId),
            child: like.photoPath == null
                ? ColoredBox(color: colors.surfaceElevated)
                : ProfilePhotoImage(like.photoPath!, decodeWidth: 200),
          ),
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, colors.background],
                  stops: const [0.45, 1],
                ),
              ),
            ),
          ),
          if (like.isSuper)
            Positioned(
              top: spacing.xs,
              right: spacing.xs,
              child: Icon(
                Icons.star_rounded,
                color: colors.lime,
                semanticLabel: l10n.superlikeLabel,
              ),
            ),
          Positioned(
            left: spacing.sm,
            right: spacing.sm,
            bottom: spacing.xs,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${like.firstName}, ${like.age}',
                  style: context.textTheme.titleMedium,
                ),
                Text(
                  like.mode == AppMode.date ? l10n.modeDate : l10n.modeCrew,
                  style: context.textTheme.labelSmall?.copyWith(color: accent),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      tooltip: l10n.actionPass,
                      onPressed: busy ? null : () => onAnswer(false),
                      icon: Icon(Icons.close_rounded, color: colors.error),
                    ),
                    IconButton(
                      tooltip: l10n.actionLike,
                      onPressed: busy ? null : () => onAnswer(true),
                      icon: Icon(Icons.favorite_rounded, color: accent),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
