import 'package:flutter/material.dart';

import '../../../../core/resources/color_manager.dart';
import '../models/device_ui_model.dart';

/// Maps presentation enums to design tokens so widgets stay declarative.
extension DeviceCategoryStyle on DeviceCategory {
  Color get accentColor => switch (this) {
        DeviceCategory.sensor => ColorManager.sky,
        DeviceCategory.camera => ColorManager.indigo,
      };

  Gradient get iconGradient => switch (this) {
        DeviceCategory.sensor => ColorManager.primaryGradient,
        DeviceCategory.camera => const LinearGradient(
            colors: [ColorManager.indigo, ColorManager.indigo],
          ),
      };

  IconData get icon => switch (this) {
        DeviceCategory.sensor => Icons.thermostat_rounded,
        DeviceCategory.camera => Icons.photo_camera_outlined,
      };
}

extension MetricToneStyle on MetricTone {
  Color get color => switch (this) {
        MetricTone.warm => ColorManager.orange,
        MetricTone.cool => ColorManager.sky,
        MetricTone.success => ColorManager.emerald,
      };
}
