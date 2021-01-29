import 'dart:async';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:qolsys_app/components/app_page.dart';
import 'package:qolsys_app/constants/color_constants.dart';
import 'package:qolsys_app/fcm/fcm_notifications.dart';
import 'package:qolsys_app/pages/favorites_page.dart';
import 'package:qolsys_app/pages/login_page.dart';
import 'package:qolsys_app/providers/account_model.dart';
import 'package:qolsys_app/providers/automation_model.dart';
import 'package:qolsys_app/providers/events_model.dart';
import 'package:qolsys_app/providers/page_model.dart';
import 'package:qolsys_app/providers/security_model.dart';
import 'package:qolsys_app/providers/user_model.dart';
import 'package:qolsys_app/repos/iqcloud_client.dart';
import 'package:qolsys_app/repos/iqcloud_repository.dart';
import 'package:qolsys_app/utils/hive_storage.dart';
import 'package:qolsys_app/utils/local_storage.dart';
import 'package:qolsys_app/utils/qolsys_logger.dart';
import 'package:qolsys_app/constants/environment_config_constants.dart';
import 'constants/integer_constants.dart';
import 'generated/codegen_loader.g.dart';
import 'generated/locale_keys.g.dart';

LocalStorage cache;

main({bool isTest = false}) async {
  final _log = getLogger('main');
  if (EnvironmentConfig.ENVIRONMENT_CONFIG == 'DEV')
    Logger.level = Level.verbose;
  else
    Logger.level = Level.warning;

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  if (!isTest) cache = HiveStorage();
  await cache?.openStorage();
  await initializeFlutterFire();
  runZonedGuarded(() {
    runApp(
      EasyLocalization(
        child: QolsysApp(),
        supportedLocales: [
          Locale("en"),
          Locale("es"),
        ],
        path: 'assets/translations',
        fallbackLocale: Locale("en"),
        assetLoader: CodegenLoader(),
      ),
    );
  }, (error, stackTrace) {
    _log.e('runZonedGuarded: Caught error in my root zone.');
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class QolsysApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final client = IQCloudClient(
        Dio()
          ..options.connectTimeout = 5000
          ..options.receiveTimeout = 3000,
        baseUrl: EnvironmentConfig.BASE_URL);
    final accountModel = AccountModel(cache: cache);
    final repo = IQCloudRepository(client: client, account: accountModel);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: accountModel),
        ChangeNotifierProvider(create: (_) => UserModel(repo)),
        ChangeNotifierProvider(create: (_) => SecurityModel(repo)),
        ChangeNotifierProvider(create: (_) => AutomationModel(repo)),
        ChangeNotifierProvider(create: (_) => EventsModel(repo)),
        ChangeNotifierProvider(create: (_) => PageModel(FavoritesPage.id)),
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: LocaleKeys.title.tr(),
        theme: ThemeData(primaryColor: kWhite, fontFamily: 'Brandon_reg'),
        home: AppScreen(),
      ),
    );
  }
}

class AppScreen extends StatelessWidget {
  final _log = getLogger('AppScreen');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _log.d('device height: ${size.height} width: ${size.width}');
    final isLoggedIn = context.select((AccountModel ac) => ac.isLoggedIn());
    _log.i('building app screen with user logged in: $isLoggedIn');

    double scaleFactor = 1.0;
    if (size.width < phoneSmallWidth)
      scaleFactor = 0.8;
    else if (size.width < phoneMediumWidth)
      scaleFactor = 0.9;
    else if (size.width < phoneLargeWidth)
      scaleFactor = 1.0;
    else if (size.width < tabletSmallWidth)
      scaleFactor = 1.1;
    else if (size.width >= tabletSmallWidth) scaleFactor = 1.2;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: scaleFactor),
      child: isLoggedIn ? AppPage() : LoginPage(),
    );
  }
}
