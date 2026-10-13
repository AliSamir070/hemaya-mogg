import '../../../../core/resources/strings_manager.dart';
import 'camera_snapshot_ui_model.dart';

/// Temporary data until the eWeLink camera data/domain layers are wired.
abstract final class CameraSnapshotDummyData {
  static CameraSnapshotUiModel snapshot({
    required String id,
    required String name,
  }) {
    return CameraSnapshotUiModel(
      deviceId: id,
      name: name,
      description: StringsManager.cameraDescription,
      capturedAt: DateTime.now().subtract(const Duration(minutes: 4)),
      eventLabel: StringsManager.motionDetectedNearFrontDoor,
      isOnline: true,
      isRecording: true,
      motionAlertsEnabled: true,
    );
  }
}
