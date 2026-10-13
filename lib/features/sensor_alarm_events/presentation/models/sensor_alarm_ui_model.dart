/// Types of sensor alarm events.
enum SensorAlarmType {
  highTemperature,
  lowTemperature,
  highHumidity,
  lowHumidity,
}

/// Filter options for sensor alarm events tab chips.
enum SensorAlarmFilter {
  all,
  temperature,
  humidity,
}

/// Arguments passed to `Routes.sensorAlarmEventsRoute`.
class SensorAlarmEventsArgs {
  const SensorAlarmEventsArgs({
    required this.deviceId,
    required this.deviceName,
  });

  final String deviceId;
  final String deviceName;
}

/// UI presentation model for a sensor alarm event item.
class SensorAlarmItemUiModel {
  const SensorAlarmItemUiModel({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.isAcknowledged,
  });

  final String id;
  final SensorAlarmType type;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final bool isAcknowledged;

  bool get isTemperature =>
      type == SensorAlarmType.highTemperature ||
      type == SensorAlarmType.lowTemperature;

  bool get isHumidity =>
      type == SensorAlarmType.highHumidity ||
      type == SensorAlarmType.lowHumidity;

  SensorAlarmItemUiModel copyWith({
    String? id,
    SensorAlarmType? type,
    String? title,
    String? subtitle,
    DateTime? timestamp,
    bool? isAcknowledged,
  }) {
    return SensorAlarmItemUiModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      timestamp: timestamp ?? this.timestamp,
      isAcknowledged: isAcknowledged ?? this.isAcknowledged,
    );
  }
}
