import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qolsys_app/constants/text_constants.dart';
import 'package:qolsys_app/providers/account_model.dart';
import 'package:qolsys_app/providers/events_model.dart';
import 'package:qolsys_app/providers/security_model.dart';
import 'package:qolsys_app/utils/qolsys_logger.dart';
import 'package:qolsys_app/utils/utils.dart';
import 'package:qolsys_app/widget/trouble_dialogs.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
String fcmToken;
String deviceId;
EventsModel eventsModel;
final _log = getLogger('FCMNotifications');
final _kTestingCrashlytics = false;

initializeFcm(BuildContext context) async {
  _log.i('initializeFcm()');
  eventsModel = context.read<EventsModel>();
  final cache = context.read<AccountModel>().cache;
  List<String> topics = cache?.loadNotificationList();
  deviceId = await getDeviceId();
  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      _log.d("onMessage() " + message.toString());
      handleNotification(message, context);
    },
    onLaunch: (Map<String, dynamic> message) async {
      _log.d("onLaunch() " + message.toString());
      handleNotification(message, context);
    },
    onResume: (Map<String, dynamic> message) async {
      _log.d("onResume() " + message.toString());
      handleNotification(message, context);
    },
    //onBackgroundMessage: Tmp.myBackgroundMessageHandler
  );

  _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true));
  _firebaseMessaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings) {
    _log.i('initializeFcm() Settings registered: $settings');
  });

  fcmToken = await _firebaseMessaging.getToken();

  if (topics == null) {
    topics = defaultNotificationTopics;
    cache?.saveNotificationList(topics);
  }

  _log.i('initializeFcm() topics: $topics');
  updateNotificationTopics(context, topics);

  Stream<String> fcmStream = _firebaseMessaging.onTokenRefresh;
  fcmStream.listen((token) {
    fcmToken = token;
    eventsModel.subscribeToPushNotifications(deviceId, fcmToken, topics);
  });
}

handleNotification(Map<String, dynamic> message, BuildContext context) {
  _log.i("handleNotification()");
  var data = message['data'] ?? message;
  String msgJson = data['message'];
  Map<String, dynamic> msg = json.decode(msgJson);
  String eventClass = msg['event_class'];
  final securityModel = context.read<SecurityModel>();
  switch (eventClass) {
    case 'panel_arming':
      String armingStatus = msg['event_info']['arming_status'];
      int partitionId = msg['partition_id'];
      securityModel.setPartitionArmingStatus(partitionId, armingStatus);
      break;
    case 'panel_alarm_no_alert':
    case 'panel_alarm':
      () async {
        await securityModel.fetchAlarms();
        if (securityModel.alarms.isNotEmpty)
          requestAlarmsDialog(context);
        else
          requestDismissAlarmsDialog(context);
      }();

      break;
    case 'zone_operation':
      String zoneStatus = msg['event_info']['device_status'];
      int deviceId = msg['device_id'];
      securityModel.setSensorStatus(deviceId, zoneStatus);
      break;
    case 'zone_config':
      int deviceId = msg['device_id'];
      String eventType = msg['event_type'];
      if (eventType == 'zone_deleted')
        securityModel.removeSensor(deviceId);
      else if (eventType == 'zone_added')
        securityModel.addSensor(deviceId);
      else
        securityModel.refreshSensor(deviceId);
      break;
    case 'zone_bypass':
      String sensorState = msg['event_info']['device_state'];
      int deviceId = msg['device_id'];
      securityModel.setSensorState(deviceId, sensorState);
      break;
    case 'zone_tamper':
      String tamperState = msg['event_info']['tamper_state'];
      if (tamperState == 'tamper') {
        int deviceId = msg['device_id'];
        securityModel.setSensorStatus(deviceId, tamperState);
      }
      break;
  }
}

updateNotificationTopics(BuildContext context, List<String> list) async {
  _log.i("updateNotificationTopics() list: $list");
  await eventsModel.unsubscribeToPushNotifications(deviceId);
  if (list.isNotEmpty)
    await eventsModel.subscribeToPushNotifications(deviceId, fcmToken, list);
}

// Define an async function to initialize FlutterFire
Future<void> initializeFlutterFire() async {
  // Wait for Firebase to initialize
  FirebaseApp firebaseApp = await Firebase.initializeApp();

  if (_kTestingCrashlytics) {
    // Force enable crashlytics collection enabled if we're testing it.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  } else {
    // Else only enable it in non-debug builds.
    // You could additionally extend this to allow users to opt-in.
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(!kDebugMode);
  }
  // Pass all uncaught errors to Crashlytics.
  Function originalOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails errorDetails) async {
    await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    // Forward to original handler.
    originalOnError(errorDetails);
  };

  /*if (_kShouldTestAsyncErrorOnInit) {
    await _testAsyncErrorOnInit();
  }*/
}

setCustomKeyValue(String key, dynamic value) {
  FirebaseCrashlytics.instance.setCustomKey(key, value);
}
