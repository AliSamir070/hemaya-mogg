import 'dart:math' as math;

import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Window size classes used by the sensor dashboard.
enum SensorLayoutSize { compact, medium, expanded }

/// Layout rules for the sensor dashboard so it stays readable on phones,
/// tablets, foldables and desktop windows.
abstract final class SensorDetailsLayout {
  static const double mediumBreakpoint = 600;
  static const double expandedBreakpoint = 840;

  static const double stackedMaxContentWidth = 640;
  static const double expandedMaxContentWidth = 1200;

  /// Below this width two gauge cards can't sit side by side comfortably.
  static const double minSideBySideCardWidth = 140;

  /// Gauge diameter relative to its card width (120px on a 165px card).
  static const double _gaugeToCardRatio = 0.73;
  static const double _minGauge = 88;
  static const double _maxGauge = 200;

  static SensorLayoutSize sizeFor(double width) {
    if (width >= expandedBreakpoint) return SensorLayoutSize.expanded;
    if (width >= mediumBreakpoint) return SensorLayoutSize.medium;
    return SensorLayoutSize.compact;
  }

  static double maxContentWidth(SensorLayoutSize size) =>
      size == SensorLayoutSize.expanded
      ? expandedMaxContentWidth
      : stackedMaxContentWidth;

  /// Base horizontal page gutter from the design (24px on a 390px frame).
  static double get gutter => 24.r;

  /// Horizontal padding that keeps content centred and capped at [maxWidth].
  static double horizontalPadding(double availableWidth, double maxWidth) =>
      math.max(gutter, (availableWidth - maxWidth) / 2);

  static double gaugeDiameter(double cardWidth) =>
      (cardWidth * _gaugeToCardRatio).clamp(_minGauge, _maxGauge);
}
