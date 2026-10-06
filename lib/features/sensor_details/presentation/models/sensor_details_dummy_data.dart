import 'dart:math' as math;

import 'sensor_details_ui_model.dart';

/// Temporary data matching the Figma design.
/// TODO: replace with readings coming from the domain/data layers (eWeLink API).
abstract final class SensorDetailsDummyData {
  /// Number of samples in the 24h window (one every 30 minutes).
  static const int _sampleCount = 49;

  static SensorDetailsUiModel sensor({
    required String id,
    required String name,
    DateTime? now,
  }) {
    final end = now ?? DateTime.now();
    final random = math.Random(7);
    const current = (temperature: 24.6, humidity: 52.0);

    final history = List<SensorSample>.generate(_sampleCount, (i) {
      final time = end.subtract(Duration(minutes: 30 * (_sampleCount - 1 - i)));
      if (i == _sampleCount - 1) {
        return SensorSample(
          time: time,
          temperature: current.temperature,
          humidity: current.humidity,
        );
      }
      // Daily wave: temperature and humidity move in opposite directions,
      // like in the Figma trend card.
      final t = i / (_sampleCount - 1);
      final wave = math.sin(t * 2 * math.pi * 1.5 + 0.4);
      final noise = random.nextDouble() - 0.5;
      return SensorSample(
        time: time,
        temperature: 23.8 + 1.7 * wave + noise * 0.3,
        humidity: 52 - 8 * wave + noise * 1.5,
      );
    }, growable: false);

    return SensorDetailsUiModel(
      id: id,
      name: name,
      temperature: current.temperature,
      humidity: current.humidity,
      lastUpdated: end,
      history: history,
    );
  }
}
