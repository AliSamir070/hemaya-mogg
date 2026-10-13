import '../../../../core/resources/strings_manager.dart';
import 'camera_event_ui_model.dart';

abstract final class CameraEventHistoryDummyData {
  static List<CameraEventItemUiModel> events() {
    final now = DateTime.now();
    return [
      CameraEventItemUiModel(
        id: 'evt_1',
        type: CameraEventType.motion,
        title: StringsManager.motionDetected,
        subtitle: 'Person near front door',
        timestamp: DateTime(now.year, now.month, now.day, 14, 32),
        isAcknowledged: false,
      ),
      CameraEventItemUiModel(
        id: 'evt_2',
        type: CameraEventType.motion,
        title: StringsManager.motionDetected,
        subtitle: 'Package delivery',
        timestamp: DateTime(now.year, now.month, now.day, 11, 5),
        isAcknowledged: false,
      ),
      CameraEventItemUiModel(
        id: 'evt_3',
        type: CameraEventType.person,
        title: StringsManager.personDetected,
        subtitle: 'Unknown visitor',
        timestamp: DateTime(now.year, now.month, now.day - 1, 19, 40),
        isAcknowledged: true,
      ),
      CameraEventItemUiModel(
        id: 'evt_4',
        type: CameraEventType.motion,
        title: StringsManager.motionDetected,
        subtitle: 'Cat passing by',
        timestamp: DateTime(now.year, now.month, now.day - 1, 8, 12),
        isAcknowledged: true,
      ),
      CameraEventItemUiModel(
        id: 'evt_5',
        type: CameraEventType.person,
        title: StringsManager.personDetected,
        subtitle: 'Delivery courier',
        timestamp: DateTime(now.year, now.month, now.day - 2, 15, 27),
        isAcknowledged: true,
      ),
    ];
  }
}
