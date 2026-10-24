import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';
import 'package:pulse/features/venues/presentation/venues_providers.dart';
import 'package:pulse/features/venues/presentation/widgets/venue_widgets.dart';

/// "Casas": clubs in the person's state, or by name anywhere.
class VenuesScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<VenuesScreen> createState() => _VenuesScreenState();
}

class _VenuesScreenState extends ConsumerState<VenuesScreen> {
  final _search = TextEditingController();
  String _query = '';
  bool _everywhere = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final role = ref.watch(currentRoleProvider);
    final myState = ref.watch(myProfileProvider).value?.state;
    final state = _query.isNotEmpty || _everywhere ? null : myState;
    final venues = ref.watch(venueListProvider(_query, state));

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(l10n.venuesTitle.toUpperCase()),
        actions: [
          if (role.createsApprovedEvents)
            IconButton(
              tooltip: l10n.venueAdd,
              onPressed: () => context.push(AppRoutes.newVenue),
              icon: const Icon(Icons.add_business_outlined),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(spacing.md, spacing.sm, spacing.md, 0),
            child: TextField(
              controller: _search,
              textInputAction: TextInputAction.search,
              onSubmitted: (v) => setState(() => _query = v.trim()),
              onChanged: (v) {
                if (v.trim().isEmpty && _query.isNotEmpty) {
                  setState(() => _query = '');
                }
              },
              decoration: InputDecoration(
                hintText: l10n.venuesSearchHint,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          if (_query.isEmpty && myState != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.md),
              child: Row(
                children: [
                  ChoiceChip(
                    label: Text(l10n.venuesInState(myState)),
                    selected: !_everywhere,
                    onSelected: (_) => setState(() => _everywhere = false),
                  ),
                  SizedBox(width: spacing.xs),
                  ChoiceChip(
                    label: Text(l10n.venuesEverywhere),
                    selected: _everywhere,
                    onSelected: (_) => setState(() => _everywhere = true),
                  ),
                ],
              ),
            ),
          Expanded(
            child: AsyncValueView(
              value: venues,
              onRetry: () => ref.invalidate(venueListProvider),
              data: (list) => list.isEmpty
                  ? EmptyView(
                      icon: Icons.storefront_outlined,
                      title: l10n.venuesEmpty,
                      message: _query.isEmpty ? null : l10n.venuesEmptySearch,
                    )
                  : RefreshIndicator(
                      onRefresh: () async => ref.invalidate(venueListProvider),
                      child: ListView.separated(
                        padding: EdgeInsets.all(spacing.md),
                        itemCount: list.length,
                        separatorBuilder: (_, _) =>
                            SizedBox(height: spacing.sm),
                        itemBuilder: (_, i) => VenueTile(
                          venue: list[i],
                          onTap: () =>
                              context.push(AppRoutes.venue(list[i].id)),
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
