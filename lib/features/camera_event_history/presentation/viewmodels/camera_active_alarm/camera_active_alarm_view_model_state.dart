part of 'camera_active_alarm_view_model_cubit.dart';

sealed class CameraActiveAlarmViewModelState {
  const CameraActiveAlarmViewModelState();
}

final class CameraActiveAlarmInitial extends CameraActiveAlarmViewModelState {
  const CameraActiveAlarmInitial();
}

final class CameraActiveAlarmLoading extends CameraActiveAlarmViewModelState {
  const CameraActiveAlarmLoading();
}

final class CameraActiveAlarmSuccess extends CameraActiveAlarmViewModelState {
  const CameraActiveAlarmSuccess({
    required this.alarm,
    this.isAcknowledging = false,
    this.isAcknowledgedSuccess = false,
  });

  final CameraActiveAlarmUiModel alarm;
  final bool isAcknowledging;
  final bool isAcknowledgedSuccess;
}

final class CameraActiveAlarmError extends CameraActiveAlarmViewModelState {
  const CameraActiveAlarmError(this.message);

  final String message;
}
