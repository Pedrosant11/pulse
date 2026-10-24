import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/errors/app_failure_message.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/events/presentation/widgets/event_attend_tile.dart';
import 'package:pulse/features/events/presentation/widgets/event_map.dart';
import 'package:pulse/features/venues/domain/venue.dart';
import 'package:pulse/features/venues/presentation/venues_providers.dart';
import 'package:pulse/features/venues/presentation/widgets/venue_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

/// A venue's page: photo, rating, follow, upcoming parties and ratings.
class VenueScreen extends ConsumerWidget {
  const new({required this.venueId, super.key});

  final String venueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keeps the editor alive while an action runs and shows its errors.
    ref.listen(venueEditorProvider, (_, next) {
      if (next case AsyncError(:final error)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(friendlyErrorMessage(error, context.l10n))),
        );
      }
    });
    return Scaffold(
      backgroundColor: context.colors.background,
      body: AsyncValueView(
        value: ref.watch(venueDetailProvider(venueId)),
        onRetry: () => ref.invalidate(venueDetailProvider(venueId)),
        data: (venue) => venue == null
            ? SafeArea(
                child: EmptyView(
                  icon: Icons.storefront_outlined,
                  title: context.l10n.venueNotFound,
                ),
              )
            : _VenueBody(venue: venue),
      ),
    );
  }
}

class _VenueBody extends ConsumerWidget {
  const new({required this.venue});

  final VenueDetail venue;

