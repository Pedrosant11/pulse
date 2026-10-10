import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/state_views.dart';

/// The Pulse logo: a neon ring with a heartbeat line (the mark) and the
/// "PULSE" wordmark. Drawn in code with the theme colors, so it is sharp at
/// any size; replace [PulseMark]'s painter to adopt an official artwork.
class PulseLogo extends StatelessWidget {
  const new({
    this.markSize = 40,
    this.vertical = false,
    this.beating = false,
    super.key,
  });

  final double markSize;

  /// Mark above the wordmark (splash) instead of side by side.
  final bool vertical;

  /// The mark pulses in a loop (off with reduced motion).
  final bool beating;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final mark = PulseMark(size: markSize, beating: beating);
    final wordmark = ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: colors.primaryGradient.createShader,
      child: Text(
        context.l10n.appTitle.toUpperCase(),
        style:
            (vertical
                    ? context.textTheme.displayMedium
                    : context.textTheme.headlineSmall)
                ?.copyWith(letterSpacing: markSize * 0.06),
      ),
    );

    return Semantics(
      label: context.l10n.appTitle,
      excludeSemantics: true,
      child: vertical
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                mark,
                SizedBox(height: spacing.md),
                wordmark,
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                mark,
                SizedBox(width: spacing.sm),
                wordmark,
              ],
            ),
    );
  }
}

/// The mark alone (ring + heartbeat line).
class PulseMark extends StatefulWidget {
  const new({this.size = 40, this.beating = false, super.key});

  final double size;
  final bool beating;

  @override
  State<PulseMark> createState() => _PulseMarkState();
}

class _PulseMarkState extends State<PulseMark>
    with SingleTickerProviderStateMixin {
  late final _beat = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final run = widget.beating && !context.reduceMotion;
    if (run && !_beat.isAnimating) {
      unawaited(
        LoopingAnimations.enabled ? _beat.repeat() : _beat.forward(from: 0),
      );
    } else if (!run && _beat.isAnimating) {
      _beat.stop();
    }
  }

  @override
  void dispose() {
    _beat.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _beat,
        builder: (_, _) {
          // Two quick beats then rest, like a heartbeat.
          final t = _beat.value;
          final pulse = t < 0.15
              ? Curves.easeOut.transform(t / 0.15)
              : t < 0.3
              ? 1 - Curves.easeIn.transform((t - 0.15) / 0.15)
              : t < 0.42
              ? 0.6 * Curves.easeOut.transform((t - 0.3) / 0.12)
              : t < 0.6
              ? 0.6 * (1 - Curves.easeIn.transform((t - 0.42) / 0.18))
              : 0.0;
          return Transform.scale(
            scale: 1 + pulse * 0.06,
            child: CustomPaint(
              size: Size.square(widget.size),
              painter: _MarkPainter(
                ringA: colors.violet,
                ringB: colors.magenta,
                line: colors.textPrimary,
                glow: colors.magenta,
                intensity: pulse,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MarkPainter extends CustomPainter {
  new({
    required this.ringA,
    required this.ringB,
    required this.line,
    required this.glow,
    required this.intensity,
  });

  final Color ringA;
  final Color ringB;
  final Color line;
  final Color glow;

  /// 0..1 while beating: brighter glow.
  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final center = size.center(Offset.zero);
    final stroke = s * 0.085;
    final radius = s / 2 - stroke;
    final bounds = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      colors: [ringA, ringB, ringA],
      transform: const GradientRotation(-1.2),
    ).createShader(bounds);

    // Glow behind the ring, then the ring.
    canvas
      ..drawCircle(
        center,
        radius,
        Paint()
          ..color = glow.withValues(alpha: 0.35 + 0.3 * intensity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke * 1.6
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, s * 0.08),
      )
      ..drawCircle(
        center,
        radius,
        Paint()
          ..shader = gradient
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke,
      );

    // Heartbeat line across the ring: flat, small bump, tall spike, deep
    // dip, small bump, flat.
    Offset p(double x, double y) =>
        Offset(center.dx + x * radius, center.dy + y * radius);
    final path = Path()
      ..moveTo(p(-0.72, 0).dx, p(-0.72, 0).dy)
      ..lineTo(p(-0.38, 0).dx, p(-0.38, 0).dy)
      ..lineTo(p(-0.26, -0.16).dx, p(-0.26, -0.16).dy)
      ..lineTo(p(-0.14, 0).dx, p(-0.14, 0).dy)
      ..lineTo(p(-0.04, 0.12).dx, p(-0.04, 0.12).dy)
      ..lineTo(p(0.08, -0.58).dx, p(0.08, -0.58).dy)
      ..lineTo(p(0.22, 0.42).dx, p(0.22, 0.42).dy)
      ..lineTo(p(0.32, 0).dx, p(0.32, 0).dy)
      ..lineTo(p(0.72, 0).dx, p(0.72, 0).dy);
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke * 0.9
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas
      ..drawPath(
        path,
        Paint()
          ..color = glow.withValues(alpha: 0.5 + 0.4 * intensity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke * 1.4
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, s * 0.05),
      )
      ..drawPath(path, linePaint..color = line);
  }

  @override
  bool shouldRepaint(_MarkPainter old) =>
      old.intensity != intensity ||
      old.ringA != ringA ||
      old.ringB != ringB ||
      old.line != line;
}
