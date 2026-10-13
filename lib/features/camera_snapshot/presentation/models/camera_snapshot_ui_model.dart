/// Arguments passed to `Routes.cameraSnapshotRoute`.
class CameraSnapshotArgs {
  const CameraSnapshotArgs({required this.deviceId, required this.deviceName});

  final String deviceId;
  final String deviceName;
}

/// Presentation model for the "04 · Camera Snapshot" screen.
class CameraSnapshotUiModel {
  const CameraSnapshotUiModel({
    required this.deviceId,
    required this.name,
    required this.description,
    required this.capturedAt,
    required this.isOnline,
    required this.isRecording,
    required this.motionAlertsEnabled,
    this.imageUrl,
    this.eventLabel,
  });

  final String deviceId;
  final String name;

  /// e.g. "eWeLink Smart Camera · Wi-Fi".
  final String description;

  /// Remote URL of the last snapshot. `null` shows the illustrated placeholder.
  final String? imageUrl;
  final DateTime capturedAt;

  /// Event that triggered the snapshot, e.g. "Motion detected near front door".
  final String? eventLabel;
  final bool isOnline;
  final bool isRecording;
  final bool motionAlertsEnabled;

  CameraSnapshotUiModel copyWith({
    String? imageUrl,
    DateTime? capturedAt,
    String? eventLabel,
    bool? isOnline,
    bool? isRecording,
    bool? motionAlertsEnabled,
  }) {
    return CameraSnapshotUiModel(
      deviceId: deviceId,
      name: name,
      description: description,
      imageUrl: imageUrl ?? this.imageUrl,
      capturedAt: capturedAt ?? this.capturedAt,
      eventLabel: eventLabel ?? this.eventLabel,
      isOnline: isOnline ?? this.isOnline,
      isRecording: isRecording ?? this.isRecording,
      motionAlertsEnabled: motionAlertsEnabled ?? this.motionAlertsEnabled,
    );
  }
}
