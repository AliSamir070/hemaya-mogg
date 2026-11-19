// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_alarm_event_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SensorAlarmEventResponse _$SensorAlarmEventResponseFromJson(
  Map<String, dynamic> json,
) => SensorAlarmEventResponse(
  id: json['id'] as String?,
  deviceId: json['deviceId'] as String?,
  temperature: (json['temperature'] as num?)?.toDouble(),
  humidity: (json['humidity'] as num?)?.toDouble(),
  type: json['type'] as String?,
  title: json['title'] as String?,
  subtitle: json['subtitle'] as String?,
  timestamp: json['timestamp'] == null
      ? null
      : DateTime.parse(json['timestamp'] as String),
  isAcknowledged: json['isAcknowledged'] as bool?,
  statusMsg: json['statusMsg'] as String?,
  message: json['message'] as String?,
);

Map<String, dynamic> _$SensorAlarmEventResponseToJson(
  SensorAlarmEventResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'deviceId': instance.deviceId,
  'temperature': instance.temperature,
  'humidity': instance.humidity,
  'type': instance.type,
  'title': instance.title,
  'subtitle': instance.subtitle,
  'timestamp': instance.timestamp?.toIso8601String(),
  'isAcknowledged': instance.isAcknowledged,
  'statusMsg': instance.statusMsg,
  'message': instance.message,
};
