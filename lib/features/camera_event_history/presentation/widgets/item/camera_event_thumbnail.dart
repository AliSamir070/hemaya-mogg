import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/widget/app_shimmer.dart';
import '../../../../camera_snapshot/presentation/widgets/snapshot/snapshot_placeholder.dart';
import '../../models/camera_event_ui_model.dart';

/// Thumbnail representation of a camera snapshot event.
/// Figma: 64x64 rounded rectangle with badge icon overlay.
class CameraEventThumbnail extends StatelessWidget {
  const CameraEventThumbnail({
    super.key,
    required this.type,
    this.thumbnailUrl,
  });

  final CameraEventType type;
  final String? thumbnailUrl;

  @override
  Widget build(BuildContext context) {
    final size = 64.r;
    final radius = BorderRadius.circular(12.r);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: radius,
            child: thumbnailUrl != null && thumbnailUrl!.isNotEmpty
                ? Image.network(
                    thumbnailUrl!,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) =>
                        progress == null
                            ? child
                            : const AppShimmer(child: ShimmerBox(radius: 12)),
                    errorBuilder: (context, error, stackTrace) =>
                        const SnapshotPlaceholder(),
                  )
                : const SnapshotPlaceholder(),
          ),
          Positioned(
            left: 6.r,
            bottom: 6.r,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.r, vertical: 2.r),
              decoration: BoxDecoration(
                color: ColorManager.homeBackground.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(
                  color: ColorManager.pureWhite.withValues(alpha: 0.1),
                ),
              ),
              child: Icon(
                type == CameraEventType.person
                    ? Icons.person_rounded
                    : Icons.motion_photos_on_rounded,
                size: 13.r,
                color: type == CameraEventType.person
                    ? ColorManager.sky
                    : ColorManager.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
