// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'automation_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AutomationDevice _$AutomationDeviceFromJson(Map<String, dynamic> json) {
  return AutomationDevice(
    deviceId: json['device_id'] as int,
    endpointId: json['endpoint_id'] as int,
    deviceType: json['device_type'] as String,
    deviceName: json['device_name'] as String,
    deviceState: json['device_state'] as String,
    deviceStatus: json['device_status'] as String,
    mode: json['mode'] as String,
    fanMode: json['fan_mode'] as String,
    currentTemp: (json['current_temp'] as num)?.toDouble(),
    targetTempHigh: (json['target_temp_high'] as num)?.toDouble(),
    targetTempLow: (json['target_temp_low'] as num)?.toDouble(),
    brightnessLevel: json['brightness_level'] as int,
    installationDate: json['installation_date'] as int,
    batteryStatus: json['battery_status'] as int,
  );
}

Map<String, dynamic> _$AutomationDeviceToJson(AutomationDevice instance) =>
    <String, dynamic>{
      'device_id': instance.deviceId,
      'endpoint_id': instance.endpointId,
      'device_type': instance.deviceType,
      'device_name': instance.deviceName,
      'device_state': instance.deviceState,
      'installation_date': instance.installationDate,
      'device_status': instance.deviceStatus,
      'mode': instance.mode,
      'fan_mode': instance.fanMode,
      'current_temp': instance.currentTemp,
      'target_temp_high': instance.targetTempHigh,
      'target_temp_low': instance.targetTempLow,
      'brightness_level': instance.brightnessLevel,
      'battery_status': instance.batteryStatus,
    };
