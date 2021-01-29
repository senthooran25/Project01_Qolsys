const String deviceTypeLight = 'Light';
const String deviceTypeDimmer = 'Dimmer';
const String deviceTypeLock = 'Door Lock';
const String deviceTypeThermostat = 'Thermostat';
const String statusOn = 'on';
const String statusOff = 'off';
const String statusLocked = 'LOCK';
const String statusUnLocked = 'UNLOCK';
const String requestSuccess = 'SUCCESS';

const String statusOpened = 'opened';
const String statusTampered = 'tamper';
const String statusClosed = 'closed';
const String statusActive = 'active';
const String statusIdle = 'idle';
const String statusFailure = 'failure';
const String statusNormal = 'normal';

const String statusArmStay = 'arm_stay';
const String statusArmAway = 'arm_away';
const String statusDisarm = 'disarm';

const String stateBypassNone = 'bypass_none';
const String stateBypassNormal = 'bypass_normal';
const String stateBypassManual = 'bypass_manual';
const String stateBypassForced = 'bypass_forced';

const String topicArmingNotification = 'arming_status';
const String topicSensorNotification = 'security_sensors';
const String topicAlarmsNotification = 'alarms';
const List<String> defaultNotificationTopics = [
  topicArmingNotification,
  topicSensorNotification,
  topicAlarmsNotification,
];

const String sensorsFilter = 'sensors';
const String armingFilter = 'arming';
const String alarmsFilter = 'alarms';
const String homeAutomationFilter = 'homeautomation';
const historyEventFilters = [
  sensorsFilter,
  armingFilter,
  alarmsFilter,
  homeAutomationFilter
];

const historyEventsRequiredEventClasses = [
  'zone_operation',
  'zone_config',
  'zone_delete',
  'zone_bypass',
  'zwave_operation',
  'zwave_config',
  'panel_arming',
  'panel_alarm',
];

const String alarmPanelKeypad = 'alarm_panel_keypad';
const String zoneAlarmNotUsed = 'zone_alarm_not_used';
const String zoneAlarmPerimeter = 'zone_alarm_perimeter';
const String zoneAlarm24hrFire = 'zone_alarm_24hr_fire';
const String zoneAlarm24hrFireWithVerification =
    'zone_alarm_24hr_fire_with_verification';
const String zoneAlarmSilentBurglary = 'zone_alarm_silent_burglary';
const String alarmEmergencyPolice = 'alarm_emergency_police';
const String alarmEmergencyFire = 'alarm_emergency_fire';
const String alarmEmergencyMedical = 'alarm_emergency_medical';
const String alarmEmergencyDuress = 'alarm_emergency_duress';
const String zoneAlarmZoneTamper = 'zone_alarm_zone_tamper';
const String alarmPanelTamper = 'alarm_panel_tamper';
const String zoneAlarmEmergencyMedical = 'zone_alarm_emergency_medical';
const String zoneAlarmEmergencyPolice = 'zone_alarm_emergency_police';
const String alarmRemoteEmergencyFire = 'alarm_remote_emergency_fire';
const String alarmRemoteEmergencyPolice = 'alarm_remote_emergency_police';
const String alarmRemoteEmergencyMedical = 'alarm_remote_emergency_medical';

const activeSensorStatuses = [
  statusOpened,
  statusTampered,
  statusFailure,
];

const crashlyticsCustomKeyAccountNumber = 'AccountNumber';
