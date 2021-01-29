import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:qolsys_app/constants/text_constants.dart';
import 'package:qolsys_app/fcm/fcm_notifications.dart';
import 'package:qolsys_app/models/auth_token.dart';
import 'package:qolsys_app/utils/local_storage.dart';
import 'package:qolsys_app/utils/qolsys_logger.dart';
import 'package:meta/meta.dart';

class AccountModel extends ChangeNotifier {
  final _log = getLogger('AccountModel');
  AuthToken authToken;
  Map<String, dynamic> _userData;
  LocalStorage cache;
  get accessToken => authToken?.accessToken;
  get refreshToken => authToken?.refreshToken;

  @visibleForTesting
  setUserData(Map<String, dynamic> data) => _userData = data;

  AccountModel({this.cache}) {
    final token = cache?.loadToken();
    if (token != null) setAuthToken(token);
  }

  String get accountNumber =>
      _userData == null ? null : _userData['account_number'];
  String get userName => _userData == null ? null : _userData['name'];

  void setAuthToken(AuthToken token) {
    _log.i('setAuthToken()');
    authToken = token;
    _userData = JwtDecoder.decode(authToken.accessToken);
    if (_userData == null) {
      _log.e('Could not decode accessToken');
      logout();
    } else {
      cache?.saveToken(authToken);
      setCustomKeyValue(crashlyticsCustomKeyAccountNumber, accountNumber);
      notifyListeners();
    }
  }

  void logout() {
    _log.i('logout()');
    authToken = null;
    _userData = null;
    cache?.clearStorage();
    notifyListeners();
  }

  bool isLoggedIn() {
    if (authToken == null || _userData == null) return false;
    final expirationDate =
        DateTime.fromMillisecondsSinceEpoch(_userData['exp'] * 1000);
    return DateTime.now().isBefore(expirationDate);
  }
}
