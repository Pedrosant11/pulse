import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/errors/app_failure.dart';
import 'package:pulse/core/errors/app_failure_message.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/models/app_mode.dart';
import 'package:pulse/core/widgets/shader_effects.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/discover/domain/discover_models.dart';
import 'package:pulse/features/discover/presentation/discover_providers.dart';
import 'package:pulse/features/discover/presentation/widgets/candidate_profile_page.dart';
import 'package:pulse/features/discover/presentation/widgets/discover_widgets.dart';
import 'package:pulse/features/discover/presentation/widgets/swipe_card.dart';
import 'package:pulse/features/onboarding/presentation/activate_modes_screen.dart';
import 'package:pulse/features/plans/domain/plan_models.dart';
import 'package:pulse/features/plans/presentation/plans_providers.dart';
import 'package:pulse/features/plans/presentation/widgets/plans_prompt.dart';
import 'package:pulse/features/plans/presentation/widgets/travel_sheet.dart';
import 'package:pulse/features/profile/domain/profile_enums.dart';
import 'package:pulse/features/profile/presentation/edit_profile_screen.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';

/// Discover tab (SPEC 8): mode selector, swipeable cards, actions.
class DiscoverScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final _card = SwipeCardController();
  final _precached = <String>{};

  /// The next like comes from the superlike button.
  bool _pendingSuper = false;

  static const _preloadCount = 3;

  /// Warms the image cache for the next cards (SPEC 8.2).
  void _precacheNext(List<DiscoverCandidate> cards) {
    for (final candidate in cards.take(_preloadCount + 1)) {
      final path = candidate.photoPaths.firstOrNull;
      if (path == null || !_precached.add(path)) continue;
      unawaited(
        ref
            .read(photoUrlProvider(path).future)
            .then((url) async {
              if (!mounted) return;
              await precacheImage(
                CachedNetworkImageProvider(url, cacheKey: path),
                context,
              );
            })
            .catchError((_) {}),
      );
    }
  }

  Future<void> _onSwiped(
    AppMode mode,
    DiscoverCandidate candidate,
    SwipeDirection direction,
  ) async {
    final superLike = _pendingSuper && direction == SwipeDirection.like;
    _pendingSuper = false;
    if (direction == SwipeDirection.like) {
      unawaited(HapticFeedback.lightImpact());
    }
    final result = await ref
        .read(discoverDeckProvider(mode).notifier)
        .swipe(candidate, direction, superLike: superLike);
    if (result == null || !result.matched || !mounted) return;
    unawaited(HapticFeedback.heavyImpact());
    unawaited(
      context.push(
        AppRoutes.match,
        extra: MatchArgs(
          other: candidate,
          mode: mode,
          conversationId: result.conversationId,
        ),
      ),
    );
  }

  Future<void> _openProfile(
    AppMode mode,
    DiscoverCandidate candidate,
    Color accent,
  ) async {
    final decision = await showCandidateProfile(
      context,
      candidate: candidate,
      accent: accent,
      onBlocked: () =>
          ref.read(discoverDeckProvider(mode).notifier).remove(candidate.id),
    );
    if (decision != null) await _card.swipe(decision);
  }

  void _superLike(Entitlements? me) {
    if ((me?.superlikesLeft ?? 0) == 0) {
      unawaited(showPlansPrompt(context, PlanFeature.superlikes));
      return;
    }
    _pendingSuper = true;
    unawaited(_card.swipe(SwipeDirection.like));
  }

  Future<void> _boost(Entitlements? me) async {
    final l10n = context.l10n;
    if (me == null) return;
    final endsAt = me.boostEndsAt;
    if (me.boostRunning(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.boostRunningUntil(DateFormat.Hm().format(endsAt!.toLocal())),
          ),
        ),
      );
      return;
    }
    if (me.boostsLeft == 0) {
      await showPlansPrompt(context, PlanFeature.boost);
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.rocket_launch_rounded, color: context.colors.lime),
        title: Text(l10n.boostConfirmTitle),
        content: Text(l10n.boostConfirmBody(me.boostsLeft)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.notNow),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.boostActivate),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final ends = await ref.read(planActionsProvider.notifier).activateBoost();
    if (ends != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.boostRunningUntil(DateFormat.Hm().format(ends))),
        ),
      );
    }
  }

  Future<void> _undo(AppMode mode, Entitlements? me) async {
    if (!(me?.canRewind ?? false)) {
      await showPlansPrompt(context, PlanFeature.rewind);
      return;
    }
    final undone = await ref.read(discoverDeckProvider(mode).notifier).undo();
    if (!undone && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.undoNothing)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    // "Events only": an invite instead of the deck (checked on the loaded
    // profile, so it doesn't flash while loading).
    final me = ref.watch(myProfileProvider).value;
    if (me != null && me.modes.isEmpty) {
      return Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: EmptyView(
            icon: Icons.nightlife_rounded,
            title: l10n.discoverEventsOnlyTitle,
            message: l10n.discoverEventsOnlyBody,
            actionLabel: l10n.discoverEventsOnlyAction,
            onAction: () => openEnableModes(context, me),
          ),
        ),
      );
    }

    final mode = ref.watch(discoverModeProvider);
    final enabled = ref.watch(enabledModesProvider);
    final accent = colors.accentOf(mode);
    final modeOn = enabled.contains(mode);
    final deck = modeOn ? ref.watch(discoverDeckProvider(mode)) : null;
    final cards = deck?.value?.cards ?? const <DiscoverCandidate>[];

    final plan = ref.watch(entitlementsProvider).value;

    ref.listen(discoverDeckProvider(mode), (_, next) {
      final error = next.value?.error;
      if (error == null) return;
      ref.read(discoverDeckProvider(mode).notifier).clearError();
      // Plan limits open the plans prompt instead of an error.
      final feature = switch (AppFailure.from(error)) {
        LikeLimitFailure() => PlanFeature.likes,
        SuperlikeLimitFailure() => PlanFeature.superlikes,
        PlanRequiredFailure() => PlanFeature.rewind,
        _ => null,
      };
      if (feature != null) {
        unawaited(showPlansPrompt(context, feature));
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(friendlyErrorMessage(error, l10n))),
      );
    });
    ref.listen(planActionsProvider, (_, next) {
      if (next case AsyncError(:final error)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(friendlyErrorMessage(error, l10n))),
        );
      }
    });
    if (cards.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _precacheNext(cards));
    }

    Widget content;
    if (!modeOn) {
      final modeName = mode == AppMode.date ? l10n.modeDate : l10n.modeCrew;
      content = EmptyView(
        icon: Icons.toggle_off_outlined,
        title: l10n.discoverModeOff(modeName),
        actionLabel: l10n.discoverEnableMode,
        onAction: () => context.push(
          AppRoutes.editProfileSection(ProfileSection.modes.name),
        ),
      );
    } else {
      content = deck!.when(
        loading: () => Padding(
          padding: EdgeInsets.all(spacing.md),
          child: ShimmerBox(height: double.infinity, radius: context.radii.xl),
        ),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(discoverDeckProvider(mode)),
        ),
        data: (state) => state.cards.isEmpty
            ? _EmptyDeck(
                mode: mode,
                onRetry: () => ref.invalidate(discoverDeckProvider(mode)),
              )
            : _CardStack(
                myGenres: {...?ref.watch(myProfileProvider).value?.musicGenres},
                state: state,
                mode: mode,
                accent: accent,
                controller: _card,
                onSwiped: (candidate, direction) =>
                    _onSwiped(mode, candidate, direction),
                onOpenProfile: (candidate) =>
                    _openProfile(mode, candidate, accent),
              ),
      );
    }

    final top = cards.firstOrNull;
    final canUndo = deck?.value?.lastSwiped != null;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(height: spacing.sm),
            Row(
              children: [
                SizedBox(width: spacing.xs),
                IconButton(
                  tooltip: l10n.travelTitle,
                  onPressed: plan == null
                      ? null
                      : () => showTravelSheet(context, plan),
                  icon: Icon(
                    Icons.flight_takeoff_rounded,
                    color: (plan?.isTraveling ?? false)
                        ? colors.lime
                        : colors.textSecondary,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ModeSelector(
                      selected: mode,
                      onChanged: ref.read(discoverModeProvider.notifier).select,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: l10n.boostTitle,
                  onPressed: plan == null ? null : () => _boost(plan),
                  icon: Icon(
                    Icons.rocket_launch_rounded,
                    color: (plan?.boostRunning(DateTime.now()) ?? false)
                        ? colors.lime
                        : colors.textSecondary,
                  ),
                ),
                SizedBox(width: spacing.xs),
              ],
            ),
            if (plan?.isTraveling ?? false)
              Text(
                l10n.travelBanner('${plan!.travelCity}, ${plan.travelState}'),
                style: context.textTheme.labelSmall?.copyWith(
                  color: colors.lime,
                ),
              ),
            SizedBox(height: spacing.sm),
            Expanded(
              // Switching Date/Crew glitches the deck (SPEC 12).
              child: GlitchTransition(
                trigger: mode,
                colors: (colors.magenta, colors.cyan),
                child: AnimatedSwitcher(
                  duration: context.reduceMotion
                      ? Duration.zero
                      : const Duration(milliseconds: 250),
                  child: KeyedSubtree(key: ValueKey(mode), child: content),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: spacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundAction(
                    icon: Icons.close_rounded,
                    label: l10n.actionPass,
                    color: colors.error,
                    onPressed: top == null
                        ? null
                        : () => _card.swipe(SwipeDirection.pass),
                  ),
                  SizedBox(width: spacing.md),
                  RoundAction(
                    // Locked without a plan: tapping explains the plans.
                    icon: (plan?.canRewind ?? true)
                        ? Icons.replay_rounded
                        : Icons.lock_rounded,
                    label: l10n.actionUndo,
                    color: colors.lime,
                    size: 48,
                    onPressed: canUndo || !(plan?.canRewind ?? true)
                        ? () => _undo(mode, plan)
                        : null,
                  ),
                  // Superlikes are for Date (Crew is about friendship).
                  if (mode == AppMode.date) ...[
                    SizedBox(width: spacing.md),
                    Badge(
                      isLabelVisible: (plan?.superlikesLeft ?? 0) > 0,
                      label: Text('${plan?.superlikesLeft ?? 0}'),
                      backgroundColor: colors.lime,
                      textColor: colors.background,
                      child: RoundAction(
                        icon: Icons.star_rounded,
                        label: l10n.superlikeLabel,
                        color: colors.lime,
                        size: 48,
                        onPressed: top == null ? null : () => _superLike(plan),
                      ),
                    ),
                  ],
                  SizedBox(width: spacing.md),
                  RoundAction(
                    icon: mode == AppMode.date
                        ? Icons.favorite_rounded
                        : Icons.bolt_rounded,
                    label: l10n.actionLike,
                    color: accent,
                    onPressed: top == null
                        ? null
                        : () => _card.swipe(SwipeDirection.like),
                  ),
                ],
              ),
            ),
            // Room for the floating bottom navigation.
            SizedBox(height: MediaQuery.paddingOf(context).bottom),
          ],
        ),
      ),
    );
  }
}

