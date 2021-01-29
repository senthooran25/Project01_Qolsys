import 'package:dio/dio.dart' hide Headers;
import 'package:flutter/painting.dart';
import 'package:qolsys_app/models/account_details.dart';
import 'package:qolsys_app/models/panel_properties.dart';
import 'package:qolsys_app/models/alarm.dart';
import 'package:qolsys_app/models/auth_token.dart';
import 'package:qolsys_app/models/history_event.dart';
import 'package:qolsys_app/models/automation_device.dart';
import 'package:qolsys_app/models/notification_response.dart';
import 'package:qolsys_app/models/partition_status.dart';
import 'package:qolsys_app/models/request_response.dart';
import 'package:qolsys_app/models/sensor.dart';
import 'package:qolsys_app/models/user_info.dart';
import 'package:retrofit/retrofit.dart';

part 'iqcloud_client.g.dart';

@RestApi(baseUrl: 'https://api-qis.qolsys.com/apps/v1/')
abstract class IQCloudClient {
  factory IQCloudClient(Dio dio, {String baseUrl}) = _IQCloudClient;

  @GET('auth/user/info')
  Future<UserInfo> getUserInfo({
    @Header("Authorization") String authorization,
  });

  @PUT('auth/user/info')
  Future<RequestResponse> updateUserProfile({
    @Header("Authorization") String authorization,
    @Field('first_name') String firstName,
    @Field('last_name') String lastName,
    @Field('email') String email,
    @Field('preferred_language') String preferredLanguage,
    @Field('date_format') String dateFormat,
    @Field('timezone_id') int timezoneId,
  });

  @PUT('auth/changepassword')
  Future<RequestResponse> changePassword({
    @Header("Authorization") String authorization,
    @Field('new_password') String newPassword,
    @Field('confirm_password') String confirmPassword,
  });

  @POST('auth/help')
  Future<RequestResponse> forgotCredentials({
    @Header("Authorization") String authorization,
    @Field() String action, // password or username
    @Field() String username, //for forgotPassword
    @Field() String email, //for forgotUsername
  });

  @GET('panels/{accountId}/{property}')
  Future<PanelProperties> getPanelProperty({
    @Header("Authorization") String authorization,
    @Path() String accountId,
    @Path() String property,
  });

  @POST("/auth/token")
  Future<AuthToken> getAuthToken(
      @Field() String username, @Field() String password);

  @POST("/auth/token/refresh")
  Future<AuthToken> refreshAuthToken(
      @Field('refresh_token') String refreshToken);

  @GET('/panels/{accountId}/devices/sensors')
  Future<List<Sensor>> getSensors({
    @Header("Authorization") String authorization,
    @Path() String accountId,
  });

  @GET('/panels/{accountId}/devices/sensors/{zoneId}')
  Future<Sensor> getSensor({
    @Header("Authorization") String authorization,
    @Path() String accountId,
    @Path() int zoneId,
  });

  @GET('/panels/{accountId}/devices/homeautomation')
  Future<List<AutomationDevice>> getAutomationDevices({
    @Header("Authorization") String authorization,
    @Path() String accountId,
  });

  @GET('/panels/{accountId}/devices/homeautomation/{deviceId}/{propertyName}')
  Future<AutomationDevice> getAutomationDeviceProperty({
    @Header("Authorization") String authorization,
    @Path() String accountId,
    @Path() int deviceId,
    @Path() String propertyName,
  });

  @PUT('/panels/{accountId}/devices/homeautomation/{deviceId}')
  Future<RequestResponse> setAutomationDevice({
    @Header("Authorization") String authorization,
    @Path() String accountId,
    @Path() int deviceId,
    @Body() Map<String, dynamic> request,
  });

  @GET('/panels/{accountId}/status')
  Future<List<PartitionStatus>> getStatus({
    @Header("Authorization") String authorization,
    @Path() String accountId,
  });

  @PUT('/panels/{accountId}/status/arming/{partitionId}')
  Future<RequestResponse> setArmState({
    @Header("Authorization") String authorization,
    @Path() String accountId,
    @Path() int partitionId,
    @Field('arming_status') String armingStatus,
    @Field('user_id') int userId,
  });

  @GET('/panels/{accountId}/events/{filter}')
  Future<List<HistoryEvent>> getHistoryEvents({
    @Header("Authorization") String authorization,
    @Path() String accountId,
    @Query('page') int pageNumber,
    @Query('pageSize') int pageSize,
    @Path() String filter,
  });

  @GET('/notification/updates')
  Future<NotificationResponse> getSubscriptionDetails({
    @Header('Authorization') String authorization,
  });

  @POST('/notification/updates')
  Future<NotificationResponse> subscribeToPushNotifications(
      {@Header('Authorization') String authorization,
      @Field('device_id') String deviceId,
      @Field('app_key') String fcmToken,
      @Field('triggers') List<String> topics});

  @PUT('/notification/updates')
  Future<NotificationResponse> updateSubscriptionTopics(
      {@Header('Authorization') String authorization,
      @Field('device_id') String deviceId,
      @Field('app_key') String fcmToken,
      @Field('triggers') List<String> topics});

  @DELETE('/notification/updates')
  Future<NotificationResponse> unsubscribeToPushNotifications({
    @Header('Authorization') String authorization,
    @Field('device_id') String deviceId,
  });

  @GET('/accounts/{accountId}')
  Future<AccountDetails> getAccountDetails({
    @Header("Authorization") String authorization,
    @Path() String accountId,
  });

  @GET('/panels/{accountId}/alarms')
  Future<List<Alarm>> getAlarms({
    @Header("Authorization") String authorization,
    @Path() String accountId,
  });
}
