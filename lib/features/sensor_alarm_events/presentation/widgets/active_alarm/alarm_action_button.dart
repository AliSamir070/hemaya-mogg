import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';

/// Full-width prominent button with alarm accent colors.
class AlarmActionButton extends StatelessWidget {
  const AlarmActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isTemperature = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isTemperature;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;
    final radius = BorderRadius.circular(20.r);
    final primaryColor = isTemperature ? ColorManager.error : ColorManager.sky;
    final secondaryColor = isTemperature ? ColorManager.orange : ColorManager.indigo;

    return Semantics(
      button: true,
      enabled: isEnabled,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isEnabled ? 1 : 0.4,
        child: Material(
          type: MaterialType.transparency,
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, secondaryColor],
              ),
              borderRadius: radius,
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: InkWell(
              onTap: onPressed,
              borderRadius: radius,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 56.r),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.r,
                      vertical: 14.r,
                    ),
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: ColorManager.pureWhite,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
