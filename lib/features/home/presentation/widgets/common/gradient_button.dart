import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';

/// Full-width primary CTA with the sky → indigo brand gradient.
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;

  /// Pass `null` to render the disabled state.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;
    final radius = BorderRadius.circular(18.r);

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
              gradient: ColorManager.primaryGradient,
              borderRadius: radius,
            ),
            child: InkWell(
              onTap: onPressed,
              borderRadius: radius,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 54.r),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.r,
                      vertical: 12.r,
                    ),
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: ColorManager.ink,
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
