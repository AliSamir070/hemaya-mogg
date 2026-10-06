import 'package:flutter/material.dart';

import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/strings_manager.dart';
import '../models/sensor_details_ui_model.dart';

extension TemperatureStatusStyle on TemperatureStatus {
  String get label => switch (this) {
    TemperatureStatus.cold => StringsManager.cold,
    TemperatureStatus.cool => StringsManager.cool,
    TemperatureStatus.comfortable => StringsManager.comfortable,
    TemperatureStatus.warm => StringsManager.warm,
    TemperatureStatus.hot => StringsManager.hot,
  };

  Color get color => switch (this) {
    TemperatureStatus.cold || TemperatureStatus.cool => ColorManager.sky,
    TemperatureStatus.comfortable => ColorManager.emerald,
    TemperatureStatus.warm => ColorManager.orange,
    TemperatureStatus.hot => ColorManager.error,
  };
}

extension HumidityStatusStyle on HumidityStatus {
  String get label => switch (this) {
    HumidityStatus.dry => StringsManager.dry,
    HumidityStatus.normal => StringsManager.normal,
    HumidityStatus.humid => StringsManager.humid,
  };

  Color get color => switch (this) {
    HumidityStatus.dry => ColorManager.orange,
    HumidityStatus.normal => ColorManager.emerald,
    HumidityStatus.humid => ColorManager.indigo,
  };
}

/// "HH:mm" without pulling in `intl`.
String formatClock(DateTime time) =>
    '${time.hour.toString().padLeft(2, '0')}:'
    '${time.minute.toString().padLeft(2, '0')}';
