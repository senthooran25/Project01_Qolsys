// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iqcloud_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _IQCloudClient implements IQCloudClient {
  _IQCloudClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'https://api-qis.qolsys.com/apps/v1/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<UserInfo> getUserInfo({authorization}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('auth/user/info',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': authorization},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = UserInfo.fromJson(_result.data);
    return value;
  }

  @override
  Future<RequestResponse> updateUserProfile(
      {authorization,
      firstName,
      lastName,
      email,
      preferredLanguage,
      dateFormat,
      timezoneId}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'preferred_language': preferredLanguage,
      'date_format': dateFormat,
      'timezone_id': timezoneId
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('auth/user/info',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'PUT',
            headers: <String, dynamic>{r'Authorization': authorization},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = RequestResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<RequestResponse> changePassword(
      {authorization, newPassword, confirmPassword}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {
      'new_password': newPassword,
      'confirm_password': confirmPassword
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>(
        'auth/changepassword',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'PUT',
            headers: <String, dynamic>{r'Authorization': authorization},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = RequestResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<RequestResponse> forgotCredentials(
      {authorization, action, username, email}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {'action': action, 'username': username, 'email': email};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('auth/help',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{r'Authorization': authorization},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = RequestResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<PanelProperties> getPanelProperty(
      {authorization, accountId, property}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        'panels/$accountId/$property',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': authorization},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = PanelProperties.fromJson(_result.data);
    return value;
  }

  @override
  Future<AuthToken> getAuthToken(username, password) async {
    ArgumentError.checkNotNull(username, 'username');
    ArgumentError.checkNotNull(password, 'password');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'username': username, 'password': password};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>('/auth/token',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = AuthToken.fromJson(_result.data);
    return value;
  }

  @override
  Future<AuthToken> refreshAuthToken(refreshToken) async {
    ArgumentError.checkNotNull(refreshToken, 'refreshToken');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {'refresh_token': refreshToken};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>(
        '/auth/token/refresh',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = AuthToken.fromJson(_result.data);
    return value;
  }

  @override
  Future<List<Sensor>> getSensors({authorization, accountId}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>(
        '/panels/$accountId/devices/sensors',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': authorization},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => Sensor.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<Sensor> getSensor({authorization, accountId, zoneId}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        '/panels/$accountId/devices/sensors/$zoneId',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': authorization},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = Sensor.fromJson(_result.data);
    return value;
  }

  @override
  Future<List<AutomationDevice>> getAutomationDevices(
      {authorization, accountId}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>(
        '/panels/$accountId/devices/homeautomation',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': authorization},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map(
            (dynamic i) => AutomationDevice.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<AutomationDevice> getAutomationDeviceProperty(
      {authorization, accountId, deviceId, propertyName}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        '/panels/$accountId/devices/homeautomation/$deviceId/$propertyName',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': authorization},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = AutomationDevice.fromJson(_result.data);
    return value;
  }

  @override
  Future<RequestResponse> setAutomationDevice(
      {authorization, accountId, deviceId, request}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request ?? <String, dynamic>{});
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>(
        '/panels/$accountId/devices/homeautomation/$deviceId',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'PUT',
            headers: <String, dynamic>{r'Authorization': authorization},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = RequestResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<List<PartitionStatus>> getStatus({authorization, accountId}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>(
        '/panels/$accountId/status',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': authorization},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => PartitionStatus.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<RequestResponse> setArmState(
      {authorization, accountId, partitionId, armingStatus, userId}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {'arming_status': armingStatus, 'user_id': userId};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>(
        '/panels/$accountId/status/arming/$partitionId',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'PUT',
            headers: <String, dynamic>{r'Authorization': authorization},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = RequestResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<List<HistoryEvent>> getHistoryEvents(
      {authorization, accountId, pageNumber, pageSize, filter}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'page': pageNumber,
      r'pageSize': pageSize
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>(
        '/panels/$accountId/events/$filter',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': authorization},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => HistoryEvent.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<NotificationResponse> getSubscriptionDetails({authorization}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        '/notification/updates',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': authorization},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = NotificationResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<NotificationResponse> subscribeToPushNotifications(
      {authorization, deviceId, fcmToken, topics}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {
      'device_id': deviceId,
      'app_key': fcmToken,
      'triggers': topics
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>(
        '/notification/updates',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{r'Authorization': authorization},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = NotificationResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<NotificationResponse> updateSubscriptionTopics(
      {authorization, deviceId, fcmToken, topics}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {
      'device_id': deviceId,
      'app_key': fcmToken,
      'triggers': topics
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>(
        '/notification/updates',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'PUT',
            headers: <String, dynamic>{r'Authorization': authorization},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = NotificationResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<NotificationResponse> unsubscribeToPushNotifications(
      {authorization, deviceId}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = {'device_id': deviceId};
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<Map<String, dynamic>>(
        '/notification/updates',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'DELETE',
            headers: <String, dynamic>{r'Authorization': authorization},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = NotificationResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<AccountDetails> getAccountDetails({authorization, accountId}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        '/accounts/$accountId',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': authorization},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = AccountDetails.fromJson(_result.data);
    return value;
  }

  @override
  Future<List<Alarm>> getAlarms({authorization, accountId}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>(
        '/panels/$accountId/alarms',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{r'Authorization': authorization},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => Alarm.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }
}