class _CardStack extends StatelessWidget {
  const new({
    required this.state,
    required this.mode,
    required this.accent,
    required this.controller,
    required this.myGenres,
    required this.onSwiped,
    required this.onOpenProfile,
  });

  final DeckState state;
  final AppMode mode;
  final Color accent;
  final SwipeCardController controller;
  final Set<MusicGenre> myGenres;
  final void Function(DiscoverCandidate, SwipeDirection) onSwiped;
  final ValueChanged<DiscoverCandidate> onOpenProfile;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final cards = state.cards;
    final top = cards.first;
    final next = cards.length > 1 ? cards[1] : null;

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.md),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (next != null)
                  // The next card waits slightly smaller behind.
                  Transform.scale(
                    scale: 0.95,
                    child: IgnorePointer(
                      child: CandidateCard(
                        candidate: next,
                        mode: mode,
                        myGenres: myGenres,
                        accent: accent,
                        onOpenProfile: () {},
                      ),
                    ),
                  ),
                Semantics(
                  customSemanticsActions: {
                    CustomSemanticsAction(label: l10n.actionLike): () =>
                        controller.swipe(SwipeDirection.like),
                    CustomSemanticsAction(label: l10n.actionPass): () =>
                        controller.swipe(SwipeDirection.pass),
                    CustomSemanticsAction(label: l10n.actionOpenProfile): () =>
                        onOpenProfile(top),
                  },
                  child: SwipeCard(
                    key: ValueKey(top.id),
                    controller: controller,
                    likeStamp: mode == AppMode.date
                        ? l10n.stampLike
                        : l10n.stampCrewLike,
                    passStamp: l10n.stampPass,
                    likeColor: accent,
                    onSwiped: (direction) => onSwiped(top, direction),
                    onOpenProfile: () => onOpenProfile(top),
                    child: CandidateCard(
                      candidate: top,
                      mode: mode,
                      myGenres: myGenres,
                      accent: accent,
                      onOpenProfile: () => onOpenProfile(top),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyDeck extends ConsumerWidget {
  const new({required this.mode, required this.onRetry});

  final AppMode mode;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    // Date also shows people nearby, so events are only a suggestion there.
    if (mode == AppMode.date) {
      final view = EmptyView(
        icon: Icons.favorite_border_rounded,
        title: l10n.discoverDateEmptyTitle,
        message: l10n.discoverDateEmptyBody,
        actionLabel: l10n.discoverGoToEvents,
        onAction: () => context.go(AppRoutes.events),
      );
      return context.reduceMotion
          ? view
          : view.animate().fadeIn(duration: 300.ms);
    }
    final attending = ref.watch(myAttendingEventsProvider).value;
    // Crew is only people from the same parties (SPEC 8.1).
    if (attending != null && attending.isEmpty) {
      return EmptyView(
        icon: Icons.event_available_outlined,
        title: l10n.discoverNoEventsTitle,
        message: l10n.discoverNoEventsBody,
        actionLabel: l10n.discoverGoToEvents,
        onAction: () => context.go(AppRoutes.events),
      );
    }
    final view = EmptyView(
      icon: Icons.nightlife_outlined,
      title: l10n.discoverEmptyTitle,
      message: l10n.discoverEmptyBody,
      actionLabel: l10n.stateRetry,
      onAction: onRetry,
    );
    return context.reduceMotion
        ? view
        : view.animate().fadeIn(duration: 300.ms);
  }
}
