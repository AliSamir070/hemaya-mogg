import 'package:injectable/injectable.dart';

import '../../../../core/resources/api_result.dart';
import '../../../../core/resources/internet_checker.dart';
import '../../domain/entity/sensor_alarm_event_entity.dart';
import '../../domain/repo/sensor_alarm_events_repo.dart';
import '../datasource/sensor_alarm_events_dao.dart';

@Injectable(as: SensorAlarmEventsRepo)
class SensorAlarmEventsRepoImpl implements SensorAlarmEventsRepo {
  final SensorAlarmEventsDao _dao;

  SensorAlarmEventsRepoImpl(this._dao);

  @override
  Future<ApiResult<List<SensorAlarmEventEntity>>> getReadings({
    Map<String, dynamic> params = const {},
  }) async {
    final bool isConnected = await InternetChecker.checkConnection();
    if (!isConnected) {
      return Error('No Internet Connection');
    }

    final result = await _dao.getReadings(params: params);

    switch (result) {
      case Success(response: final responses):
        return Success(responses.map((r) => r.toEntity()).toList());
      case Error(message: final errorMessage):
        return Error(errorMessage);
    }
  }
}
