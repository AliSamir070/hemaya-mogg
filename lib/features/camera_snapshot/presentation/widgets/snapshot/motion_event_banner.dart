import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';

/// Bottom banner over the snapshot describing the trigger event
/// (Figma: "Motion detected near front door").
class MotionEventBanner extends StatelessWidget {
  const MotionEventBanner({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 42.r),
      padding: EdgeInsets.symmetric(horizontal: 14.r, vertical: 8.r),
      decoration: BoxDecoration(
        color: ColorManager.homeBackground.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: ColorManager.pureWhite.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 20.r,
            height: 20.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorManager.orange.withValues(alpha: 0.2),
            ),
            child: Container(
              width: 8.r,
              height: 8.r,
              decoration: BoxDecoration(
                color: ColorManager.orange,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(width: 12.r),
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: ColorManager.pureWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