  Future<void> _open(BuildContext context, Uri uri) async {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
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
    final editor = ref.watch(venueEditorProvider);
    final approved = venue.status == VenueStatus.approved;
    final point = venue.lat != null && venue.lng != null
        ? LatLng(venue.lat!, venue.lng!)
        : null;
    final place = [
      ?venue.neighborhood,
      '${venue.city}, ${venue.state}',
    ].join(' · ');

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 220,
          backgroundColor: colors.background,
          actions: [
            if (venue.canEdit)
              IconButton(
                tooltip: l10n.venueEdit,
                onPressed: () => context.push(AppRoutes.editVenue(venue.id)),
                icon: const Icon(Icons.edit_outlined),
              ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                VenuePhoto(photoPath: venue.photoPath, iconSize: 64),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colors.background.withValues(alpha: 0),
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
          padding: EdgeInsets.fromLTRB(spacing.md, 0, spacing.md, spacing.xl),
          sliver: SliverList.list(
            children: [
              Text(
                venue.name.toUpperCase(),
                style: context.textTheme.headlineMedium,
              ),
              SizedBox(height: spacing.xxs),
              Text(place, style: context.textTheme.bodyMedium),
              SizedBox(height: spacing.xs),
              Row(
                children: [
                  VenueRating(rating: venue.rating, count: venue.ratingCount),
                  SizedBox(width: spacing.md),
                  Text(
                    l10n.venueFollowers(venue.followers),
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),
              SizedBox(height: spacing.md),
              if (venue.status == VenueStatus.pending)
                _Banner(
                  icon: Icons.hourglass_top_rounded,
                  color: colors.lime,
                  text: l10n.venuePendingBanner,
                ),
              if (venue.status == VenueStatus.rejected)
                _Banner(
                  icon: Icons.block_outlined,
                  color: colors.error,
                  text: l10n.venueRejectedBanner(venue.rejectionReason ?? '—'),
                ),
              if (approved && venue.isFollowing)
                OutlinedButton.icon(
                  onPressed: editor.isLoading
                      ? null
                      : () => ref
                            .read(venueEditorProvider.notifier)
                            .setFollowing(venue.id, following: false),
                  icon: Icon(Icons.favorite_rounded, color: colors.magenta),
                  label: Text(l10n.venueFollowing),
                )
              else if (approved)
                FilledButton.icon(
                  onPressed: editor.isLoading
                      ? null
                      : () => ref
                            .read(venueEditorProvider.notifier)
                            .setFollowing(venue.id, following: true),
                  icon: const Icon(Icons.favorite_outline_rounded),
                  label: Text(l10n.venueFollow),
                ),
              if (approved)
                Padding(
                  padding: EdgeInsets.only(top: spacing.xxs),
                  child: Text(
                    l10n.venueFollowHint,
                    style: context.textTheme.bodySmall,
                  ),
                ),
              if (venue.status == VenueStatus.pending && role.isModerator) ...[
                SizedBox(height: spacing.sm),
                _ReviewActions(venueId: venue.id),
              ],
              if (venue.description case final text?) ...[
                SizedBox(height: spacing.lg),
                Text(text, style: context.textTheme.bodyLarge),
              ],
              if (venue.address != null || point != null) ...[
                SizedBox(height: spacing.lg),
                _SectionTitle(l10n.venueWhere),
                if (venue.address case final address?)
                  Text(address, style: context.textTheme.bodyMedium),
                if (point != null) ...[
                  SizedBox(height: spacing.sm),
                  _VenueMap(point: point),
                ],
                SizedBox(height: spacing.sm),
                OutlinedButton.icon(
                  onPressed: () => _open(
                    context,
                    Uri.https('www.google.com', '/maps/dir/', {
                      'api': '1',
                      'destination': point != null
                          ? '${point.latitude},${point.longitude}'
                          : '${venue.address}, ${venue.city} - ${venue.state}',
                    }),
                  ),
                  icon: const Icon(Icons.directions_outlined),
                  label: Text(l10n.eventDirections),
                ),
              ],
              if (venue.instagram case final handle?) ...[
                SizedBox(height: spacing.xs),
                TextButton.icon(
                  onPressed: () => _open(
                    context,
                    Uri.https('www.instagram.com', '/$handle/'),
                  ),
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: Text('@$handle'),
                ),
              ],
              SizedBox(height: spacing.lg),
              _SectionTitle(l10n.venueUpcoming),
              if (venue.upcoming.isEmpty)
                Text(l10n.venueNoUpcoming, style: context.textTheme.bodyMedium)
              else
                for (final event in venue.upcoming)
                  Padding(
                    padding: EdgeInsets.only(bottom: spacing.sm),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(context.radii.lg),
                      onTap: () =>
                          context.push(AppRoutes.eventDetail(event.id)),
                      child: EventAttendTile(event: event),
                    ),
                  ),
              if (venue.pastEvents > 0)
                Text(
                  l10n.venuePastEvents(venue.pastEvents),
                  style: context.textTheme.bodySmall,
                ),
              if (approved) ...[
                SizedBox(height: spacing.lg),
                _SectionTitle(l10n.venueRatings),
                if (venue.canReview)
                  OutlinedButton.icon(
                    onPressed: () => showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      showDragHandle: true,
                      builder: (_) => _RateSheet(venue: venue),
                    ),
                    icon: const Icon(Icons.star_outline_rounded),
                    label: Text(
                      venue.myRating == null
                          ? l10n.venueRate
                          : l10n.venueRateEdit,
                    ),
                  )
                else
                  Text(
                    l10n.venueRateOnlyWent,
                    style: context.textTheme.bodySmall,
                  ),
                SizedBox(height: spacing.sm),
                for (final review in venue.reviews)
                  Padding(
                    padding: EdgeInsets.only(bottom: spacing.sm),
                    child: _ReviewCard(review: review),
                  ),
              ],
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
    padding: EdgeInsets.only(bottom: context.spacing.sm),
    child: Text(text.toUpperCase(), style: context.textTheme.titleLarge),
  );
}

class _Banner extends StatelessWidget {
  const new({required this.icon, required this.color, required this.text});

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: context.spacing.sm),
    child: GlassCard(
      child: Row(
        children: [
          Icon(icon, color: color),
          SizedBox(width: context.spacing.sm),
          Expanded(child: Text(text)),
        ],
      ),
    ),
  );
}

class _VenueMap extends ConsumerWidget {
  const new({required this.point});

  final LatLng point;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = ref.watch(mapStyleProvider).value;
    return ClipRRect(
      borderRadius: BorderRadius.circular(context.radii.lg),
      child: SizedBox(
        height: 170,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: point,
            initialZoom: 15,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.none,
            ),
          ),
          children: [
            ...mapBaseLayers(style),
            MarkerLayer(
              markers: [
                Marker(
                  point: point,
                  width: EventPin.size,
                  height: EventPin.size,
                  alignment: Alignment.topCenter,
                  child: const EventPin(),
                ),
              ],
            ),
            mapAttribution(),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const new({required this.review});

  final VenueReview review;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final date = DateFormat(
      "d 'de' MMM",
      'pt_BR',
    ).format(review.updatedAt.toLocal());
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  review.firstName,
                  style: context.textTheme.titleSmall,
                ),
              ),
              for (var i = 1; i <= 5; i++)
                Icon(
                  i <= review.rating
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  size: 16,
                  color: i <= review.rating
                      ? colors.lime
                      : colors.textSecondary,
                ),
            ],
          ),
          if (review.comment case final comment?) ...[
            SizedBox(height: context.spacing.xxs),
            Text(comment, style: context.textTheme.bodyMedium),
          ],
          SizedBox(height: context.spacing.xxs),
          Text(date, style: context.textTheme.bodySmall),
        ],
      ),
    );
  }
}

