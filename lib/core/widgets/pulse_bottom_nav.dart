import 'dart:ui' show ImageFilter;

import 'package:material_ui/material_ui.dart';
import 'package:pulse/core/extensions/context_extensions.dart';

@immutable
class PulseNavItem {
  const new({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.badgeCount = 0,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;

  /// Shown as a badge on the icon when above zero.
  final int badgeCount;
}

/// Floating glass bottom navigation with an animated pill indicator.
class PulseBottomNav extends StatelessWidget {
  const new({
    required this.items,
    required this.currentIndex,
    required this.onSelected,
    this.accentGradient,
    super.key,
  });

  final List<PulseNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelected;

  /// Indicator gradient; defaults to the primary gradient.
  final LinearGradient? accentGradient;

  static const _height = 68.0;
  static const _indicatorInset = 6.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = BorderRadius.circular(context.radii.pill);
    final gradient = accentGradient ?? colors.primaryGradient;
    final duration = context.reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 320);

    return SafeArea(
      top: false,
      minimum: EdgeInsets.fromLTRB(spacing.md, 0, spacing.md, spacing.md),
      child: RepaintBoundary(
        child: ClipRRect(
          borderRadius: radius,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: context.radii.glassBlur,
              sigmaY: context.radii.glassBlur,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.glassFill,
                borderRadius: radius,
                border: Border.all(color: colors.glassBorder),
              ),
              child: SizedBox(
                height: _height,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final itemWidth = constraints.maxWidth / items.length;
                    return Stack(
                      children: [
                        AnimatedPositioned(
                          duration: duration,
                          curve: Curves.easeOutCubic,
                          left: itemWidth * currentIndex + _indicatorInset,
                          width: itemWidth - _indicatorInset * 2,
                          top: _indicatorInset,
                          bottom: _indicatorInset,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: radius,
                              gradient: LinearGradient(
                                colors: [
                                  for (final c in gradient.colors)
                                    c.withValues(alpha: 0.28),
                                ],
                              ),
                              border: Border.all(
                                color: gradient.colors.last.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            for (var i = 0; i < items.length; i++)
                              Expanded(
                                child: _NavButton(
                                  item: items[i],
                                  selected: i == currentIndex,
                                  accent: gradient.colors.last,
                                  onTap: () => onSelected(i),
                                ),
                              ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const new({
    required this.item,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final PulseNavItem item;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = selected ? colors.textPrimary : colors.textSecondary;

    return Semantics(
      button: true,
      selected: selected,
      label: item.badgeCount > 0
          ? context.l10n.navItemWithBadge(item.label, item.badgeCount)
          : item.label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Badge(
              isLabelVisible: item.badgeCount > 0,
              backgroundColor: colors.lime,
              textColor: colors.background,
              label: Text(item.badgeCount > 99 ? '99+' : '${item.badgeCount}'),
              child: Icon(
                selected ? item.selectedIcon : item.icon,
                color: selected ? accent : color,
                size: 24,
              ),
            ),
            SizedBox(height: context.spacing.xxs),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.labelSmall?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
