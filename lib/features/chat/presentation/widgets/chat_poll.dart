import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/features/auth/presentation/session_providers.dart';
import 'package:pulse/features/chat/domain/poll.dart';
import 'package:pulse/features/chat/presentation/chat_providers.dart';

/// A poll inside a crew chat bubble: options with live counts. Tap to
/// vote, tap your option again to take the vote back.
class PollCard extends ConsumerWidget {
  const new({required this.pollId, required this.accent, super.key});

  final String pollId;
  final Color accent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final poll = ref.watch(pollProvider(pollId)).value;
    if (poll == null) {
      return const SizedBox(
        height: 48,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    final votes = ref.watch(pollVotesProvider(pollId)).value ?? const [];
    final userId = ref.watch(currentUserIdProvider);
    final (:counts, :total, :mine) = tallyVotes(poll, votes, userId);
    final open = poll.isOpen(DateTime.now());
    final busy = ref.watch(pollEditorProvider).isLoading;
    final left = poll.closesAt.difference(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(Icons.poll_outlined, size: 18, color: accent),
            SizedBox(width: spacing.xs),
            Expanded(
              child: Text(poll.question, style: context.textTheme.titleSmall),
            ),
          ],
        ),
        SizedBox(height: spacing.xs),
        for (final (i, option) in poll.options.indexed)
          Padding(
            padding: EdgeInsets.only(bottom: spacing.xs),
            child: Semantics(
              button: open,
              selected: mine == i,
              child: InkWell(
                borderRadius: BorderRadius.circular(context.radii.md),
                onTap: !open || busy
                    ? null
                    : () => ref
                          .read(pollEditorProvider.notifier)
                          .vote(pollId, mine == i ? null : i),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(context.radii.md),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ColoredBox(
                          color: colors.background.withValues(alpha: 0.35),
                        ),
                      ),
                      Positioned.fill(
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: total == 0 ? 0 : counts[i] / total,
                          child: ColoredBox(
                            color: accent.withValues(
                              alpha: mine == i ? 0.55 : 0.28,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: spacing.sm,
                          vertical: spacing.xs,
                        ),
                        child: Row(
                          children: [
                            if (mine == i) ...[
                              Icon(
                                Icons.check_circle_rounded,
                                size: 16,
                                color: colors.textPrimary,
                              ),
                              SizedBox(width: spacing.xxs),
                            ],
                            Expanded(
                              child: Text(
                                option,
                                style: context.textTheme.bodyMedium,
                              ),
                            ),
                            Text(
                              '${counts[i]}',
                              style: context.textTheme.labelLarge,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        Text(
          [
            l10n.pollVotes(total),
            if (open && left.inHours >= 1)
              l10n.pollClosesInHours(left.inHours)
            else if (open)
              l10n.pollClosesSoon
            else
              l10n.pollClosed,
          ].join(' · '),
          style: context.textTheme.labelSmall,
        ),
      ],
    );
  }
}

/// Question, 2–4 options and how long it stays open.
Future<void> showCreatePollSheet(BuildContext context, String conversationId) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _CreatePollSheet(conversationId: conversationId),
    );

class _CreatePollSheet extends ConsumerStatefulWidget {
  const new({required this.conversationId});

  final String conversationId;

  @override
  ConsumerState<_CreatePollSheet> createState() => _CreatePollSheetState();
}

class _CreatePollSheetState extends ConsumerState<_CreatePollSheet> {
  final _formKey = GlobalKey<FormState>();
  final _question = TextEditingController();
  final _options = [TextEditingController(), TextEditingController()];
  int _hours = 24;

  @override
  void dispose() {
    _question.dispose();
    for (final c in _options) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _create() async {
    if (!_formKey.currentState!.validate()) return;
    final id = await ref
        .read(pollEditorProvider.notifier)
        .create(
          conversationId: widget.conversationId,
          question: _question.text,
          options: [for (final c in _options) c.text],
          hours: _hours,
        );
    if (id != null && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final editor = ref.watch(pollEditorProvider);
    final filled = _options.where((c) => c.text.trim().isNotEmpty).length;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.md,
        0,
        spacing.md,
        spacing.md + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.pollCreateTitle, style: context.textTheme.titleLarge),
              SizedBox(height: spacing.sm),
              TextFormField(
                controller: _question,
                autofocus: true,
                maxLength: 140,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: l10n.pollQuestion,
                  hintText: l10n.pollQuestionHint,
                ),
                validator: (v) =>
                    (v ?? '').trim().isEmpty ? l10n.validationRequired : null,
              ),
              for (final (i, controller) in _options.indexed)
                Padding(
                  padding: EdgeInsets.only(top: spacing.xs),
                  child: TextFormField(
                    controller: controller,
                    maxLength: 60,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      labelText: l10n.pollOption(i + 1),
                      counterText: '',
                    ),
                  ),
                ),
              if (_options.length < 4)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () =>
                        setState(() => _options.add(TextEditingController())),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.pollAddOption),
                  ),
                ),
              SizedBox(height: spacing.xs),
              Text(l10n.pollDuration, style: context.textTheme.labelLarge),
              SizedBox(height: spacing.xs),
              Wrap(
                spacing: spacing.xs,
                children: [
                  for (final hours in const [3, 12, 24, 48])
                    ChoiceChip(
                      label: Text(l10n.pollHours(hours)),
                      selected: _hours == hours,
                      onSelected: (_) => setState(() => _hours = hours),
                    ),
                ],
              ),
              SizedBox(height: spacing.sm),
              FormErrorText(error: editor.error),
              FilledButton(
                onPressed: filled < 2 || editor.isLoading ? null : _create,
                child: Text(l10n.pollCreate),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
