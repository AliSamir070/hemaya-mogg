part of 'sensor_alarm_events_view_model_cubit.dart';

sealed class SensorAlarmEventsViewModelState {
  const SensorAlarmEventsViewModelState();
}

final class SensorAlarmEventsInitial extends SensorAlarmEventsViewModelState {
  const SensorAlarmEventsInitial();
}

final class SensorAlarmEventsLoading extends SensorAlarmEventsViewModelState {
  const SensorAlarmEventsLoading();
}

final class SensorAlarmEventsSuccess extends SensorAlarmEventsViewModelState {
  const SensorAlarmEventsSuccess({
    required this.events,
    required this.filter,
    this.acknowledgedEventId,
  });

  final List<SensorAlarmItemUiModel> events;
  final SensorAlarmFilter filter;
  final String? acknowledgedEventId;

  List<SensorAlarmItemUiModel> get filteredEvents {
    return switch (filter) {
      SensorAlarmFilter.all => events,
      SensorAlarmFilter.temperature =>
        events.where((e) => e.isTemperature).toList(),
      SensorAlarmFilter.humidity =>
        events.where((e) => e.isHumidity).toList(),
    };
  }
}

final class SensorAlarmEventsError extends SensorAlarmEventsViewModelState {
  const SensorAlarmEventsError(this.message);

  final String message;
}
