import 'dart:async';
import 'dart:ui' show ImageFilter;

import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/errors/app_failure_message.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/models/user_role.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/genre_chip.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/core/widgets/rive_slot.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/ads/presentation/ad_form_screen.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/badges/presentation/widgets/profile_badges.dart';
import 'package:pulse/features/crews/presentation/crew_screen.dart';
import 'package:pulse/features/events/data/events_repository.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/events/presentation/widgets/event_location.dart';
import 'package:pulse/features/events/presentation/widgets/event_night.dart';
import 'package:pulse/features/events/presentation/widgets/event_share.dart';
import 'package:pulse/features/events/presentation/widgets/event_visuals.dart';
import 'package:pulse/features/events/presentation/widgets/featured_promo.dart';
import 'package:pulse/features/profile/presentation/profile_labels.dart';
import 'package:pulse/features/profile/presentation/widgets/profile_photo_image.dart';
import 'package:pulse/features/safety/domain/safety_models.dart';
import 'package:pulse/features/safety/presentation/safety_actions.dart';
import 'package:pulse/features/safety/presentation/widgets/night_safety.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailScreen extends ConsumerWidget {
  const new({required this.eventId, super.key});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = ref.watch(eventDetailProvider(eventId));
    return Scaffold(
      backgroundColor: context.colors.background,
      body: event.when(
        loading: () => const SafeArea(child: LoadingView(itemCount: 2)),
        error: (error, _) => SafeArea(
          child: Column(
            children: [
              const BackButton(),
              Expanded(
                child: ErrorView(
                  error: error,
                  onRetry: () => ref.invalidate(eventDetailProvider(eventId)),
                ),
              ),
            ],
          ),
        ),
        data: (event) => _EventDetailBody(event: event),
      ),
    );
  }
}

class _EventDetailBody extends ConsumerWidget {
  const new({required this.event});

  final EventDetail event;

