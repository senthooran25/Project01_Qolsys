import 'package:qolsys_app/constants/integer_constants.dart';
import 'package:qolsys_app/models/account_details.dart';
import 'package:qolsys_app/models/panel_properties.dart';
import 'package:qolsys_app/models/alarm.dart';
import 'package:qolsys_app/models/auth_token.dart';
import 'package:qolsys_app/models/automation_device.dart';
import 'package:qolsys_app/models/history_event.dart';
import 'package:qolsys_app/models/notification_response.dart';
import 'package:qolsys_app/models/partition_status.dart';
import 'package:qolsys_app/models/request_response.dart';
import 'package:qolsys_app/models/sensor.dart';
import 'package:qolsys_app/models/user_info.dart';
import 'package:qolsys_app/providers/account_model.dart';
import 'package:synchronized/extension.dart';
import 'iqcloud_client.dart';

class IQCloudRepository {
  final IQCloudClient client;
  final AccountModel account;

  IQCloudRepository({this.client, this.account});

  String get _authorization => 'Bearer ${account.accessToken}';

  Future login(String username, String password) async {
    AuthToken token = await client.getAuthToken(username, password);
    account.setAuthToken(token);
    return token;
  }

  Future refreshToken() async {
    AuthToken token = await client.refreshAuthToken(account.refreshToken);
    account.setAuthToken(token);
    return token;
  }

  Future checkRefreshToken() async {
    await synchronized(() async {
      if (!account.isLoggedIn()) await refreshToken();
    });
  }

  Future<Sensor> getSensor(int zoneId) async {
    await checkRefreshToken();
    return await client.getSensor(
      authorization: _authorization,
      accountId: account.accountNumber,
      zoneId: zoneId,
    );
  }

  Future<List<Sensor>> getSensors() async {
    await checkRefreshToken();
    return await client.getSensors(
      authorization: _authorization,
      accountId: account.accountNumber,
    );
  }

  Future<List<AutomationDevice>> getAutomationDevices() async {
    await checkRefreshToken();
    return await client.getAutomationDevices(
      authorization: _authorization,
      accountId: account.accountNumber,
    );
  }

  Future<List<PartitionStatus>> getStatus() async {
    await checkRefreshToken();
    return await client.getStatus(
      authorization: _authorization,
      accountId: account.accountNumber,
    );
  }

  Future<RequestResponse> armStay({int partitionId}) async {
    await checkRefreshToken();
    return await client.setArmState(
      accountId: account.accountNumber,
      authorization: _authorization,
      partitionId: partitionId,
      armingStatus: 'arm_stay',
      userId: ADMIN_USER_ID,
    );
  }

  Future<RequestResponse> armAway({int partitionId}) async {
    await checkRefreshToken();
    return await client.setArmState(
      accountId: account.accountNumber,
      authorization: _authorization,
      partitionId: partitionId,
      armingStatus: 'arm_away',
      userId: ADMIN_USER_ID,
    );
  }

  Future<RequestResponse> disarm({int partitionId}) async {
    await checkRefreshToken();
    return await client.setArmState(
      accountId: account.accountNumber,
      authorization: _authorization,
      partitionId: partitionId,
      armingStatus: 'disarm',
      userId: ADMIN_USER_ID,
    );
  }

  Future<List<HistoryEvent>> getHistoryEvents({String filter}) async {
    await checkRefreshToken();
    return await client.getHistoryEvents(
      authorization: _authorization,
      accountId: account.accountNumber,
      pageNumber: 1,
      pageSize: 50,
      filter: filter ?? '',
    );
  }

  //Can be used for Light on/off, Doorlock lock/Unlock, GarageDoor Open/Close etc
  Future<RequestResponse> setDeviceStatus(
      {int deviceId, String deviceStatus}) async {
    await checkRefreshToken();
    final params = {'device_status': deviceStatus};
    return await client.setAutomationDevice(
      accountId: account.accountNumber,
      authorization: _authorization,
      deviceId: deviceId,
      request: params,
    );
  }

  Future<AutomationDevice> getAutomationDeviceBatteryStatus(
      {int deviceId}) async {
    await checkRefreshToken();
    return await client.getAutomationDeviceProperty(
      accountId: account.accountNumber,
      authorization: _authorization,
      deviceId: deviceId,
      propertyName: 'battery_status',
    );
  }

