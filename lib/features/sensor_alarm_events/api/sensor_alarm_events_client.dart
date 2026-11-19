import 'package:injectable/injectable.dart';

import '../../../core/remote/network/meteor_service.dart';
import '../data/model/sensor_alarm_event_response.dart';

@singleton
class SensorAlarmEventsClient {
  static const String readingsListMethod = 'readings.list';

  final MeteorService _meteorService;

  @factoryMethod
  SensorAlarmEventsClient(this._meteorService);

  /// Calls the `readings.list` Meteor method with the provided [params] map (defaults to `{}`).
  Future<List<SensorAlarmEventResponse>> getReadings({
    Map<String, dynamic> params = const {},
  }) async {
    final result = await _meteorService.call(
      readingsListMethod,
      args: [params],
    );
    return SensorAlarmEventResponse.fromMeteorResult(result);
  }
}
