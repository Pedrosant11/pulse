import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/app/theme/app_theme.dart';
import 'package:pulse/app/theme/pulse_colors.dart';
import 'package:pulse/app/theme/pulse_dimens.dart';
import 'package:pulse/app/theme/pulse_typography.dart';
import 'package:pulse/core/models/app_mode.dart';

void main() {
  final theme = AppTheme.dark();

  test('registers the design-system extensions', () {
    expect(theme.extension<PulseColors>(), isNotNull);
    expect(theme.extension<PulseSpacing>(), isNotNull);
    expect(theme.extension<PulseRadii>(), isNotNull);
  });

  test('uses the SPEC palette', () {
    expect(theme.scaffoldBackgroundColor, PulsePalette.background);
    expect(theme.colorScheme.primary, PulsePalette.magenta);
    expect(theme.colorScheme.secondary, PulsePalette.cyan);
    expect(theme.colorScheme.error, PulsePalette.error);
  });

  test('accent follows the discovery mode', () {
    const colors = PulseColors.dark;
    expect(colors.accentOf(AppMode.date), PulsePalette.magenta);
    expect(colors.accentOf(AppMode.crew), PulsePalette.cyan);
    expect(colors.gradientOf(AppMode.date).colors, [
      PulsePalette.violet,
      PulsePalette.magenta,
    ]);
    expect(colors.gradientOf(AppMode.crew).colors, [
      PulsePalette.violet,
      PulsePalette.cyan,
    ]);
  });

  test('headlines use Unbounded and body uses Inter', () {
    expect(theme.textTheme.headlineMedium?.fontFamily, PulseFonts.display);
    expect(theme.textTheme.bodyMedium?.fontFamily, PulseFonts.body);
  });

  test('extensions lerp between themselves', () {
    const colors = PulseColors.dark;
    expect(colors.lerp(colors, 0.5).magenta, colors.magenta);
    const spacing = PulseSpacing.regular;
    expect(spacing.lerp(spacing.copyWith(md: 20), 0.5).md, 18);
  });
}
