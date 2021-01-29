import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'automation_device.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AutomationDevice {
  int deviceId;
  int endpointId;
  String deviceType;
  String deviceName;
  String deviceState;
  int installationDate;
  String deviceStatus;
  String mode;
  String fanMode;
  double currentTemp;
  double targetTempHigh;
  double targetTempLow;
  int brightnessLevel;
  int batteryStatus;

  @JsonKey(ignore: true)
  bool loading = false;

  AutomationDevice({
    this.deviceId,
    this.endpointId,
    this.deviceType,
    this.deviceName,
    this.deviceState,
    this.deviceStatus,
    this.mode,
    this.fanMode,
    this.currentTemp,
    this.targetTempHigh,
    this.targetTempLow,
    this.brightnessLevel,
    this.installationDate,
    this.batteryStatus,
  });

  factory AutomationDevice.fromJson(Map<String, dynamic> json) =>
      _$AutomationDeviceFromJson(json);
  Map<String, dynamic> toJson() => _$AutomationDeviceToJson(this);
}
