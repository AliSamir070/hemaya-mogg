import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';

/// Decorative blurred glows painted behind the home content.
class HomeBackground extends StatelessWidget {
  const HomeBackground({super.key, this.showSecondaryGlow = true});

  /// The bottom-right sky glow is only shown on the Devices tab in Figma.
  final bool showSecondaryGlow;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            left: -190.r,
            top: -210.r,
            child: _Glow(
              diameter: 480.r,
              color: ColorManager.indigo,
              opacity: 0.24,
            ),
          ),
          Positioned(
            right: -200.r,
            top: 290.r,
            child: AnimatedOpacity(
              opacity: showSecondaryGlow ? 1 : 0,
              duration: const Duration(milliseconds: 350),
              child: _Glow(
                diameter: 460.r,
                color: ColorManager.sky,
                opacity: 0.16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Cheap approximation of a Gaussian-blurred circle via a radial gradient
/// (avoids an expensive ImageFilter.blur on every frame).
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
              color.withValues(alpha: opacity * 0.6),
              color.withValues(alpha: 0),
            ],
            stops: const [0.0, 0.45, 1.0],
          ),
        ),
      ),
    );
  }
}
