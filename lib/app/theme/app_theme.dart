import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/pulse_colors.dart';
import 'package:pulse/app/theme/pulse_dimens.dart';
import 'package:pulse/app/theme/pulse_typography.dart';

abstract final class AppTheme {
  /// The app is dark-only (SPEC 12: "pista de dança à noite").
  static ThemeData dark() {
    const colors = PulseColors.dark;
    const spacing = PulseSpacing.regular;
    const radii = PulseRadii.regular;
    final textTheme = buildPulseTextTheme(
      colors.textPrimary,
      colors.textSecondary,
    );

    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: colors.magenta,
      onPrimary: colors.textPrimary,
      primaryContainer: colors.violet,
      onPrimaryContainer: colors.textPrimary,
      secondary: colors.cyan,
      onSecondary: colors.background,
      tertiary: colors.lime,
      onTertiary: colors.background,
      error: colors.error,
      onError: colors.background,
      surface: colors.surface,
      onSurface: colors.textPrimary,
      onSurfaceVariant: colors.textSecondary,
      surfaceContainerLowest: colors.background,
      surfaceContainerLow: colors.surface,
      surfaceContainer: colors.surface,
      surfaceContainerHigh: colors.surfaceElevated,
      surfaceContainerHighest: colors.surfaceElevated,
      outline: colors.textSecondary,
      outlineVariant: colors.glassBorder,
    );

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(radii.md),
      borderSide: BorderSide(color: colors.glassBorder),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.background,
      canvasColor: colors.background,
      fontFamily: PulseFonts.body,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        foregroundColor: colors.textPrimary,
        titleTextStyle: textTheme.headlineSmall,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        hintStyle: textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
        contentPadding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.md,
        ),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: colors.magenta, width: 1.5),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: colors.error),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: colors.error, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          // Height only; full width comes from the parent (stretch).`n          // An infinite minimum width breaks buttons inside rows.`n          minimumSize: const Size(64, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radii.pill),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          // Height only; full width comes from the parent (stretch).`n          // An infinite minimum width breaks buttons inside rows.`n          minimumSize: const Size(64, 52),
          foregroundColor: colors.textPrimary,
          side: BorderSide(color: colors.glassBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radii.pill),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.textSecondary,
          textStyle: textTheme.labelLarge,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colors.surfaceElevated,
        contentTextStyle: textTheme.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radii.md),
        ),
      ),
      dividerTheme: DividerThemeData(color: colors.glassBorder, thickness: 1),
      extensions: const [colors, spacing, radii],
    );
  }
}
