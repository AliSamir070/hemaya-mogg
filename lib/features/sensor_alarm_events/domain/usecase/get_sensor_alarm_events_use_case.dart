import 'package:injectable/injectable.dart';

import '../../../../core/resources/api_result.dart';
import '../entity/sensor_alarm_event_entity.dart';
import '../repo/sensor_alarm_events_repo.dart';

@singleton
class GetSensorAlarmEventsUseCase {
  final SensorAlarmEventsRepo _repo;

  GetSensorAlarmEventsUseCase(this._repo);

  Future<ApiResult<List<SensorAlarmEventEntity>>> call({
    Map<String, dynamic> params = const {},
  }) {
    return _repo.getReadings(params: params);
  }
}
