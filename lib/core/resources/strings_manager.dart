abstract class StringsManager {
  // Home tabs
  static const String devicesTab = 'Devices';
  static const String delegateTab = 'Delegate';

  // Devices tab
  static const String myDevices = 'My Devices';
  static const String searchDevices = 'Search devices';
  static const String noDevicesFound = 'No devices match your search';
  static const String online = 'Online';
  static const String offline = 'Offline';

  // Delegate tab
  static const String delegate = 'Delegate';
  static const String chooseAPerson = 'Choose a person';
  static const String delegationPeriod = 'Delegation period';
  static const String from = 'From';
  static const String to = 'To';
  static const String activateDelegation = 'Activate Delegation';
  static const String noPeopleAvailable = 'No people available to delegate to';
  static const String choosePersonHint =
      'Choose a person to receive your sensor and motion alerts.';

  static String delegationSummary(String name, String from, String to) =>
      '$name will receive your sensor and motion alerts from $from to $to.';

  static String delegationActivated(String name) =>
      'Alerts delegated to $name';
}