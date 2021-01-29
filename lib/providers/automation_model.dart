import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:qolsys_app/constants/text_constants.dart';
import 'package:qolsys_app/models/automation_device.dart';
import 'package:qolsys_app/providers/q_change_notifier.dart';
import 'package:qolsys_app/repos/iqcloud_repository.dart';
import 'package:qolsys_app/utils/qolsys_logger.dart';

class AutomationModel extends QChangeNotifier {
  final _log = getLogger('AutomationModel');

  IQCloudRepository repo;
  AutomationModel(this.repo) : super(repo);

  List<AutomationDevice> _automationDevices = [];
  List<AutomationDevice> get locks =>
      UnmodifiableListView(devicesByType([deviceTypeLock]));

  List<AutomationDevice> get lights =>
      UnmodifiableListView(devicesByType([deviceTypeLight, deviceTypeDimmer]));

  List<AutomationDevice> get thermostats =>
      UnmodifiableListView(devicesByType([deviceTypeThermostat]));

  List<AutomationDevice> devicesByType(List<String> deviceTypes) {
    return _automationDevices
        .where((d) => deviceTypes.contains(d.deviceType))
        .toList();
  }

  Future fetchAutomationDevices() async {
    _log.i('fetchAutomationDevices()');
    Function requestFunc = () async {
      final devices = await repo.getAutomationDevices();
      _automationDevices = devices;
    };
    return sendRequest(requestFunc);
  }

  Future setDeviceStatus(int deviceId, String status) async {
    _log.i('setDeviceStatus() | deviceId: $deviceId status: $status');
    Function requestFunc = () async {
      final response = await repo.setDeviceStatus(
        deviceId: deviceId,
        deviceStatus: status,
      );
      if (response.requestStatus)
        getAutomationDevice(deviceId)?.deviceStatus = status;
    };
    return sendRequest(
      requestFunc,
      (val) => _setAutomationDeviceLoading(deviceId, val),
    );
  }

  void refreshDoorLock(int deviceId) {
    _log.i('refreshDoorLock() | deviceId: $deviceId');
    fetchDeviceStatus(deviceId);
    fetchHomeautomationDeviceBatteryStatus(deviceId);
  }

  Future fetchHomeautomationDeviceBatteryStatus(int deviceId) async {
    _log.i('fetchHomeautomationDeviceBatteryStatus() | deviceId: $deviceId');
    Function requestFunc = () async {
      final deviceProperty = await repo.getAutomationDeviceBatteryStatus(
        deviceId: deviceId,
      );
      getAutomationDevice(deviceId)?.batteryStatus =
          deviceProperty.batteryStatus;
    };
    return sendRequest(
      requestFunc,
      (val) => _setAutomationDeviceLoading(deviceId, val),
    );
  }

  Future fetchDeviceStatus(int deviceId) async {
    _log.i('fetchDeviceStatus() | deviceId: $deviceId');
    Function requestFunc = () async {
      final deviceProperty = await repo.getDeviceStatus(deviceId: deviceId);
      getAutomationDevice(deviceId)?.deviceStatus = deviceProperty.deviceStatus;
    };
    return sendRequest(
      requestFunc,
      (val) => _setAutomationDeviceLoading(deviceId, val),
    );
  }

  //TODO: don't require status when changing dimmer level. status will always be ON
  Future setDimmer({
    @required int deviceId,
    String status,
    @required int level,
  }) async {
    _log.i('setDimmer() | deviceId: $deviceId level: $level');
    Function requestFunc = () async {
      final response = await repo.setDimmer(
          deviceId: deviceId, deviceStatus: status, level: level);
      if (response.requestStatus)
        getAutomationDevice(deviceId)
          ..deviceStatus = status
          ..brightnessLevel = level;
    };
    return sendRequest(
      requestFunc,
      (val) => _setAutomationDeviceLoading(deviceId, val),
    );
  }

  Future setThermostatMode({
    @required int deviceId,
    @required String mode,
  }) async {
    _log.i('setThermostatMode() | deviceId: $deviceId mode: $mode');
    Function requestFunc = () async {
      final response = await repo.setThermostatMode(
        deviceId: deviceId,
        mode: mode,
      );
      if (response.requestStatus) getAutomationDevice(deviceId)..mode = mode;
    };
    return sendRequest(
      requestFunc,
      (val) => _setAutomationDeviceLoading(deviceId, val),
    );
  }

  Future setThermostatFanMode({
    @required int deviceId,
    @required String fanMode,
  }) async {
    _log.i('setThermostatFanMode() | deviceId: $deviceId fanMode: $fanMode');
    Function requestFunc = () async {
      final response = await repo.setThermostatFanMode(
        deviceId: deviceId,
        fanMode: fanMode,
      );
      if (response.requestStatus)
        getAutomationDevice(deviceId)..fanMode = fanMode;
    };
    return sendRequest(
      requestFunc,
      (val) => _setAutomationDeviceLoading(deviceId, val),
    );
  }

  Future setThermostatCoolSetPoint({
    @required int deviceId,
    @required double coolSetPoint,
  }) async {
    _log.i(
        'setThermostatCoolSetPoint() | deviceId: $deviceId coolSetPoint: $coolSetPoint');
    Function requestFunc = () async {
      final response = await repo.setThermostatCoolSetPoint(
        deviceId: deviceId,
        coolSetPointTemp: coolSetPoint,
      );
      if (response.requestStatus)
        getAutomationDevice(deviceId)..targetTempLow = coolSetPoint;
    };
    return sendRequest(
      requestFunc,
      (val) => _setAutomationDeviceLoading(deviceId, val),
    );
  }

  Future setThermostatHeatSetPoint({
    @required int deviceId,
    @required double heatSetPoint,
  }) async {
    _log.i('setThermostatHeatSetPoint()');
    Function requestFunc = () async {
      final response = await repo.setThermostatHeatSetPoint(
        deviceId: deviceId,
        heatSetPointTemp: heatSetPoint,
      );
      if (response.requestStatus)
        getAutomationDevice(deviceId)..targetTempHigh = heatSetPoint;
    };
    return sendRequest(
      requestFunc,
      (val) => _setAutomationDeviceLoading(deviceId, val),
    );
  }

  AutomationDevice getAutomationDevice(int deviceId) {
    return _automationDevices.firstWhere(
      (AutomationDevice d) => d.deviceId == deviceId,
      orElse: () => null,
    );
  }

  void _setAutomationDeviceLoading(int deviceId, bool load) {
    AutomationDevice device = getAutomationDevice(deviceId);
    device?.loading = load;
    notifyListeners();
  }
}
