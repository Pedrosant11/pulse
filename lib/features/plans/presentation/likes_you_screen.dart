import 'dart:async';

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
import 'package:pulse/features/discover/presentation/widgets/discover_widgets.dart';
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

  /// Returns the swipe result (match and its conversation), or null when it
  /// failed.
  Future<SwipeResult?> answer(LikedYou like, {required bool liked}) =>
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
        return result;
      });
}

/// Who liked you: the count for everyone, the people with Pulse Black.
class LikesYouScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<LikesYouScreen> createState() => _LikesYouScreenState();
}

class _LikesYouScreenState extends ConsumerState<LikesYouScreen> {
  @override
  void initState() {
    super.initState();
    // The badge count may be older than this list; both refresh on open.
    unawaited(
      Future.microtask(() {
        if (mounted) ref.invalidate(likesReceivedCountProvider);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
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

/// Without Black: how many, never who (the app doesn't receive them).
class _Locked extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final count = ref.watch(likesReceivedCountProvider).value ?? 0;

    return ListView(
      padding: EdgeInsets.all(spacing.lg),
      children: [
        SizedBox(height: spacing.md),
        _GhostStack(count: count),
        SizedBox(height: spacing.lg),
        Text(
          count == 0 ? l10n.likesYouNoneYetTitle : l10n.likesYouCount(count),
          textAlign: TextAlign.center,
          style: context.textTheme.headlineSmall,
        ),
        SizedBox(height: spacing.sm),
        Text(
          count == 0 ? l10n.likesYouNoneYet : l10n.likesYouLockedBody,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium?.copyWith(
            color: colors.textSecondary,
          ),
        ),
        SizedBox(height: spacing.xl),
        NeonButton(
          label: l10n.likesYouUnlock,
          icon: Icons.workspace_premium_rounded,
          gradient: colors.blackGradient,
          onPressed: () =>
              context.push(AppRoutes.plansFor(PlanFeature.likedYou)),
        ),
      ],
    );
  }
}

/// Overlapping "mystery" avatars with the count on top.
class _GhostStack extends StatelessWidget {
  const new({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    const size = 88.0;
    final ghosts = count.clamp(1, 3);
    final gradients = [
      colors.primaryGradient,
      colors.crewGradient,
      colors.blackGradient,
    ];

    return SizedBox(
      height: size + spacing.md,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (var i = 0; i < ghosts; i++)
            Transform.translate(
              offset: Offset((i - (ghosts - 1) / 2) * size * 0.62, 0),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: gradients[i],
                  border: Border.all(color: colors.background, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: gradients[i].colors.last.withValues(alpha: 0.4),
                      blurRadius: 24,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.question_mark_rounded,
                  size: 36,
                  color: colors.textPrimary.withValues(alpha: 0.85),
                ),
              ),
            ),
          if (count > 0)
            Positioned(
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.sm,
                  vertical: spacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: colors.magenta,
                  borderRadius: BorderRadius.circular(context.radii.pill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite_rounded,
                      size: 14,
                      color: colors.textPrimary,
                    ),
                    SizedBox(width: spacing.xxs),
                    Text('$count', style: context.textTheme.labelLarge),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LikesGrid extends ConsumerStatefulWidget {
  const new();

  @override
  ConsumerState<_LikesGrid> createState() => _LikesGridState();
}

class _LikesGridState extends ConsumerState<_LikesGrid> {
  /// null = everyone.
  AppMode? _filter;

  Future<void> _answer(LikedYou like, {required bool liked}) async {
    final l10n = context.l10n;
    final result = await ref
        .read(likesYouActionsProvider.notifier)
        .answer(like, liked: liked);
    if (result == null || !result.matched || !mounted) return;
    final router = GoRouter.maybeOf(context);
    final conversationId = result.conversationId;
    // A newer match replaces the previous notice instead of queueing, and
    // it leaves by itself (snackbars with an action persist by default).
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          persist: false,
          duration: const Duration(seconds: 5),
          content: Text(l10n.likesYouMatched(like.firstName)),
          action: SnackBarAction(
            label: l10n.likesYouOpenChat,
            onPressed: () => conversationId == null
                ? router?.go(AppRoutes.chats)
                : router?.push(AppRoutes.conversation(conversationId)),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final likes = ref.watch(likesReceivedProvider);
    final busy = ref.watch(likesYouActionsProvider).isLoading;

    return AsyncValueView(
      value: likes,
      onRetry: () => ref.invalidate(likesReceivedProvider),
      data: (all) {
        if (all.isEmpty) {
          return EmptyView(
            icon: Icons.favorite_border_rounded,
            title: l10n.likesYouNoneYetTitle,
            message: l10n.likesYouNoneYet,
          );
        }
        final shown = [
          for (final like in all)
            if (_filter == null || like.mode == _filter) like,
        ];
        final hasBoth =
            all.any((l) => l.mode == AppMode.date) &&
            all.any((l) => l.mode == AppMode.crew);

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                spacing.md,
                spacing.sm,
                spacing.md,
                spacing.md,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.likesYouCount(all.length),
                      style: context.textTheme.headlineSmall,
                    ),
                    SizedBox(height: spacing.xxs),
                    Text(l10n.likesYouHint, style: context.textTheme.bodySmall),
                    if (hasBoth) ...[
                      SizedBox(height: spacing.sm),
                      Wrap(
                        spacing: spacing.xs,
                        children: [
                          for (final (mode, label) in [
                            (null, l10n.likesYouAll),
                            (AppMode.date, l10n.modeDate),
                            (AppMode.crew, l10n.modeCrew),
                          ])
                            ChoiceChip(
                              label: Text(label),
                              selected: _filter == mode,
                              onSelected: (_) => setState(() => _filter = mode),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                spacing.md,
                0,
                spacing.md,
                spacing.xl,
              ),
              sliver: SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: spacing.md,
                  crossAxisSpacing: spacing.md,
                  childAspectRatio: 0.58,
                ),
                itemCount: shown.length,
                itemBuilder: (context, index) => _LikeTile(
                  like: shown[index],
                  busy: busy,
                  onAnswer: (liked) => _answer(shown[index], liked: liked),
                ),
              ),
            ),
          ],
        );
      },
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
    final outer = context.radii.lg;
    final accent = colors.accentOf(like.mode);
    final gradient = like.isSuper
        ? colors.blackGradient
        : colors.gradientOf(like.mode);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Container(
            // Gradient ring in the mode's colors (Black's for superlikes).
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(outer),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(outer - 2),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Semantics(
                    button: true,
                    label: l10n.requesterViewProfile,
                    child: GestureDetector(
                      onTap: () => showUserProfile(context, like.userId),
                      child: like.photoPath == null
                          ? ColoredBox(color: colors.surfaceElevated)
                          : ProfilePhotoImage(
                              like.photoPath!,
                              decodeWidth: 220,
                            ),
                    ),
                  ),
                  IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            colors.background.withValues(alpha: 0.92),
                          ],
                          stops: const [0.5, 1],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: spacing.sm,
                    left: spacing.sm,
                    child: _Pill(
                      color: accent,
                      text: like.mode == AppMode.date
                          ? l10n.modeDate
                          : l10n.modeCrew,
                    ),
                  ),
                  if (like.isSuper)
                    Positioned(
                      top: spacing.sm,
                      right: spacing.sm,
                      child: _Pill(
                        color: colors.lime,
                        icon: Icons.star_rounded,
                        text: l10n.superlikeLabel,
                      ),
                    ),
                  Positioned(
                    left: spacing.sm,
                    right: spacing.sm,
                    bottom: spacing.sm,
                    child: IgnorePointer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.profileNameAge(like.firstName, like.age),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.titleLarge,
                          ),
                          if (like.city case final city?)
                            Text(
                              city,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.bodySmall,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: spacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RoundAction(
              icon: Icons.close_rounded,
              label: l10n.actionPass,
              color: colors.error,
              size: 48,
              onPressed: busy ? null : () => onAnswer(false),
            ),
            RoundAction(
              icon: like.mode == AppMode.date
                  ? Icons.favorite_rounded
                  : Icons.bolt_rounded,
              label: l10n.actionLike,
              color: accent,
              size: 48,
              onPressed: busy ? null : () => onAnswer(true),
            ),
          ],
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const new({required this.color, required this.text, this.icon});

  final Color color;
  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.xs,
        vertical: spacing.xxs,
      ),
      decoration: BoxDecoration(
        color: context.colors.background.withValues(alpha: 0.7),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(context.radii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            SizedBox(width: spacing.xxs),
          ],
          Text(
            text,
            style: context.textTheme.labelSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
