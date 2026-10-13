import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widget/app_shimmer.dart';
import '../../utils/camera_snapshot_layout.dart';

/// Shimmer skeleton mirroring the snapshot screen while it first loads.
class CameraSnapshotShimmer extends StatelessWidget {
  const CameraSnapshotShimmer({super.key, required this.size});

  final CameraLayoutSize size;

  @override
  Widget build(BuildContext context) {
    final gap = 12.r;
    final frame = AspectRatio(
      aspectRatio: CameraSnapshotLayout.snapshotAspectRatio(size),
      child: ShimmerBox(radius: 28.r),
    );
    final controls = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ShimmerBox(height: 14.r, width: 220.r, radius: 6.r),
        SizedBox(height: 24.r),
        Row(
          children: [
            Expanded(child: ShimmerBox(height: 58.r, radius: 20.r)),
            SizedBox(width: gap),
            Expanded(child: ShimmerBox(height: 58.r, radius: 20.r)),
          ],
        ),
        SizedBox(height: 18.r),
        ShimmerBox(height: 80.r, radius: 22.r),
      ],
    );

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
                    ShimmerBox(height: 20.r, width: 180.r, radius: 6.r),
                    SizedBox(height: 6.r),
                    ShimmerBox(height: 12.r, width: 140.r, radius: 6.r),
                  ],
                ),
              ),
              ShimmerBox(width: 56.r, height: 26.r, radius: 13.r),
            ],
          ),
          SizedBox(height: 22.r),
          if (size == CameraLayoutSize.expanded)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: frame),
                SizedBox(width: 24.r),
                Expanded(flex: 2, child: controls),
              ],
            )
          else ...[
            frame,
            SizedBox(height: 18.r),
            controls,
          ],
        ],
      ),
    );
  }
}
