import 'dart:async';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/errors/app_failure_message.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/core/widgets/neon_button.dart';

/// Skeleton block with a shimmer sweep (static when motion is reduced).
class ShimmerBox extends StatelessWidget {
  const new({this.width, this.height = 16, this.radius, super.key});

  final double? width;
  final double height;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final box = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(radius ?? context.radii.sm),
      ),
    );
    if (context.reduceMotion) return box;
    return box
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: 1400.ms,
          color: colors.textPrimary.withValues(alpha: 0.08),
        );
  }
}

/// Generic loading state: a few skeleton cards.
class LoadingView extends StatelessWidget {
  const new({this.itemCount = 3, super.key});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Semantics(
      label: context.l10n.stateLoading,
      liveRegion: true,
      child: ExcludeSemantics(
        child: ListView.separated(
          padding: EdgeInsets.all(spacing.md),
          // Not scrollable and sized to its content, so it also works
          // inside scrolling screens (forms, lists).
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: itemCount,
          separatorBuilder: (_, _) => SizedBox(height: spacing.md),
          itemBuilder: (_, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(height: 160, radius: context.radii.lg),
              SizedBox(height: spacing.sm),
              const ShimmerBox(width: 180),
              SizedBox(height: spacing.xs),
              const ShimmerBox(width: 120, height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

/// Empty state with an icon, a message and an optional call to action.
class EmptyView extends StatelessWidget {
  const new({
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final actionLabel = this.actionLabel;
    final message = this.message;
    final colors = context.colors;
    final spacing = context.spacing;

    final badge = DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.surfaceElevated,
        boxShadow: [
          BoxShadow(
            color: colors.violet.withValues(alpha: 0.4),
            blurRadius: 32,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Icon(icon, size: 40, color: colors.magenta),
      ),
    );

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (context.reduceMotion)
          badge
        else
          _PulseRings(color: colors.magenta, child: badge),
        SizedBox(height: spacing.lg),
        Text(
          title,
          textAlign: TextAlign.center,
          style: context.textTheme.headlineSmall,
        ),
        if (message != null) ...[
          SizedBox(height: spacing.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
        if (actionLabel != null && onAction != null) ...[
          SizedBox(height: spacing.lg),
          NeonButton(label: actionLabel, onPressed: onAction),
        ],
      ],
    );

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.xl),
        child: context.reduceMotion
            ? content
            : content
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .scaleXY(begin: 0.96, curve: Curves.easeOut),
      ),
    );
  }
}

/// Error state with a friendly message and a retry button.
class ErrorView extends StatelessWidget {
  const new({required this.error, this.onRetry, super.key});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return EmptyView(
      icon: Icons.wifi_tethering_error_rounded,
      title: l10n.stateErrorTitle,
      message: friendlyErrorMessage(error, l10n),
      actionLabel: onRetry == null ? null : l10n.stateRetry,
      onAction: onRetry,
    );
  }
}

/// Renders an [AsyncValue] with the standard loading and error states.
class AsyncValueView<T> extends StatelessWidget {
  const new({
    required this.value,
    required this.data,
    this.onRetry,
    this.loading,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;
  final Widget? loading;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () => loading ?? const LoadingView(),
      error: (error, _) => ErrorView(error: error, onRetry: onRetry),
    );
  }
}

/// Test switch for looping decorations (widget tests can't settle while
/// something animates forever; see `test/flutter_test_config.dart`).
abstract final class LoopingAnimations {
  /// Only widget tests turn it off.
  static bool enabled = true;
}

/// Empty-state illustration: neon rings pulse out of [child] in a loop.
/// The ticker pauses off screen (TickerMode) and stops on dispose.
class _PulseRings extends StatefulWidget {
  const new({required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  State<_PulseRings> createState() => _PulseRingsState();
}

class _PulseRingsState extends State<_PulseRings>
    with SingleTickerProviderStateMixin {
  bool _halfway = false;

  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void initState() {
    super.initState();
    unawaited(_play());
  }

  Future<void> _play() async {
    try {
      if (LoopingAnimations.enabled) {
        await _controller.repeat().orCancel;
      } else {
        await _controller.forward(from: 0).orCancel;
      }
    } on TickerCanceled {
      // Disposed mid-animation.
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget ring(double phase) => Positioned.fill(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, _) {
          final t = (_controller.value + phase) % 1;
          // The second ring starts once the first one is halfway out.
          _halfway = _halfway || _controller.value >= 0.5;
          final visible = _controller.isAnimating && (phase == 0 || _halfway);
          final eased = Curves.easeOut.transform(t);
          return Opacity(
            opacity: visible ? (1 - t) * 0.6 : 0,
            child: Transform.scale(
              scale: 1 + eased * 0.8,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: widget.color, width: 2),
                ),
              ),
            ),
          );
        },
      ),
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [ring(0), ring(0.5), widget.child],
    );
  }
}