  Future<AutomationDevice> getDeviceStatus({int deviceId}) async {
    await checkRefreshToken();
    return await client.getAutomationDeviceProperty(
      accountId: account.accountNumber,
      authorization: _authorization,
      deviceId: deviceId,
      propertyName: 'device_status',
    );
  }

  Future<RequestResponse> setDimmer(
      {int deviceId, String deviceStatus, int level}) async {
    await checkRefreshToken();
    final params = {'device_status': deviceStatus, 'brightness_level': level};
    return await client.setAutomationDevice(
      accountId: account.accountNumber,
      authorization: _authorization,
      deviceId: deviceId,
      request: params,
    );
  }

  Future<RequestResponse> setThermostatMode({int deviceId, String mode}) async {
    await checkRefreshToken();
    final params = {'mode': mode};
    return await client.setAutomationDevice(
      accountId: account.accountNumber,
      authorization: _authorization,
      deviceId: deviceId,
      request: params,
    );
  }

  Future<RequestResponse> setThermostatFanMode(
      {int deviceId, String fanMode}) async {
    await checkRefreshToken();
    final params = {'fan_mode': fanMode};
    return await client.setAutomationDevice(
      accountId: account.accountNumber,
      authorization: _authorization,
      deviceId: deviceId,
      request: params,
    );
  }

  Future<RequestResponse> setThermostatHeatSetPoint(
      {int deviceId, double heatSetPointTemp}) async {
    await checkRefreshToken();
    final params = {'target_temp_high': heatSetPointTemp};
    return await client.setAutomationDevice(
      accountId: account.accountNumber,
      authorization: _authorization,
      deviceId: deviceId,
      request: params,
    );
  }

  Future<RequestResponse> setThermostatCoolSetPoint(
      {int deviceId, double coolSetPointTemp}) async {
    await checkRefreshToken();
    final params = {'target_temp_low': coolSetPointTemp};
    return await client.setAutomationDevice(
      accountId: account.accountNumber,
      authorization: _authorization,
      deviceId: deviceId,
      request: params,
    );
  }

  Future<NotificationResponse> getSubscriptionDetails() async {
    await checkRefreshToken();
    return await client.getSubscriptionDetails(
      authorization: _authorization,
    );
  }

  Future<NotificationResponse> subscribeToPushNotifications(
      String deviceId, String fcmToken, List<String> topics) async {
    await checkRefreshToken();
    return await client.subscribeToPushNotifications(
      authorization: _authorization,
      deviceId: deviceId,
      fcmToken: fcmToken,
      topics: topics,
    );
  }

  Future<NotificationResponse> updateSubscriptionTopics(
      String deviceId, String fcmToken, List<String> topics) async {
    await checkRefreshToken();
    return await client.updateSubscriptionTopics(
      authorization: _authorization,
      deviceId: deviceId,
      fcmToken: fcmToken,
      topics: topics,
    );
  }

  Future<NotificationResponse> unsubscribeToPushNotifications(
      String deviceId) async {
    await checkRefreshToken();
    return await client.unsubscribeToPushNotifications(
      authorization: _authorization,
      deviceId: deviceId,
    );
  }

  Future<RequestResponse> forgotUsername(String emailId) async {
    await checkRefreshToken();
    return await client.forgotCredentials(
        authorization: _authorization, action: "username", email: emailId);
  }

  Future<RequestResponse> forgotPassword(String userName) async {
    await checkRefreshToken();
    return await client.forgotCredentials(
        authorization: _authorization, action: "password", username: userName);
  }

  Future<AccountDetails> getAccountDetails() async {
    await checkRefreshToken();
    return await client.getAccountDetails(
      authorization: _authorization,
      accountId: account.accountNumber,
    );
  }

  Future<UserInfo> getUserInfo() async {
    await checkRefreshToken();
    return await client.getUserInfo(
      authorization: _authorization,
    );
  }

  Future<PanelProperties> getPanelProperty(String property) async {
    await checkRefreshToken();
    return await client.getPanelProperty(
      authorization: _authorization,
      accountId: account.accountNumber,
      property: property,
    );
  }

  Future<List<Alarm>> getAlarms() async {
    await checkRefreshToken();
    return await client.getAlarms(
      authorization: _authorization,
      accountId: account.accountNumber,
    );
  }
}
