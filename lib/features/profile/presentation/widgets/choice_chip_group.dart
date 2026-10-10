import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/genre_chip.dart';

/// Wrap of selectable chips. Single choice can be cleared by tapping the
/// selected chip again (optional fields).
class ChoiceChipGroup<T> extends StatelessWidget {
  const new({
    required this.options,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
    this.multiple = false,
    this.accent,
    super.key,
  });

  final List<T> options;
  final Set<T> selected;
  final String Function(T option) labelOf;
  final ValueChanged<Set<T>> onChanged;
  final bool multiple;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: context.spacing.xs,
      runSpacing: context.spacing.xs,
      children: [
        for (final option in options)
          GenreChip(
            label: labelOf(option),
            selected: selected.contains(option),
            accent: accent,
            onSelected: (isSelected) {
              if (multiple) {
                onChanged(
                  isSelected
                      ? {...selected, option}
                      : ({...selected}..remove(option)),
                );
              } else {
                onChanged(isSelected ? {option} : <T>{});
              }
            },
          ),
      ],
    );
  }
}

/// Section label used inside the profile forms.
class FieldLabel extends StatelessWidget {
  const new(this.text, {this.trailing, super.key});

  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final trailing = this.trailing;
    return Padding(
      padding: EdgeInsets.only(
        top: context.spacing.lg,
        bottom: context.spacing.xs,
      ),
      child: Row(
        children: [
          Expanded(child: Text(text, style: context.textTheme.labelLarge)),
          ?trailing,
        ],
      ),
    );
  }
}
