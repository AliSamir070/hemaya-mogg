/// Event types supported in the camera event history stream.
enum CameraEventType { motion, person }

/// Filter options for the camera event history tab chips.
enum CameraEventFilter { all, motion, person }

/// Arguments passed to `Routes.cameraEventHistoryRoute`.
class CameraEventHistoryArgs {
  const CameraEventHistoryArgs({
    required this.deviceId,
    required this.deviceName,
  });

  final String deviceId;
  final String deviceName;
}

/// UI representation of a single camera event row in the history list.
class CameraEventItemUiModel {
  const CameraEventItemUiModel({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.isAcknowledged,
    this.thumbnailUrl,
  });

  final String id;
  final CameraEventType type;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final bool isAcknowledged;
  final String? thumbnailUrl;

  CameraEventItemUiModel copyWith({
    String? id,
    CameraEventType? type,
    String? title,
    String? subtitle,
    DateTime? timestamp,
    bool? isAcknowledged,
    String? thumbnailUrl,
  }) {
    return CameraEventItemUiModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      timestamp: timestamp ?? this.timestamp,
      isAcknowledged: isAcknowledged ?? this.isAcknowledged,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }
}
