import 'dart:ui' show FragmentProgram;

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/core/widgets/neon_backdrop.dart';
import 'package:pulse/core/widgets/shader_effects.dart';

void main() {
  setUp(() {
    Shaders.clearCache();
    Shaders.enabled = true;
  });
  tearDown(() => Shaders.enabled = false);

  test('every shader compiles and loads', () async {
    for (final asset in [
      Shaders.neonBackground,
      Shaders.matchBurst,
      Shaders.glitch,
    ]) {
      final program = await FragmentProgram.fromAsset(asset);
      program.fragmentShader().dispose();
    }
  });

  Widget app({required bool reduceMotion}) => MaterialApp(
    theme: AppTheme.dark(),
    home: MediaQuery(
      data: MediaQueryData(disableAnimations: reduceMotion),
      child: const NeonBackdrop(child: Text('conteúdo')),
    ),
  );

  Finder shaderPaint() => find.descendant(
    of: find.byType(AnimatedShader),
    matching: find.byType(CustomPaint),
  );

  testWidgets('the backdrop paints the smoke shader with its uniforms', (
    tester,
  ) async {
    await tester.pumpWidget(app(reduceMotion: false));
    // Loading the program is real async work.
    await tester.runAsync(() => Shaders.load(Shaders.neonBackground));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(shaderPaint(), findsOneWidget);
    expect(tester.takeException(), isNull);
    expect(find.text('conteúdo'), findsOneWidget);

    // Stops the ticker before the test ends.
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('reduced motion keeps the static background', (tester) async {
    await tester.pumpWidget(app(reduceMotion: true));
    await tester.runAsync(() => Shaders.load(Shaders.neonBackground));
    await tester.pump();

    expect(shaderPaint(), findsNothing);
    expect(find.text('conteúdo'), findsOneWidget);
  });
}
