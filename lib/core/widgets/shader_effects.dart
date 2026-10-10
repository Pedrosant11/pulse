import 'dart:async';
import 'dart:ui' show FragmentProgram, FragmentShader;

import 'package:flutter/scheduler.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';

/// Fragment shaders from `shaders/` (SPEC 12), loaded once and cached.
abstract final class Shaders {
  static const neonBackground = 'shaders/neon_background.frag';
  static const matchBurst = 'shaders/match_burst.frag';
  static const glitch = 'shaders/glitch.frag';

  /// Widget tests turn shaders off: their tickers never settle
  /// (see `test/flutter_test_config.dart`).
  @visibleForTesting
  static bool enabled = true;

  static final _programs = <String, Future<FragmentProgram>>{};

  /// Each widget test runs in its own fake-async zone; a Future cached by an
  /// earlier test never completes in the next one.
  @visibleForTesting
  static void clearCache() => _programs.clear();

  static Future<FragmentProgram> load(String asset) =>
      _programs.putIfAbsent(asset, () => FragmentProgram.fromAsset(asset));
}

/// Sets shader uniforms by index (in declaration order in the `.frag`).
extension ShaderUniforms on FragmentShader {
  /// Sets `vec2 uSize` and returns the next index.
  int setSize(int index, Size size) {
    setFloat(index, size.width);
    setFloat(index + 1, size.height);
    return index + 2;
  }

  /// Sets a `vec4` color (straight alpha) and returns the next index.
  int setColor(int index, Color color) {
    setFloat(index, color.r);
    setFloat(index + 1, color.g);
    setFloat(index + 2, color.b);
    setFloat(index + 3, color.a);
    return index + 4;
  }
}

typedef ShaderUniformSetter = void Function(
  FragmentShader shader,
  Size size,
  double seconds,
);

/// Paints [asset] full-size, animated by elapsed time. Shows [fallback]
/// while loading, if the shader fails, and when the user asked to reduce
/// motion. Wrapped in a RepaintBoundary so only this layer repaints.
class AnimatedShader extends StatefulWidget {
  const new({
    required this.asset,
    required this.setUniforms,
    required this.fallback,
    super.key,
  });

  final String asset;
  final ShaderUniformSetter setUniforms;
  final Widget fallback;

  @override
  State<AnimatedShader> createState() => _AnimatedShaderState();
}

class _AnimatedShaderState extends State<AnimatedShader>
    with SingleTickerProviderStateMixin {
  final _seconds = ValueNotifier<double>(0);
  late final Ticker _ticker = createTicker(
    (elapsed) => _seconds.value = elapsed.inMicroseconds / 1e6,
  );
  FragmentShader? _shader;

  @override
  void initState() {
    super.initState();
    if (!Shaders.enabled) return;
    unawaited(_load());
  }

  Future<void> _load() async {
    try {
      final program = await Shaders.load(widget.asset);
      if (!mounted) return;
      setState(() => _shader = program.fragmentShader());
    } on Object catch (error) {
      // The static fallback stays on screen.
      debugPrint('Shader ${widget.asset} unavailable: $error');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncTicker();
  }

  void _syncTicker() {
    final run = _shader != null && !context.reduceMotion;
    if (run && !_ticker.isActive) _ticker.start();
    if (!run && _ticker.isActive) _ticker.stop();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _seconds.dispose();
    _shader?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shader = _shader;
    _syncTicker();
    if (shader == null || context.reduceMotion) return widget.fallback;
    return RepaintBoundary(
      child: CustomPaint(
        size: Size.infinite,
        painter: _ShaderPainter(
          shader: shader,
          repaint: _seconds,
          setUniforms: (shader, size) =>
              widget.setUniforms(shader, size, _seconds.value),
        ),
      ),
    );
  }
}

class _ShaderPainter extends CustomPainter {
  new({
    required this.shader,
    required this.setUniforms,
    required super.repaint,
  });

  final FragmentShader shader;
  final void Function(FragmentShader shader, Size size) setUniforms;

  @override
  void paint(Canvas canvas, Size size) {
    setUniforms(shader, size);
    canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(_ShaderPainter oldDelegate) =>
      oldDelegate.shader != shader;
}

/// Plays a short glitch over [child] every time [trigger] changes (SPEC 12,
/// e.g. switching Date/Crew). Nothing happens with reduced motion.
class GlitchTransition extends StatefulWidget {
  const new({
    required this.trigger,
    required this.colors,
    required this.child,
    super.key,
  });

  final Object trigger;

  /// Two neon colors for the bands.
  final (Color, Color) colors;
  final Widget child;

  @override
  State<GlitchTransition> createState() => _GlitchTransitionState();
}

class _GlitchTransitionState extends State<GlitchTransition>
    with SingleTickerProviderStateMixin {
  static const _duration = Duration(milliseconds: 380);

  late final _controller = AnimationController(vsync: this, duration: _duration)
    ..addStatusListener((_) => setState(() {}));
  FragmentShader? _shader;

  @override
  void initState() {
    super.initState();
    if (!Shaders.enabled) return;
    unawaited(_load());
  }

  Future<void> _load() async {
    try {
      final program = await Shaders.load(Shaders.glitch);
      if (mounted) _shader = program.fragmentShader();
    } on Object catch (error) {
      debugPrint('Glitch shader unavailable: $error');
    }
  }

  @override
  void didUpdateWidget(GlitchTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trigger != widget.trigger &&
        _shader != null &&
        !context.reduceMotion) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _shader?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shader = _shader;
    if (shader == null || !_controller.isAnimating) return widget.child;
    final (colorA, colorB) = widget.colors;

    return Stack(
      fit: StackFit.passthrough,
      children: [
        AnimatedBuilder(
          animation: _controller,
          // A few pixels of horizontal jitter while it glitches.
          builder: (_, child) => Transform.translate(
            offset: Offset(
              (_controller.value * 97 % 1 - 0.5) * 8 * (1 - _controller.value),
              0,
            ),
            child: child,
          ),
          child: widget.child,
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: _ShaderPainter(
                  shader: shader,
                  repaint: _controller,
                  setUniforms: (shader, size) {
                    var i = shader.setSize(0, size);
                    shader
                      ..setFloat(
                        i++,
                        _controller.value * _duration.inMilliseconds / 1000,
                      )
                      ..setFloat(i++, 1 - _controller.value);
                    i = shader.setColor(i, colorA);
                    shader.setColor(i, colorB);
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
