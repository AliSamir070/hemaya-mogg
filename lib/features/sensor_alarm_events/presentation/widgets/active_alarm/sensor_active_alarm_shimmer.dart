import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widget/app_shimmer.dart';
import '../../../../sensor_details/presentation/widgets/common/sensor_card.dart';

/// Shimmer skeleton matching the active alarm screen during loading.
class SensorActiveAlarmShimmer extends StatelessWidget {
  const SensorActiveAlarmShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 44.r),
              ShimmerBox(width: 140.r, height: 32.r, radius: 16.r),
              ShimmerBox(width: 44.r, height: 44.r, shape: BoxShape.circle),
            ],
          ),
          SizedBox(height: 40.r),
          Center(
            child: ShimmerBox(width: 140.r, height: 140.r, shape: BoxShape.circle),
          ),
          SizedBox(height: 36.r),
          Center(child: ShimmerBox(width: 80.r, height: 14.r, radius: 4.r)),
          SizedBox(height: 10.r),
          Center(child: ShimmerBox(width: 220.r, height: 28.r, radius: 6.r)),
          SizedBox(height: 10.r),
          Center(child: ShimmerBox(width: 260.r, height: 14.r, radius: 4.r)),
          SizedBox(height: 32.r),
          SensorCard(
            radius: 24.r,
            padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 22.r),
            child: Column(
              children: [
                ShimmerBox(width: 160.r, height: 36.r, radius: 8.r),
                SizedBox(height: 12.r),
                ShimmerBox(width: 220.r, height: 14.r, radius: 4.r),
              ],
            ),
          ),
          SizedBox(height: 36.r),
          ShimmerBox(height: 56.r, radius: 20.r),
        ],
      ),
    );
  }
}
