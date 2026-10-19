import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/admin/presentation/role_request_providers.dart';
import 'package:pulse/features/admin/presentation/widgets/requester_header.dart';
import 'package:pulse/features/events/presentation/widgets/event_visuals.dart';

/// Pending curator/producer requests, with approve and reject (admins).
/// Used by the app's admin panel and the web console.
class RoleRequestsList extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final requests = ref.watch(pendingRoleRequestsProvider);
    final editor = ref.watch(roleRequestEditorProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              RequesterHeader(
                                userId: request.userId,
                                name: request.requesterName,
                                place: request.requesterPlace,
                                trailing: Chip(
                                  label: Text(l10n.role(request.requestedRole)),
                                ),
                              ),
                              Text(request.justification),
                              for (final link in request.links)
                                Text(
                                  link,
                                  style: context.textTheme.bodySmall?.copyWith(
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
    );
  }
}
