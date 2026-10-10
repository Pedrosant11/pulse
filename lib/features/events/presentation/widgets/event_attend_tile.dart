import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/profile/presentation/profile_labels.dart';

/// Compact event card with the date highlighted and an optional
/// "Eu vou" toggle. Phase 4 adds covers and attendee counts.
class EventAttendTile extends StatelessWidget {
  const new({
    required this.event,
    this.attending,
    this.onToggle,
    this.busy = false,
    super.key,
  });

  final EventSummary event;

  /// null hides the toggle.
  final bool? attending;
  final VoidCallback? onToggle;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final material = MaterialLocalizations.of(context);
    final start = event.startsAt.toLocal();
    final attending = this.attending;

    return GlassCard(
      child: Row(
        children: [
          // Date badge.
          Container(
            width: 56,
            padding: EdgeInsets.symmetric(vertical: spacing.xs),
            decoration: BoxDecoration(
              gradient: colors.primaryGradient,
              borderRadius: BorderRadius.circular(context.radii.md),
            ),
            child: Column(
              children: [
                Text('${start.day}', style: context.textTheme.headlineSmall),
                Text(
                  DateFormat.MMM('pt_BR')
                      .format(start)
                      .replaceAll('.', '')
                      .toUpperCase(),
                  style: context.textTheme.labelSmall?.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        event.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.titleMedium,
                      ),
                    ),
                    if (event.isOfficial) ...[
                      SizedBox(width: spacing.xxs),
                      Icon(Icons.verified, size: 16, color: colors.lime),
                    ],
                  ],
                ),
                SizedBox(height: spacing.xxs),
                Text(
                  [
                    material.formatTimeOfDay(TimeOfDay.fromDateTime(start)),
                    event.venueName,
                    event.city,
                  ].join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall,
                ),
                if (event.genres.isNotEmpty)
                  Text(
                    event.genres.take(3).map(l10n.genre).join(' · '),
                    style: context.textTheme.labelSmall?.copyWith(
                      color: colors.cyan,
                    ),
                  ),
              ],
            ),
          ),
          if (attending != null) ...[
            SizedBox(width: spacing.xs),
            if (attending)
              FilledButton.tonal(
                onPressed: busy ? null : onToggle,
                style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
                child: Text(l10n.attendingButton),
              )
            else
              OutlinedButton(
                onPressed: busy ? null : onToggle,
                style: OutlinedButton.styleFrom(minimumSize: const Size(0, 40)),
                child: Text(l10n.attendButton),
              ),
          ],
        ],
      ),
    );
  }
}
