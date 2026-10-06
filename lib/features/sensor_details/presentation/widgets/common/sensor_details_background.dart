import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';

/// Decorative glows behind the dashboard (Figma: two "Glow" ellipses —
/// warm top-left, cool bottom-right).
class SensorDetailsBackground extends StatelessWidget {
  const SensorDetailsBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            left: -180.r,
            top: -200.r,
            child: _Glow(
              diameter: 480.r,
              color: ColorManager.orange,
              opacity: 0.26,
            ),
          ),
          Positioned(
            right: -200.r,
            top: 250.r,
            child: _Glow(
              diameter: 460.r,
              color: ColorManager.sky,
              opacity: 0.14,
            ),
          ),
        ],
      ),
    );
  }
}

/// Radial-gradient approximation of a blurred circle (no ImageFilter cost).
class _Glow extends StatelessWidget {
  const _Glow({
    required this.diameter,
    required this.color,
    required this.opacity,
  });

  final double diameter;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: diameter,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: opacity),
              color.withValues(alpha: opacity * 0.5),
              color.withValues(alpha: 0),
            ],
            stops: const [0.0, 0.45, 1.0],
          ),
        ),
      ),
    );
  }
}

/// Fades + slides a child in, offset by [index] along a shared [animation].
class StaggeredEntrance extends StatelessWidget {
  const StaggeredEntrance({
    super.key,
    required this.animation,
    required this.index,
    required this.child,
    this.count = 6,
  });

  final Animation<double> animation;
  final int index;
  final int count;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final step = 0.6 / count;
    final interval = Interval(
      (index * step).clamp(0.0, 1.0),
      (index * step + 0.4).clamp(0.0, 1.0),
      curve: Curves.easeOutCubic,
    );
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final t = interval.transform(animation.value);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 24.r),
            child: child,
          ),
        );
      },
    );
  }
}
