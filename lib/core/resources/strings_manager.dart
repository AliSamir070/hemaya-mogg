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

  static const String selectFromDate = 'Select From Date';
  static const String selectToDate = 'Select To Date';
  static const String delegationBeginHint =
      'Choose when the delegation should begin';
  static const String delegationEndHint =
      'Choose when the delegation should end';
  static const String confirmDate = 'Confirm Date';

  static String delegationSummary(String name, String from, String to) =>
      '$name will receive your sensor and motion alerts from $from to $to.';

  static String delegationActivated(String name) => 'Alerts delegated to $name';

  // Sensor details
  static const String back = 'Back';
  static const String live = 'Live';
  static const String updatedJustNow = 'Updated just now';
  static String updatedAgo(String ago) => 'Updated $ago ago';
  static const String temperature = 'Temperature';
  static const String humidity = 'Humidity';
  static const String celsius = '°C';
  static const String percentRh = '% RH';
  static const String last24Hours = 'Last 24 hours';
  static const String temp = 'Temp';
  static const String now = 'Now';
  static const String thresholdAlerts = 'Threshold Alerts';
  static const String thresholdAlertsHint =
      'Get notified when temp or humidity crosses your set limits';
  static const String alarmEvents = 'Alarm Events';
  static const String viewHistory = 'View history';
  static const String setThresholds = 'Set Thresholds';
  static const String tempAndHumidity = 'Temp & humidity';
  static const String comingSoon = 'Coming soon';
  static const String noReadings = 'No readings in the last 24 hours';

  // Comfort statuses
  static const String cold = 'Cold';
  static const String cool = 'Cool';
  static const String comfortable = 'Comfortable';
  static const String warm = 'Warm';
  static const String hot = 'Hot';
  static const String dry = 'Dry';
  static const String normal = 'Normal';
  static const String humid = 'Humid';
}
