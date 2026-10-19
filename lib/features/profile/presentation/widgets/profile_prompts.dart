import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/form_error_text.dart';
import 'package:pulse/core/widgets/glass_card.dart';
import 'package:pulse/core/widgets/neon_button.dart';
import 'package:pulse/features/profile/domain/profile_prompt.dart';
import 'package:pulse/features/profile/presentation/profile_providers.dart';

/// The profile's answers, one card each. Nothing when there are none.
class ProfilePromptsView extends ConsumerWidget {
  const new({required this.userId, super.key});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final answers = ref.watch(profilePromptsProvider(userId)).value;
    if (answers == null || answers.isEmpty) return const SizedBox.shrink();
    final spacing = context.spacing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final answer in answers) ...[
          SizedBox(height: spacing.md),
          PromptCard(answer: answer),
        ],
      ],
    );
  }
}

class PromptCard extends StatelessWidget {
  const new({required this.answer, super.key});

  final PromptAnswer answer;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.prompt(answer.prompt.name),
            style: context.textTheme.labelLarge?.copyWith(color: colors.cyan),
          ),
          SizedBox(height: context.spacing.xs),
          Text(answer.answer, style: context.textTheme.titleMedium),
        ],
      ),
    );
  }
}

/// Edit up to 3 answers: pick a question, write the answer.
class PromptsForm extends ConsumerStatefulWidget {
  const new({required this.initial, required this.onSaved, super.key});

  final List<PromptAnswer> initial;
  final VoidCallback onSaved;

  @override
  ConsumerState<PromptsForm> createState() => _PromptsFormState();
}

class _PromptsFormState extends ConsumerState<PromptsForm> {
  static const _max = 3;
  static const _maxLength = 150;

  late final List<(ProfilePrompt, TextEditingController)> _items = [
    for (final a in widget.initial)
      (a.prompt, TextEditingController(text: a.answer)),
  ];

  @override
  void dispose() {
    for (final (_, controller) in _items) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<ProfilePrompt?> _pickPrompt({ProfilePrompt? current}) {
    final used = {for (final (p, _) in _items) p}..remove(current);
    return showModalBottomSheet<ProfilePrompt>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      builder: (context) => ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: context.spacing.md),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.spacing.md),
            child: Text(
              context.l10n.promptsPick,
              style: context.textTheme.titleLarge,
            ),
          ),
          SizedBox(height: context.spacing.sm),
          for (final prompt in ProfilePrompt.values)
            if (!used.contains(prompt))
              ListTile(
                title: Text(context.l10n.prompt(prompt.name)),
                trailing: prompt == current
                    ? Icon(Icons.check_rounded, color: context.colors.lime)
                    : null,
                onTap: () => Navigator.pop(context, prompt),
              ),
        ],
      ),
    );
  }

  Future<void> _add() async {
    final prompt = await _pickPrompt();
    if (prompt == null || !mounted) return;
    setState(() => _items.add((prompt, TextEditingController())));
  }

  Future<void> _change(int index) async {
    final (current, controller) = _items[index];
    final prompt = await _pickPrompt(current: current);
    if (prompt == null || !mounted) return;
    setState(() => _items[index] = (prompt, controller));
  }

  void _remove(int index) {
    final (_, controller) = _items.removeAt(index);
    controller.dispose();
    setState(() {});
  }

  Future<void> _save() async {
    final answers = [
      for (final (prompt, controller) in _items)
        if (controller.text.trim().isNotEmpty)
          PromptAnswer(prompt: prompt, answer: controller.text.trim()),
    ];
    final saved = await ref.read(promptsEditorProvider.notifier).save(answers);
    if (saved == true) widget.onSaved();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final editor = ref.watch(promptsEditorProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.promptsIntro, style: context.textTheme.bodySmall),
        SizedBox(height: spacing.md),
        for (final (i, (prompt, controller)) in _items.indexed)
          Padding(
            padding: EdgeInsets.only(bottom: spacing.md),
            child: GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _change(i),
                          child: Text(
                            l10n.prompt(prompt.name),
                            style: context.textTheme.labelLarge?.copyWith(
                              color: colors.cyan,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: l10n.promptsRemove,
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => _remove(i),
                      ),
                    ],
                  ),
                  TextField(
                    controller: controller,
                    maxLength: _maxLength,
                    minLines: 1,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: l10n.promptsAnswerHint,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (_items.length < _max)
          OutlinedButton.icon(
            onPressed: _add,
            icon: const Icon(Icons.add_rounded),
            label: Text(l10n.promptsAdd),
          ),
        FormErrorText(error: editor.error),
        SizedBox(height: spacing.lg),
        NeonButton(
          label: l10n.saveButton,
          isLoading: editor.isLoading,
          onPressed: editor.isLoading ? null : _save,
        ),
      ],
    );
  }
}
