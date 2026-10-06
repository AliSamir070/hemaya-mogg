import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';

/// Figma: "All Alarm Events btn" (surface) / "Alarm Thresholds btn" (gradient).
///
/// Scales down slightly while pressed for tactile feedback.
class SensorActionButton extends StatefulWidget {
  const SensorActionButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onPressed,
    this.primary = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onPressed;

  /// Gradient (call-to-action) style when true, dark surface otherwise.
  final bool primary;

  @override
  State<SensorActionButton> createState() => _SensorActionButtonState();
}

class _SensorActionButtonState extends State<SensorActionButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final primary = widget.primary;
    final radius = BorderRadius.circular(20.r);
    final titleColor = primary ? ColorManager.ink : ColorManager.pureWhite;
    final subtitleColor = primary
        ? ColorManager.ink.withValues(alpha: 0.75)
        : ColorManager.slate;
    final iconColor = primary ? ColorManager.ink : ColorManager.orange;

    return Semantics(
      button: true,
      label: '${widget.title}, ${widget.subtitle}',
      excludeSemantics: true,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 120),
        child: Material(
          type: MaterialType.transparency,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: radius,
              color: primary ? null : ColorManager.surface,
              gradient: primary ? ColorManager.primaryGradient : null,
              border: primary
                  ? null
                  : Border.all(
                      color: ColorManager.pureWhite.withValues(alpha: 0.07),
                    ),
              boxShadow: primary
                  ? [
                      BoxShadow(
                        color: ColorManager.sky.withValues(alpha: 0.25),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: InkWell(
              borderRadius: radius,
              onTap: widget.onPressed,
              onHighlightChanged: _setPressed,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 58.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.r,
                    vertical: 10.r,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 26.r,
                        height: 26.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: iconColor.withValues(
                            alpha: primary ? 0.14 : 0.16,
                          ),
                        ),
                        child: Icon(widget.icon, size: 15.r, color: iconColor),
                      ),
                      SizedBox(width: 12.r),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: titleColor,
                              ),
                            ),
                            SizedBox(height: 2.r),
                            Text(
                              widget.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: subtitleColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
