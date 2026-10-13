import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widget/app_shimmer.dart';
import '../../../../sensor_details/presentation/widgets/common/sensor_card.dart';

/// Shimmer skeleton matching the Alarm Thresholds screen during loading.
class SensorThresholdsShimmer extends StatelessWidget {
  const SensorThresholdsShimmer({super.key});

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
                    ShimmerBox(height: 20.r, width: 160.r, radius: 6.r),
                    SizedBox(height: 6.r),
                    ShimmerBox(height: 12.r, width: 80.r, radius: 6.r),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.r),
          _buildCardShimmer(),
          SizedBox(height: 18.r),
          _buildCardShimmer(),
          SizedBox(height: 24.r),
          ShimmerBox(height: 56.r, radius: 20.r),
        ],
      ),
    );
  }

  Widget _buildCardShimmer() {
    return SensorCard(
      radius: 24.r,
      padding: EdgeInsets.symmetric(horizontal: 18.r, vertical: 18.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ShimmerBox(width: 32.r, height: 32.r, radius: 10.r),
              SizedBox(width: 12.r),
              ShimmerBox(width: 110.r, height: 16.r, radius: 4.r),
              const Spacer(),
              ShimmerBox(width: 80.r, height: 26.r, radius: 13.r),
            ],
          ),
          SizedBox(height: 14.r),
          ShimmerBox(width: 180.r, height: 12.r, radius: 4.r),
          SizedBox(height: 20.r),
          Center(
            child: ShimmerBox(width: 160.r, height: 56.r, radius: 16.r),
          ),
          SizedBox(height: 20.r),
          ShimmerBox(height: 6.r, radius: 3.r),
          SizedBox(height: 10.r),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerBox(width: 32.r, height: 12.r, radius: 3.r),
              ShimmerBox(width: 32.r, height: 12.r, radius: 3.r),
            ],
          ),
        ],
      ),
    );
  }
}
