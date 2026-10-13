import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/resources/color_manager.dart';
import '../../models/camera_event_ui_model.dart';

/// Single filter pill button (All, Motion, Person).
class FilterTabChip extends StatelessWidget {
  const FilterTabChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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

/// Horizontal row of filter chips.
class CameraEventFilterTabs extends StatelessWidget {
  const CameraEventFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  final CameraEventFilter selectedFilter;
  final ValueChanged<CameraEventFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          FilterTabChip(
            label: 'All',
            isSelected: selectedFilter == CameraEventFilter.all,
            onTap: () => onFilterChanged(CameraEventFilter.all),
          ),
          SizedBox(width: 10.r),
          FilterTabChip(
            label: 'Motion',
            isSelected: selectedFilter == CameraEventFilter.motion,
            onTap: () => onFilterChanged(CameraEventFilter.motion),
          ),
          SizedBox(width: 10.r),
          FilterTabChip(
            label: 'Person',
            isSelected: selectedFilter == CameraEventFilter.person,
            onTap: () => onFilterChanged(CameraEventFilter.person),
          ),
        ],
      ),
    );
  }
}
