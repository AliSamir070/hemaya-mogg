import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';
import '../../../../sensor_details/presentation/widgets/common/sensor_card.dart';

/// Card showing the current critical sensor reading and safe threshold bound.
/// Figma node 63:29 (Value card).
class ActiveAlarmValueCard extends StatelessWidget {
  const ActiveAlarmValueCard({
    super.key,
    required this.readingValue,
    required this.thresholdDescription,
    required this.isTemperature,
  });

  final String readingValue;
  final String thresholdDescription;
  final bool isTemperature;

  @override
  Widget build(BuildContext context) {
    final valueColor = isTemperature ? ColorManager.error : ColorManager.sky;

    return SensorCard(
      radius: 24.r,
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 18.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            readingValue,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 38.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: valueColor,
            ),
          ),
          SizedBox(height: 6.r),
          Text(
            thresholdDescription,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.sp,
              color: ColorManager.slate,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
