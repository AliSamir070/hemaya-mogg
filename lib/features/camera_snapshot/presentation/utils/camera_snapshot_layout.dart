import 'dart:math' as math;

import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Window size classes used by the camera snapshot screen.
enum CameraLayoutSize { compact, medium, expanded }

/// Layout rules so the snapshot screen adapts to phones, tablets,
/// foldables and desktop windows.
abstract final class CameraSnapshotLayout {
  static const double mediumBreakpoint = 600;
  static const double expandedBreakpoint = 840;

  static const double stackedMaxContentWidth = 600;
  static const double expandedMaxContentWidth = 1200;

  /// Figma frame: 342 × 430.
  static const double compactSnapshotAspectRatio = 342 / 430;

  /// Wider screens use a landscape-friendly camera ratio.
  static const double wideSnapshotAspectRatio = 4 / 3;

  /// Below this width the two action buttons stack vertically.
  static const double minSideBySideButtonWidth = 130;

  static CameraLayoutSize sizeFor(double width) {
    if (width >= expandedBreakpoint) return CameraLayoutSize.expanded;
    if (width >= mediumBreakpoint) return CameraLayoutSize.medium;
    return CameraLayoutSize.compact;
  }

  static double maxContentWidth(CameraLayoutSize size) =>
      size == CameraLayoutSize.expanded
      ? expandedMaxContentWidth
      : stackedMaxContentWidth;

  static double snapshotAspectRatio(CameraLayoutSize size) =>
      size == CameraLayoutSize.compact
      ? compactSnapshotAspectRatio
      : wideSnapshotAspectRatio;

  /// Base horizontal page gutter from the design (24px on a 390px frame).
  static double get gutter => 24.r;

  static double horizontalPadding(double availableWidth, double maxWidth) =>
      math.max(gutter, (availableWidth - maxWidth) / 2);
}
