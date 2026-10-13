part of 'sensor_thresholds_view_model_cubit.dart';

sealed class SensorThresholdsViewModelState {
  const SensorThresholdsViewModelState();
}

final class SensorThresholdsInitial extends SensorThresholdsViewModelState {
  const SensorThresholdsInitial();
}

final class SensorThresholdsLoading extends SensorThresholdsViewModelState {
  const SensorThresholdsLoading();
}

final class SensorThresholdsSuccess extends SensorThresholdsViewModelState {
  const SensorThresholdsSuccess({
    required this.thresholds,
    this.isSaving = false,
    this.isSaveSuccess = false,
  });

  final SensorThresholdsUiModel thresholds;
  final bool isSaving;
  final bool isSaveSuccess;
}

final class SensorThresholdsError extends SensorThresholdsViewModelState {
  const SensorThresholdsError(this.message);

  final String message;
}
