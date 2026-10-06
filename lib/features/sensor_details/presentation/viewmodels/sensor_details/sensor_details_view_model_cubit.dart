import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../models/sensor_details_dummy_data.dart';
import '../../models/sensor_details_ui_model.dart';

part 'sensor_details_view_model_state.dart';

@injectable
class SensorDetailsViewModelCubit extends Cubit<SensorDetailsViewModelState> {
  SensorDetailsViewModelCubit()
    : _random = math.Random(),
      liveInterval = const Duration(seconds: 5),
      super(const SensorDetailsInitial());

  final Duration liveInterval;
  final math.Random _random;

  Timer? _liveTimer;
  SensorDetailsUiModel? _currentSensor;

  SensorDetailsUiModel? get currentSensor => _currentSensor;

  void loadSensor({required String deviceId, required String deviceName}) {
    emit(const SensorDetailsLoading());
    final sensor = SensorDetailsDummyData.sensor(
      id: deviceId,
      name: deviceName,
    );
    _currentSensor = sensor;
    emit(SensorDetailsSuccess(sensor));
  }

  void startLiveUpdates() {
    _liveTimer?.cancel();
    _liveTimer = Timer.periodic(liveInterval, (_) => _applyNextReading());
  }

  void stopLiveUpdates() {
    _liveTimer?.cancel();
    _liveTimer = null;
  }

  /// Pull-to-refresh: simulates fetching the latest sensor reading.
  Future<void> refresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (isClosed) return;
    _applyNextReading();
  }

  void setThresholdAlerts(bool enabled) {
    final sensor = _currentSensor;
    if (sensor == null || sensor.thresholdAlertsEnabled == enabled) return;
    final updated = sensor.copyWith(thresholdAlertsEnabled: enabled);
    _currentSensor = updated;
    emit(SensorDetailsSuccess(updated));
  }

  void _applyNextReading() {
    final sensor = _currentSensor;
    if (sensor == null || isClosed) return;

    final temperature =
        (sensor.temperature + (_random.nextDouble() - 0.5) * 0.6).clamp(
          16.0,
          32.0,
        );
    final humidity = (sensor.humidity + (_random.nextDouble() - 0.5) * 3).clamp(
      25.0,
      80.0,
    );
    final roundedTemperature = (temperature * 10).roundToDouble() / 10;
    final roundedHumidity = humidity.roundToDouble();
    final now = DateTime.now();

    final history = [...sensor.history];
    if (history.isNotEmpty) {
      history[history.length - 1] = SensorSample(
        time: now,
        temperature: roundedTemperature,
        humidity: roundedHumidity,
      );
    }

    final updated = sensor.copyWith(
      temperature: roundedTemperature,
      humidity: roundedHumidity,
      lastUpdated: now,
      history: List.unmodifiable(history),
    );
    _currentSensor = updated;
    emit(SensorDetailsSuccess(updated));
  }

  @override
  Future<void> close() {
    _liveTimer?.cancel();
    return super.close();
  }
}
