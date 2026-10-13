import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widget/app_shimmer.dart';
import '../../../../sensor_details/presentation/widgets/common/sensor_card.dart';

/// Shimmer skeleton matching the sensor alarm events screen while loading.
class SensorAlarmEventsShimmer extends StatelessWidget {
  const SensorAlarmEventsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ShimmerBox(width: 44.r, height: 44.r, shape: BoxShape.circle),
              SizedBox(width: 14.r),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(height: 20.r, width: 150.r, radius: 6.r),
                    SizedBox(height: 6.r),
                    ShimmerBox(height: 12.r, width: 90.r, radius: 6.r),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 22.r),
          Row(
            children: [
              ShimmerBox(width: 54.r, height: 34.r, radius: 17.r),
              SizedBox(width: 10.r),
              ShimmerBox(width: 110.r, height: 34.r, radius: 17.r),
              SizedBox(width: 10.r),
              ShimmerBox(width: 86.r, height: 34.r, radius: 17.r),
            ],
          ),
          SizedBox(height: 20.r),
          for (int i = 0; i < 5; i++) ...[
            SensorCard(
              radius: 20.r,
              padding: EdgeInsets.symmetric(horizontal: 14.r, vertical: 14.r),
              child: Row(
                children: [
                  ShimmerBox(width: 40.r, height: 40.r, shape: BoxShape.circle),
                  SizedBox(width: 14.r),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(height: 14.r, width: 120.r, radius: 4.r),
                        SizedBox(height: 8.r),
                        ShimmerBox(height: 12.r, width: 140.r, radius: 4.r),
                        SizedBox(height: 8.r),
                        ShimmerBox(height: 10.r, width: 70.r, radius: 4.r),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.r),
                  ShimmerBox(width: 80.r, height: 26.r, radius: 12.r),
                ],
              ),
            ),
            SizedBox(height: 12.r),
          ],
        ],
      ),
    );
  }
}
