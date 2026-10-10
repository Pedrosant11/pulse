import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/admin/presentation/moderation_providers.dart';
import 'package:pulse/features/admin/presentation/role_request_providers.dart';
import 'package:pulse/features/badges/presentation/badges_providers.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/events/presentation/widgets/event_visuals.dart';

/// Admin panel (SPEC 10): event queue (curators too), reports, restricted
/// accounts and role requests. Data access is enforced by RLS and RPCs.
class AdminScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final role = ref.watch(currentRoleProvider);
    final requests = ref.watch(pendingRoleRequestsProvider);
    final editor = ref.watch(roleRequestEditorProvider);
    final pendingEvents = ref.watch(pendingEventsProvider).value?.length;
    final pendingReports = role.isAdmin
        ? ref.watch(pendingReportsProvider).value?.length
        : null;
    final pendingBadges = role.isAdmin
        ? ref.watch(pendingBadgeRequestsProvider).value?.length
        : null;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(l10n.adminTitle.toUpperCase())),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(spacing.md),
          children: [
            if (role.isModerator)
              GlassCard(
                padding: EdgeInsets.zero,
                child: ListTile(
                  leading: const Icon(Icons.fact_check_outlined),
                  title: Text(l10n.moderationQueue),
                  trailing: Badge(
                    isLabelVisible: (pendingEvents ?? 0) > 0,
                    label: Text('${pendingEvents ?? 0}'),
                    child: const Icon(Icons.chevron_right),
                  ),
                  onTap: () => context.push(AppRoutes.eventQueue),
                ),
              ),
            if (role.isAdmin) ...[
              SizedBox(height: spacing.sm),
              GlassCard(
                padding: EdgeInsets.zero,
                child: ListTile(
                  leading: const Icon(Icons.flag_outlined),
                  title: Text(l10n.adminReports),
                  trailing: Badge(
                    isLabelVisible: (pendingReports ?? 0) > 0,
                    label: Text('${pendingReports ?? 0}'),
                    child: const Icon(Icons.chevron_right),
                  ),
                  onTap: () => context.push(AppRoutes.adminReports),
                ),
              ),
              SizedBox(height: spacing.sm),
              GlassCard(
                padding: EdgeInsets.zero,
                child: ListTile(
                  leading: const Icon(Icons.person_off_outlined),
                  title: Text(l10n.adminRestrictedUsers),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.adminRestricted),
                ),
              ),
              SizedBox(height: spacing.sm),
              GlassCard(
                padding: EdgeInsets.zero,
                child: ListTile(
                  leading: const Icon(Icons.verified_outlined),
                  title: Text(l10n.adminBadges),
                  trailing: Badge(
                    isLabelVisible: (pendingBadges ?? 0) > 0,
                    label: Text('${pendingBadges ?? 0}'),
                    child: const Icon(Icons.chevron_right),
                  ),
                  onTap: () => context.push(AppRoutes.adminBadges),
                ),
              ),
              SizedBox(height: spacing.lg),
              Text(
                l10n.adminRoleRequests.toUpperCase(),
                style: context.textTheme.titleLarge,
              ),
              SizedBox(height: spacing.sm),
              FormErrorText(error: editor.error),
              AsyncValueView(
                value: requests,
                onRetry: () => ref.invalidate(pendingRoleRequestsProvider),
                loading: const LoadingView(itemCount: 1),
                data: (requests) => requests.isEmpty
                    ? Text(l10n.adminNoRoleRequests)
                    : Column(
                        children: [
                          for (final request in requests)
                            Padding(
                              padding: EdgeInsets.only(bottom: spacing.sm),
                              child: GlassCard(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      l10n.role(request.requestedRole),
                                      style: context.textTheme.titleMedium,
                                    ),
                                    SizedBox(height: spacing.xs),
                                    Text(request.justification),
                                    for (final link in request.links)
                                      Text(
                                        link,
                                        style: context.textTheme.bodySmall
                                            ?.copyWith(
                                              color: context.colors.cyan,
                                            ),
                                      ),
                                    SizedBox(height: spacing.sm),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: editor.isLoading
                                              ? null
                                              : () => ref
                                                    .read(
                                                      roleRequestEditorProvider
                                                          .notifier,
                                                    )
                                                    .review(
                                                      request.id,
                                                      approve: false,
                                                    ),
                                          child: Text(l10n.reject),
                                        ),
                                        FilledButton(
                                          onPressed: editor.isLoading
                                              ? null
                                              : () => ref
                                                    .read(
                                                      roleRequestEditorProvider
                                                          .notifier,
                                                    )
                                                    .review(
                                                      request.id,
                                                      approve: true,
                                                    ),
                                          child: Text(l10n.approve),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
