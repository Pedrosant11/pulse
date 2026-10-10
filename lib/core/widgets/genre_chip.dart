import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';

/// Selectable music-genre chip. Glows in [accent] when selected.
class GenreChip extends StatelessWidget {
  const new({
    required this.label,
    this.selected = false,
    this.onSelected,
    this.accent,
    super.key,
  });

  final String label;
  final bool selected;

  /// Receives the new selection state. `null` makes the chip read-only.
  final ValueChanged<bool>? onSelected;

  /// Defaults to magenta.
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final color = accent ?? colors.magenta;
    final onSelected = this.onSelected;

    return Semantics(
      button: onSelected != null,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onSelected == null ? null : () => onSelected(!selected),
        child: AnimatedContainer(
          duration: context.reduceMotion
              ? Duration.zero
              : const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: spacing.md,
            vertical: spacing.xs,
          ),
          decoration: BoxDecoration(
            color: selected ? color.withValues(alpha: 0.16) : colors.surface,
            borderRadius: BorderRadius.circular(context.radii.pill),
            border: Border.all(color: selected ? color : colors.glassBorder),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.35),
                      blurRadius: 12,
                    ),
                  ]
                : const [],
          ),
          child: Text(
            label,
            style: context.textTheme.labelMedium?.copyWith(
              color: selected ? color : colors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
