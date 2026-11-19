import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/sensor_alarm_event_entity.dart';

part 'sensor_alarm_event_response.g.dart';

@JsonSerializable()
class SensorAlarmEventResponse {
  final String? id;
  final String? deviceId;
  final double? temperature;
  final double? humidity;
  final String? type;
  final String? title;
  final String? subtitle;
  final DateTime? timestamp;
  final bool? isAcknowledged;
  final String? statusMsg;
  final String? message;

  const SensorAlarmEventResponse({
    this.id,
    this.deviceId,
    this.temperature,
    this.humidity,
    this.type,
    this.title,
    this.subtitle,
    this.timestamp,
    this.isAcknowledged,
    this.statusMsg,
    this.message,
  });

  factory SensorAlarmEventResponse.fromJson(Map<String, dynamic> json) =>
      _$SensorAlarmEventResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SensorAlarmEventResponseToJson(this);

  /// Robust parser for Meteor `readings.list` result payloads.
  static List<SensorAlarmEventResponse> fromMeteorResult(dynamic result) {
    if (result == null) return [];

    if (result is List) {
      return result
          .whereType<Map>()
          .map((item) => _fromMap(Map<String, dynamic>.from(item)))
          .toList();
    }

    if (result is Map) {
      final map = Map<String, dynamic>.from(result);
      for (final key in ['readings', 'data', 'events', 'items', 'results']) {
        if (map[key] is List) {
          return (map[key] as List)
              .whereType<Map>()
              .map((item) => _fromMap(Map<String, dynamic>.from(item)))
              .toList();
        }
      }
      return [_fromMap(map)];
    }

    return [];
  }

  static SensorAlarmEventResponse _fromMap(Map<String, dynamic> map) {
    final id = (map['_id'] ?? map['id'] ?? map['readingId'])?.toString() ?? '';
    final deviceId = (map['deviceId'] ?? map['device_id'])?.toString();

    double? temperature;
    final rawTemp = map['temperature'] ?? map['temp'];
    if (rawTemp is num) {
      temperature = rawTemp.toDouble();
    } else if (rawTemp is String) {
      temperature = double.tryParse(rawTemp);
    }

    double? humidity;
    final rawHum = map['humidity'] ?? map['hum'];
    if (rawHum is num) {
      humidity = rawHum.toDouble();
    } else if (rawHum is String) {
      humidity = double.tryParse(rawHum);
    }

    final type = (map['type'] ??
            map['alarmType'] ??
            map['alertType'] ??
            map['eventType'])
        ?.toString();

    final title = (map['title'] ?? map['name'])?.toString();
    final subtitle = (map['subtitle'] ??
            map['description'] ??
            map['message'] ??
            map['detail'])
        ?.toString();

    DateTime? timestamp;
    final rawTime = map['timestamp'] ??
        map['createdAt'] ??
        map['time'] ??
        map['date'] ??
        map['created_at'];
    if (rawTime is DateTime) {
      timestamp = rawTime;
    } else if (rawTime is int) {
      timestamp = rawTime > 100000000000
          ? DateTime.fromMillisecondsSinceEpoch(rawTime)
          : DateTime.fromMillisecondsSinceEpoch(rawTime * 1000);
    } else if (rawTime is String) {
      timestamp = DateTime.tryParse(rawTime);
    }

    final isAcknowledged = (map['isAcknowledged'] ??
            map['acknowledged'] ??
            map['is_acknowledged']) as bool? ??
        false;

    return SensorAlarmEventResponse(
      id: id,
      deviceId: deviceId,
      temperature: temperature,
      humidity: humidity,
      type: type,
      title: title,
      subtitle: subtitle,
      timestamp: timestamp,
      isAcknowledged: isAcknowledged,
      statusMsg: map['statusMsg']?.toString(),
      message: map['message']?.toString(),
    );
  }

  SensorAlarmEventEntity toEntity() {
    return SensorAlarmEventEntity(
      id: id ?? '',
      deviceId: deviceId,
      temperature: temperature,
      humidity: humidity,
      type: type ?? '',
      title: title ?? '',
      subtitle: subtitle ?? '',
      timestamp: timestamp ?? DateTime.now(),
      isAcknowledged: isAcknowledged ?? false,
    );
  }
}
