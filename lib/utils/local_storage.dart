import 'package:qolsys_app/models/auth_token.dart';

abstract class LocalStorage {
  Future openStorage();
  Future clearStorage();
  Future saveToken(AuthToken token);
  Future saveNotificationList(List<String> topics);
  AuthToken loadToken();
  List<String> loadNotificationList();
}
