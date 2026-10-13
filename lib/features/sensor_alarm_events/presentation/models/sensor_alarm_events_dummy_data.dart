import '../../../../core/resources/strings_manager.dart';
import 'sensor_alarm_ui_model.dart';

abstract final class SensorAlarmEventsDummyData {
  static List<SensorAlarmItemUiModel> events() {
    final now = DateTime.now();
    return [
      SensorAlarmItemUiModel(
        id: 'alarm_1',
        type: SensorAlarmType.highTemperature,
        title: StringsManager.highTemperature,
        subtitle: '29.4°C — above 28°C max',
        timestamp: DateTime(now.year, now.month, now.day, 14, 32),
        isAcknowledged: false,
      ),
      SensorAlarmItemUiModel(
        id: 'alarm_2',
        type: SensorAlarmType.lowHumidity,
        title: StringsManager.lowHumidity,
        subtitle: '36% RH — below 40% min',
        timestamp: DateTime(now.year, now.month, now.day, 9, 10),
        isAcknowledged: false,
      ),
      SensorAlarmItemUiModel(
        id: 'alarm_3',
        type: SensorAlarmType.highTemperature,
        title: StringsManager.highTemperature,
        subtitle: '28.6°C — above 28°C max',
        timestamp: DateTime(now.year, now.month, now.day - 1, 21, 4),
        isAcknowledged: true,
      ),
      SensorAlarmItemUiModel(
        id: 'alarm_4',
        type: SensorAlarmType.highHumidity,
        title: StringsManager.highHumidity,
        subtitle: '63% RH — above 60% max',
        timestamp: DateTime(now.year, now.month, now.day - 1, 16, 47),
        isAcknowledged: true,
      ),
      SensorAlarmItemUiModel(
        id: 'alarm_5',
        type: SensorAlarmType.lowTemperature,
        title: StringsManager.lowTemperature,
        subtitle: '17.2°C — below 18°C min',
        timestamp: DateTime(now.year, now.month, now.day - 2, 5, 58),
        isAcknowledged: true,
      ),
    ];
  }
}
