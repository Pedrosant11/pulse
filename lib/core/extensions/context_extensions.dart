import 'package:material_ui/material_ui.dart';
import 'package:pulse/app/theme/pulse_colors.dart';
import 'package:pulse/app/theme/pulse_dimens.dart';
import 'package:pulse/l10n/app_localizations.dart';

extension PulseContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;

  PulseColors get colors => Theme.of(this).extension<PulseColors>()!;
  PulseSpacing get spacing => Theme.of(this).extension<PulseSpacing>()!;
  PulseRadii get radii => Theme.of(this).extension<PulseRadii>()!;

  AppLocalizations get l10n => AppLocalizations.of(this);

  /// True when the system asks for reduced motion. Heavy effects (shaders,
  /// long animations) must be reduced or turned off (SPEC 12).
  bool get reduceMotion => MediaQuery.disableAnimationsOf(this);
}
