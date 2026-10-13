import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';
import '../../models/sensor_alarm_ui_model.dart';

class SensorAlarmFilterTabs extends StatelessWidget {
  const SensorAlarmFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  final SensorAlarmFilter selectedFilter;
  final ValueChanged<SensorAlarmFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildChip(
            label: 'All',
            isSelected: selectedFilter == SensorAlarmFilter.all,
            onTap: () => onFilterChanged(SensorAlarmFilter.all),
          ),
          SizedBox(width: 10.r),
          _buildChip(
            label: 'Temperature',
            isSelected: selectedFilter == SensorAlarmFilter.temperature,
            onTap: () => onFilterChanged(SensorAlarmFilter.temperature),
          ),
          SizedBox(width: 10.r),
          _buildChip(
            label: 'Humidity',
            isSelected: selectedFilter == SensorAlarmFilter.humidity,
            onTap: () => onFilterChanged(SensorAlarmFilter.humidity),
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      excludeSemantics: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(17.r),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            constraints: BoxConstraints(minHeight: 34.r),
            padding: EdgeInsets.symmetric(horizontal: 18.r, vertical: 8.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17.r),
              color: isSelected ? null : ColorManager.surface,
              gradient: isSelected ? ColorManager.primaryGradient : null,
              border: isSelected
                  ? null
                  : Border.all(
                      color: ColorManager.pureWhite.withValues(alpha: 0.08),
                    ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: ColorManager.sky.withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? ColorManager.ink : ColorManager.slate,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
