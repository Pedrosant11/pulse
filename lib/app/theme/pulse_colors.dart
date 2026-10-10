import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/models/app_mode.dart';

/// Raw palette from SPEC section 12. Only the theme reads these values;
/// screens use [PulseColors] through `context.colors`.
abstract final class PulsePalette {
  static const background = Color(0xFF0A0A0F);
  static const surface = Color(0xFF14141C);
  static const surfaceElevated = Color(0xFF1E1E2A);
  static const magenta = Color(0xFFFF2BD6);
  static const cyan = Color(0xFF00E5FF);
  static const violet = Color(0xFF7B2CFF);
  static const lime = Color(0xFFC6FF00);
  static const textPrimary = Color(0xFFF5F5F7);
  static const textSecondary = Color(0xFF9A9AB0);
  static const error = Color(0xFFFF4D6D);
  static const success = Color(0xFF2BFF88);
}

@immutable
class PulseColors extends ThemeExtension<PulseColors> {
  const new({
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.magenta,
    required this.cyan,
    required this.violet,
    required this.lime,
    required this.textPrimary,
    required this.textSecondary,
    required this.error,
    required this.success,
    required this.glassFill,
    required this.glassBorder,
  });

  static const dark = PulseColors(
    background: PulsePalette.background,
    surface: PulsePalette.surface,
    surfaceElevated: PulsePalette.surfaceElevated,
    magenta: PulsePalette.magenta,
    cyan: PulsePalette.cyan,
    violet: PulsePalette.violet,
    lime: PulsePalette.lime,
    textPrimary: PulsePalette.textPrimary,
    textSecondary: PulsePalette.textSecondary,
    error: PulsePalette.error,
    success: PulsePalette.success,
    glassFill: Color(0x991E1E2A),
    glassBorder: Color(0x33F5F5F7),
  );

  final Color background;
  final Color surface;
  final Color surfaceElevated;
  final Color magenta;
  final Color cyan;
  final Color violet;
  final Color lime;
  final Color textPrimary;
  final Color textSecondary;
  final Color error;
  final Color success;

  /// Translucent fill for glassmorphism surfaces.
  final Color glassFill;

  /// Neutral fallback border for glass surfaces.
  final Color glassBorder;

  /// Main gradient: violet → magenta (Date / primary actions).
  LinearGradient get primaryGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [violet, magenta],
  );

  /// Crew gradient: violet → cyan.
  LinearGradient get crewGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [violet, cyan],
  );

  /// Accent color for a discovery mode (Date: magenta, Crew: cyan).
  Color accentOf(AppMode mode) => switch (mode) {
    AppMode.date => magenta,
    AppMode.crew => cyan,
  };

  LinearGradient gradientOf(AppMode mode) => switch (mode) {
    AppMode.date => primaryGradient,
    AppMode.crew => crewGradient,
  };

  @override
  PulseColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceElevated,
    Color? magenta,
    Color? cyan,
    Color? violet,
    Color? lime,
    Color? textPrimary,
    Color? textSecondary,
    Color? error,
    Color? success,
    Color? glassFill,
    Color? glassBorder,
  }) {
    return PulseColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      magenta: magenta ?? this.magenta,
      cyan: cyan ?? this.cyan,
      violet: violet ?? this.violet,
      lime: lime ?? this.lime,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      error: error ?? this.error,
      success: success ?? this.success,
      glassFill: glassFill ?? this.glassFill,
      glassBorder: glassBorder ?? this.glassBorder,
    );
  }

  @override
  PulseColors lerp(PulseColors? other, double t) {
    if (other == null) return this;
    return PulseColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      magenta: Color.lerp(magenta, other.magenta, t)!,
      cyan: Color.lerp(cyan, other.cyan, t)!,
      violet: Color.lerp(violet, other.violet, t)!,
      lime: Color.lerp(lime, other.lime, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      glassFill: Color.lerp(glassFill, other.glassFill, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
    );
  }
}
