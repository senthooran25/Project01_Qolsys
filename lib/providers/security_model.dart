import 'dart:async';
import 'dart:collection';

import 'package:qolsys_app/models/alarm.dart';
import 'package:qolsys_app/models/partition_status.dart';
import 'package:qolsys_app/models/sensor.dart';
import 'package:qolsys_app/repos/iqcloud_repository.dart';
import 'package:qolsys_app/providers/q_change_notifier.dart';
import 'package:qolsys_app/utils/qolsys_logger.dart';

class SecurityModel extends QChangeNotifier {
  final _log = getLogger('SecurityModel');
  IQCloudRepository repo;
  SecurityModel(this.repo) : super(repo);

  List<PartitionStatus> _partitions = [];
  List<Sensor> _sensors = [];
  List<Alarm> _alarms = [];

  List<PartitionStatus> get partitions => UnmodifiableListView(_partitions);
  List<Sensor> get sensors => UnmodifiableListView(_sensors);
  List<Alarm> get alarms => UnmodifiableListView(_alarms);

  List<Sensor> getSensorsByPartition(int partitionId) =>
      sensors.where((Sensor s) => s.partitionId == partitionId).toList();

  Future fetchPartitions() {
    _log.i('fetchPartitions()');
    Function requestFunc = () async {
      final parts = await repo.getStatus();
      _partitions = parts;
    };
    return sendRequest(requestFunc);
  }

  Future fetchSensors() {
    _log.i('fetchSensors()');
    Function requestFunc = () async {
      final devices = await repo.getSensors();
      _sensors = devices;
    };
    return sendRequest(requestFunc);
  }

  Future fetchAlarms() {
    _log.i('fetchAlarms()');
    Function requestFunc = () async {
      final alarms = await repo.getAlarms();
      _alarms = alarms;
    };
    return sendRequest(requestFunc);
  }

  void _setPartitionLoading(int partitionId, bool load) {
    _log.i('_setPartitionLoading() | $partitionId $load');
    PartitionStatus partition = getPartition(partitionId);
    partition?.loading = load;
    notifyListeners();
  }

  void setPartitionArmingStatus(int partitionId, String status) {
    _log.i('setPartitionArmingStatus() | $partitionId $status');
    getPartition(partitionId)?.armingStatus = status;
    notifyListeners();
  }

  void setSensorStatus(int zoneId, String status) {
    _log.i('setSensorStatus() | $zoneId $status');
    getSensor(zoneId)?.sensorStatus = status;
    notifyListeners();
  }

  void setSensorState(int zoneId, String state) {
    _log.i('setSensorState() | $zoneId $state');
    getSensor(zoneId)?.sensorState = state;
    notifyListeners();
  }

  Future addSensor(int zoneId) {
    _log.i('addSensor() | $zoneId');
    if (getSensor(zoneId) != null)
      throw Exception('Sensor with zoneId $zoneId already in sensor list');
    Function requestFunc = () async {
      final sensor = await repo.getSensor(zoneId);
      _sensors.add(sensor);
    };
    return sendRequest(requestFunc);
  }

  Future refreshSensor(int zoneId) {
    _log.i('refreshSensor() | $zoneId');
    Function requestFunc = () async {
      final staleSensor = getSensor(zoneId);
      int index = _sensors.indexOf(staleSensor);
      final currentSensor = await repo.getSensor(zoneId);
      _sensors[index] = currentSensor;
    };
    return sendRequest(requestFunc);
  }

  void removeSensor(int zoneId) {
    _log.i('removeSensor() | $zoneId');
    _sensors.removeWhere((s) => s.zoneId == zoneId);
    notifyListeners();
  }

  PartitionStatus getPartition(int partitionId) {
    _log.i('getPartition() | $partitionId');
    return partitions.firstWhere(
      (PartitionStatus d) => d.partitionId == partitionId,
      orElse: () => null,
    );
  }

  Sensor getSensor(int zoneId) {
    _log.i('getSensor() | $zoneId');
    return sensors.firstWhere(
      (Sensor d) => d.zoneId == zoneId,
      orElse: () => null,
    );
  }

  Future armStay(int partitionId) async {
    _log.i('armStay() | $partitionId');
    Function requestFunc = () async {
      final response = await repo.armStay(partitionId: partitionId);
      if (response.requestStatus)
        setPartitionArmingStatus(partitionId, 'arm_stay');
    };
    return sendRequest(
      requestFunc,
      (val) => _setPartitionLoading(partitionId, val),
    );
  }

  Future armAway(int partitionId) async {
    _log.i('armAway() | $partitionId');
    Function requestFunc = () async {
      final response = await repo.armAway(partitionId: partitionId);
      if (response.requestStatus)
        setPartitionArmingStatus(partitionId, 'arm_away');
    };
    return sendRequest(
      requestFunc,
      (val) => _setPartitionLoading(partitionId, val),
    );
  }

  Future disarm(int partitionId) async {
    _log.i('disarm() | $partitionId');
    Function requestFunc = () async {
      final response = await repo.disarm(partitionId: partitionId);
      if (response.requestStatus)
        setPartitionArmingStatus(partitionId, 'disarm');
    };
    return sendRequest(
      requestFunc,
      (val) => _setPartitionLoading(partitionId, val),
    );
  }
}
