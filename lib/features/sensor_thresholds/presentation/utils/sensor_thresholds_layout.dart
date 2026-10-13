import 'dart:math' as math;

import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Window size classes used by the Alarm Thresholds screen.
enum SensorThresholdsLayoutSize { compact, medium, expanded }

abstract final class SensorThresholdsLayout {
  static const double mediumBreakpoint = 600;
  static const double expandedBreakpoint = 840;

  static const double compactMaxContentWidth = 600;
  static const double expandedMaxContentWidth = 1000;

  static SensorThresholdsLayoutSize sizeFor(double width) {
    if (width >= expandedBreakpoint) return SensorThresholdsLayoutSize.expanded;
    if (width >= mediumBreakpoint) return SensorThresholdsLayoutSize.medium;
    return SensorThresholdsLayoutSize.compact;
  }

  static double maxContentWidth(SensorThresholdsLayoutSize size) =>
      size == SensorThresholdsLayoutSize.expanded
          ? expandedMaxContentWidth
          : compactMaxContentWidth;

  static double get gutter => 24.r;

  static double horizontalPadding(double availableWidth, double maxWidth) =>
      math.max(gutter, (availableWidth - maxWidth) / 2);
}
