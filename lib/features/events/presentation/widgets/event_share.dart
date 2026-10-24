import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/core/widgets/pulse_logo.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/events/presentation/widgets/event_visuals.dart';
import 'package:pulse/features/profile/presentation/profile_labels.dart';
import 'package:pulse/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

/// "Chamar a galera": the message shared by WhatsApp & co.
String eventInviteText(
  AppLocalizations l10n,
  EventDetail event, {
  required String when,
}) => [
  l10n.eventInviteHeadline(event.name),
  '$when · ${event.venueName}, ${event.city}',
  if (event.lineup.isNotEmpty) l10n.eventInviteLineup(event.lineup.join(', ')),
  if (event.ticketUrl case final url?) l10n.eventInviteTicket(url),
  if (event.ticketCoupon case final coupon?) l10n.eventInviteCoupon(coupon),
  l10n.eventInviteFooter,
].join('\n');

/// Story card + "Chamar a galera" for an approved event.
Future<void> showEventShareSheet(BuildContext context, EventDetail event) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _EventShareSheet(event: event),
    );

class _EventShareSheet extends ConsumerStatefulWidget {
  const new({required this.event});

  final EventDetail event;

  @override
  ConsumerState<_EventShareSheet> createState() => _EventShareSheetState();
}

class _EventShareSheetState extends ConsumerState<_EventShareSheet> {
  final GlobalKey _card = GlobalKey();
  bool _busy = false;

  Future<void> _shareStory() async {
    setState(() => _busy = true);
    try {
      final boundary =
          _card.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      if (data == null || !mounted) return;
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              data.buffer.asUint8List(),
              mimeType: 'image/png',
              name: 'pulse-festa.png',
            ),
          ],
          fileNameOverrides: ['pulse-festa.png'],
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _invite() => SharePlus.instance.share(
    ShareParams(
      text: eventInviteText(
        context.l10n,
        widget.event,
        when: formatEventDate(context, widget.event.startsAt),
      ),
      subject: widget.event.name,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final going = ref.watch(isAttendingProvider(widget.event.id)).value;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(spacing.md, 0, spacing.md, spacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.eventShareTitle, style: context.textTheme.titleLarge),
            SizedBox(height: spacing.sm),
            // Preview at a smaller size; captured at full size.
            Center(
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.45,
                child: FittedBox(
                  child: RepaintBoundary(
                    key: _card,
                    child: EventStoryCard(
                      event: widget.event,
                      going: going ?? false,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: spacing.md),
            NeonButton(
              label: l10n.eventShareStory,
              icon: Icons.auto_awesome_rounded,
              isLoading: _busy,
              onPressed: _shareStory,
            ),
            SizedBox(height: spacing.sm),
            OutlinedButton.icon(
              onPressed: _invite,
              icon: const Icon(Icons.groups_rounded),
              label: Text(l10n.eventInviteFriends),
            ),
          ],
        ),
      ),
    );
  }
}

/// 9:16 card for Instagram/WhatsApp stories (360×640, shared at 3×).
class EventStoryCard extends StatelessWidget {
  const new({required this.event, required this.going, super.key});

  final EventDetail event;
  final bool going;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final text = context.textTheme;
    return SizedBox(
      width: 360,
      height: 640,
      child: DecoratedBox(
        decoration: BoxDecoration(color: colors.background),
        child: Stack(
          children: [
            Positioned.fill(
              bottom: 280,
              child: EventCover(coverPath: event.coverPath, seed: event.id),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0, 0.35, 0.58],
                    colors: [
                      colors.background.withValues(alpha: 0.1),
                      colors.background.withValues(alpha: 0.2),
                      colors.background,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (going)
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: colors.lime,
                        borderRadius: BorderRadius.circular(context.radii.pill),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: spacing.sm,
                          vertical: spacing.xxs,
                        ),
                        child: Text(
                          l10n.eventStoryGoing,
                          style: text.labelLarge?.copyWith(
                            color: colors.background,
                          ),
                        ),
                      ),
                    ),
                  const Spacer(),
                  Text(
                    event.name.toUpperCase(),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: text.headlineMedium,
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    formatEventDate(context, event.startsAt),
                    style: text.titleMedium?.copyWith(color: colors.cyan),
                  ),
                  Text(
                    '${event.venueName} · ${event.city}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodyLarge,
                  ),
                  if (event.lineup.isNotEmpty) ...[
                    SizedBox(height: spacing.sm),
                    Text(
                      event.lineup.take(4).join(' · '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleSmall?.copyWith(color: colors.magenta),
                    ),
                  ],
                  if (event.genres.isNotEmpty) ...[
                    SizedBox(height: spacing.sm),
                    Wrap(
                      spacing: spacing.xs,
                      runSpacing: spacing.xs,
                      children: [
                        for (final genre in event.genres.take(3))
                          DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(color: colors.magenta),
                              borderRadius: BorderRadius.circular(
                                context.radii.pill,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: spacing.sm,
                                vertical: spacing.xxs,
                              ),
                              child: Text(
                                l10n.genre(genre),
                                style: text.labelMedium,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                  if (event.ticketCoupon case final coupon?) ...[
                    SizedBox(height: spacing.sm),
                    Text(
                      l10n.eventStoryCoupon(coupon),
                      style: text.titleSmall?.copyWith(color: colors.lime),
                    ),
                  ],
                  SizedBox(height: spacing.lg),
                  Row(
                    children: [
                      const PulseLogo(markSize: 28),
                      const Spacer(),
                      Flexible(
                        child: Text(
                          l10n.eventStoryTagline,
                          textAlign: TextAlign.end,
                          style: text.bodySmall,
                        ),
                      ),
                    ],
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
