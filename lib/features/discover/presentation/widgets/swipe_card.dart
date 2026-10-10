import 'dart:async';
import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';
import 'package:pulse/features/discover/domain/discover_models.dart';

/// Lets the action buttons fling the top card.
class SwipeCardController {
  _SwipeCardState? _state;

  /// Animates the card out; [SwipeCard.onSwiped] fires at the end.
  Future<void> swipe(SwipeDirection direction) async {
    await _state?._flingOut(direction);
  }
}

/// Card with hand-made swipe physics (SPEC 8.2): follows the finger, rotates
/// proportionally to the drag, shows the like/pass stamps with progressive
/// opacity, flings out past a threshold (distance or velocity) and springs
/// back otherwise. Dragging up opens the full profile.
class SwipeCard extends StatefulWidget {
  const new({
    required this.child,
    required this.onSwiped,
    required this.onOpenProfile,
    required this.likeStamp,
    required this.passStamp,
    required this.likeColor,
    this.controller,
    super.key,
  });

  final Widget child;
  final ValueChanged<SwipeDirection> onSwiped;
  final VoidCallback onOpenProfile;
  final String likeStamp;
  final String passStamp;
  final Color likeColor;
  final SwipeCardController? controller;

  @override
  State<SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation = AnimationController(vsync: this)
    ..addListener(_onTick);
  Animation<Offset>? _tween;
  Offset _offset = Offset.zero;
  Size _size = Size.zero;
  bool _leaving = false;

  static const _maxRotation = 0.35; // radians at full width
  static const _flingVelocity = 900.0;

  @override
  void initState() {
    super.initState();
    widget.controller?._state = this;
  }

  @override
  void didUpdateWidget(SwipeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._state = null;
      widget.controller?._state = this;
    }
  }

  @override
  void dispose() {
    if (widget.controller?._state == this) widget.controller?._state = null;
    _animation.dispose();
    super.dispose();
  }

  void _onTick() {
    final tween = _tween;
    if (tween != null) setState(() => _offset = tween.value);
  }

  Duration _duration(int ms) => MediaQuery.disableAnimationsOf(context)
      ? Duration(milliseconds: ms ~/ 4)
      : Duration(milliseconds: ms);

  Future<void> _animateTo(Offset target, Duration duration, Curve curve) {
    _tween = Tween(
      begin: _offset,
      end: target,
    ).animate(CurvedAnimation(parent: _animation, curve: curve));
    _animation.duration = duration;
    return _animation.forward(from: 0).orCancel.catchError((_) {});
  }

  Future<void> _flingOut(SwipeDirection direction) async {
    if (_leaving || !mounted) return;
    _leaving = true;
    final sign = direction == SwipeDirection.like ? 1 : -1;
    final width = _size.width == 0 ? 400.0 : _size.width;
    await _animateTo(
      Offset(sign * width * 1.6, _offset.dy + 60),
      _duration(260),
      Curves.easeIn,
    );
    if (mounted) widget.onSwiped(direction);
  }

  void _springBack() =>
      _animateTo(Offset.zero, _duration(420), Curves.elasticOut);

  void _onPanUpdate(DragUpdateDetails details) {
    if (_leaving) return;
    _animation.stop();
    setState(() => _offset += details.delta);
  }

  void _onPanEnd(DragEndDetails details) {
    if (_leaving) return;
    final velocity = details.velocity.pixelsPerSecond;
    final width = _size.width;
    final pastDistance = _offset.dx.abs() > width * 0.3;
    final pastVelocity =
        velocity.dx.abs() > _flingVelocity &&
        velocity.dx.sign == _offset.dx.sign;

    if (pastDistance || pastVelocity) {
      unawaited(
        _flingOut(_offset.dx > 0 ? SwipeDirection.like : SwipeDirection.pass),
      );
      return;
    }
    final draggedUp =
        _offset.dy < -_size.height * 0.15 && _offset.dx.abs() < width * 0.15;
    _springBack();
    if (draggedUp) widget.onOpenProfile();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _size = constraints.biggest;
        final width = max(_size.width, 1);
        final progress = (_offset.dx / (width * 0.3)).clamp(-1.0, 1.0);
        final rotation = (_offset.dx / width) * _maxRotation;

        return GestureDetector(
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: Transform.translate(
            offset: _offset,
            child: Transform.rotate(
              angle: rotation,
              alignment: Alignment.bottomCenter,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Drawn once; dragging only moves the layer.
                  RepaintBoundary(child: widget.child),
                  // Stamps fade in with the drag.
                  Positioned(
                    top: 48,
                    left: 24,
                    child: _Stamp(
                      text: widget.likeStamp,
                      color: widget.likeColor,
                      angle: -0.25,
                      opacity: progress.clamp(0.0, 1.0),
                    ),
                  ),
                  Positioned(
                    top: 48,
                    right: 24,
                    child: _Stamp(
                      text: widget.passStamp,
                      color: context.colors.error,
                      angle: 0.25,
                      opacity: (-progress).clamp(0.0, 1.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Stamp extends StatelessWidget {
  const new({
    required this.text,
    required this.color,
    required this.angle,
    required this.opacity,
  });

  final String text;
  final Color color;
  final double angle;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    if (opacity <= 0) return const SizedBox.shrink();
    return IgnorePointer(
      child: Opacity(
        opacity: opacity,
        child: Transform.rotate(
          angle: angle,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: color, width: 4),
              borderRadius: BorderRadius.circular(context.radii.sm),
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 16),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text(
                text,
                style: context.textTheme.displaySmall?.copyWith(color: color),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
