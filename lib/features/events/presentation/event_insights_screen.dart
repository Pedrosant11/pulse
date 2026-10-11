import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/events/domain/event.dart';
import 'package:pulse/features/events/presentation/events_providers.dart';
import 'package:pulse/features/profile/domain/profile_enums.dart';
import 'package:pulse/features/profile/presentation/profile_labels.dart';

/// Event panel for the creator and moderators: aggregated numbers only.
class EventInsightsScreen extends ConsumerWidget {
  const new({required this.eventId, super.key});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final insights = ref.watch(eventInsightsProvider(eventId));
    final event = ref.watch(eventDetailProvider(eventId)).value;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(l10n.insightsTitle.toUpperCase())),
      body: SafeArea(
        child: AsyncValueView(
          value: insights,
          onRetry: () => ref.invalidate(eventInsightsProvider(eventId)),
          data: (data) => ListView(
            padding: EdgeInsets.all(spacing.md),
            children: [
              if (event != null) ...[
                Text(event.name, style: context.textTheme.headlineSmall),
                SizedBox(height: spacing.xs),
                _FeaturedStatus(event: event),
                SizedBox(height: spacing.md),
              ],
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: spacing.sm,
                crossAxisSpacing: spacing.sm,
                childAspectRatio: 1.7,
                children: [
                  _Stat(value: data.going, label: l10n.insightsGoing),
                  _Stat(
                    value: data.ticketClicks,
                    label: l10n.insightsTicketClicks,
                  ),
                  _Stat(value: data.goingDate, label: l10n.insightsGoingDate),
                  _Stat(value: data.goingCrew, label: l10n.insightsGoingCrew),
                  _Stat(value: data.crews, label: l10n.insightsCrews),
                ],
              ),
              SizedBox(height: spacing.lg),
              if (data.breakdownsHidden)
                Text(l10n.insightsTooFew, style: context.textTheme.bodySmall)
              else ...[
                _Bars(
                  title: l10n.insightsGenres,
                  rows: [
                    for (final g in data.genres)
                      (
                        label: g.genre == null ? '—' : l10n.genre(g.genre!),
                        value: g.count,
                      ),
                  ],
                ),
                _Bars(
                  title: l10n.insightsCities,
                  rows: [
                    for (final c in data.cities)
                      (label: c.label, value: c.count),
                  ],
                ),
                _Bars(
                  title: l10n.insightsGender,
                  rows: [
                    for (final e in data.genders.entries)
                      (label: _genderLabel(context, e.key), value: e.value),
                  ]..sort((a, b) => b.value.compareTo(a.value)),
                ),
                _Bars(
                  title: l10n.insightsAge,
                  rows: [
                    (label: '18–24', value: data.ages['18_24'] ?? 0),
                    (label: '25–34', value: data.ages['25_34'] ?? 0),
                    (label: '35+', value: data.ages['35_plus'] ?? 0),
                  ],
                ),
              ],
              SizedBox(height: spacing.md),
              Text(l10n.insightsPrivacy, style: context.textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }

  static String _genderLabel(BuildContext context, String value) {
    final gender = Gender.values
        .where((g) => g.name == value || _snake(g.name) == value)
        .firstOrNull;
    return gender == null
        ? context.l10n.insightsGenderUnknown
        : context.l10n.gender(gender);
  }

  static String _snake(String name) =>
      name.replaceAllMapped(RegExp('[A-Z]'), (m) => '_${m[0]!.toLowerCase()}');
}

class _FeaturedStatus extends StatelessWidget {
  const new({required this.event});

  final EventDetail event;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final until = event.featuredUntil;
    final featured = until != null && until.isAfter(DateTime.now());
    return Row(
      children: [
        Icon(
          featured ? Icons.star_rounded : Icons.star_outline_rounded,
          size: 18,
          color: featured ? context.colors.lime : context.colors.textSecondary,
        ),
        SizedBox(width: context.spacing.xs),
        Expanded(
          child: Text(
            featured
                ? l10n.insightsFeaturedUntil(
                    DateFormat.yMd('pt_BR').format(until.toLocal()),
                  )
                : l10n.insightsFeatureHint,
            style: context.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

/// Headline number (no chart needed for a single value).
class _Stat extends StatelessWidget {
  const new({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$value', style: context.textTheme.headlineMedium),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

/// Ranked horizontal bars of one series: one hue, value written beside each
/// bar (identity never relies on color), rounded data ends.
class _Bars extends StatelessWidget {
  const new({required this.title, required this.rows});

  final String title;
  final List<({String label, int value})> rows;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();
    final colors = context.colors;
    final spacing = context.spacing;
    final max = rows.map((r) => r.value).fold<int>(1, (a, b) => b > a ? b : a);

    return Padding(
      padding: EdgeInsets.only(bottom: spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title.toUpperCase(), style: context.textTheme.titleMedium),
          SizedBox(height: spacing.sm),
          for (final row in rows)
            Padding(
              padding: EdgeInsets.only(bottom: spacing.sm),
              child: Semantics(
                label: '${row.label}: ${row.value}',
                excludeSemantics: true,
                child: Row(
                  children: [
                    SizedBox(
                      width: 110,
                      child: Text(
                        row.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodySmall,
                      ),
                    ),
                    SizedBox(width: spacing.sm),
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: FractionallySizedBox(
                          widthFactor: (row.value / max).clamp(0.02, 1.0),
                          child: Container(
                            height: 10,
                            decoration: BoxDecoration(
                              color: colors.magenta,
                              borderRadius: const BorderRadius.horizontal(
                                right: Radius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: spacing.sm),
                    SizedBox(
                      width: 32,
                      child: Text(
                        '${row.value}',
                        textAlign: TextAlign.end,
                        style: context.textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
