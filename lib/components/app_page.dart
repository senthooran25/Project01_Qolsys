import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:qolsys_app/constants/color_constants.dart';
import 'package:qolsys_app/constants/svg_constants.dart';
import 'package:qolsys_app/fcm/fcm_notifications.dart';
import 'package:qolsys_app/pages/about_page.dart';
import 'package:qolsys_app/pages/favorites_page.dart';
import 'package:qolsys_app/pages/groups_page.dart';
import 'package:qolsys_app/pages/history_events_page.dart';
import 'package:qolsys_app/pages/lights_page.dart';
import 'package:qolsys_app/pages/locks_page.dart';
import 'package:qolsys_app/pages/scenes_page.dart';
import 'package:qolsys_app/pages/security_page.dart';
import 'package:qolsys_app/pages/settings_page.dart';
import 'package:qolsys_app/pages/thermostats_page.dart';
import 'package:qolsys_app/providers/automation_model.dart';
import 'package:qolsys_app/providers/events_model.dart';
import 'package:qolsys_app/providers/page_model.dart';
import 'package:qolsys_app/providers/security_model.dart';
import 'package:qolsys_app/providers/user_model.dart';
import 'package:qolsys_app/utils/qolsys_logger.dart';
import 'package:qolsys_app/utils/toast_utils.dart';
import 'package:qolsys_app/widget/circular_indicator.dart';
import 'package:qolsys_app/widget/scaled_image.dart';
import 'package:qolsys_app/widget/trouble_dialogs.dart';

final Map<String, Function> pageMap = {
  SecurityPage.id: (context) => SecurityPage(
        Provider.of<PageModel>(context, listen: false).activePartition,
      ),
  ScenesPage.id: (context) => ScenesPage(),
  FavoritesPage.id: (context) => FavoritesPage(),
  GroupsPage.id: (context) => GroupsPage(),
  SettingsPage.id: (context) => SettingsPage(),
  LightsPage.id: (context) => LightsPage(),
  HistoryEventsPage.id: (context) => HistoryEventsPage(),
  AboutPage.id: (context) => AboutPage(),
  LocksPage.id: (context) => LocksPage(),
  ThermostatsPage.id: (context) => ThermostatsPage(),
};

class AppPage extends StatefulWidget {
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> with WidgetsBindingObserver {
  final _log = getLogger('AppPage');

  List<StreamSubscription> subscriptions = [];
  @override
  void initState() {
    _log.i('initState()');
    WidgetsBinding.instance.addObserver(this);
    _subscribeForErrors();
    _initializeData(false).then((value) {
      if (context.read<SecurityModel>().alarms.isNotEmpty)
        requestAlarmsDialog(context);
    });
    initializeFcm(context);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _initializeData(false).then((value) {
          if (context.read<SecurityModel>().alarms.isNotEmpty)
            requestAlarmsDialog(context);
        });
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  dispose() {
    _log.i('dispose()');
    for (var sub in subscriptions) sub.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool loaded = false;

  Future _precacheSvg(String assetName) => precachePicture(
        ExactAssetPicture(SvgPicture.svgStringDecoder, assetName),
        null,
      );

  void _subscribeForErrors() {
    subscriptions.add(context
        .read<SecurityModel>()
        .errorStream
        .listen((event) => errorToast(event)));
    subscriptions.add(context
        .read<AutomationModel>()
        .errorStream
        .listen((event) => errorToast(event)));
  }

  Future<void> _preloadImages() async {
    try {
      // Causes exceptions during flutter driver tests
      await Future.wait(<Future>[
        precacheImage(AssetImage(ICON_TICK), context),
        _precacheSvg(ICON_DISARM),
        _precacheSvg(ICON_ARMSTAY),
        _precacheSvg(ICON_ARMAWAY),
      ]);
    } catch (error) {
      _log.e('_loadImages() | $error');
    }
  }

  Future<void> _initializeData(bool onResume) async {
    if (!onResume) _preloadImages();
    await Future.wait(<Future>[
      context.read<SecurityModel>().fetchAlarms(),
      context.read<SecurityModel>().fetchPartitions(),
      context.read<SecurityModel>().fetchSensors(),
      context.read<EventsModel>().fetchHistoryEvents(),
      context.read<AutomationModel>().fetchAutomationDevices(),
      context.read<UserModel>().fetchUserData(),
    ]);
    if (!onResume) {
      context.read<PageModel>().currentPage = FavoritesPage.id;
      setState(() {
        loaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLight,
      appBar: AppBar(
        leading: SizedBox(),
        title: Center(
          child: ScaledImage(svgAsset: ICON_JCI_LOGO, height: 40.0),
        ),
        actions: <Widget>[
          ScaledImage(svgAsset: ICON_MESSAGES, height: 25.0),
          SizedBox(
            width: 20.0,
          )
        ],
        backgroundColor: kWhite,
      ),
      body: loaded
          ? pageMap[context.watch<PageModel>().currentPage](context)
          : Center(child: CircularIndicator()),
      bottomNavigationBar: BottomNav(),
    );
  }
}

class BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.1,
      child: Container(
        color: kWhite,
        child: Column(
          children: [
            Container(color: kLight, height: 2.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BottomNavIconButton(
                  key: Key('favorites'),
                  imagePath: ICON_FAVORITE,
                  pageId: FavoritesPage.id,
                ),
                BottomNavIconButton(
                  key: Key('security'),
                  imagePath: ICON_SECURITY,
                  pageId: SecurityPage.id,
                ),
                BottomNavIconButton(
                  key: Key('settings'),
                  imagePath: ICON_SETTINGS,
                  pageId: SettingsPage.id,
                ),
              ],
            ),
            Expanded(child: Container(color: kLight)),
          ],
        ),
      ),
    );
  }
}

class BottomNavIconButton extends StatelessWidget {
  final String imagePath;
  final String pageId;
  final String label;

  BottomNavIconButton({
    Key key,
    @required this.imagePath,
    @required this.pageId,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageModel = context.watch<PageModel>();
    return GestureDetector(
      key: Key(label),
      onTap: () => pageModel.currentPage = pageId,
      child: ScaledImage(
        svgAsset: imagePath,
        height: 45.0,
        color: pageModel.currentPage == pageId ? kGreen : kGray,
      ),
    );
  }
}
