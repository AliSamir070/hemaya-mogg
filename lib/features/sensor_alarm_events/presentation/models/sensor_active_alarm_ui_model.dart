import 'sensor_alarm_ui_model.dart';

/// Arguments passed to `Routes.sensorActiveAlarmRoute`.
class SensorActiveAlarmArgs {
  const SensorActiveAlarmArgs({
    required this.event,
    required this.deviceName,
    required this.thresholdValueLabel,
  });

  final SensorAlarmItemUiModel event;
  final String deviceName;
  final String thresholdValueLabel;
}

/// UI presentation model for the Active Alarm warning screen.
class SensorActiveAlarmUiModel {
  const SensorActiveAlarmUiModel({
    required this.event,
    required this.deviceName,
    required this.readingValueLabel,
    required this.thresholdDescriptionLabel,
  });

  final SensorAlarmItemUiModel event;
  final String deviceName;
  final String readingValueLabel;
  final String thresholdDescriptionLabel;

  SensorActiveAlarmUiModel copyWith({
    SensorAlarmItemUiModel? event,
    String? deviceName,
    String? readingValueLabel,
    String? thresholdDescriptionLabel,
  }) {
    return SensorActiveAlarmUiModel(
      event: event ?? this.event,
      deviceName: deviceName ?? this.deviceName,
      readingValueLabel: readingValueLabel ?? this.readingValueLabel,
      thresholdDescriptionLabel:
          thresholdDescriptionLabel ?? this.thresholdDescriptionLabel,
    );
  }
}
