import 'delegate_user_ui_model.dart';
import 'device_ui_model.dart';

/// Temporary static data matching the Figma design.
/// TODO: replace with data coming from the domain/data layers (eWeLink API).
abstract final class HomeDummyData {
  static const List<DeviceUiModel> devices = [
    DeviceUiModel(
      id: 'airguard-th',
      name: 'Sensor',
      description: 'Temp & Humidity Sensor',
      category: DeviceCategory.sensor,
      actionHint: 'Tap to view live dashboard',
      metrics: [
        DeviceMetricUiModel(label: '24.6°C', tone: MetricTone.warm),
        DeviceMetricUiModel(label: '52% RH', tone: MetricTone.cool),
      ],
    ),
    DeviceUiModel(
      id: 'front-door-camera',
      name: 'Front Door Camera',
      description: 'eWeLink Smart Camera · Wi-Fi',
      category: DeviceCategory.camera,
      actionHint: 'Tap to view last snapshot',
      metrics: [
        DeviceMetricUiModel(label: 'Recording', tone: MetricTone.success),
      ],
    ),
  ];

  static const List<DelegateUserUiModel> delegateUsers = [
    DelegateUserUiModel(
      id: 'sarah',
      fullName: 'Sarah Ahmed',
      email: 'sarah.ahmed@email.com',
    ),
    DelegateUserUiModel(
      id: 'omar',
      fullName: 'Omar Khaled',
      email: 'omar.khaled@email.com',
    ),
    DelegateUserUiModel(
      id: 'layla',
      fullName: 'Layla Hassan',
      email: 'layla.hassan@email.com',
    ),
  ];
}
