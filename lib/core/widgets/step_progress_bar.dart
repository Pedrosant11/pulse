import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';

/// Animated gradient progress for the multi-step sign-up (SPEC 5.1).
class StepProgressBar extends StatelessWidget {
  const new({required this.current, required this.total, super.key});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = BorderRadius.circular(context.radii.pill);
    final progress = (current / total).clamp(0.0, 1.0);

    return Semantics(
      value: context.l10n.signupStep(current, total),
      child: ClipRRect(
        borderRadius: radius,
        child: SizedBox(
          height: 6,
          child: Stack(
            children: [
              Positioned.fill(child: ColoredBox(color: colors.surfaceElevated)),
              TweenAnimationBuilder<double>(
                tween: Tween(end: progress),
                duration: context.reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) => FractionallySizedBox(
                  widthFactor: value,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: colors.primaryGradient,
                      borderRadius: radius,
                      boxShadow: [
                        BoxShadow(
                          color: colors.magenta.withValues(alpha: 0.5),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
