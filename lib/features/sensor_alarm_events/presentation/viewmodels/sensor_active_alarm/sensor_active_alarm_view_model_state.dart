part of 'sensor_active_alarm_view_model_cubit.dart';

sealed class SensorActiveAlarmViewModelState {
  const SensorActiveAlarmViewModelState();
}

final class SensorActiveAlarmInitial extends SensorActiveAlarmViewModelState {
  const SensorActiveAlarmInitial();
}

final class SensorActiveAlarmLoading extends SensorActiveAlarmViewModelState {
  const SensorActiveAlarmLoading();
}

final class SensorActiveAlarmSuccess extends SensorActiveAlarmViewModelState {
  const SensorActiveAlarmSuccess({
    required this.alarm,
    this.isAcknowledging = false,
    this.isAcknowledgedSuccess = false,
  });

  final SensorActiveAlarmUiModel alarm;
  final bool isAcknowledging;
  final bool isAcknowledgedSuccess;
}

final class SensorActiveAlarmError extends SensorActiveAlarmViewModelState {
  const SensorActiveAlarmError(this.message);

  final String message;
}
