/// Arguments passed to `Routes.sensorThresholdsRoute`.
class SensorThresholdsArgs {
  const SensorThresholdsArgs({
    required this.deviceId,
    required this.deviceName,
    required this.currentTemperature,
    required this.currentHumidity,
    this.initialTemperatureThreshold = 28.0,
    this.initialHumidityThreshold = 60.0,
  });

  final String deviceId;
  final String deviceName;
  final double currentTemperature;
  final double currentHumidity;
  final double initialTemperatureThreshold;
  final double initialHumidityThreshold;
}

/// Presentation model representing the current and threshold sensor values.
class SensorThresholdsUiModel {
  const SensorThresholdsUiModel({
    required this.deviceId,
    required this.deviceName,
    required this.currentTemperature,
    required this.currentHumidity,
    required this.temperatureThreshold,
    required this.humidityThreshold,
    this.minTemperature = 10.0,
    this.maxTemperature = 40.0,
    this.minHumidity = 20.0,
    this.maxHumidity = 80.0,
  });

  final String deviceId;
  final String deviceName;
  final double currentTemperature;
  final double currentHumidity;
  final double temperatureThreshold;
  final double humidityThreshold;
  final double minTemperature;
  final double maxTemperature;
  final double minHumidity;
  final double maxHumidity;

  SensorThresholdsUiModel copyWith({
    String? deviceId,
    String? deviceName,
    double? currentTemperature,
    double? currentHumidity,
    double? temperatureThreshold,
    double? humidityThreshold,
    double? minTemperature,
    double? maxTemperature,
    double? minHumidity,
    double? maxHumidity,
  }) {
    return SensorThresholdsUiModel(
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName ?? this.deviceName,
      currentTemperature: currentTemperature ?? this.currentTemperature,
      currentHumidity: currentHumidity ?? this.currentHumidity,
      temperatureThreshold: temperatureThreshold ?? this.temperatureThreshold,
      humidityThreshold: humidityThreshold ?? this.humidityThreshold,
      minTemperature: minTemperature ?? this.minTemperature,
      maxTemperature: maxTemperature ?? this.maxTemperature,
      minHumidity: minHumidity ?? this.minHumidity,
      maxHumidity: maxHumidity ?? this.maxHumidity,
    );
  }
}
