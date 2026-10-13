import 'dart:math' as math;

import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Window size classes used by the Camera Event History screen.
enum CameraEventHistoryLayoutSize { compact, medium, expanded }

abstract final class CameraEventHistoryLayout {
  static const double mediumBreakpoint = 600;
  static const double expandedBreakpoint = 840;

  static const double compactMaxContentWidth = 600;
  static const double expandedMaxContentWidth = 1000;

  static CameraEventHistoryLayoutSize sizeFor(double width) {
    if (width >= expandedBreakpoint) return CameraEventHistoryLayoutSize.expanded;
    if (width >= mediumBreakpoint) return CameraEventHistoryLayoutSize.medium;
    return CameraEventHistoryLayoutSize.compact;
  }

  static double maxContentWidth(CameraEventHistoryLayoutSize size) =>
      size == CameraEventHistoryLayoutSize.expanded
          ? expandedMaxContentWidth
          : compactMaxContentWidth;

  static double get gutter => 24.r;

  static double horizontalPadding(double availableWidth, double maxWidth) =>
      math.max(gutter, (availableWidth - maxWidth) / 2);
}
