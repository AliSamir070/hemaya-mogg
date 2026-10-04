import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';

/// Tinted info card summarising who receives the alerts and when.
class DelegationSummaryCard extends StatelessWidget {
  const DelegationSummaryCard({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 50.r),
      padding: EdgeInsets.symmetric(horizontal: 14.r, vertical: 10.r),
      alignment: AlignmentDirectional.centerStart,
      decoration: BoxDecoration(
        color: ColorManager.sky.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorManager.sky.withValues(alpha: 0.3)),
      ),
      child: Semantics(
        liveRegion: true,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            message,
            key: ValueKey(message),
            style: TextStyle(
              fontSize: 10.sp,
              height: 1.4,
              color: ColorManager.pureWhite.withValues(alpha: 0.85),
            ),
          ),
        ),
      ),
    );
  }
}
