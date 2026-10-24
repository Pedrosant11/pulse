import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/models/app_mode.dart';
import 'package:pulse/core/widgets/genre_chip.dart';
import 'package:pulse/core/widgets/text_with_badge.dart';
import 'package:pulse/features/badges/presentation/widgets/profile_badges.dart';
import 'package:pulse/features/discover/domain/discover_models.dart';
import 'package:pulse/features/discover/domain/music_match.dart';
import 'package:pulse/features/events/presentation/widgets/event_visuals.dart';
import 'package:pulse/features/profile/domain/profile_enums.dart';
import 'package:pulse/features/profile/presentation/profile_labels.dart';
import 'package:pulse/features/profile/presentation/widgets/profile_view.dart';

/// Hero tag shared by a discovery card photo and the full profile.
Object candidatePhotoHeroTag(String userId) => 'candidate-photo-$userId';

/// Discovery card content (SPEC 8.2): photos with side taps and indicators,
/// name, age and city, plus mode-specific details:
///   * Date: "Vocês vão" chip, what the person is looking for and the bio;
///   * Crew: the event is the star ("Procurando crew para…"), plus music
///     affinity (genres and favorite DJs).
class CandidateCard extends StatelessWidget {
  const new({
    required this.candidate,
    required this.mode,
    required this.accent,
    required this.onOpenProfile,
    this.myGenres = const {},
    this.myDjs = const [],
    super.key,
  });

  final DiscoverCandidate candidate;
  final AppMode mode;

  /// The user's genres: fallback cards show the ones in common.
  final Set<MusicGenre> myGenres;

  /// The user's favorite DJs (music match).
  final List<String> myDjs;
  final Color accent;
  final VoidCallback onOpenProfile;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final c = candidate;
    final firstEvent = c.commonEvents.firstOrNull;
    final distance = c.distanceKm;
    final isCrew = mode == AppMode.crew;
    final bio = c.bio;
    final intent = c.dateLookingFor;
    final shared = [
      for (final genre in c.musicGenres)
        if (myGenres.contains(genre)) genre,
    ];
    // Fallback ("mesma vibe") cards explain why they're shown.
    final vibeChip = c.isFallback && shared.isNotEmpty
        ? Padding(
            padding: EdgeInsets.only(bottom: spacing.sm),
            child: _EventChip(
              accent: accent,
              text: l10n.discoverSharedGenres(
                shared.take(3).map(l10n.genre).join(' · '),
              ),
            ),
          )
        : null;

    // They superliked the viewer (shown first in the deck).
    final superChip = c.superLikedMe
        ? Padding(
            padding: EdgeInsets.only(bottom: spacing.sm),
            child: _EventChip(
              accent: colors.lime,
              text: l10n.discoverSuperLikedYou,
            ),
          )
        : null;

    final match = musicMatch(
      myGenres: myGenres,
      myDjs: myDjs,
      theirGenres: c.musicGenres,
      theirDjs: c.favoriteDjs,
    );
    final matchRow = match == null || match == 0
        ? null
        : Padding(
            padding: EdgeInsets.only(top: spacing.xxs),
            child: Row(
              children: [
                Icon(Icons.graphic_eq_rounded, size: 16, color: accent),
                SizedBox(width: spacing.xxs),
                Text(
                  l10n.discoverMusicMatch(match),
                  style: context.textTheme.labelMedium?.copyWith(color: accent),
                ),
              ],
            ),
          );

    final location = Text(
      [
        if (c.city != null) c.city!,
        if (distance != null) l10n.discoverDistance(distance.round()),
      ].join(' · '),
      style: context.textTheme.bodyMedium,
    );

    final nameRow = Row(
      children: [
        Expanded(
          child: TextWithBadge(
            l10n.profileNameAge(c.firstName, c.age),
            style: context.textTheme.headlineMedium,
            badge: c.isVerified
                ? Icon(
                    Icons.verified,
                    color: colors.lime,
                    semanticLabel: l10n.profileVerified,
                  )
                : null,
          ),
        ),
        Icon(Icons.keyboard_arrow_up, color: accent),
      ],
    );

    // DJ, Equipe Pulse, Figura pública, Produtor (SPEC 6.4).
    final badges = Padding(
      padding: EdgeInsets.only(top: spacing.xxs),
      child: ProfileBadges(userId: c.id, max: 2, dense: true),
    );

