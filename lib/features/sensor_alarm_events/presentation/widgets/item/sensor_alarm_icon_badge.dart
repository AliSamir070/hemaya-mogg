import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';
import '../../models/sensor_alarm_ui_model.dart';

/// 40x40 circular icon badge representing the sensor alarm type.
/// Figma: Ellipse with themed icon and colors (Temperature: orange, Humidity: sky).
class SensorAlarmIconBadge extends StatelessWidget {
  const SensorAlarmIconBadge({
    super.key,
    required this.type,
  });

  final SensorAlarmType type;

  @override
  Widget build(BuildContext context) {
    final isTemp = type == SensorAlarmType.highTemperature ||
        type == SensorAlarmType.lowTemperature;
    final color = isTemp ? ColorManager.orange : ColorManager.sky;

    final IconData icon = switch (type) {
      SensorAlarmType.highTemperature => Icons.thermostat_rounded,
      SensorAlarmType.lowTemperature => Icons.ac_unit_rounded,
      SensorAlarmType.highHumidity => Icons.water_drop_rounded,
      SensorAlarmType.lowHumidity => Icons.opacity_rounded,
    };

    return Container(
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.16),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 20.r,
          color: color,
        ),
      ),
    );
  }
}