  Future<void> _reject(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final reason = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.eventRejectTitle),
        content: TextField(
          controller: reason,
          autofocus: true,
          maxLength: 500,
          maxLines: 3,
          decoration: InputDecoration(hintText: l10n.eventRejectReasonHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.reject),
          ),
        ],
      ),
    );
    final text = reason.text.trim();
    reason.dispose();
    if (confirmed != true || text.isEmpty) return;
    await ref
        .read(eventEditorProvider.notifier)
        .setStatus(event.id, EventStatus.rejected, rejectionReason: text);
  }

  Future<void> _cancelEvent(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.eventCancelTitle),
        content: Text(l10n.eventCancelBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref
        .read(eventEditorProvider.notifier)
        .setStatus(event.id, EventStatus.cancelled);
  }

  /// Admin: feature for some days (paid by the producer) or remove it.
  Future<void> _feature(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    if (event.featuredUntil?.isAfter(DateTime.now()) ?? false) {
      await ref.read(featureEditorProvider.notifier).feature(event.id);
      return;
    }
    final days = await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.eventFeatureTitle),
        children: [
          for (final days in const [3, 7, 14, 30])
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, days),
              child: Text(l10n.eventFeatureDays(days)),
            ),
        ],
      ),
    );
    // Read after the dialog (the controller is kept alive by build).
    if (days != null) {
      await ref
          .read(featureEditorProvider.notifier)
          .feature(event.id, days: days);
    }
  }

  Future<void> _openTicket(BuildContext context, String url) async {
    final opened = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.eventLinkError)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final role = ref.watch(currentRoleProvider);
    final userId = ref.watch(currentUserIdProvider);
    final editor = ref.watch(eventEditorProvider);
    // Keeps the admin highlight controller alive across its dialog and
    // reports its errors.
    ref.listen(featureEditorProvider, (_, next) {
      if (next case AsyncError(:final error)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(friendlyErrorMessage(error, l10n))),
        );
      }
    });
    final isCreator = event.createdBy != null && event.createdBy == userId;
    // UI hints only; the database decides (can_edit_event / guard trigger).
    final canEdit =
        role.isModerator ||
        (isCreator &&
            (event.status == EventStatus.pending || role == UserRole.producer));
    // Only the creator or an admin cancels (event_moderation migration).
    final canCancel =
        (role.isAdmin || isCreator) &&
        event.status != EventStatus.cancelled &&
        event.status != EventStatus.rejected;
    final canReport = !isCreator && event.status == EventStatus.approved;
    final hasEnded = event.endsAt.isBefore(DateTime.now());
    final isFeatured = event.featuredUntil?.isAfter(DateTime.now()) ?? false;
    final ticketUrl = event.ticketUrl;
    final description = event.description;

    final notice = switch (event.status) {
      EventStatus.pending => (l10n.eventPendingNotice, colors.lime),
      EventStatus.rejected => (
        l10n.eventRejectedReason(event.rejectionReason ?? '—'),
        colors.error,
      ),
      EventStatus.cancelled => (
        l10n.eventCancelledNotice,
        colors.textSecondary,
      ),
      EventStatus.approved => null,
    };

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          stretch: true,
          expandedHeight: 260,
          backgroundColor: colors.background,
          actions: [
            // "Salvar" for later, without "Eu vou".
            if (event.status == EventStatus.approved && !hasEnded)
              _SaveButton(eventId: event.id),
            // Story card + "Chamar a galera".
            if (event.status == EventStatus.approved)
              IconButton(
                tooltip: l10n.eventShareTitle,
                icon: const Icon(Icons.ios_share_rounded),
                onPressed: () => showEventShareSheet(context, event),
              ),
            // Event panel: aggregated numbers (creator and moderators).
            if (role.isModerator || isCreator)
              IconButton(
                tooltip: l10n.insightsTitle,
                icon: const Icon(Icons.insights_rounded),
                onPressed: () =>
                    context.push(AppRoutes.eventInsights(event.id)),
              ),
            if (canEdit)
              IconButton(
                tooltip: l10n.eventEdit,
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => context.push(AppRoutes.editEvent(event.id)),
              ),
            if (canCancel || canReport || canEdit || role.isAdmin)
              PopupMenuButton<void>(
                itemBuilder: (_) => [
                  // The rotating QR to show at the door (check_in_qr).
                  if (canEdit && event.status == EventStatus.approved)
                    PopupMenuItem(
                      onTap: () => context.push(AppRoutes.checkInQr(event.id)),
                      child: Text(l10n.eventCheckInQr),
                    ),
                  // Next edition of a recurring party, already filled.
                  if (canEdit && role.createsApprovedEvents)
                    PopupMenuItem(
                      onTap: () =>
                          context.push(AppRoutes.duplicateEvent(event.id)),
                      child: Text(l10n.eventDuplicate),
                    ),
                  if (role.isAdmin && event.status == EventStatus.approved)
                    PopupMenuItem(
                      onTap: () => _feature(context, ref),
                      child: Text(
                        isFeatured ? l10n.eventUnfeature : l10n.eventFeature,
                      ),
                    ),
                  if (role.isAdmin && event.status == EventStatus.approved)
                    PopupMenuItem(
                      onTap: () => context.push(
                        AppRoutes.adminAdForm,
                        extra: AdFormArgs(
                          eventId: event.id,
                          eventName: event.name,
                        ),
                      ),
                      child: Text(l10n.eventAdvertise),
                    ),
                  if (canCancel)
                    PopupMenuItem(
                      onTap: () => _cancelEvent(context, ref),
                      child: Text(l10n.eventCancel),
                    ),
                  if (canReport)
                    PopupMenuItem(
                      onTap: () => showReportSheet(
                        context,
                        target: ReportTarget.event,
                        targetId: event.id,
                      ),
                      child: Text(l10n.reportEventAction),
                    ),
                ],
              ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                EventCover(coverPath: event.coverPath, seed: event.id),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colors.background.withValues(alpha: 0.2),
                        colors.background,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(spacing.md, 0, spacing.md, spacing.xxl),
          sliver: SliverList.list(
            children: [
              if (notice case (final text, final color)) ...[
                StatusPill(label: text, color: color),
                SizedBox(height: spacing.sm),
              ],
              Row(
                children: [
                  Flexible(
                    child: Text(
                      event.name.toUpperCase(),
                      style: context.textTheme.headlineMedium,
                    ),
                  ),
                  if (event.isOfficial) ...[
                    SizedBox(width: spacing.xs),
                    StatusPill(label: l10n.eventOfficial, color: colors.lime),
                  ],
                ],
              ),
              SizedBox(height: spacing.md),
              _InfoRow(
                icon: Icons.schedule,
                label: l10n.eventWhen,
                value:
                    '${formatEventDate(context, event.startsAt)}\n'
                    '→ ${formatEventDate(context, event.endsAt)}',
              ),
              _InfoRow(
                icon: Icons.place_outlined,
                label: l10n.eventWhere,
                value: [
                  event.venueName,
                  ?ref.watch(eventVenueProvider(event.id)).value?.address,
                  '${event.city}, ${event.state}',
                ].join('\n'),
              ),
              if (event.venueId case final venueId?)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => context.push(AppRoutes.venue(venueId)),
                    icon: const Icon(Icons.storefront_outlined),
                    label: Text(l10n.venueSee(event.venueName)),
                  ),
                ),
              // Map + "Como chegar", or the secret-location notice.
              EventLocationSection(event: event),
              _InfoRow(
                icon: Icons.badge_outlined,
                label: l10n.eventMinAge(event.minAge),
                value: null,
              ),
              if (event.genres.isNotEmpty) ...[
                SizedBox(height: spacing.sm),
                Wrap(
                  spacing: spacing.xs,
                  runSpacing: spacing.xs,
                  children: [
                    for (final genre in event.genres)
                      GenreChip(label: l10n.genre(genre), selected: true),
                  ],
                ),
              ],
              SizedBox(height: spacing.lg),
              // Tonight: "Tô ON"; the day after: "Veja quem estava lá".
              Padding(
                padding: EdgeInsets.only(bottom: spacing.sm),
                child: EventNightSection(event: event),
              ),
              if (event.status == EventStatus.approved && !hasEnded)
                _GoingButton(eventId: event.id),
              if (ticketUrl != null) ...[
                SizedBox(height: spacing.sm),
                OutlinedButton.icon(
                  onPressed: () {
                    // Counted for the producer; never blocks the link.
                    unawaited(
                      ref
                          .read(eventsRepositoryProvider)
                          .logTicketClick(event.id)
                          .catchError((_) {}),
                    );
                    unawaited(_openTicket(context, ticketUrl));
                  },
                  icon: const Icon(Icons.confirmation_number_outlined),
                  label: Text(l10n.eventBuyTicket),
                ),
                if (event.ticketCoupon case final coupon?) ...[
                  SizedBox(height: spacing.xs),
                  _CouponRow(coupon: coupon),
                ],
              ],
              // The producer can put the party on top of "Próximos".
              if (isCreator &&
                  event.status == EventStatus.approved &&
                  !hasEnded) ...[
                SizedBox(height: spacing.md),
                FeaturedPromoCard(event: event),
              ],
              if (event.status == EventStatus.approved && !hasEnded) ...[
                SizedBox(height: spacing.md),
                NightSafetyCard(
                  eventName: event.name,
                  venue: '${event.venueName}, ${event.city}',
                  startsAt: event.startsAt,
                ),
              ],
              if (role.isModerator && event.status == EventStatus.pending) ...[
                SizedBox(height: spacing.md),
                FormErrorText(error: editor.error),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: editor.isLoading
                            ? null
                            : () => _reject(context, ref),
                        child: Text(l10n.reject),
                      ),
                    ),
                    SizedBox(width: spacing.sm),
                    Expanded(
                      child: NeonButton(
                        label: l10n.approve,
                        isLoading: editor.isLoading,
                        onPressed: () => ref
                            .read(eventEditorProvider.notifier)
                            .setStatus(event.id, EventStatus.approved),
                      ),
                    ),
                  ],
                ),
              ],
              if (role.isModerator) ...[
                _SectionTitle(l10n.eventCreatedBy),
                _CreatorCard(eventId: event.id),
              ],
              if (description != null) ...[
                _SectionTitle(l10n.eventAbout),
                Text(description, style: context.textTheme.bodyMedium),
              ],
              if (event.lineup.isNotEmpty) ...[
                _SectionTitle(l10n.eventLineup),
                for (final artist in event.lineup)
                  Padding(
                    padding: EdgeInsets.only(bottom: spacing.xs),
                    child: Row(
                      children: [
                        Icon(
                          Icons.album_outlined,
                          size: 18,
                          color: colors.cyan,
                        ),
                        SizedBox(width: spacing.sm),
                        Expanded(
                          child: Text(
                            artist,
                            style: context.textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
              _SectionTitle(l10n.eventGoing),
              _WhoIsGoing(eventId: event.id),
              _SectionTitle(l10n.eventCrews),
              EventCrewsSection(
                eventId: event.id,
                eventName: event.name,
                isGoing:
                    ref.watch(isAttendingProvider(event.id)).value ?? false,
              ),
              SizedBox(height: spacing.md),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const new(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(
      top: context.spacing.xl,
      bottom: context.spacing.sm,
    ),
    child: Text(text.toUpperCase(), style: context.textTheme.titleLarge),
  );
}

class _InfoRow extends StatelessWidget {
  const new({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    return Padding(
      padding: EdgeInsets.only(bottom: context.spacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: context.colors.magenta),
          SizedBox(width: context.spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: context.textTheme.labelLarge),
                if (value != null)
                  Text(value, style: context.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Big "Eu vou" button with a small celebration on tap (Rive version in
/// Phase 9).
class _GoingButton extends ConsumerWidget {
  const new({required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final going = ref.watch(isAttendingProvider(eventId));
    final editor = ref.watch(attendanceEditorProvider);
    final isGoing = going.value ?? false;

    Future<void> toggle() async {
      final next = !isGoing;
      if (next) await HapticFeedback.mediumImpact();
      await ref
          .read(attendanceEditorProvider.notifier)
          .setAttending(eventId, attending: next);
    }

    final Widget button = isGoing
        ? OutlinedButton.icon(
            onPressed: editor.isLoading ? null : toggle,
            icon: SizedBox.square(
              dimension: 24,
              // Optional Rive icon (docs/RIVE.md); the check pops otherwise.
              child: RiveSlot(
                asset: RiveAssets.attend,
                fallback: context.reduceMotion
                    ? Icon(Icons.check_circle, color: context.colors.magenta)
                    : Icon(Icons.check_circle, color: context.colors.magenta)
                          .animate()
                          .scaleXY(
                            begin: 0.2,
                            duration: 450.ms,
                            curve: Curves.elasticOut,
                          )
                          .rotate(begin: -0.15, duration: 300.ms),
              ),
            ),
            label: Text(l10n.attendingButton),
          )
        : NeonButton(
            label: l10n.attendButton,
            icon: Icons.bolt,
            isLoading: editor.isLoading || going.isLoading,
            onPressed: toggle,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FormErrorText(error: editor.error),
        if (context.reduceMotion)
          button
        else
          button
              .animate(key: ValueKey(isGoing))
              .scaleXY(
                begin: 0.92,
                end: 1,
                duration: 350.ms,
                curve: Curves.elasticOut,
              ),
      ],
    );
  }
}

class _WhoIsGoing extends ConsumerWidget {
  const new({required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final counts = ref.watch(eventAttendeeCountsProvider(eventId)).value;
    final attendees = ref.watch(eventAttendeesProvider(eventId));

    return AsyncValueView(
      value: attendees,
      onRetry: () => ref.invalidate(eventAttendeesProvider(eventId)),
      loading: const LoadingView(itemCount: 1),
      data: (people) {
        if (people.isEmpty) {
          return Text(
            l10n.eventNobodyGoing,
            style: context.textTheme.bodyMedium,
          );
        }
        return GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (counts != null) ...[
                Text(
                  l10n.goingCount(counts.total),
                  style: context.textTheme.titleMedium,
                ),
                Text(
                  l10n.eventGoingCounts(counts.dateCount, counts.crewCount),
                  style: context.textTheme.bodySmall,
                ),
                SizedBox(height: spacing.md),
              ],
              Wrap(
                spacing: spacing.sm,
                runSpacing: spacing.sm,
                children: [
                  for (final person in people.take(24)) _Avatar(person),
                ],
              ),
              SizedBox(height: spacing.sm),
              Text(l10n.eventMatchHint, style: context.textTheme.labelSmall),
            ],
          ),
        );
      },
    );
  }
}

class _Avatar extends StatelessWidget {
  const new(this.person);

  final EventAttendee person;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final path = person.photoPath;
    var photo = path == null
        ? ColoredBox(color: colors.surfaceElevated)
        : ProfilePhotoImage(path, decodeWidth: 64);
    if (!person.isMatch) {
      // Non-matches stay anonymous (SPEC 7.3).
      photo = ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: photo,
      );
    }
    final name = person.firstName;

    return Semantics(
      label: name ?? context.l10n.eventAttendeeAnonymous,
      image: true,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: person.isMatch ? colors.magenta : colors.glassBorder,
                width: person.isMatch ? 2 : 1,
              ),
            ),
            child: ClipOval(child: photo),
          ),
          if (name != null) ...[
            const SizedBox(height: 2),
            SizedBox(
              width: 56,
              child: Text(
                name,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelSmall,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Who created the event (moderators only): contact and spam checks.
class _CreatorCard extends ConsumerWidget {
  const new({required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final colors = context.colors;

    return AsyncValueView(
      value: ref.watch(eventCreatorProvider(eventId)),
      onRetry: () => ref.invalidate(eventCreatorProvider(eventId)),
      loading: const LoadingView(itemCount: 1),
      data: (creator) {
        if (creator == null) {
          return Text(
            l10n.eventCreatorDeleted,
            style: context.textTheme.bodyMedium,
          );
        }
        final photo = creator.photoPath;
        final email = creator.email;
        return GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox.square(
                    dimension: 48,
                    child: ClipOval(
                      child: photo == null
                          ? ColoredBox(color: colors.surfaceElevated)
                          : ProfilePhotoImage(photo, decodeWidth: 48),
                    ),
                  ),
                  SizedBox(width: spacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          creator.firstName ?? '—',
                          style: context.textTheme.titleMedium,
                        ),
                        ProfileBadges(userId: creator.userId, dense: true),
                        Text(
                          [
                            l10n.role(creator.role),
                            l10n.creatorMemberSince(
                              MaterialLocalizations.of(
                                context,
                              ).formatShortDate(creator.memberSince.toLocal()),
                            ),
                          ].join(' · '),
                          style: context.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing.sm),
              Text(
                l10n.creatorEventsStats(
                  creator.eventsCreated,
                  creator.eventsRejected,
                ),
                style: context.textTheme.bodyMedium?.copyWith(
                  color: creator.eventsRejected > 0 ? colors.lime : null,
                ),
              ),
              if (email != null)
                Row(
                  children: [
                    Expanded(
                      child: SelectableText(
                        email,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: colors.cyan,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: l10n.copyEmail,
                      icon: const Icon(Icons.copy_rounded, size: 18),
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: email));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.emailCopied)),
                          );
                        }
                      },
                    ),
                  ],
                ),
              SizedBox(height: spacing.xs),
              Text(
                l10n.creatorOnlyModerators,
                style: context.textTheme.labelSmall,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Coupon next to the ticket link, with a copy button (affiliate/promoter).
class _CouponRow extends StatelessWidget {
  const new({required this.coupon});

  final String coupon;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return GlassCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        dense: true,
        leading: Icon(Icons.sell_outlined, color: colors.lime),
        title: Text(l10n.eventCouponLabel),
        subtitle: Text(
          coupon,
          style: context.textTheme.titleMedium?.copyWith(color: colors.lime),
        ),
        trailing: TextButton.icon(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: coupon));
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.eventCouponCopied)));
            }
          },
          icon: const Icon(Icons.copy_rounded, size: 18),
          label: Text(l10n.eventCouponCopy),
        ),
      ),
    );
  }
}

class _SaveButton extends ConsumerWidget {
  const new({required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final saved = ref.watch(isSavedProvider(eventId)).value ?? false;
    final busy = ref.watch(eventNightEditorProvider).isLoading;
    return IconButton(
      tooltip: saved ? l10n.eventUnsave : l10n.eventSave,
      icon: Icon(
        saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
        color: saved ? context.colors.lime : null,
      ),
      onPressed: busy
          ? null
          : () async {
              final ok = await ref
                  .read(eventNightEditorProvider.notifier)
                  .setSaved(eventId, saved: !saved);
              if (ok == true && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(saved ? l10n.eventUnsaved : l10n.eventSaved),
                  ),
                );
              }
            },
    );
  }
}
