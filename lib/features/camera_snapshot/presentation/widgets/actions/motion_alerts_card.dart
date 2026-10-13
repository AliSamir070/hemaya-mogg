import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/resources/strings_manager.dart';
import '../../../../sensor_details/presentation/widgets/common/sensor_card.dart';

/// Figma: "Motion notification toggle card". The whole card toggles.
class MotionAlertsCard extends StatelessWidget {
  const MotionAlertsCard({
    super.key,
    required this.enabled,
    required this.onChanged,
  });

  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(22.r);
    return MergeSemantics(
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: radius,
          onTap: () => onChanged(!enabled),
          child: SensorCard(
            radius: 22.r,
            padding: EdgeInsetsDirectional.fromSTEB(16.r, 14.r, 12.r, 14.r),
            child: Row(
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: enabled ? 1 : 0.5,
                  child: Container(
                    width: 36.r,
                    height: 36.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorManager.orange.withValues(alpha: 0.16),
                    ),
                    child: Icon(
                      enabled
                          ? Icons.notifications_active_rounded
                          : Icons.notifications_off_rounded,
                      size: 18.r,
                      color: ColorManager.orange,
                    ),
                  ),
                ),
                SizedBox(width: 12.r),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        StringsManager.motionAlerts,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorManager.pureWhite,
                        ),
                      ),
                      SizedBox(height: 3.r),
                      Text(
                        StringsManager.motionAlertsHint,
                        style: TextStyle(
                          fontSize: 11.sp,
                          height: 1.3,
                          color: ColorManager.slate,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.r),
                Switch(
                  value: enabled,
                  onChanged: onChanged,
                  activeTrackColor: ColorManager.sky,
                  inactiveTrackColor: ColorManager.surfaceLight,
                  thumbColor: const WidgetStatePropertyAll(
                    ColorManager.pureWhite,
                  ),
                  trackOutlineColor: const WidgetStatePropertyAll(
                    Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
