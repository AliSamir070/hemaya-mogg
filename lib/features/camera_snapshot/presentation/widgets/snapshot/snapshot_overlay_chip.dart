import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';

/// Dark translucent chip floating over the snapshot
/// (Figma: "● REC" and "Today 14:32").
class SnapshotOverlayChip extends StatelessWidget {
  const SnapshotOverlayChip({
    super.key,
    required this.label,
    this.leading,
    this.labelColor = ColorManager.pureWhite,
  });

  final String label;
  final Widget? leading;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 26.r),
      padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 5.r),
      decoration: BoxDecoration(
        color: ColorManager.homeBackground.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(13.r),
        border: Border.all(
          color: ColorManager.pureWhite.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[leading!, SizedBox(width: 6.r)],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
                color: labelColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
