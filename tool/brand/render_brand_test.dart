// Renders the Pulse mark (lib/core/widgets/pulse_logo.dart) to the PNGs used
// for the launcher icon and the native splash. Not part of the test suite;
// run it after changing the logo:
//
//   flutter test tool/brand/render_brand_test.dart
//   dart run flutter_launcher_icons
//   dart run flutter_native_splash:create
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/core/widgets/pulse_logo.dart';

/// [markFraction] of the canvas taken by the mark; [background] fills it.
Future<void> render(
  WidgetTester tester, {
  required String path,
  required double size,
  required double markFraction,
  Color? background,
}) async {
  final key = GlobalKey();
  tester.view
    ..physicalSize = Size.square(size)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.dark(),
      debugShowCheckedModeBanner: false,
      home: RepaintBoundary(
        key: key,
        child: Container(
          width: size,
          height: size,
          color: background ?? const Color(0x00000000),
          alignment: Alignment.center,
          child: PulseMark(size: size * markFraction),
        ),
      ),
    ),
  );
  await tester.pump();

  final boundary =
      key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  final bytes = await tester.runAsync(() async {
    final image = await boundary.toImage();
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  });
  File(path)
    ..createSync(recursive: true)
    ..writeAsBytesSync(bytes!);
}

void main() {
  testWidgets('render brand assets', (tester) async {
    final background = AppTheme.dark().scaffoldBackgroundColor;
    // Full icon (iOS, legacy Android): dark square, mark in the middle.
    await render(
      tester,
      path: 'assets/brand/icon.png',
      size: 1024,
      markFraction: 0.62,
      background: background,
    );
    // Adaptive icon foreground: transparent, inside the 66% safe zone (the
    // glow may be cropped, the mark never).
    await render(
      tester,
      path: 'assets/brand/icon_foreground.png',
      size: 1024,
      markFraction: 0.62,
    );
    // Native splash image (Android 12 crops it to a circle).
    await render(
      tester,
      path: 'assets/brand/splash.png',
      size: 768,
      markFraction: 0.6,
    );
  });
}
