import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/admin_web/domain/admin_console_models.dart';
import 'package:pulse/features/admin_web/presentation/admin_console_providers.dart';
import 'package:pulse/features/admin_web/presentation/admin_web_app.dart';

final _number = NumberFormat.decimalPattern('pt_BR');

/// The app at a glance: people, activity, what's waiting and money.
class DashboardScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final dashboard = ref.watch(adminDashboardProvider);
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(l10n.consoleDashboard.toUpperCase()),
        actions: [
          IconButton(
            tooltip: l10n.stateRetry,
            onPressed: () => ref.invalidate(adminDashboardProvider),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: AsyncValueView(
        value: dashboard,
        onRetry: () => ref.invalidate(adminDashboardProvider),
        data: (d) => ListView(
          padding: EdgeInsets.all(spacing.md),
          children: [
            _Section(l10n.consolePending),
            _Pending(pending: d.pending),
            _Section(l10n.consoleUsersSection),
            _Tiles([
              (l10n.consoleUsersTotal, d.users.total, null),
              (
                l10n.consoleUsersNew,
                d.users.new7d,
                l10n.consoleToday(d.users.newToday),
              ),
              (
                l10n.consoleUsersActive,
                d.users.active24h,
                l10n.consoleLast7d(d.users.active7d),
              ),
              (
                l10n.consoleUsersPaused,
                d.users.paused,
                l10n.consoleRestricted(d.users.restricted),
              ),
            ]),
            SizedBox(height: spacing.md),
            _DailyChart(
              title: l10n.consoleSignupsChart,
              days: d.daily,
              value: (day) => day.signups,
              color: context.colors.violet,
            ),
            _Section(l10n.consoleActivity),
            _Tiles([
              (
                l10n.consoleMatches,
                d.activity.matches24h,
                l10n.consoleLast7d(d.activity.matches7d),
              ),
              (
                l10n.consoleMessages,
                d.activity.messages24h,
                l10n.consoleLast7d(d.activity.messages7d),
              ),
              (
                l10n.consoleUpcomingEvents,
                d.activity.upcomingEvents,
                l10n.consoleFeaturedNow(d.activity.featuredNow),
              ),
            ]),
            SizedBox(height: spacing.md),
            _DailyChart(
              title: l10n.consoleMatchesChart,
              days: d.daily,
              value: (day) => day.matches,
              color: context.colors.magenta,
            ),
            _Section(l10n.consoleMoney),
            _Tiles([
              (l10n.planName('plus'), d.plans.plus, null),
              (l10n.planName('black'), d.plans.black, null),
              (l10n.consoleTrials, d.plans.trial, null),
            ]),
            SizedBox(height: spacing.md),
            _Tiles([
              (
                l10n.consoleStoreRevenue,
                null,
                NumberFormat.simpleCurrency(name: 'USD')
                    .format(d.revenue30d.storeUsd),
              ),
              (
                l10n.consoleFeaturedRevenue,
                null,
                NumberFormat.simpleCurrency(locale: 'pt_BR')
                    .format(d.revenue30d.featuredTeamCents / 100),
              ),
            ], valuesAsText: true),
            SizedBox(height: spacing.xs),
            Text(l10n.consoleRevenueHint, style: context.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const new(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(
      top: context.spacing.lg,
      bottom: context.spacing.sm,
    ),
    child: Text(title.toUpperCase(), style: context.textTheme.titleLarge),
  );
}

/// Stat tiles: label, big number, a smaller line under it.
class _Tiles extends StatelessWidget {
  const new(this.items, {this.valuesAsText = false});

  /// (label, value, detail). With [valuesAsText], the detail is the value.
  final List<(String, int?, String?)> items;
  final bool valuesAsText;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Wrap(
      spacing: spacing.sm,
      runSpacing: spacing.sm,
      children: [
        for (final (label, value, detail) in items)
          SizedBox(
            width: 220,
            child: GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: context.textTheme.labelLarge),
                  SizedBox(height: spacing.xs),
                  Text(
                    valuesAsText ? (detail ?? '') : _number.format(value ?? 0),
                    style: context.textTheme.headlineMedium,
                  ),
                  if (!valuesAsText && detail != null)
                    Text(detail, style: context.textTheme.bodySmall),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// What's waiting for a decision, each opening its page.
class _Pending extends StatelessWidget {
  const new({required this.pending});

  final DashboardPending pending;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final items = [
      (l10n.moderationQueue, pending.events, ConsoleRoutes.events),
      (l10n.adminReports, pending.reports, ConsoleRoutes.reports),
      (
        l10n.adminVerifications,
        pending.verifications,
        ConsoleRoutes.verifications,
      ),
      (l10n.consoleBadgeRequests, pending.badges, ConsoleRoutes.people),
      (l10n.adminRoleRequests, pending.roles, ConsoleRoutes.roles),
      (l10n.adminFeatured, pending.featured, ConsoleRoutes.featured),
    ];
    if (pending.total == 0) {
      return GlassCard(
        child: Row(
          children: [
            Icon(Icons.check_circle_outline_rounded, color: colors.success),
            SizedBox(width: context.spacing.sm),
            Text(l10n.consoleNothingPending),
          ],
        ),
      );
    }
    return Wrap(
      spacing: context.spacing.sm,
      runSpacing: context.spacing.sm,
      children: [
        for (final (label, count, path) in items)
          if (count > 0)
            ActionChip(
              avatar: CircleAvatar(
                backgroundColor: colors.magenta,
                child: Text(
                  '$count',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
              label: Text(label),
              onPressed: () => context.go(path),
            ),
      ],
    );
  }
}

/// 30 days as thin bars of one color; hovering a bar shows the day and
/// the value, and the total is written above.
class _DailyChart extends StatelessWidget {
  const new({
    required this.title,
    required this.days,
    required this.value,
    required this.color,
  });

  final String title;
  final List<DashboardDay> days;
  final int Function(DashboardDay) value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final values = [for (final d in days) value(d)];
    final max = values.fold(0, (a, b) => a > b ? a : b);
    final total = values.fold(0, (a, b) => a + b);
    final dayFormat = DateFormat("EEE, d 'de' MMM", 'pt_BR');
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.textTheme.titleMedium),
          Text(
            context.l10n.consoleChartTotal(_number.format(total)),
            style: context.textTheme.bodySmall,
          ),
          SizedBox(height: spacing.md),
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final (i, day) in days.indexed)
                  Expanded(
                    child: Tooltip(
                      message: '${dayFormat.format(day.day)}: ${values[i]}',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: FractionallySizedBox(
                            widthFactor: 1,
                            heightFactor: max == 0
                                ? 0.02
                                : (values[i] / max).clamp(0.02, 1.0),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: values[i] == 0
                                    ? colors.glassBorder
                                    : color,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: spacing.xs),
          if (days.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('d/M').format(days.first.day),
                  style: context.textTheme.labelSmall,
                ),
                Text(
                  DateFormat('d/M').format(days.last.day),
                  style: context.textTheme.labelSmall,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
