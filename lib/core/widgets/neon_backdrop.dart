import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/shader_effects.dart';

/// Dark background with neon smoke (`shaders/neon_background.frag`), used
/// on splash, login and onboarding. Static light spots while the shader
/// loads, with reduced motion, or when [animated] is false (e.g. behind
/// another effect).
class NeonBackdrop extends StatelessWidget {
  const new({required this.child, this.animated = true, super.key});

  final Widget child;
  final bool animated;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const still = _StaticBackdrop();
    return Stack(
      fit: StackFit.expand,
      children: [
        if (animated)
          AnimatedShader(
            asset: Shaders.neonBackground,
            fallback: still,
            setUniforms: (shader, size, seconds) {
              var i = shader.setSize(0, size);
              shader.setFloat(i++, seconds);
              i = shader.setColor(i, colors.background);
              i = shader.setColor(i, colors.violet);
              i = shader.setColor(i, colors.magenta);
              shader.setColor(i, colors.cyan);
            },
          )
        else
          still,
        child,
      ],
    );
  }
}

class _StaticBackdrop extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return RepaintBoundary(
      child: ColoredBox(
        color: colors.background,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(-0.9, -0.9),
              radius: 1.3,
              colors: [
                colors.violet.withValues(alpha: 0.38),
                colors.violet.withValues(alpha: 0),
              ],
            ),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(1, 0.85),
                radius: 1.1,
                colors: [
                  colors.magenta.withValues(alpha: 0.24),
                  colors.magenta.withValues(alpha: 0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
