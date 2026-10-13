import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/resources/strings_manager.dart';
import '../../../../camera_event_history/presentation/utils/camera_event_time_formatter.dart';
import '../../../../sensor_details/presentation/widgets/common/sensor_card.dart';
import '../../models/sensor_alarm_ui_model.dart';
import 'sensor_alarm_icon_badge.dart';

/// Single item card representing a sensor alarm event in the history list.
/// Figma: 342x84 card with IconBadge, Title, Subtitle, Timestamp, Unread dot, and Action button/tag.
class SensorAlarmCard extends StatelessWidget {
  const SensorAlarmCard({
    super.key,
    required this.event,
    required this.onAcknowledge,
    this.onTap,
  });

  final SensorAlarmItemUiModel event;
  final VoidCallback onAcknowledge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isUnread = !event.isAcknowledged;
    final timeStr = CameraEventTimeFormatter.format(event.timestamp);

    return Semantics(
      label: '${event.title}, ${event.subtitle}, $timeStr'
          '${isUnread ? ', unread' : ', acknowledged'}',
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: onTap,
          child: SensorCard(
            radius: 20.r,
            padding: EdgeInsets.symmetric(horizontal: 14.r, vertical: 14.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SensorAlarmIconBadge(type: event.type),
                SizedBox(width: 14.r),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              event.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: ColorManager.pureWhite,
                              ),
                            ),
                          ),
                          if (isUnread) ...[
                            SizedBox(width: 6.r),
                            Container(
                              width: 8.r,
                              height: 8.r,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorManager.orange,
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 3.r),
                      Text(
                        event.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: ColorManager.slate,
                        ),
                      ),
                      SizedBox(height: 5.r),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 11.r,
                            color: ColorManager.slate.withValues(alpha: 0.8),
                          ),
                          SizedBox(width: 4.r),
                          Expanded(
                            child: Text(
                              timeStr,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: ColorManager.slate.withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.r),
                _buildActionButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    if (event.isAcknowledged) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 5.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: ColorManager.emerald.withValues(alpha: 0.12),
          border: Border.all(
            color: ColorManager.emerald.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_rounded,
              size: 12.r,
              color: ColorManager.emerald,
            ),
            SizedBox(width: 3.r),
            Text(
              StringsManager.acknowledged,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: ColorManager.emerald,
              ),
            ),
          ],
        ),
      );
    }

    return Semantics(
      button: true,
      label: StringsManager.acknowledge,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onAcknowledge,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 6.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: ColorManager.surfaceLight,
              border: Border.all(
                color: ColorManager.sky.withValues(alpha: 0.35),
              ),
            ),
            child: Text(
              StringsManager.acknowledge,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: ColorManager.sky,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
