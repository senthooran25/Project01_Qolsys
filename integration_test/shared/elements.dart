import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iq_wifi/mock/mock_account_model.dart';
import 'package:iq_wifi/repos/mock/mock_fenway_client.dart';
import 'package:iq_wifi/main.dart' as app;
import 'package:iq_wifi/constants/keys.dart';

const DO_MOCK = String.fromEnvironment('DO_MOCK', defaultValue: 'true');
var startLocale = Locale("en");

//Application
Widget getRootWidget(
        {MockFenwayRepository? clientMock,
        MockAccountModel? mockAccountModel}) =>
    app.MyApp(
      fenwayRepo: clientMock,
      accountModel: mockAccountModel,
      startLocale: startLocale,
    );

bool isMock() {
  if (DO_MOCK == 'true') {
    return true;
  }
  return false;
}

//Login Page
final signOnBtn = find.byKey(RouterAppKeys.signOnBtn);

//Home Page Elements
final settingsIcon = find.byKey(RouterAppKeys.homePageSettingsIcon);
final devicesBtn = find.byKey(RouterAppKeys.devicesBtn);
final devicesValue = find.byKey(RouterAppKeys.devicesValue);
final networkMapBtn = find.byKey(RouterAppKeys.networkMapBtn);
final speedTestBtn = find.byKey(RouterAppKeys.speedTestBtn);
final profilesBtn = find.byKey(RouterAppKeys.profilesBtn);
final profilesValue = find.byKey(RouterAppKeys.profilesValue);
final statusLbl = find.byKey(RouterAppKeys.statusLbl);
final statusValue = find.byKey(RouterAppKeys.statusValue);
final routerAlias = find.byKey(RouterAppKeys.routerAlias);
final wifiPoints = find.byKey(RouterAppKeys.wifiPoints);

//TOS Page
final tosText = find.byKey(RouterAppKeys.tosText);
final tosTitle = find.byKey(RouterAppKeys.tosTitle);
final tosAcceptBtn = find.byKey(RouterAppKeys.tosAcceptBtn);
final tosPrivacyNotice = find.byKey(RouterAppKeys.tosPrivacyNotice);
final tosInfoProcessed = find.byKey(RouterAppKeys.tosInfoProcessed);
final tosInfoData = find.byKey(RouterAppKeys.tosInfoData);
final tospurposeOfProcessing = find.byKey(RouterAppKeys.tospurposeOfProcessing);
final tosAcknowledge = find.byKey(RouterAppKeys.tosAcknowledge);
final tosfindOutMore = find.byKey(RouterAppKeys.tosfindOutMore);

//Settings Page
final settingsTitle = find.byKey(RouterAppKeys.settingsTitle);
final settingsAccountTitle = find.byKey(RouterAppKeys.settingsAccountTitle);
final settingsUserEmail = find.byKey(RouterAppKeys.settingsUserEmail);
final settingsLogOutUser = find.byKey(RouterAppKeys.settingsLogOutUser);
final settingsUpdateProfile = find.byKey(RouterAppKeys.settingsUpdateProfile);
final settingsMiscTitle = find.byKey(RouterAppKeys.settingsMiscTitle);
final settingsLanguage = find.byKey(RouterAppKeys.settingsLanguage);
final settingsDarkTheme = find.byKey(RouterAppKeys.settingsDarkTheme);
final settingsVersionMsg = find.byKey(RouterAppKeys.settingsVersionMsg);
final settingsModelTitle = find.byKey(RouterAppKeys.settingsModelTitle);
final settingsModelVersion = find.byKey(RouterAppKeys.settingsModelVersion);
final settingsMACTitle = find.byKey(RouterAppKeys.settingsMACTitle);
final settingsMACVersion = find.byKey(RouterAppKeys.settingsMACVersion);
final settingsFWTitle = find.byKey(RouterAppKeys.settingsFWTitle);
final settingsFWVersion = find.byKey(RouterAppKeys.settingsFWVersion);
final settingsRouterTitle = find.byKey(RouterAppKeys.settingsRouterTitle);
final settingsOnlineStatus = find.byKey(RouterAppKeys.settingsOnlineStatus);
final closeLangSelector = find.byKey(RouterAppKeys.closeLangSelector);
final dropDownItem = find.byKey(Key('languageDropDownItem'));
final settingsSitesTitle = find.byKey(RouterAppKeys.settingsSitesTitle);
final navRight = find.byKey(RouterAppKeys.navigateRightArrow);

//Logout
final logoutTitle = find.byKey(RouterAppKeys.logoutTitle);
final logoutDialog = find.byKey(RouterAppKeys.logoutDialog);
final cancelLogoutBtn = find.byKey(RouterAppKeys.cancelLogoutBtn);
final confirmLogout = find.byKey(RouterAppKeys.confirmLogout);
