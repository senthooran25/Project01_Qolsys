import 'package:flutter/services.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:qolsys_app/constants/svg_constants.dart';
import 'package:qolsys_app/constants/text_constants.dart';
import 'package:qolsys_app/generated/locale_keys.g.dart';
import 'package:qolsys_app/models/alarm.dart';
import 'package:qolsys_app/models/sensor.dart';
import 'package:easy_localization/easy_localization.dart';

Future<String> getDeviceId() async {
  try {
    final deviceId = await PlatformDeviceId.getDeviceId;
    return deviceId;
  } on PlatformException {
    return 'Qolsys_Mobile';
  }
}

String getBatteryAsset(int batteryLevel) {
  if (batteryLevel == 100) return ICON_BATTERY_100;
  if (batteryLevel > 90) return ICON_BATTERY_90;
  if (batteryLevel > 80) return ICON_BATTERY_80;
  if (batteryLevel > 70) return ICON_BATTERY_70;
  if (batteryLevel > 60) return ICON_BATTERY_60;
  if (batteryLevel > 50) return ICON_BATTERY_50;
  if (batteryLevel > 40) return ICON_BATTERY_40;
  if (batteryLevel > 30) return ICON_BATTERY_30;
  if (batteryLevel > 20) return ICON_BATTERY_20;
  if (batteryLevel > 10) return ICON_BATTERY_10;
  return ICON_BATTERY_CRITICAL;
}

String getAlarmDescription(Alarm alarm, Sensor sensor) {
  String result;
  String sensorName = sensor?.sensorName ?? '';
  switch (alarm.eventType) {
    case alarmPanelKeypad:
      result = LocaleKeys.panelKeypadAlarm.tr();
      break;
    case zoneAlarmNotUsed:
      result =
          LocaleKeys.zoneAlarmNotUsed.tr(namedArgs: {'zoneName': sensorName});
      break;
    case zoneAlarmPerimeter:
      result = LocaleKeys.zoneAlarm.tr(namedArgs: {'zoneName': sensorName});
      break;
    case zoneAlarm24hrFire:
      result = LocaleKeys.zoneFireAlarm.tr(namedArgs: {'zoneName': sensorName});
      break;
    case zoneAlarm24hrFireWithVerification:
      result = LocaleKeys.zoneFireAlarm.tr(namedArgs: {'zoneName': sensorName});
      break;
    case zoneAlarmSilentBurglary:
      result =
          LocaleKeys.zoneSilentAlarm.tr(namedArgs: {'zoneName': sensorName});
      break;
    case alarmEmergencyPolice:
      result = LocaleKeys.policeAlarm.tr();
      break;
    case alarmEmergencyFire:
      result = LocaleKeys.fireAlarm.tr();
      break;
    case alarmEmergencyMedical:
      result = LocaleKeys.medicalAlarm.tr();
      break;
    case alarmEmergencyDuress:
      result = LocaleKeys.duressAlarm.tr();
      break;
    case zoneAlarmZoneTamper:
      result =
          LocaleKeys.zoneTamperedAlarm.tr(namedArgs: {'zoneName': sensorName});
      break;
    case alarmPanelTamper:
      result = LocaleKeys.panelTamperedAlarm.tr();
      break;
    case zoneAlarmEmergencyMedical:
      result =
          LocaleKeys.zoneMedicalAlarm.tr(namedArgs: {'zoneName': sensorName});
      break;
    case zoneAlarmEmergencyPolice:
      result =
          LocaleKeys.zonePoliceAlarm.tr(namedArgs: {'zoneName': sensorName});
      break;
    case alarmRemoteEmergencyFire:
      result = LocaleKeys.remoteFireAlarm.tr();
      break;
    case alarmRemoteEmergencyPolice:
      result = LocaleKeys.remotePoliceAlarm.tr();
      break;
    case alarmRemoteEmergencyMedical:
      result = LocaleKeys.remoteMedicalAlarm.tr();
      break;
    default:
      result = alarm.eventType;
      break;
  }

  return result;
}
