import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';

/// Primary call-to-action: gradient pill with a soft glow that intensifies
/// while pressed.
class NeonButton extends StatefulWidget {
  const new({
    required this.label,
    required this.onPressed,
    this.icon,
    this.gradient,
    this.isLoading = false,
    super.key,
  });

  final String label;

  /// `null` disables the button.
  final VoidCallback? onPressed;
  final IconData? icon;

  /// Defaults to the primary gradient (violet → magenta).
  final LinearGradient? gradient;
  final bool isLoading;

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

/// WCAG AA for the label (4.5:1, SPEC 13).
const _minContrast = 4.6;

double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

/// Darkens each stop only as much as needed for [text] to stay readable on
/// it (bright neon like cyan needs more); the glow keeps the pure colors.
LinearGradient _readableFill(
  LinearGradient gradient,
  Color text,
  Color background,
) {
  Color darken(Color color) {
    var result = color;
    for (
      var t = 0.05;
      _contrast(result, text) < _minContrast && t <= 0.8;
      t += 0.05
    ) {
      result = Color.lerp(color, background, t)!;
    }
    return result;
  }

  return LinearGradient(
    begin: gradient.begin,
    end: gradient.end,
    stops: gradient.stops,
    colors: [for (final c in gradient.colors) darken(c)],
  );
}

class _NeonButtonState extends State<NeonButton> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final gradient = widget.gradient ?? colors.primaryGradient;
    final glow = gradient.colors.last;
    final duration = context.reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 160);
    final foreground = _enabled ? colors.textPrimary : colors.textSecondary;

    return Semantics(
      button: true,
      enabled: _enabled,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _enabled ? (_) => _setPressed(true) : null,
        onTapUp: _enabled ? (_) => _setPressed(false) : null,
        onTapCancel: _enabled ? () => _setPressed(false) : null,
        onTap: _enabled ? widget.onPressed : null,
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1,
          duration: duration,
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: duration,
            height: 52,
            padding: EdgeInsets.symmetric(horizontal: spacing.lg),
            decoration: BoxDecoration(
              gradient: _enabled
                  ? _readableFill(gradient, foreground, colors.background)
                  : null,
              color: _enabled ? null : colors.surfaceElevated,
              borderRadius: BorderRadius.circular(context.radii.pill),
              boxShadow: _enabled
                  ? [
                      BoxShadow(
                        color: glow.withValues(alpha: _pressed ? 0.55 : 0.3),
                        blurRadius: _pressed ? 28 : 18,
                        spreadRadius: _pressed ? 1 : 0,
                      ),
                    ]
                  : const [],
            ),
            child: Center(
              child: widget.isLoading
                  ? SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.textPrimary,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, size: 20, color: foreground),
                          SizedBox(width: spacing.xs),
                        ],
                        Flexible(
                          child: Text(
                            widget.label,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.labelLarge?.copyWith(
                              color: foreground,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
