import 'package:material_ui/material_ui.dart';

/// Bundled font families (assets/fonts, OFL licensed).
abstract final class PulseFonts {
  /// Headlines and highlights (uppercase in emphasis spots).
  static const display = 'Unbounded';

  /// Body text.
  static const body = 'Inter';
}

/// Text theme: Unbounded for display/headline/title, Inter for the rest.
TextTheme buildPulseTextTheme(Color primary, Color secondary) {
  TextStyle display(double size, FontWeight weight, {double height = 1.15}) =>
      TextStyle(
        fontFamily: PulseFonts.display,
        fontSize: size,
        fontWeight: weight,
        height: height,
        color: primary,
        letterSpacing: -0.2,
      );

  TextStyle body(
    double size,
    FontWeight weight, {
    Color? color,
    double height = 1.4,
    double letterSpacing = 0,
  }) => TextStyle(
    fontFamily: PulseFonts.body,
    fontSize: size,
    fontWeight: weight,
    height: height,
    color: color ?? primary,
    letterSpacing: letterSpacing,
  );

  return TextTheme(
    displayLarge: display(48, FontWeight.w800),
    displayMedium: display(40, FontWeight.w800),
    displaySmall: display(32, FontWeight.w700),
    headlineLarge: display(28, FontWeight.w700),
    headlineMedium: display(24, FontWeight.w700),
    headlineSmall: display(20, FontWeight.w600),
    titleLarge: display(18, FontWeight.w600, height: 1.25),
    titleMedium: body(16, FontWeight.w600),
    titleSmall: body(14, FontWeight.w600),
    bodyLarge: body(16, FontWeight.w400),
    bodyMedium: body(14, FontWeight.w400),
    bodySmall: body(12, FontWeight.w400, color: secondary),
    labelLarge: body(14, FontWeight.w600, letterSpacing: 0.2),
    labelMedium: body(12, FontWeight.w600, letterSpacing: 0.3),
    labelSmall: body(11, FontWeight.w500, color: secondary, letterSpacing: 0.4),
  );
}
