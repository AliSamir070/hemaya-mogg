import 'package:flutter_test/flutter_test.dart';
import 'package:hemaya_mogg/core/resources/api_result.dart';
import 'package:hemaya_mogg/features/sensor_alarm_events/domain/entity/sensor_alarm_event_entity.dart';
import 'package:hemaya_mogg/features/sensor_alarm_events/domain/repo/sensor_alarm_events_repo.dart';
import 'package:hemaya_mogg/features/sensor_alarm_events/domain/usecase/get_sensor_alarm_events_use_case.dart';
import 'package:hemaya_mogg/features/sensor_alarm_events/presentation/models/sensor_alarm_ui_model.dart';
import 'package:hemaya_mogg/features/sensor_alarm_events/presentation/viewmodels/sensor_alarm_events/sensor_alarm_events_view_model_cubit.dart';

class FakeSensorAlarmEventsRepo implements SensorAlarmEventsRepo {
  final ApiResult<List<SensorAlarmEventEntity>> Function(
    Map<String, dynamic> params,
  ) onGetReadings;

  FakeSensorAlarmEventsRepo({required this.onGetReadings});

  @override
  Future<ApiResult<List<SensorAlarmEventEntity>>> getReadings({
    Map<String, dynamic> params = const {},
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    return onGetReadings(params);
  }
}

void main() {
  group('SensorAlarmEventsViewModelCubit', () {
    test('emits [Loading, Success] when getReadings succeeds', () async {
      final fakeRepo = FakeSensorAlarmEventsRepo(
        onGetReadings: (params) => Success([
          SensorAlarmEventEntity(
            id: 'event-1',
            type: 'highTemperature',
            title: 'High Temperature',
            subtitle: '29.4°C — above 28°C max',
            timestamp: DateTime(2026, 11, 16, 14, 30),
            isAcknowledged: false,
            temperature: 29.4,
            deviceId: 'sensor-1',
          ),
          SensorAlarmEventEntity(
            id: 'event-2',
            type: 'highHumidity',
            title: 'High Humidity',
            subtitle: '65% RH — above 60% max',
            timestamp: DateTime(2026, 11, 16, 15, 0),
            isAcknowledged: true,
            humidity: 65,
            deviceId: 'sensor-1',
          ),
        ]),
      );

      final useCase = GetSensorAlarmEventsUseCase(fakeRepo);
      final cubit = SensorAlarmEventsViewModelCubit(useCase);

      expect(cubit.state, isA<SensorAlarmEventsInitial>());

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<SensorAlarmEventsLoading>(),
          predicate<SensorAlarmEventsSuccess>((state) {
            return state.events.length == 2 &&
                state.events[0].id == 'event-1' &&
                state.events[0].type == SensorAlarmType.highTemperature &&
                state.events[1].type == SensorAlarmType.highHumidity;
          }),
        ]),
      );

      await cubit.loadEvents(deviceId: 'sensor-1', deviceName: 'AirGuard TH');
      await cubit.close();
    });

    test('emits [Loading, Error] when getReadings fails', () async {
      final fakeRepo = FakeSensorAlarmEventsRepo(
        onGetReadings: (params) => Error('Failed to fetch readings'),
      );

      final useCase = GetSensorAlarmEventsUseCase(fakeRepo);
      final cubit = SensorAlarmEventsViewModelCubit(useCase);

      expectLater(
        cubit.stream,
        emitsInOrder([
          isA<SensorAlarmEventsLoading>(),
          predicate<SensorAlarmEventsError>(
            (state) => state.message == 'Failed to fetch readings',
          ),
        ]),
      );

      await cubit.loadEvents(deviceId: 'sensor-1', deviceName: 'AirGuard TH');
      await cubit.close();
    });

    test('filters events by temperature and humidity', () async {
      final fakeRepo = FakeSensorAlarmEventsRepo(
        onGetReadings: (params) => Success([
          SensorAlarmEventEntity(
            id: 'event-1',
            type: 'highTemperature',
            title: 'High Temperature',
            subtitle: '29.4°C',
            timestamp: DateTime.now(),
            isAcknowledged: false,
            temperature: 29.4,
          ),
          SensorAlarmEventEntity(
            id: 'event-2',
            type: 'lowHumidity',
            title: 'Low Humidity',
            subtitle: '30% RH',
            timestamp: DateTime.now(),
            isAcknowledged: false,
            humidity: 30,
          ),
        ]),
      );

      final useCase = GetSensorAlarmEventsUseCase(fakeRepo);
      final cubit = SensorAlarmEventsViewModelCubit(useCase);

      await cubit.loadEvents(deviceId: 'sensor-1', deviceName: 'AirGuard TH');

      expect((cubit.state as SensorAlarmEventsSuccess).filteredEvents.length, 2);

      cubit.setFilter(SensorAlarmFilter.temperature);
      expect((cubit.state as SensorAlarmEventsSuccess).filteredEvents.length, 1);
      expect((cubit.state as SensorAlarmEventsSuccess).filteredEvents[0].isTemperature, true);

      cubit.setFilter(SensorAlarmFilter.humidity);
      expect((cubit.state as SensorAlarmEventsSuccess).filteredEvents.length, 1);
      expect((cubit.state as SensorAlarmEventsSuccess).filteredEvents[0].isHumidity, true);

      await cubit.close();
    });

    test('acknowledges an event', () async {
      final fakeRepo = FakeSensorAlarmEventsRepo(
        onGetReadings: (params) => Success([
          SensorAlarmEventEntity(
            id: 'event-1',
            type: 'highTemperature',
            title: 'High Temperature',
            subtitle: '29.4°C',
            timestamp: DateTime.now(),
            isAcknowledged: false,
            temperature: 29.4,
          ),
        ]),
      );

      final useCase = GetSensorAlarmEventsUseCase(fakeRepo);
      final cubit = SensorAlarmEventsViewModelCubit(useCase);

      await cubit.loadEvents(deviceId: 'sensor-1', deviceName: 'AirGuard TH');
      expect((cubit.state as SensorAlarmEventsSuccess).events[0].isAcknowledged, false);

      await cubit.acknowledgeEvent('event-1');
      expect((cubit.state as SensorAlarmEventsSuccess).events[0].isAcknowledged, true);
      expect((cubit.state as SensorAlarmEventsSuccess).acknowledgedEventId, 'event-1');

      await cubit.close();
    });
  });
}
