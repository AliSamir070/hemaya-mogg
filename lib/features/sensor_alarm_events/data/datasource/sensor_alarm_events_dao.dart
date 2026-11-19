import '../../../../core/resources/api_result.dart';
import '../model/sensor_alarm_event_response.dart';

abstract interface class SensorAlarmEventsDao {
  Future<ApiResult<List<SensorAlarmEventResponse>>> getReadings({
    Map<String, dynamic> params = const {},
  });
}
