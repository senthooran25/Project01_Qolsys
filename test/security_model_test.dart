import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:qolsys_app/constants/text_constants.dart';
import 'package:qolsys_app/models/partition_status.dart';
import 'package:qolsys_app/models/sensor.dart';
import 'package:qolsys_app/providers/account_model.dart';
import 'package:qolsys_app/providers/security_model.dart';
import 'package:qolsys_app/repos/iqcloud_client.dart';
import 'package:qolsys_app/repos/iqcloud_repository.dart';

class MockDio extends Mock implements Dio {}

class MockAccountModel extends Mock implements AccountModel {
  @override
  String get accessToken => 'dummytoken';

  @override
  String get userName => 'test username';

  @override
  String get accountNumber => '1234';

  @override
  bool isLoggedIn() => true;
}

final sensorList = [
  {
    "protocol_type": "srf",
    "zone_id": 1,
    "sensor_id": "1A5FA2",
    "serial_number": null,
    "partition_id": 0,
    "sensor_name": "Front Window",
    "sensor_type": "contact",
    "sensor_group": "10-entry-exit-normal delay",
    "sensor_state": "bypass_manual",
    "sensor_status": "open",
    "sensor_tts": "on",
    "chime_type": "high_wire",
    "battery_status": "Normal",
    "ac_status": null,
    "area_group": null,
    "mod_input": null,
    "sensor_app": null,
    "installation_date": 1605599974041
  },
];

final partitionList = [
  {
    "partition_id": 0,
    "arming_status": "disarm",
    "user_id": 1,
    "updated_time": 1603140503617
  }
];

final successfulRequest = {
  "request_status": true,
  "updated_time": 1603137298925
};

final unsuccessfulRequest = {
  "error": {
    "statusCode": 500,
    "errorCode": 1010,
    "name": "OPERATION_FAILED",
    "message": "Unable to process the request at panel"
  }
};

