import 'dart:math' as math;

import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Layout rules shared by the home tabs so they stay readable on phones,
/// tablets, foldables and desktop windows.
abstract final class HomeLayout {
  static const double tabBarMaxWidth = 420;
  static const double delegateMaxContentWidth = 560;
  static const double devicesMaxContentWidth = 1000;

  /// Base horizontal page gutter from the design (24px on a 390px frame).
  static double get gutter => 24.r;

  /// Horizontal padding that keeps content centred and capped at [maxWidth].
  static double horizontalPadding(double availableWidth, double maxWidth) =>
      math.max(gutter, (availableWidth - maxWidth) / 2);

  /// Number of device-card columns for the given content width.
  static int deviceColumns(double contentWidth) {
    if (contentWidth >= 880) return 3;
    if (contentWidth >= 540) return 2;
    return 1;
  }
}
