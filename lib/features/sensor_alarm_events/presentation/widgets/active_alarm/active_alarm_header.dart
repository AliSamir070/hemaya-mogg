import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/resources/strings_manager.dart';

/// Top bar for Active Alarm screen.
/// Figma: ALARM ACTIVE pill (blinking red indicator + text) + Close (✕) button.
class ActiveAlarmHeader extends StatelessWidget {
  const ActiveAlarmHeader({
    super.key,
    required this.onClose,
  });

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Invisible spacer matching close button width to keep pill centered
        SizedBox(width: 44.r),

        // Centered ALARM ACTIVE pill
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.r, vertical: 6.r),
          decoration: BoxDecoration(
            color: ColorManager.error.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: ColorManager.error.withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _BlinkingAlarmDot(),
              SizedBox(width: 8.r),
              Text(
                StringsManager.alarmActive,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: ColorManager.error,
                ),
              ),
            ],
          ),
        ),

        // Close (✕) circular button
        Semantics(
          button: true,
          label: 'Close alarm view',
          child: Material(
            color: ColorManager.surface,
            shape: CircleBorder(
              side: BorderSide(
                color: ColorManager.pureWhite.withValues(alpha: 0.08),
              ),
            ),
            child: InkWell(
              onTap: onClose,
              customBorder: const CircleBorder(),
              child: SizedBox.square(
                dimension: 44.r,
                child: Icon(
                  Icons.close_rounded,
                  color: ColorManager.pureWhite,
                  size: 22.r,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BlinkingAlarmDot extends StatefulWidget {
  @override
  State<_BlinkingAlarmDot> createState() => _BlinkingAlarmDotState();
}

class _BlinkingAlarmDotState extends State<_BlinkingAlarmDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.3, end: 1.0).animate(_controller),
      child: Container(
        width: 8.r,
        height: 8.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorManager.error,
        ),
      ),
    );
  }
}
