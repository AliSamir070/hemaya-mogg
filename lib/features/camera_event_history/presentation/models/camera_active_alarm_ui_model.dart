import 'camera_event_ui_model.dart';

/// Arguments passed to `Routes.cameraActiveAlarmRoute`.
class CameraActiveAlarmArgs {
  const CameraActiveAlarmArgs({
    required this.event,
    required this.deviceName,
  });

  final CameraEventItemUiModel event;
  final String deviceName;
}

/// UI presentation model for the Camera Active Alarm screen.
class CameraActiveAlarmUiModel {
  const CameraActiveAlarmUiModel({
    required this.event,
    required this.deviceName,
    required this.detectionTypeLabel,
    required this.detectionDetailLabel,
  });

  final CameraEventItemUiModel event;
  final String deviceName;
  final String detectionTypeLabel;
  final String detectionDetailLabel;

  CameraActiveAlarmUiModel copyWith({
    CameraEventItemUiModel? event,
    String? deviceName,
    String? detectionTypeLabel,
    String? detectionDetailLabel,
  }) {
    return CameraActiveAlarmUiModel(
      event: event ?? this.event,
      deviceName: deviceName ?? this.deviceName,
      detectionTypeLabel: detectionTypeLabel ?? this.detectionTypeLabel,
      detectionDetailLabel: detectionDetailLabel ?? this.detectionDetailLabel,
    );
  }
}
