import 'dart:ui' show ImageFilter;

import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';

/// Subtle glassmorphism surface: background blur, translucent fill and a 1px
/// gradient border (SPEC 12).
class GlassCard extends StatelessWidget {
  const new({
    required this.child,
    this.padding,
    this.radius,
    this.borderGradient,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? radius;

  /// Defaults to a light-to-violet gradient.
  final Gradient? borderGradient;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radii = context.radii;
    final borderRadius = BorderRadius.circular(radius ?? radii.lg);
    final gradient =
        borderGradient ??
        LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.textPrimary.withValues(alpha: 0.28),
            colors.violet.withValues(alpha: 0.24),
            colors.textPrimary.withValues(alpha: 0.05),
          ],
        );

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: radii.glassBlur,
          sigmaY: radii.glassBlur,
        ),
        child: CustomPaint(
          foregroundPainter: _GradientBorderPainter(
            gradient: gradient,
            borderRadius: borderRadius,
          ),
          child: ColoredBox(
            color: colors.glassFill,
            // Lets ListTiles/InkWells inside the card paint their splashes.
            child: Material(
              type: MaterialType.transparency,
              child: Padding(
                padding: padding ?? EdgeInsets.all(context.spacing.md),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  new({required this.gradient, required this.borderRadius});

  final Gradient gradient;
  final BorderRadius borderRadius;
  static const _strokeWidth = 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = borderRadius.toRRect(rect).deflate(_strokeWidth / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..shader = gradient.createShader(rect);
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_GradientBorderPainter oldDelegate) =>
      oldDelegate.gradient != gradient ||
      oldDelegate.borderRadius != borderRadius;
}
