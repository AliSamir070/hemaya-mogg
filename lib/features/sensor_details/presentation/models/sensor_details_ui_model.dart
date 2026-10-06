/// Arguments passed to `Routes.sensorDetailsRoute`.
class SensorDetailsArgs {
  const SensorDetailsArgs({required this.deviceId, required this.deviceName});

  final String deviceId;
  final String deviceName;
}

/// A single historical reading used by the trend chart.
class SensorSample {
  const SensorSample({
    required this.time,
    required this.temperature,
    required this.humidity,
  });

  final DateTime time;

  /// Degrees Celsius.
  final double temperature;

  /// Relative humidity in percent.
  final double humidity;
}

/// Physical ranges represented by the radial gauges.
abstract final class SensorRanges {
  static const double minTemperature = 0;
  static const double maxTemperature = 50;
  static const double minHumidity = 0;
  static const double maxHumidity = 100;
}

/// Comfort classification of the current temperature.
enum TemperatureStatus {
  cold,
  cool,
  comfortable,
  warm,
  hot;

  static TemperatureStatus fromCelsius(double celsius) {
    if (celsius < 16) return cold;
    if (celsius < 20) return cool;
    if (celsius <= 26) return comfortable;
    if (celsius <= 30) return warm;
    return hot;
  }
}

/// Comfort classification of the current relative humidity.
enum HumidityStatus {
  dry,
  normal,
  humid;

  static HumidityStatus fromPercent(double percent) {
    if (percent < 30) return dry;
    if (percent <= 60) return normal;
    return humid;
  }
}

/// Presentation model for the sensor dashboard (Figma: "01 · Dashboard").
class SensorDetailsUiModel {
  const SensorDetailsUiModel({
    required this.id,
    required this.name,
    required this.temperature,
    required this.humidity,
    required this.lastUpdated,
    required this.history,
    this.isOnline = true,
    this.thresholdAlertsEnabled = true,
  });

  final String id;
  final String name;
  final double temperature;
  final double humidity;
  final DateTime lastUpdated;

  /// Chronologically ordered readings (oldest first) for the last 24 hours.
  final List<SensorSample> history;
  final bool isOnline;
  final bool thresholdAlertsEnabled;

  TemperatureStatus get temperatureStatus =>
      TemperatureStatus.fromCelsius(temperature);

  HumidityStatus get humidityStatus => HumidityStatus.fromPercent(humidity);

  SensorDetailsUiModel copyWith({
    String? name,
    double? temperature,
    double? humidity,
    DateTime? lastUpdated,
    List<SensorSample>? history,
    bool? isOnline,
    bool? thresholdAlertsEnabled,
  }) {
    return SensorDetailsUiModel(
      id: id,
      name: name ?? this.name,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      history: history ?? this.history,
      isOnline: isOnline ?? this.isOnline,
      thresholdAlertsEnabled:
          thresholdAlertsEnabled ?? this.thresholdAlertsEnabled,
    );
  }
}
