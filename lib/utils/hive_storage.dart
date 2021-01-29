import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qolsys_app/utils/local_storage.dart';
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:qolsys_app/constants/hive_constants.dart' as hc;
import 'package:qolsys_app/models/auth_token.dart';
import 'package:qolsys_app/utils/qolsys_logger.dart';

class HiveStorage implements LocalStorage {
  final _log = getLogger('HiveStorage');
  final _keyStorage = FlutterSecureStorage();

  Future openStorage() async {
    _log.i('openStorage()');
    await Hive.initFlutter();
    List<int> privateKey;
    bool containsAESKey =
        await _keyStorage.containsKey(key: hc.keyAESPrivateKey);
    if (containsAESKey) {
      _log.v('openStorage() | contains key');
      final encodedKey = await _keyStorage.read(key: hc.keyAESPrivateKey);
      privateKey = base64Decode(encodedKey);
    } else {
      _log.v('openStorage() | does not contain key');
      await Hive.deleteFromDisk();
      await _keyStorage.deleteAll();
      _log.v('openStorage() | generating new key');
      privateKey = Hive.generateSecureKey();
      await _keyStorage.write(
        key: hc.keyAESPrivateKey,
        value: base64Encode(privateKey),
      );
      _log.v('openStorage() | wrote key');
    }
    _log.v('openStorage() | open box');
    await Hive.openBox(
      hc.boxUserData,
      encryptionCipher: HiveAesCipher(privateKey),
    );
    _log.v('openStorage() | done');
  }

  Future clearStorage() async {
    _log.i('clearStorage()');
    Box userDataBox = Hive.box(hc.boxUserData);
    userDataBox.clear();
  }

  AuthToken loadToken() {
    _log.i('loadToken()');
    Box userDataBox = Hive.box(hc.boxUserData);
    bool hasToken = userDataBox.containsKey(hc.keyAccessToken);
    if (hasToken) {
      final tokenJson = userDataBox.get(hc.keyAccessToken);
      return AuthToken.fromJson(jsonDecode(tokenJson));
    }
    return null;
  }

  Future saveToken(AuthToken token) {
    _log.i('saveToken()');
    Box userDataBox = Hive.box(hc.boxUserData);
    return userDataBox.put(hc.keyAccessToken, jsonEncode(token.toJson()));
  }

  Future saveNotificationList(List<String> topics) {
    _log.i('saveNotificationList()');
    Box userDataBox = Hive.box(hc.boxUserData);
    return userDataBox.put(hc.keyNotificationTopics, topics);
  }

  List<String> loadNotificationList() {
    _log.i('loadNotificationList()');
    Box userDataBox = Hive.box(hc.boxUserData);
    bool hasList = userDataBox.containsKey(hc.keyNotificationTopics);
    if (hasList) {
      List notificationList = userDataBox.get(hc.keyNotificationTopics);
      return notificationList;
    }
    return null;
  }
}
