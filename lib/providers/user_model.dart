import 'package:qolsys_app/models/account_details.dart';
import 'package:qolsys_app/models/panel_properties.dart';
import 'package:qolsys_app/models/user_info.dart';
import 'package:qolsys_app/providers/q_change_notifier.dart';
import 'package:qolsys_app/repos/iqcloud_repository.dart';
import 'package:qolsys_app/utils/qolsys_logger.dart';

class UserModel extends QChangeNotifier {
  IQCloudRepository repo;
  UserModel(this.repo) : super(repo);
  final _log = getLogger('UserModel');

  AccountDetails _accountDetails;
  AccountDetails get accountDetails => _accountDetails;
  PanelProperties _panelProperties = PanelProperties();
  PanelProperties get panelProperties => _panelProperties;
  UserInfo _userInfo;
  UserInfo get userInfo => _userInfo;
  bool _loading = false;
  bool get loading => _loading;
  Future login(String username, String password) async {
    _log.i('login()');
    final function = () async {
      await repo.login(username, password);
    };
    return await sendRequest(function, (val) => _loading = val);
  }

  Future fetchWifiStatus() async {
    _log.i('fetchWifiStatus()');
    final function = () async {
      final properties = await repo.getPanelProperty('wifi_status');
      _panelProperties.wifiStatus = properties.wifiStatus;
    };
    return await sendRequest(function);
  }

  Future fetchAccountDetails() async {
    _log.i('fetchAccountDetails()');
    final function = () async {
      final details = await repo.getAccountDetails();
      _accountDetails = details;
    };
    return await sendRequest(function);
  }

  Future fetchUserInfo() async {
    _log.i('fetchUserInfo()');
    final function = () async {
      final userInfo = await repo.getUserInfo();
      _userInfo = userInfo;
    };
    return await sendRequest(function);
  }

  Future fetchUserData() async {
    await Future.wait(<Future>[
      fetchAccountDetails(),
      fetchWifiStatus(),
      fetchUserInfo(),
    ]);
  }
}
