import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/core/widgets/state_views.dart';
import 'package:pulse/features/admin/domain/moderation_models.dart';
import 'package:pulse/features/admin/presentation/moderation_providers.dart';
import 'package:pulse/features/chat/presentation/widgets/chat_avatar.dart';
import 'package:pulse/features/events/presentation/widgets/event_visuals.dart';
import 'package:pulse/features/profile/presentation/widgets/user_profile_sheet.dart';
import 'package:pulse/features/safety/domain/safety_models.dart';
import 'package:pulse/features/safety/presentation/safety_actions.dart';
import 'package:pulse/l10n/app_localizations.dart';

String _targetLabel(AppLocalizations l10n, ReportTarget target) =>
    switch (target) {
      ReportTarget.user => l10n.adminReportTargetUser,
      ReportTarget.message => l10n.adminReportTargetMessage,
      ReportTarget.event => l10n.adminReportTargetEvent,
    };

/// Admin panel → Denúncias (SPEC 10): pending reports, oldest first.
class ReportsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final reports = ref.watch(pendingReportsProvider);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(title: Text(l10n.adminReports.toUpperCase())),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(pendingReportsProvider.future),
          child: AsyncValueView(
            value: reports,
            onRetry: () => ref.invalidate(pendingReportsProvider),
            data: (reports) => reports.isEmpty
                ? EmptyView(
                    icon: Icons.verified_user_outlined,
                    title: l10n.adminReportsEmpty,
                  )
                : ListView.separated(
                    padding: EdgeInsets.all(spacing.md),
                    itemCount: reports.length,
                    separatorBuilder: (_, _) => SizedBox(height: spacing.sm),
                    itemBuilder: (context, i) => ReportCard(
                      report: reports[i],
                      onTap: () => showModalBottomSheet<void>(
                        context: context,
                        useRootNavigator: true,
                        isScrollControlled: true,
                        useSafeArea: true,
                        backgroundColor: context.colors.surface,
                        builder: (_) => _ResolveSheet(report: reports[i]),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  const new({required this.report, required this.onTap, super.key});

  final AdminReport report;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final snapshot = report.snapshotText;
    final details = report.details;
    final reporter = report.reporterFirstName;

    return GlassCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  StatusPill(
                    label: _targetLabel(l10n, report.targetType),
                    color: colors.cyan,
                  ),
                  SizedBox(width: spacing.xs),
                  Expanded(
                    child: Text(
                      reportReasonLabel(l10n, report.reason, report.targetType),
                      style: context.textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              if (snapshot != null && snapshot.isNotEmpty) ...[
                SizedBox(height: spacing.sm),
                Text(
                  report.targetType == ReportTarget.message
                      ? '“$snapshot”'
                      : snapshot,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyLarge,
                ),
              ],
              if (details != null) ...[
                SizedBox(height: spacing.xs),
                Text(
                  l10n.adminReportDetails(details),
                  style: context.textTheme.bodyMedium,
                ),
              ],
              SizedBox(height: spacing.sm),
              Text(
                [
                  if (reporter != null) l10n.adminReportBy(reporter),
                  formatEventDate(context, report.createdAt),
                ].join(' · '),
                style: context.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResolveSheet extends ConsumerStatefulWidget {
  const new({required this.report});

  final AdminReport report;

  @override
  ConsumerState<_ResolveSheet> createState() => _ResolveSheetState();
}

class _ResolveSheetState extends ConsumerState<_ResolveSheet> {
  static const _dayOptions = [1, 3, 7, 30];

  final _note = TextEditingController();
  ReportOutcome _outcome = ReportOutcome.warning;
  int _days = 7;
  late bool _removeContent = widget.report.hasRemovableContent;

  @override
  void initState() {
    super.initState();
    _note.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  bool get _isAccountAction =>
      _outcome == ReportOutcome.warning ||
      _outcome == ReportOutcome.suspension ||
      _outcome == ReportOutcome.ban;

  Future<void> _apply() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final done = await ref
        .read(moderationEditorProvider.notifier)
        .resolve(
          reportId: widget.report.id,
          outcome: _outcome,
          note: _note.text,
          suspensionDays: _days,
          removeContent:
              _outcome != ReportOutcome.dismiss &&
              widget.report.hasRemovableContent &&
              _removeContent,
        );
    if (done != true) return;
    messenger.showSnackBar(SnackBar(content: Text(l10n.adminReportHandled)));
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final report = widget.report;
    final editor = ref.watch(moderationEditorProvider);
    final reportedId = report.reportedUserId;
    final reportedName = report.reportedFirstName;
    final canAct = reportedId != null;
    final needsNote = _isAccountAction && _note.text.trim().length < 3;

    final outcomes = [
      (ReportOutcome.dismiss, l10n.adminOutcomeDismiss),
      if (report.hasRemovableContent)
        (ReportOutcome.resolve, l10n.adminOutcomeResolve),
      if (canAct) ...[
        (ReportOutcome.warning, l10n.adminOutcomeWarning),
        (ReportOutcome.suspension, l10n.adminOutcomeSuspension),
        (ReportOutcome.ban, l10n.adminOutcomeBan),
      ],
    ];
    if (!outcomes.any((o) => o.$1 == _outcome)) _outcome = outcomes.first.$1;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(spacing.md),
        children: [
          ReportCard(report: report, onTap: () {}),
          SizedBox(height: spacing.md),
          if (canAct && reportedName != null)
            GlassCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: ChatAvatar(
                  photoPath: report.reportedPhotoPath,
                  size: 40,
                ),
                title: Text(l10n.adminReportedUser(reportedName)),
                subtitle: Text(
                  l10n.adminReportHistory(
                    report.reportsAgainstUser,
                    report.previousActions,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => showUserProfile(context, reportedId),
              ),
            )
          else
            Text(l10n.adminReportedGone, style: context.textTheme.bodySmall),
          SizedBox(height: spacing.md),
          Text(l10n.adminDecision, style: context.textTheme.labelLarge),
          SizedBox(height: spacing.xs),
          Wrap(
            spacing: spacing.xs,
            runSpacing: spacing.xs,
            children: [
              for (final (outcome, label) in outcomes)
                ChoiceChip(
                  label: Text(label),
                  selected: _outcome == outcome,
                  onSelected: (_) => setState(() => _outcome = outcome),
                ),
            ],
          ),
          if (_outcome == ReportOutcome.suspension) ...[
            SizedBox(height: spacing.md),
            Text(l10n.adminSuspensionDays, style: context.textTheme.labelLarge),
            SizedBox(height: spacing.xs),
            Wrap(
              spacing: spacing.xs,
              children: [
                for (final days in _dayOptions)
                  ChoiceChip(
                    label: Text(l10n.adminSuspensionDaysValue(days)),
                    selected: _days == days,
                    onSelected: (_) => setState(() => _days = days),
                  ),
              ],
            ),
          ],
          SizedBox(height: spacing.md),
          TextField(
            controller: _note,
            maxLength: 1000,
            minLines: 1,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: _isAccountAction
                  ? l10n.adminNote
                  : l10n.adminNoteInternal,
            ),
          ),
          if (report.hasRemovableContent && _outcome != ReportOutcome.dismiss)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _removeContent,
              onChanged: (v) => setState(() => _removeContent = v ?? false),
              title: Text(
                report.targetType == ReportTarget.message
                    ? l10n.adminRemoveMessage
                    : l10n.adminRemoveEvent,
              ),
            ),
          SizedBox(height: spacing.sm),
          FormErrorText(error: editor.error),
          NeonButton(
            label: l10n.adminApply,
            icon: Icons.gavel_rounded,
            gradient: _outcome == ReportOutcome.ban
                ? LinearGradient(colors: [colors.error, colors.magenta])
                : null,
            isLoading: editor.isLoading,
            onPressed: needsNote ? null : _apply,
          ),
        ],
      ),
    );
  }
}
