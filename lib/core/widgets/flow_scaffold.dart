import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/neon_backdrop.dart';
import 'package:pulse/core/widgets/pulse_logo.dart';
import 'package:pulse/core/widgets/step_progress_bar.dart';

/// Layout shared by the auth screens: neon backdrop, big title, optional
/// sign-up progress and a scrollable column of [children].
class FlowScaffold extends StatelessWidget {
  const new({
    required this.title,
    required this.children,
    this.subtitle,
    this.step,
    this.totalSteps = 3,
    this.onBack,
    this.actions = const [],
    this.showLogo = false,
    super.key,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;

  /// Current sign-up step (1-based); shows the progress bar when set.
  final int? step;
  final int totalSteps;

  /// Custom back action; defaults to the navigator's.
  final VoidCallback? onBack;
  final List<Widget> actions;

  /// Pulse logo above the title (entry screens: login, sign-up…).
  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final step = this.step;
    final subtitle = this.subtitle;

    Widget header = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLogo) ...[
          const PulseLogo(markSize: 44),
          SizedBox(height: spacing.xl),
        ],
        if (step != null) ...[
          StepProgressBar(current: step, total: totalSteps),
          SizedBox(height: spacing.xs),
          Text(
            context.l10n.signupStep(step, totalSteps),
            style: context.textTheme.labelSmall,
          ),
          SizedBox(height: spacing.lg),
        ],
        Text(title.toUpperCase(), style: context.textTheme.headlineMedium),
        if (subtitle != null) ...[
          SizedBox(height: spacing.xs),
          Text(
            subtitle,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
        SizedBox(height: spacing.xl),
      ],
    );
    if (!context.reduceMotion) {
      header = header.animate().fadeIn(duration: 300.ms).slideY(begin: 0.05);
    }

    return NeonBackdrop(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: onBack == null ? null : BackButton(onPressed: onBack),
          actions: actions,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(spacing.lg, 0, spacing.lg, spacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [header, ...children],
            ),
          ),
        ),
      ),
    );
  }
}
