import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/routes.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/events/presentation/widgets/event_visuals.dart';

/// Admin: highlight requests settled with the team. "Pago" turns the
/// highlight on (and tells the producer).
class AdminFeaturedScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final requests = ref.watch(adminFeaturedRequestsProvider);
    final sales = ref.watch(featuredSalesProvider);
    final money = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(l10n.adminFeatured.toUpperCase())),
      body: SafeArea(
        child: AsyncValueView(
          value: requests,
          onRetry: () => ref.invalidate(adminFeaturedRequestsProvider),
          data: (requests) => requests.isEmpty
              ? EmptyView(
                  icon: Icons.rocket_launch_outlined,
                  title: l10n.adminFeaturedEmpty,
                  message: l10n.adminFeaturedEmptyHint,
                )
              : ListView(
                  padding: EdgeInsets.all(spacing.md),
                  children: [
                    FormErrorText(error: sales.error),
                    for (final request in requests)
                      Padding(
                        padding: EdgeInsets.only(bottom: spacing.sm),
                        child: GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              InkWell(
                                onTap: () => context.push(
                                  AppRoutes.eventDetail(request.eventId),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      request.eventName,
                                      style: context.textTheme.titleMedium,
                                    ),
                                    Text(
                                      [
                                        formatEventDate(
                                          context,
                                          request.eventStartsAt,
                                        ),
                                        request.city,
                                      ].join(' · '),
                                      style: context.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: spacing.sm),
                              Text(
                                l10n.adminFeaturedLine(
                                  request.requesterName ?? '—',
                                  request.days,
                                  money.format(request.priceCents / 100),
                                ),
                              ),
                              SizedBox(height: spacing.sm),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: sales.isLoading
                                        ? null
                                        : () => ref
                                              .read(
                                                featuredSalesProvider.notifier,
                                              )
                                              .review(request, approve: false),
                                    child: Text(l10n.reject),
                                  ),
                                  SizedBox(width: spacing.sm),
                                  FilledButton(
                                    onPressed: sales.isLoading
                                        ? null
                                        : () => ref
                                              .read(
                                                featuredSalesProvider.notifier,
                                              )
                                              .review(request, approve: true),
                                    child: Text(l10n.adminFeaturedPaid),
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
      ),
    );
  }
}
