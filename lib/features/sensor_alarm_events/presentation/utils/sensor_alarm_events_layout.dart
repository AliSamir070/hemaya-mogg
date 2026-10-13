import 'dart:math' as math;

import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Window size classes used by the Sensor Alarm Events screen.
enum SensorAlarmEventsLayoutSize { compact, medium, expanded }

abstract final class SensorAlarmEventsLayout {
  static const double mediumBreakpoint = 600;
  static const double expandedBreakpoint = 840;

  static const double compactMaxContentWidth = 600;
  static const double expandedMaxContentWidth = 1000;

  static SensorAlarmEventsLayoutSize sizeFor(double width) {
    if (width >= expandedBreakpoint) return SensorAlarmEventsLayoutSize.expanded;
    if (width >= mediumBreakpoint) return SensorAlarmEventsLayoutSize.medium;
    return SensorAlarmEventsLayoutSize.compact;
  }

  static double maxContentWidth(SensorAlarmEventsLayoutSize size) =>
      size == SensorAlarmEventsLayoutSize.expanded
          ? expandedMaxContentWidth
          : compactMaxContentWidth;

  static double get gutter => 24.r;

  static double horizontalPadding(double availableWidth, double maxWidth) =>
      math.max(gutter, (availableWidth - maxWidth) / 2);
}
