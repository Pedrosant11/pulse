import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/errors/app_failure_message.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/features/safety/domain/safety_models.dart';
import 'package:pulse/features/safety/presentation/safety_providers.dart';
import 'package:pulse/l10n/app_localizations.dart';

/// Confirms and blocks [userId]. Returns true when blocked.
Future<bool> blockUser(
  BuildContext context,
  WidgetRef ref, {
  required String userId,
  required String name,
}) async {
  final l10n = context.l10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.blockTitle(name)),
      content: Text(l10n.blockBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(l10n.blockAction),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return false;

  final messenger = ScaffoldMessenger.of(context);
  // Keeps the (auto-dispose) controller alive to read its error afterwards.
  final subscription = ref.listenManual(safetyActionsProvider, (_, _) {});
  final blocked = await ref.read(safetyActionsProvider.notifier).block(userId);
  final error = subscription.read().error;
  subscription.close();
  if (blocked == true) {
    messenger.showSnackBar(SnackBar(content: Text(l10n.blockDone(name))));
    return true;
  }
  if (error != null) {
    messenger.showSnackBar(
      SnackBar(content: Text(friendlyErrorMessage(error, l10n))),
    );
  }
  return false;
}

/// Reasons offered for each kind of target, in display order.
List<ReportReason> reportReasonsFor(ReportTarget target) => switch (target) {
  ReportTarget.event => const [
    ReportReason.fakeProfile,
    ReportReason.scam,
    ReportReason.spam,
    ReportReason.inappropriateContent,
    ReportReason.safetyConcern,
    ReportReason.other,
  ],
  _ => ReportReason.values,
};

String reportReasonLabel(
  AppLocalizations l10n,
  ReportReason reason,
  ReportTarget target,
) {
  final isEvent = target == ReportTarget.event;
  return switch (reason) {
    ReportReason.harassment => l10n.reportReasonHarassment,
    ReportReason.inappropriateContent => l10n.reportReasonInappropriateContent,
    ReportReason.fakeProfile =>
      isEvent ? l10n.reportReasonFakeEvent : l10n.reportReasonFakeProfile,
    ReportReason.scam =>
      isEvent ? l10n.reportReasonScamEvent : l10n.reportReasonScam,
    ReportReason.spam => l10n.reportReasonSpam,
    ReportReason.underage => l10n.reportReasonUnderage,
    ReportReason.safetyConcern => l10n.reportReasonSafetyConcern,
    ReportReason.other => l10n.reportReasonOther,
  };
}

/// Report a person, message or event (SPEC 10). When [userId] is given the
/// sheet also offers to block that person. Returns true if they were
/// blocked, false if only reported, null if cancelled.
Future<bool?> showReportSheet(
  BuildContext context, {
  required ReportTarget target,
  required String targetId,
  String? userId,
  String? userName,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: context.colors.surface,
    builder: (_) => _ReportSheet(
      target: target,
      targetId: targetId,
      userId: userId,
      userName: userName,
    ),
  );
}

class _ReportSheet extends ConsumerStatefulWidget {
  const new({
    required this.target,
    required this.targetId,
    this.userId,
    this.userName,
  });

  final ReportTarget target;
  final String targetId;
  final String? userId;
  final String? userName;

  @override
  ConsumerState<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends ConsumerState<_ReportSheet> {
  final _details = TextEditingController();
  ReportReason? _reason;
  bool _alsoBlock = true;

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final reason = _reason;
    if (reason == null) return;
    final l10n = context.l10n;
    final actions = ref.read(safetyActionsProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);
    final userId = widget.userId;

    final reported = await actions.report(
      target: widget.target,
      targetId: widget.targetId,
      reason: reason,
      details: _details.text,
    );
    if (reported != true) return;
    final blocked =
        userId != null && _alsoBlock && await actions.block(userId) == true;
    if (mounted) Navigator.pop(context, blocked);
    messenger.showSnackBar(SnackBar(content: Text(l10n.reportSent)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final state = ref.watch(safetyActionsProvider);
    final name = widget.userName;
    final title = switch (widget.target) {
      ReportTarget.user => l10n.reportUserTitle(name ?? ''),
      ReportTarget.message => l10n.reportMessageTitle,
      ReportTarget.event => l10n.reportEventTitle,
    };

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(spacing.md),
        children: [
          Text(title.toUpperCase(), style: context.textTheme.titleLarge),
          SizedBox(height: spacing.xs),
          Text(l10n.reportIntro, style: context.textTheme.bodyMedium),
          SizedBox(height: spacing.md),
          Text(l10n.reportReasonLabel, style: context.textTheme.labelLarge),
          SizedBox(height: spacing.xs),
          Wrap(
            spacing: spacing.xs,
            runSpacing: spacing.xs,
            children: [
              for (final reason in reportReasonsFor(widget.target))
                ChoiceChip(
                  label: Text(reportReasonLabel(l10n, reason, widget.target)),
                  selected: _reason == reason,
                  onSelected: (_) => setState(() => _reason = reason),
                ),
            ],
          ),
          SizedBox(height: spacing.md),
          TextField(
            controller: _details,
            maxLength: 1000,
            minLines: 2,
            maxLines: 5,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l10n.reportDetails,
              hintText: l10n.reportDetailsHint,
              alignLabelWithHint: true,
            ),
          ),
          if (widget.userId != null && name != null)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _alsoBlock,
              onChanged: (v) => setState(() => _alsoBlock = v ?? false),
              title: Text(l10n.reportAlsoBlock(name)),
            ),
          SizedBox(height: spacing.sm),
          FormErrorText(error: state.error),
          NeonButton(
            label: l10n.reportSubmit,
            icon: Icons.flag_outlined,
            isLoading: state.isLoading,
            onPressed: _reason == null ? null : _submit,
          ),
        ],
      ),
    );
  }
}

/// "⋮" menu with Report / Block for someone's profile.
class UserSafetyMenu extends ConsumerWidget {
  const new({
    required this.userId,
    required this.name,
    this.onBlocked,
    super.key,
  });

  final String userId;
  final String name;

  /// Called after the person is blocked (e.g. close the sheet).
  final VoidCallback? onBlocked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return PopupMenuButton<_SafetyChoice>(
      tooltip: l10n.safetyMenuTooltip,
      icon: const Icon(Icons.more_vert),
      onSelected: (choice) async {
        final action = switch (choice) {
          _SafetyChoice.report => showReportSheet(
            context,
            target: ReportTarget.user,
            targetId: userId,
            userId: userId,
            userName: name,
          ),
          _SafetyChoice.block => blockUser(
            context,
            ref,
            userId: userId,
            name: name,
          ),
        };
        if (await action ?? false) onBlocked?.call();
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: _SafetyChoice.report,
          child: Text(l10n.chatMenuReport),
        ),
        PopupMenuItem(
          value: _SafetyChoice.block,
          child: Text(l10n.blockAction),
        ),
      ],
    );
  }
}

enum _SafetyChoice { report, block }
