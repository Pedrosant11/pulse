import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/models/app_mode.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/features/crews/domain/crew_models.dart';
import 'package:pulse/features/events/presentation/widgets/event_visuals.dart';
import 'package:pulse/features/profile/presentation/widgets/profile_photo_image.dart';

/// Overlapping member avatars.
class AvatarStack extends StatelessWidget {
  const new({required this.photos, this.size = 32, super.key});

  final List<String> photos;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final overlap = size * 0.65;
    return SizedBox(
      width: photos.isEmpty ? 0 : overlap * (photos.length - 1) + size,
      height: size,
      child: Stack(
        children: [
          for (var i = 0; i < photos.length; i++)
            Positioned(
              left: overlap * i,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.background, width: 2),
                ),
                child: ClipOval(
                  child: ProfilePhotoImage(photos[i], decodeWidth: size),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// A crew in the event's "Crews deste evento" list (SPEC 7.3 / 9.2).
class CrewCard extends StatelessWidget {
  const new({required this.crew, required this.onTap, super.key});

  final CrewSummary crew;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final accent = colors.accentOf(AppMode.crew);
    final status = crew.myStatus;
    final description = crew.description;
    final owner = crew.ownerFirstName;

    final (String? pillText, Color? pillColor) = switch (status) {
      CrewRelation.owner => (l10n.crewOwner, colors.lime),
      CrewRelation.member => (l10n.attendingButton, accent),
      CrewRelation.requested => (l10n.crewRequested, colors.textSecondary),
      CrewRelation.invited => (l10n.crewAcceptInvite, colors.magenta),
      null =>
        crew.isFull ? (l10n.crewFull, colors.textSecondary) : (null, null),
    };

    return GlassCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      crew.name,
                      style: context.textTheme.titleMedium,
                    ),
                  ),
                  if (pillText != null && pillColor != null)
                    StatusPill(label: pillText, color: pillColor),
                ],
              ),
              if (owner != null)
                Text(
                  l10n.crewByOwner(owner),
                  style: context.textTheme.bodySmall,
                ),
              if (description != null) ...[
                SizedBox(height: spacing.xs),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMedium,
                ),
              ],
              SizedBox(height: spacing.sm),
              Row(
                children: [
                  AvatarStack(photos: crew.memberPhotos),
                  SizedBox(width: spacing.sm),
                  Text(
                    l10n.crewMembersCount(crew.memberCount, crew.maxMembers),
                    style: context.textTheme.labelMedium?.copyWith(
                      color: accent,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    [
                      if (crew.isOpen) l10n.crewOpen else l10n.crewInviteOnly,
                      if (crew.sameGenderOnly) l10n.crewSameGenderLabel,
                    ].join(' · '),
                    style: context.textTheme.labelSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