/// Curators approve or refuse a suggested venue.
class _ReviewActions extends ConsumerWidget {
  const new({required this.venueId});

  final String venueId;

  Future<void> _refuse(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.venueRefuseTitle),
        content: TextField(
          controller: controller,
          maxLength: 300,
          decoration: InputDecoration(labelText: l10n.eventRejectReasonHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(l10n.venueRefuse),
          ),
        ],
      ),
    );
    controller.dispose();
    if (reason == null) return;
    await ref
        .read(venueEditorProvider.notifier)
        .review(venueId, approve: false, reason: reason);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final busy = ref.watch(venueEditorProvider).isLoading;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: busy ? null : () => _refuse(context, ref),
            child: Text(l10n.venueRefuse),
          ),
        ),
        SizedBox(width: context.spacing.sm),
        Expanded(
          child: FilledButton(
            onPressed: busy
                ? null
                : () => ref
                      .read(venueEditorProvider.notifier)
                      .review(venueId, approve: true),
            child: Text(l10n.venueApprove),
          ),
        ),
      ],
    );
  }
}

/// 1–5 stars and an optional comment.
class _RateSheet extends ConsumerStatefulWidget {
  const new({required this.venue});

  final VenueDetail venue;

  @override
  ConsumerState<_RateSheet> createState() => _RateSheetState();
}

class _RateSheetState extends ConsumerState<_RateSheet> {
  late int _rating = widget.venue.myRating ?? 0;
  late final _comment = TextEditingController(text: widget.venue.myComment);

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final ok = await ref
        .read(venueEditorProvider.notifier)
        .rate(widget.venue.id, _rating, _comment.text);
    if (ok == true && mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    final ok = await ref
        .read(venueEditorProvider.notifier)
        .deleteRating(widget.venue.id);
    if (ok == true && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final editor = ref.watch(venueEditorProvider);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.md,
        0,
        spacing.md,
        spacing.md + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.venueRateTitle(widget.venue.name),
            style: context.textTheme.titleLarge,
          ),
          SizedBox(height: spacing.sm),
          Center(
            child: StarPicker(
              value: _rating,
              onChanged: (v) => setState(() => _rating = v),
            ),
          ),
          SizedBox(height: spacing.sm),
          TextField(
            controller: _comment,
            maxLength: 500,
            minLines: 2,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: l10n.venueRateComment),
          ),
          FormErrorText(error: editor.error),
          FilledButton(
            onPressed: _rating == 0 || editor.isLoading ? null : _save,
            child: Text(l10n.saveButton),
          ),
          if (widget.venue.myRating != null)
            TextButton(
              onPressed: editor.isLoading ? null : _delete,
              child: Text(l10n.venueRateDelete),
            ),
        ],
      ),
    );
  }
}
