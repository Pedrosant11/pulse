import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/features/venues/data/venues_repository.dart';
import 'package:pulse/features/venues/domain/venue.dart';
import 'package:pulse/features/venues/presentation/venues_providers.dart';
import 'package:pulse/features/venues/presentation/widgets/venue_widgets.dart';

/// Picks the event's casa (or adds a new one); null when dismissed.
Future<Venue?> showVenuePicker(BuildContext context) =>
    showModalBottomSheet<Venue>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const FractionallySizedBox(
        heightFactor: 0.85,
        child: _VenuePickerSheet(),
      ),
    );

class _VenuePickerSheet extends ConsumerStatefulWidget {
  const new();

  @override
  ConsumerState<_VenuePickerSheet> createState() => _VenuePickerSheetState();
}

class _VenuePickerSheetState extends ConsumerState<_VenuePickerSheet> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _addNew() async {
    final id = await context.push<String>(
      AppRoutes.newVenueNamed(_search.text.trim()),
    );
    if (id == null || !mounted) return;
    final detail = await ref.read(venuesRepositoryProvider).detail(id);
    if (detail == null || !mounted) return;
    Navigator.pop(
      context,
      Venue(
        id: detail.id,
        name: detail.name,
        city: detail.city,
        state: detail.state,
        neighborhood: detail.neighborhood,
        address: detail.address,
        lat: detail.lat,
        lng: detail.lng,
        photoPath: detail.photoPath,
        status: detail.status,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final role = ref.watch(currentRoleProvider);
    final myState = ref.watch(myProfileProvider).value?.state;
    final venues = ref.watch(
      venueListProvider(_query, _query.isEmpty ? myState : null),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.md,
        0,
        spacing.md,
        MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.venuePickTitle, style: context.textTheme.titleLarge),
          SizedBox(height: spacing.sm),
          TextField(
            controller: _search,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onChanged: (v) => setState(() => _query = v.trim()),
            decoration: InputDecoration(
              hintText: l10n.venuesSearchHint,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          if (role.createsApprovedEvents)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: _addNew,
                icon: const Icon(Icons.add_business_outlined),
                label: Text(l10n.venuePickAdd),
              ),
            ),
          Expanded(
            child: AsyncValueView(
              value: venues,
              data: (list) => list.isEmpty
                  ? Center(
                      child: Text(
                        l10n.venuesEmptySearch,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.only(bottom: spacing.md),
                      itemCount: list.length,
                      separatorBuilder: (_, _) => SizedBox(height: spacing.xs),
                      itemBuilder: (_, i) => VenueTile(
                        venue: list[i],
                        onTap: () => Navigator.pop(context, list[i]),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
