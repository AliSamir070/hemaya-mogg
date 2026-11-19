import 'package:injectable/injectable.dart';

import '../../../../core/remote/network/meteor_service.dart';
import '../../../../core/resources/api_result.dart';
import '../../api/sensor_alarm_events_client.dart';
import '../datasource/sensor_alarm_events_dao.dart';
import '../model/sensor_alarm_event_response.dart';

@Injectable(as: SensorAlarmEventsDao)
class SensorAlarmEventsApiDaoImpl implements SensorAlarmEventsDao {
  final SensorAlarmEventsClient _client;
  final MeteorService _meteorService;

  SensorAlarmEventsApiDaoImpl(this._client, this._meteorService);

  @override
  Future<ApiResult<List<SensorAlarmEventResponse>>> getReadings({
    Map<String, dynamic> params = const {},
  }) async {
    try {
      final response = await _client.getReadings(params: params);
      return Success(response);
    } catch (e) {
      return Error(_meteorService.formatError(e));
    }
  }
}
