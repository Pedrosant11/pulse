import 'package:material_ui/material_ui.dart';

/// Spacing scale. Screens read it through `context.spacing`.
@immutable
class PulseSpacing extends ThemeExtension<PulseSpacing> {
  const new({
    this.xxs = 4,
    this.xs = 8,
    this.sm = 12,
    this.md = 16,
    this.lg = 24,
    this.xl = 32,
    this.xxl = 48,
  });

  static const regular = PulseSpacing();

  final double xxs;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  @override
  PulseSpacing copyWith({
    double? xxs,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
  }) {
    return PulseSpacing(
      xxs: xxs ?? this.xxs,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
    );
  }

  @override
  PulseSpacing lerp(PulseSpacing? other, double t) {
    if (other == null) return this;
    return PulseSpacing(
      xxs: _lerp(xxs, other.xxs, t),
      xs: _lerp(xs, other.xs, t),
      sm: _lerp(sm, other.sm, t),
      md: _lerp(md, other.md, t),
      lg: _lerp(lg, other.lg, t),
      xl: _lerp(xl, other.xl, t),
      xxl: _lerp(xxl, other.xxl, t),
    );
  }
}

/// Corner radii and blur amounts. Screens read it through `context.radii`.
@immutable
class PulseRadii extends ThemeExtension<PulseRadii> {
  const new({
    this.sm = 8,
    this.md = 16,
    this.lg = 24,
    this.xl = 32,
    this.pill = 999,
    this.glassBlur = 18,
  });

  static const regular = PulseRadii();

  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double pill;

  /// Sigma used by glassmorphism surfaces.
  final double glassBlur;

  @override
  PulseRadii copyWith({
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? pill,
    double? glassBlur,
  }) {
    return PulseRadii(
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      pill: pill ?? this.pill,
      glassBlur: glassBlur ?? this.glassBlur,
    );
  }

  @override
  PulseRadii lerp(PulseRadii? other, double t) {
    if (other == null) return this;
    return PulseRadii(
      sm: _lerp(sm, other.sm, t),
      md: _lerp(md, other.md, t),
      lg: _lerp(lg, other.lg, t),
      xl: _lerp(xl, other.xl, t),
      pill: _lerp(pill, other.pill, t),
      glassBlur: _lerp(glassBlur, other.glassBlur, t),
    );
  }
}

double _lerp(double a, double b, double t) => a + (b - a) * t;
