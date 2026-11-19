import '../../../../core/resources/api_result.dart';
import '../entity/sensor_alarm_event_entity.dart';

abstract interface class SensorAlarmEventsRepo {
  Future<ApiResult<List<SensorAlarmEventEntity>>> getReadings({
    Map<String, dynamic> params = const {},
  });
}