main() {
  Dio client;
  AccountModel accountModel;
  SecurityModel securityModel;

  setUp(() {
    client = MockDio();
    accountModel = MockAccountModel();
    securityModel = SecurityModel(
      IQCloudRepository(
        client: IQCloudClient(client),
        account: accountModel,
      ),
    );
  });

  tearDown(() {
    client = null;
    accountModel = null;
    securityModel = null;
  });

  group('Fetch Security Data', () {
    test('Fetch Partition Data Success', () async {
      when(client.request(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response<List<dynamic>>(data: partitionList));

      expect(securityModel.partitions.length, 0);
      await securityModel.fetchPartitions();
      expect(securityModel.partitions.length, 1);
      PartitionStatus partition = securityModel.getPartition(0);
      final samplePartition = partitionList[0];
      expect(partition.partitionId, samplePartition['partition_id']);
      expect(partition.armingStatus, samplePartition['arming_status']);
      expect(partition.userId, samplePartition['user_id']);
      expect(partition.updatedTime, samplePartition['updated_time']);
    });
    test('Fetch Partition Data Server Error', () async {
      when(client.request(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 10));
        throw DioError(
          type: DioErrorType.RESPONSE,
          error: 'error changing partition',
          response: Response<Map<String, dynamic>>(
            data: unsuccessfulRequest,
            statusCode: 500,
          ),
        );
      });

      expect(securityModel.partitions.length, 0);
      await securityModel.fetchPartitions();
      expect(securityModel.partitions.length, 0);
      PartitionStatus partition = securityModel.getPartition(0);
      expect(partition, isNull);
    });
    test('Fetch Sensors Data Success', () async {
      when(client.request(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response<List<dynamic>>(data: sensorList));

      expect(securityModel.sensors.length, 0);
      await securityModel.fetchSensors();
      expect(securityModel.sensors.length, 1);

      final sampleDevice = sensorList[0];
      Sensor deviceFromModel = securityModel.getSensor(sampleDevice['zone_id']);

      expect(deviceFromModel.protocolType, sampleDevice['protocol_type']);
      expect(deviceFromModel.zoneId, sampleDevice['zone_id']);
      expect(deviceFromModel.sensorId, sampleDevice['sensor_id']);
      expect(deviceFromModel.partitionId, sampleDevice['partition_id']);
      expect(deviceFromModel.sensorName, sampleDevice['sensor_name']);
      expect(deviceFromModel.sensorType, sampleDevice['sensor_type']);
      expect(deviceFromModel.sensorGroup, sampleDevice['sensor_group']);
      expect(deviceFromModel.sensorState, sampleDevice['sensor_state']);
      expect(deviceFromModel.sensorStatus, sampleDevice['sensor_status']);
      expect(deviceFromModel.sensorTts, sampleDevice['sensor_tts']);
      expect(deviceFromModel.chimeType, sampleDevice['chime_type']);
      expect(deviceFromModel.batteryStatus, sampleDevice['battery_status']);
      expect(
        deviceFromModel.installationDate,
        sampleDevice['installation_date'],
      );
    });
    test('Fetch Sensors Data Server Error', () async {
      when(client.request(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 10));
        throw DioError(
          type: DioErrorType.RESPONSE,
          error: 'error changing partition',
          response: Response<Map<String, dynamic>>(
            data: unsuccessfulRequest,
            statusCode: 500,
          ),
        );
      });

      expect(securityModel.sensors.length, 0);
      await securityModel.fetchSensors();
      expect(securityModel.sensors.length, 0);

      final sampleDevice = sensorList[0];
      Sensor deviceFromModel = securityModel.getSensor(sampleDevice['zone_id']);
      expect(deviceFromModel, isNull);
    });
  });

  group('Set Security Data', () {
    Dio client;
    AccountModel accountModel;
    SecurityModel securityModel;

    setUp(() async {
      client = MockDio();
      accountModel = MockAccountModel();
      securityModel = SecurityModel(IQCloudRepository(
          client: IQCloudClient(client), account: accountModel));

      when(client.request(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response<List<dynamic>>(data: partitionList));
      await securityModel.fetchPartitions();

      when(client.request(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response<List<dynamic>>(data: sensorList));
      await securityModel.fetchSensors();
    });

    tearDown(() {
      client = null;
      accountModel = null;
      securityModel = null;
    });
    test('Set Partition Arming Status', () async {
      expect(securityModel.getPartition(0).armingStatus, statusDisarm);
      securityModel.setPartitionArmingStatus(0, statusArmStay);
      expect(securityModel.getPartition(0).armingStatus, statusArmStay);
    });
    test('Set Sensor Status', () async {
      final sensor = Sensor.fromJson(sensorList[0]);
      expect(securityModel.getSensor(sensor.zoneId).sensorStatus,
          isNot(statusClosed));
      securityModel.setSensorStatus(sensor.zoneId, statusClosed);
      expect(securityModel.getSensor(sensor.zoneId).sensorStatus, statusClosed);
    });
    test('Set Sensor State', () async {
      final sensor = Sensor.fromJson(sensorList[0]);
      expect(
        securityModel.getSensor(sensor.zoneId).sensorState,
        isNot(stateBypassNone),
      );
      securityModel.setSensorState(sensor.zoneId, stateBypassNone);
      expect(
          securityModel.getSensor(sensor.zoneId).sensorState, stateBypassNone);
    });
    test('Add Sensor Success', () async {
      final newSensor = {'zone_id': 5};
      when(client.request(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(data: newSensor));

      expect(securityModel.sensors.length, 1);
      expect(securityModel.getSensor(5), isNull);
      await securityModel.addSensor(5);
      expect(securityModel.getSensor(5), isNotNull);
      expect(securityModel.sensors.length, 2);
    });

    test('Add Sensor Already Exists', () async {
      expect(securityModel.sensors.length, 1);
      expect(securityModel.getSensor(1), isNotNull);
      expect(() => securityModel.addSensor(1), throwsException);
      expect(securityModel.sensors.length, 1);
    });
    test('Add Sensor Server Error', () async {
      when(client.request(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 10));
        throw DioError(
          type: DioErrorType.RESPONSE,
          error: 'error fetching sensor',
          response: Response<Map<String, dynamic>>(
            data: unsuccessfulRequest,
            statusCode: 500,
          ),
        );
      });
      expect(securityModel.sensors.length, 1);
      expect(securityModel.getSensor(5), isNull);
      await securityModel.addSensor(5);
      expect(securityModel.sensors.length, 1);
    });
    test('Refresh Sensor Success', () async {
      final updatedSensor = Map<String, dynamic>.from(sensorList[0])
        ..['sensor_status'] = 'closed';
      when(client.request(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer(
          (_) async => Response<Map<String, dynamic>>(data: updatedSensor));
      expect(securityModel.getSensor(1).sensorStatus, 'open');
      await securityModel.refreshSensor(1);
      expect(securityModel.getSensor(1).sensorStatus, 'closed');
    });
    test('Refresh Sensor Server Error', () async {
      when(client.request(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 10));
        throw DioError(
          type: DioErrorType.RESPONSE,
          error: 'error fetching sensor',
          response: Response<Map<String, dynamic>>(
            data: unsuccessfulRequest,
            statusCode: 500,
          ),
        );
      });
      await securityModel.refreshSensor(1);
    });
    test('Remove Sensor', () async {
      expect(securityModel.sensors.length, 1);
      securityModel.removeSensor(1);
      expect(securityModel.sensors.length, 0);
    });
  });

  group('Get Security Data', () {
    Dio client;
    AccountModel accountModel;
    SecurityModel securityModel;

    setUp(() async {
      client = MockDio();
      accountModel = MockAccountModel();
      securityModel = SecurityModel(IQCloudRepository(
          client: IQCloudClient(client), account: accountModel));

      when(client.request(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response<List<dynamic>>(data: partitionList));
      await securityModel.fetchPartitions();

      when(client.request(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response<List<dynamic>>(data: sensorList));
      await securityModel.fetchSensors();
    });

    tearDown(() {
      client = null;
      accountModel = null;
      securityModel = null;
    });

    test('Get Partition Exists', () {
      expect(securityModel.getPartition(0), isNotNull);
    });
    test('Get Partition Doesnt Exist', () {
      expect(securityModel.getPartition(2), isNull);
    });
    test('Get Sensor Exists', () {
      expect(securityModel.getSensor(1), isNotNull);
    });
    test('Get Sensor Doesnt Exist', () {
      expect(securityModel.getSensor(2), isNull);
    });

    test('Get Sensors By Partition', () {
      expect(securityModel.getSensorsByPartition(0), isNotEmpty);
    });

    test('Get Sensors By Partition Empty', () {
      expect(securityModel.getSensorsByPartition(1), isEmpty);
    });
  });

  group('Partition Commands', () {
    group('Success Commands', () {
      Dio client;
      AccountModel accountModel;
      SecurityModel securityModel;
      setUp(() async {
        client = MockDio();
        accountModel = MockAccountModel();
        securityModel = SecurityModel(IQCloudRepository(
            client: IQCloudClient(client), account: accountModel));

        when(client.request(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
          data: anyNamed('data'),
        )).thenAnswer(
            (_) async => Response<List<dynamic>>(data: partitionList));
        await securityModel.fetchPartitions();
        when(client.request(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
          data: anyNamed('data'),
        )).thenAnswer((_) async =>
            Response<Map<String, dynamic>>(data: successfulRequest));
      });
      tearDown(() {
        client = null;
        accountModel = null;
        securityModel = null;
      });

      test('Arm Stay Loading Success', () async {
        expect(securityModel.partitions.length, 1);
        expect(securityModel.partitions[0].loading, false);
        var futureResult = securityModel.armStay(0);
        expect(securityModel.partitions[0].loading, true);
        await futureResult;
        expect(securityModel.partitions[0].loading, false);
      });
      test('Arm Stay Arming Success', () async {
        expect(securityModel.partitions.length, 1);
        expect(securityModel.partitions[0].armingStatus, statusDisarm);
        await securityModel.armStay(0);
        expect(securityModel.partitions[0].armingStatus, statusArmStay);
      });
      test('Arm Away Loading Success', () async {
        expect(securityModel.partitions.length, 1);
        expect(securityModel.partitions[0].loading, false);
        var futureResult = securityModel.armAway(0);
        expect(securityModel.partitions[0].loading, true);
        await futureResult;
        expect(securityModel.partitions[0].loading, false);
      });
      test('Arm Away Arming Success', () async {
        expect(securityModel.partitions.length, 1);
        expect(securityModel.partitions[0].armingStatus, statusDisarm);
        await securityModel.armAway(0);
        expect(securityModel.partitions[0].armingStatus, statusArmAway);
      });
      test('Disarm Loading Success', () async {
        expect(securityModel.partitions.length, 1);
        expect(securityModel.partitions[0].loading, false);
        var futureResult = securityModel.disarm(0);
        expect(securityModel.partitions[0].loading, true);
        await futureResult;
        expect(securityModel.partitions[0].loading, false);
      });
      test('Disarm Arming Success', () async {
        expect(securityModel.partitions.length, 1);
        securityModel.setPartitionArmingStatus(0, statusArmStay);
        expect(securityModel.partitions[0].armingStatus, statusArmStay);
        await securityModel.disarm(0);
        expect(securityModel.partitions[0].armingStatus, statusDisarm);
      });
    });
    group('Error Commands', () {
      Dio client;
      AccountModel accountModel;
      SecurityModel securityModel;
      setUp(() async {
        client = MockDio();
        accountModel = MockAccountModel();
        securityModel = SecurityModel(IQCloudRepository(
            client: IQCloudClient(client), account: accountModel));

        when(client.request(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
          data: anyNamed('data'),
        )).thenAnswer(
            (_) async => Response<List<dynamic>>(data: partitionList));
        await securityModel.fetchPartitions();

        when(client.request(
          any,
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
          data: anyNamed('data'),
        )).thenAnswer((_) async {
          await Future.delayed(Duration(milliseconds: 10));
          throw DioError(
            type: DioErrorType.RESPONSE,
            error: 'error changing partition',
            response: Response<Map<String, dynamic>>(
              data: unsuccessfulRequest,
              statusCode: 500,
            ),
          );
        });
      });
      tearDown(() {
        client = null;
        accountModel = null;
        securityModel = null;
      });
      test('Arm Stay Loading Server Error', () async {
        expect(securityModel.partitions.length, 1);
        expect(securityModel.partitions[0].loading, false);
        var futureResult = securityModel.armAway(0);
        expect(securityModel.partitions[0].loading, true);
        await futureResult;
        expect(securityModel.partitions[0].loading, false);
      });
      test('Arm Stay Arming Server Error', () async {
        expect(securityModel.partitions.length, 1);
        expect(securityModel.partitions[0].armingStatus, statusDisarm);
        await securityModel.armStay(0);
        expect(securityModel.partitions[0].armingStatus, statusDisarm);
      });
      test('Arm Away Loading Server Error', () async {
        expect(securityModel.partitions.length, 1);
        expect(securityModel.partitions[0].loading, false);
        var futureResult = securityModel.armStay(0);
        expect(securityModel.partitions[0].loading, true);
        await futureResult;
        expect(securityModel.partitions[0].loading, false);
      });
      test('Arm Away Arming Server Error', () async {
        expect(securityModel.partitions.length, 1);
        expect(securityModel.partitions[0].armingStatus, statusDisarm);
        await securityModel.armAway(0);
        expect(securityModel.partitions[0].armingStatus, statusDisarm);
      });
      test('Disarm Loading Server Error', () async {
        expect(securityModel.partitions.length, 1);
        securityModel.setPartitionArmingStatus(0, statusArmStay);
        expect(securityModel.partitions[0].loading, false);
        var futureResult = securityModel.disarm(0);
        expect(securityModel.partitions[0].loading, true);
        await futureResult;
        expect(securityModel.partitions[0].loading, false);
      });
      test('Disarm Arming Server Error', () async {
        expect(securityModel.partitions.length, 1);
        securityModel.setPartitionArmingStatus(0, statusArmStay);
        expect(securityModel.partitions[0].armingStatus, statusArmStay);
        await securityModel.disarm(0);
        expect(securityModel.partitions[0].armingStatus, statusArmStay);
      });
    });
  });
}
