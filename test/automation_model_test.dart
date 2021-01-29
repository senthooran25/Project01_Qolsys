import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:qolsys_app/constants/text_constants.dart';
import 'package:qolsys_app/models/automation_device.dart';
import 'package:qolsys_app/providers/account_model.dart';
import 'package:qolsys_app/providers/automation_model.dart';
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

final automationList = [
  {
    "device_id": 2,
    "device_type": "Light",
    "device_name": "Light",
    "device_state": "normal",
    "installation_date": 1598037726096,
    "device_status": "on",
    "battery_status": 100,
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
  AutomationModel automationModel;
  setUp(() {
    client = MockDio();
    accountModel = MockAccountModel();
    automationModel = AutomationModel(IQCloudRepository(
        client: IQCloudClient(client), account: accountModel));
  });

  tearDown(() {
    client = null;
    accountModel = null;
    automationModel = null;
  });

  test('Fetch AutomationDevices', () async {
    when(client.request(
      any,
      queryParameters: anyNamed('queryParameters'),
      options: anyNamed('options'),
      data: anyNamed('data'),
    )).thenAnswer((_) async => Response<List<dynamic>>(data: automationList));

    expect(automationModel.lights.length, 0);
    await automationModel.fetchAutomationDevices();
    expect(automationModel.lights.length, 1);
    AutomationDevice deviceFromModel = automationModel.lights[0];
    final sampleDevice = automationList[0];
    expect(deviceFromModel.installationDate, sampleDevice['installation_date']);
    expect(deviceFromModel.deviceName, sampleDevice['device_name']);
    expect(deviceFromModel.deviceId, sampleDevice['device_id']);
    expect(deviceFromModel.deviceState, sampleDevice['device_state']);
    expect(deviceFromModel.deviceStatus, sampleDevice['device_status']);
    expect(deviceFromModel.deviceType, sampleDevice['device_type']);
    expect(deviceFromModel.batteryStatus, sampleDevice['battery_status']);
  });

  group('Automation Commands ::', () {
    Dio client;
    AccountModel accountModel;
    AutomationModel automationModel;

    setUp(() async {
      client = MockDio();
      accountModel = MockAccountModel();
      automationModel = AutomationModel(IQCloudRepository(
          client: IQCloudClient(client), account: accountModel));
      when(client.request(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response<List<dynamic>>(data: automationList));
      await automationModel.fetchAutomationDevices();
    });

    tearDown(() {
      client = null;
      accountModel = null;
      automationModel = null;
    });
    test('Light success loading status', () async {
      when(client.request(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 10));
        return Response<Map<String, dynamic>>(data: successfulRequest);
      });
      expect(automationModel.lights.length, 1);
      expect(automationModel.lights[0].loading, false);
      var futureResult = automationModel.setDeviceStatus(
          automationModel.lights[0].deviceId, statusOff);
      expect(automationModel.lights[0].loading, true);
      await futureResult;
      expect(automationModel.lights[0].loading, false);
    });

    test('Light success current status', () async {
      when(client.request(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 10));
        return Response<Map<String, dynamic>>(data: successfulRequest);
      });
      expect(automationModel.lights.length, 1);
      expect(automationModel.lights[0].deviceStatus, statusOn);
      await automationModel.setDeviceStatus(
          automationModel.lights[0].deviceId, statusOff);
      expect(automationModel.lights[0].deviceStatus, statusOff);
    });
    test('Light 500 error loading status', () async {
      when(client.request(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 10));
        throw DioError(
          error: 'error changing light',
          response: Response<Map<String, dynamic>>(
            data: unsuccessfulRequest,
            statusCode: 500,
          ),
        );
      });

      expect(automationModel.lights.length, 1);
      expect(automationModel.lights[0].loading, false);
      var futureResult = automationModel.setDeviceStatus(
          automationModel.lights[0].deviceId, statusOff);
      expect(automationModel.lights[0].loading, true);
      await futureResult;
      expect(automationModel.lights[0].loading, false);
    });

    test('Light TIMEOUT error loading status', () async {
      when(client.request(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 10));
        throw DioError(
          error: 'error changing light',
          type: DioErrorType.CONNECT_TIMEOUT,
          response: Response<Map<String, dynamic>>(
            data: {},
            statusCode: 500,
          ),
        );
      });

      expect(automationModel.lights.length, 1);
      expect(automationModel.lights[0].loading, false);
      var futureResult = automationModel.setDeviceStatus(
          automationModel.lights[0].deviceId, statusOff);
      expect(automationModel.lights[0].loading, true);
      await futureResult;
      expect(automationModel.lights[0].loading, false);
    });
    test('Light 500 error current status', () async {
      when(client.request(
        any,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 10));
        throw DioError(
          error: 'error changing light',
          response: Response<Map<String, dynamic>>(
            data: unsuccessfulRequest,
            statusCode: 500,
          ),
        );
      });
      expect(automationModel.lights.length, 1);
      expect(automationModel.lights[0].deviceStatus, statusOn);
      await automationModel.setDeviceStatus(
          automationModel.lights[0].deviceId, statusOff);
      expect(automationModel.lights[0].deviceStatus, statusOn);
    });
  });
}
