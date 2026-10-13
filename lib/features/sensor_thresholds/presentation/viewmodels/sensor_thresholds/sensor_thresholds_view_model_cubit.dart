import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../models/sensor_thresholds_ui_model.dart';

part 'sensor_thresholds_view_model_state.dart';

@injectable
class SensorThresholdsViewModelCubit
    extends Cubit<SensorThresholdsViewModelState> {
  SensorThresholdsViewModelCubit() : super(const SensorThresholdsInitial());

  SensorThresholdsUiModel? _current;

  void initThresholds(SensorThresholdsArgs args) {
    emit(const SensorThresholdsLoading());
    _current = SensorThresholdsUiModel(
      deviceId: args.deviceId,
      deviceName: args.deviceName,
      currentTemperature: args.currentTemperature,
      currentHumidity: args.currentHumidity,
      temperatureThreshold: args.initialTemperatureThreshold,
      humidityThreshold: args.initialHumidityThreshold,
    );
    emit(SensorThresholdsSuccess(thresholds: _current!));
  }

  void updateTemperatureThreshold(double value) {
    final current = _current;
    if (current == null) return;
    final clamped = value.clamp(current.minTemperature, current.maxTemperature);
    final rounded = (clamped * 10).roundToDouble() / 10;
    _current = current.copyWith(temperatureThreshold: rounded);
    emit(SensorThresholdsSuccess(thresholds: _current!));
  }

  void adjustTemperatureThreshold(double delta) {
    final current = _current;
    if (current == null) return;
    updateTemperatureThreshold(current.temperatureThreshold + delta);
  }

  void updateHumidityThreshold(double value) {
    final current = _current;
    if (current == null) return;
    final clamped = value.clamp(current.minHumidity, current.maxHumidity);
    final rounded = clamped.roundToDouble();
    _current = current.copyWith(humidityThreshold: rounded);
    emit(SensorThresholdsSuccess(thresholds: _current!));
  }

  void adjustHumidityThreshold(double delta) {
    final current = _current;
    if (current == null) return;
    updateHumidityThreshold(current.humidityThreshold + delta);
  }

  Future<void> saveThresholds() async {
    final current = _current;
    if (current == null) return;

    emit(SensorThresholdsSuccess(thresholds: current, isSaving: true));
    // Simulate API delay; when Clean Architecture Domain is wired, this delegates to SetThresholdsUseCase.
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (isClosed) return;

    emit(
      SensorThresholdsSuccess(
        thresholds: current,
        isSaving: false,
        isSaveSuccess: true,
      ),
    );
  }
}
