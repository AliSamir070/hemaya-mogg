class SensorAlarmEventEntity {
  final String id;
  final String type;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final bool isAcknowledged;
  final double? temperature;
  final double? humidity;
  final String? deviceId;

  const SensorAlarmEventEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.isAcknowledged,
    this.temperature,
    this.humidity,
    this.deviceId,
  });
}
