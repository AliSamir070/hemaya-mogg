import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';

/// Animated pulse rings with siren glow behind the alarm icon badge.
/// Figma nodes 63:17, 63:18, 63:19 (Pulse rings) + 63:20 (Siren glow) + 63:21 (Icon badge).
class ActiveAlarmSirenPulse extends StatefulWidget {
  const ActiveAlarmSirenPulse({
    super.key,
    required this.isTemperature,
  });

  final bool isTemperature;

  @override
  State<ActiveAlarmSirenPulse> createState() => _ActiveAlarmSirenPulseState();
}

class _ActiveAlarmSirenPulseState extends State<ActiveAlarmSirenPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _pulseController
        ..stop()
        ..value = 0.5;
    } else if (!_pulseController.isAnimating) {
      _pulseController.repeat();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor =
        widget.isTemperature ? ColorManager.error : ColorManager.sky;
    final secondaryColor =
        widget.isTemperature ? ColorManager.orange : ColorManager.indigo;

    return Center(
      child: SizedBox(
        width: 320.r,
        height: 320.r,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer Siren Ambient Glow
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final scale = 1.0 + 0.12 * _pulseController.value;
                final opacity = 0.25 - 0.1 * _pulseController.value;
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 300.r,
                    height: 300.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          primaryColor.withValues(alpha: opacity),
                          primaryColor.withValues(alpha: opacity * 0.4),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                );
              },
            ),

            // Pulse Rings (Staggered radiating circles)
            _buildAnimatedRing(delay: 0.0, color: primaryColor),
            _buildAnimatedRing(delay: 0.33, color: primaryColor),
            _buildAnimatedRing(delay: 0.66, color: primaryColor),

            // Core Icon Badge (140x140 in Figma)
            Container(
              width: 130.r,
              height: 130.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    primaryColor.withValues(alpha: 0.25),
                    secondaryColor.withValues(alpha: 0.15),
                  ],
                ),
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.45),
                  width: 2.r,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.3),
                    blurRadius: 28,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  widget.isTemperature
                      ? Icons.thermostat_rounded
                      : Icons.water_drop_rounded,
                  size: 64.r,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedRing({
    required double delay,
    required Color color,
  }) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final progress = (_pulseController.value + delay) % 1.0;
        final size = 130.r + (170.r * progress);
        final opacity = (1.0 - progress) * 0.4;

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withValues(alpha: opacity),
              width: 1.5.r,
            ),
          ),
        );
      },
    );
  }
}
