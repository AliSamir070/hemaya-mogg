part of 'sensor_details_view_model_cubit.dart';

sealed class SensorDetailsViewModelState {
  const SensorDetailsViewModelState();
}

final class SensorDetailsInitial extends SensorDetailsViewModelState {
  const SensorDetailsInitial();
}

final class SensorDetailsLoading extends SensorDetailsViewModelState {
  const SensorDetailsLoading();
}

final class SensorDetailsSuccess extends SensorDetailsViewModelState {
  const SensorDetailsSuccess(this.sensor);

  final SensorDetailsUiModel sensor;
}

final class SensorDetailsError extends SensorDetailsViewModelState {
  const SensorDetailsError(this.message);

  final String message;
}