    final crewSize = c.crewSize;
    final details = isCrew
        ? <Widget>[
            ?superChip,
            ?vibeChip,
            nameRow,
            badges,
            location,
            ?matchRow,
            // Going solo or already with a crew for that event (SPEC 9.2).
            if (!c.isFallback)
              Padding(
                padding: EdgeInsets.only(top: spacing.xxs),
                child: Row(
                  children: [
                    Icon(
                      crewSize == null
                          ? Icons.person_outline
                          : Icons.groups_rounded,
                      size: 16,
                      color: accent,
                    ),
                    SizedBox(width: spacing.xxs),
                    Text(
                      crewSize == null
                          ? l10n.crewSolo
                          : l10n.crewHasCrew(crewSize),
                      style: context.textTheme.labelMedium?.copyWith(
                        color: accent,
                      ),
                    ),
                  ],
                ),
              ),
            if (c.musicGenres.isNotEmpty) ...[
              SizedBox(height: spacing.sm),
              Wrap(
                spacing: spacing.xxs,
                runSpacing: spacing.xxs,
                children: [
                  for (final genre in c.musicGenres.take(3))
                    GenreChip(
                      label: l10n.genre(genre),
                      selected: true,
                      accent: accent,
                    ),
                ],
              ),
            ],
            if (c.favoriteDjs.isNotEmpty) ...[
              SizedBox(height: spacing.xs),
              Text(
                l10n.discoverDjs(c.favoriteDjs.take(3).join(', ')),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodySmall?.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ],
          ]
        : <Widget>[
            ?superChip,
            ?vibeChip,
            if (firstEvent != null)
              Padding(
                padding: EdgeInsets.only(bottom: spacing.sm),
                child: _EventChip(
                  accent: accent,
                  text: c.commonEventCount > 1
                      ? l10n.discoverGoingToMore(
                          firstEvent.name,
                          c.commonEventCount - 1,
                        )
                      : l10n.discoverGoingTo(firstEvent.name),
                ),
              ),
            nameRow,
            badges,
            location,
            ?matchRow,
            if (intent != null)
              Text(
                l10n.discoverLookingFor(l10n.dateIntent(intent)),
                style: context.textTheme.labelMedium?.copyWith(color: accent),
              ),
            if (bio != null) ...[
              SizedBox(height: spacing.xs),
              Text(
                bio,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodySmall?.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ],
          ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(context.radii.xl),
      child: Stack(
        fit: StackFit.expand,
        children: [
          PhotoCarousel(photos: c.photos, heroTag: candidatePhotoHeroTag(c.id)),
          // Crew: the event is the main information, at the top.
          if (isCrew && firstEvent != null)
            Positioned(
              left: spacing.md,
              right: spacing.md,
              top: spacing.xl,
              child: IgnorePointer(
                child: _CrewEventBanner(
                  accent: accent,
                  title: c.commonEventCount > 1
                      ? l10n.discoverCrewForMore(
                          firstEvent.name,
                          c.commonEventCount - 1,
                        )
                      : l10n.discoverCrewFor(firstEvent.name),
                  date: formatEventDate(context, firstEvent.startsAt),
                ),
              ),
            ),
          // Info over a bottom gradient; tapping it opens the full profile.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Semantics(
              button: true,
              label: l10n.actionOpenProfile,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onOpenProfile,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colors.background.withValues(alpha: 0),
                        colors.background.withValues(alpha: 0.92),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      spacing.md,
                      spacing.xxl,
                      spacing.md,
                      spacing.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: details,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventChip extends StatelessWidget {
  const new({required this.accent, required this.text});

  final Color accent;
  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.2),
        border: Border.all(color: accent),
        borderRadius: BorderRadius.circular(context.radii.pill),
        boxShadow: [
          BoxShadow(color: accent.withValues(alpha: 0.4), blurRadius: 12),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Text(
          text,
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _CrewEventBanner extends StatelessWidget {
  const new({required this.accent, required this.title, required this.date});

  final Color accent;
  final String title;
  final String date;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background.withValues(alpha: 0.78),
        border: Border.all(color: accent, width: 1.5),
        borderRadius: BorderRadius.circular(context.radii.md),
        boxShadow: [
          BoxShadow(color: accent.withValues(alpha: 0.45), blurRadius: 18),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(context.spacing.sm),
        child: Row(
          children: [
            Icon(Icons.groups_rounded, color: accent, size: 28),
            SizedBox(width: context.spacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.titleMedium,
                  ),
                  Text(
                    date,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: accent,
                    ),
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

/// Date / Crew selector with an animated pill; each mode has its accent
/// (SPEC 8.2: Date magenta, Crew cyan).
class ModeSelector extends StatelessWidget {
  const new({required this.selected, required this.onChanged, super.key});

  final AppMode selected;
  final ValueChanged<AppMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final radius = BorderRadius.circular(context.radii.pill);
    final duration = context.reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 280);

    return Container(
      height: 44,
      width: 220,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: radius,
        border: Border.all(color: colors.glassBorder),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: duration,
            curve: Curves.easeOutCubic,
            alignment: selected == AppMode.date
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 1,
              child: AnimatedContainer(
                duration: duration,
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  gradient: colors.gradientOf(selected),
                  borderRadius: radius,
                  boxShadow: [
                    BoxShadow(
                      color: colors.accentOf(selected).withValues(alpha: 0.45),
                      blurRadius: 14,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              for (final mode in AppMode.values)
                Expanded(
                  child: Semantics(
                    button: true,
                    selected: mode == selected,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onChanged(mode),
                      child: Center(
                        child: Text(
                          (mode == AppMode.date ? l10n.modeDate : l10n.modeCrew)
                              .toUpperCase(),
                          style: context.textTheme.labelLarge?.copyWith(
                            color: mode == selected
                                ? colors.textPrimary
                                : colors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Round action button (pass / undo / like).
class RoundAction extends StatelessWidget {
  const new({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
    this.size = 64,
    super.key,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final colors = context.colors;
    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        enabled: enabled,
        label: label,
        excludeSemantics: true,
        child: Material(
          color: colors.surface,
          shape: CircleBorder(
            side: BorderSide(
              color: enabled ? color : colors.glassBorder,
              width: 1.5,
            ),
          ),
          elevation: enabled ? 6 : 0,
          shadowColor: color.withValues(alpha: 0.6),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: SizedBox.square(
              dimension: size,
              child: Icon(
                icon,
                size: size * 0.45,
                color: enabled ? color : colors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
