/// Device kinds supported on the home screen. Drives the card's accent
/// colour, icon and gradient (see `device_category_style.dart`).
enum DeviceCategory { sensor, camera }

/// Visual tone of a metric chip (e.g. temperature = warm, humidity = cool).
enum MetricTone { warm, cool, success }

class DeviceMetricUiModel {
  const DeviceMetricUiModel({required this.label, required this.tone});

  final String label;
  final MetricTone tone;
}

/// Presentation model for a single device card in the Devices tab.
class DeviceUiModel {
  const DeviceUiModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.actionHint,
    this.isOnline = true,
    this.metrics = const [],
  });

  final String id;
  final String name;
  final String description;
  final DeviceCategory category;

  /// Call-to-action text shown at the bottom of the card.
  final String actionHint;
  final bool isOnline;
  final List<DeviceMetricUiModel> metrics;
}
