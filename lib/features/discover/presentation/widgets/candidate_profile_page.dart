import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/features/discover/domain/discover_models.dart';
import 'package:pulse/features/discover/presentation/widgets/discover_widgets.dart';
import 'package:pulse/features/events/presentation/widgets/event_visuals.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/features/profile/presentation/widgets/profile_view.dart';
import 'package:pulse/features/safety/presentation/safety_actions.dart';

/// Full profile of a discovery card (SPEC 8.2), as a page over the tabs so
/// the card photo flies into it (Hero). Returns the decision taken from the
/// page's buttons, if any.
Future<SwipeDirection?> showCandidateProfile(
  BuildContext context, {
  required DiscoverCandidate candidate,
  required Color accent,
  VoidCallback? onBlocked,
}) {
  final duration = context.reduceMotion
      ? Duration.zero
      : const Duration(milliseconds: 350);
  return Navigator.of(context, rootNavigator: true).push(
    PageRouteBuilder<SwipeDirection>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (_, _, _) => _CandidateProfilePage(
        candidate: candidate,
        accent: accent,
        onBlocked: onBlocked,
      ),
      transitionsBuilder: (_, animation, _, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      ),
    ),
  );
}

class _CandidateProfilePage extends ConsumerWidget {
  const new({required this.candidate, required this.accent, this.onBlocked});

  final DiscoverCandidate candidate;
  final Color accent;
  final VoidCallback? onBlocked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    // The card's data first; the full profile replaces it when loaded.
    final profile =
        ref.watch(publicProfileProvider(candidate.id)).value ??
        candidate.previewProfile;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.fromLTRB(spacing.md, 56, spacing.md, 120),
              children: [
                ProfileView(
                  profile: profile,
                  photos: candidate.photos,
                  photoHeroTag: candidatePhotoHeroTag(candidate.id),
                ),
                if (candidate.commonEvents.isNotEmpty) ...[
                  SizedBox(height: spacing.lg),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final event in candidate.commonEvents)
                          Padding(
                            padding: EdgeInsets.only(bottom: spacing.xs),
                            child: Row(
                              children: [
                                Icon(Icons.bolt, color: accent, size: 18),
                                SizedBox(width: spacing.xs),
                                Expanded(
                                  child: Text(
                                    [
                                      event.name,
                                      formatEventDate(context, event.startsAt),
                                    ].join(' · '),
                                    style: context.textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            Positioned(
              top: spacing.xs,
              left: spacing.xs,
              right: spacing.xs,
              child: Row(
                children: [
                  const CloseButton(),
                  const Spacer(),
                  UserSafetyMenu(
                    userId: candidate.id,
                    name: candidate.firstName,
                    onBlocked: () {
                      onBlocked?.call();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: spacing.md,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundAction(
                    icon: Icons.close_rounded,
                    label: l10n.actionPass,
                    color: context.colors.error,
                    onPressed: () =>
                        Navigator.pop(context, SwipeDirection.pass),
                  ),
                  SizedBox(width: spacing.xl),
                  RoundAction(
                    icon: Icons.favorite_rounded,
                    label: l10n.actionLike,
                    color: accent,
                    onPressed: () =>
                        Navigator.pop(context, SwipeDirection.like),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
