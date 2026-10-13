import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/resources/strings_manager.dart';
import '../../../../../core/widget/app_shimmer.dart';
import '../../../../sensor_details/presentation/widgets/header/sensor_details_header.dart';
import '../../utils/snapshot_time_formatter.dart';
import 'motion_event_banner.dart';
import 'snapshot_overlay_chip.dart';
import 'snapshot_placeholder.dart';

/// Figma: "Snapshot frame" — bordered card holding the last snapshot with
/// "● REC" / timestamp chips on top and the event banner at the bottom.
///
/// While [isRefreshing], a shimmer sweeps over the current image.
class SnapshotViewer extends StatelessWidget {
  const SnapshotViewer({
    super.key,
    required this.capturedAt,
    required this.isRecording,
    required this.aspectRatio,
    this.imageUrl,
    this.eventLabel,
    this.isRefreshing = false,
  });

  final String? imageUrl;
  final DateTime capturedAt;
  final String? eventLabel;
  final bool isRecording;
  final bool isRefreshing;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    final outer = 28.r;
    final inset = 6.r;
    final inner = outer - inset;
    final timeLabel = SnapshotTimeFormatter.format(capturedAt);

    return Semantics(
      image: true,
      label: '${StringsManager.lastCameraSnapshot}, $timeLabel'
          '${eventLabel != null ? ', $eventLabel' : ''}',
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Container(
          padding: EdgeInsets.all(inset),
          decoration: BoxDecoration(
            color: ColorManager.surface,
            borderRadius: BorderRadius.circular(outer),
            border: Border.all(
              color: ColorManager.pureWhite.withValues(alpha: 0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: ColorManager.ink.withValues(alpha: 0.5),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(inner),
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 450),
                  child: KeyedSubtree(
                    key: ValueKey(capturedAt),
                    child: _SnapshotImage(url: imageUrl),
                  ),
                ),
                if (isRefreshing)
                  const IgnorePointer(
                    child: Opacity(
                      opacity: 0.85,
                      child: AppShimmer(child: ShimmerBox(radius: 0)),
                    ),
                  ),
                Positioned(
                  top: 12.r,
                  left: 12.r,
                  right: 12.r,
                  child: Row(
                    children: [
                      if (isRecording)
                        SnapshotOverlayChip(
                          label: StringsManager.rec,
                          labelColor: ColorManager.error,
                          leading: LiveDot(color: ColorManager.error),
                        ),
                      const Spacer(),
                      Flexible(
                        flex: 4,
                        child: SnapshotOverlayChip(
                          label: timeLabel,
                          leading: Icon(
                            Icons.schedule_rounded,
                            size: 12.r,
                            color: ColorManager.slate,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (eventLabel != null)
                  Positioned(
                    left: 12.r,
                    right: 12.r,
                    bottom: 12.r,
                    child: MotionEventBanner(label: eventLabel!),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SnapshotImage extends StatelessWidget {
  const _SnapshotImage({this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final url = this.url;
    if (url == null || url.isEmpty) return const SnapshotPlaceholder();
    return Image.network(
      url,
      fit: BoxFit.cover,
      gaplessPlayback: true,
      loadingBuilder: (context, child, progress) => progress == null
          ? child
          : const AppShimmer(child: ShimmerBox(radius: 0)),
      errorBuilder: (context, error, stackTrace) => Stack(
        fit: StackFit.expand,
        children: [
          const SnapshotPlaceholder(),
          Center(
            child: SnapshotOverlayChip(
              label: StringsManager.snapshotUnavailable,
              leading: Icon(
                Icons.videocam_off_rounded,
                size: 14.r,
                color: ColorManager.slate,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
