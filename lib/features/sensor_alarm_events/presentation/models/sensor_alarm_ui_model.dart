import '../../../../core/resources/strings_manager.dart';
import '../../domain/entity/sensor_alarm_event_entity.dart';

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

  factory SensorAlarmItemUiModel.fromEntity(SensorAlarmEventEntity entity) {
    SensorAlarmType type;
    final typeStr = entity.type.toLowerCase();
    if (typeStr.contains('hightemp') ||
        typeStr.contains('high_temp') ||
        (typeStr.contains('temp') && typeStr.contains('high'))) {
      type = SensorAlarmType.highTemperature;
    } else if (typeStr.contains('lowtemp') ||
        typeStr.contains('low_temp') ||
        (typeStr.contains('temp') && typeStr.contains('low'))) {
      type = SensorAlarmType.lowTemperature;
    } else if (typeStr.contains('highhum') ||
        typeStr.contains('high_hum') ||
        (typeStr.contains('hum') && typeStr.contains('high'))) {
      type = SensorAlarmType.highHumidity;
    } else if (typeStr.contains('lowhum') ||
        typeStr.contains('low_hum') ||
        (typeStr.contains('hum') && typeStr.contains('low'))) {
      type = SensorAlarmType.lowHumidity;
    } else if (entity.temperature != null) {
      type = entity.temperature! >= 28.0
          ? SensorAlarmType.highTemperature
          : SensorAlarmType.lowTemperature;
    } else if (entity.humidity != null) {
      type = entity.humidity! >= 60.0
          ? SensorAlarmType.highHumidity
          : SensorAlarmType.lowHumidity;
    } else {
      type = SensorAlarmType.highTemperature;
    }

    String title = entity.title;
    if (title.isEmpty) {
      title = switch (type) {
        SensorAlarmType.highTemperature => StringsManager.highTemperature,
        SensorAlarmType.lowTemperature => StringsManager.lowTemperature,
        SensorAlarmType.highHumidity => StringsManager.highHumidity,
        SensorAlarmType.lowHumidity => StringsManager.lowHumidity,
      };
    }

    String subtitle = entity.subtitle;
    if (subtitle.isEmpty) {
      if (entity.temperature != null) {
        subtitle = '${entity.temperature!.toStringAsFixed(1)}°C';
      } else if (entity.humidity != null) {
        subtitle = '${entity.humidity!.toStringAsFixed(0)}% RH';
      } else {
        subtitle = title;
      }
    }

    return SensorAlarmItemUiModel(
      id: entity.id,
      type: type,
      title: title,
      subtitle: subtitle,
      timestamp: entity.timestamp,
      isAcknowledged: entity.isAcknowledged,
    );
  }

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
