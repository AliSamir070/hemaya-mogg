import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';
import '../../../../sensor_details/presentation/widgets/common/sensor_card.dart';

/// Card showing the detected event category ("Person" or "Motion") and details.
/// Figma node 63:66 (Value card).
class CameraActiveAlarmValueCard extends StatelessWidget {
  const CameraActiveAlarmValueCard({
    super.key,
    required this.detectionType,
    required this.detectionDetail,
  });

  final String detectionType;
  final String detectionDetail;

  @override
  Widget build(BuildContext context) {
    return SensorCard(
      radius: 24.r,
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 18.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            detectionType,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 34.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: ColorManager.error,
            ),
          ),
          SizedBox(height: 6.r),
          Text(
            detectionDetail,
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
