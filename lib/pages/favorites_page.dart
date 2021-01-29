import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qolsys_app/constants/color_constants.dart';
import 'package:qolsys_app/constants/text_constants.dart';
import 'package:qolsys_app/favorite_cards/favorite_active_card.dart';
import 'package:qolsys_app/favorite_cards/favorite_arming_card.dart';
import 'package:qolsys_app/favorite_cards/favorite_history_card.dart';
import 'package:qolsys_app/favorite_cards/favorite_lights_card.dart';
import 'package:qolsys_app/favorite_cards/favorite_locks_card.dart';
import 'package:qolsys_app/favorite_cards/favorite_thermostats_card.dart';
import 'package:qolsys_app/providers/automation_model.dart';
import 'package:qolsys_app/providers/events_model.dart';
import 'package:qolsys_app/providers/page_model.dart';
import 'package:qolsys_app/providers/security_model.dart';
import 'package:qolsys_app/providers/user_model.dart';
import 'package:qolsys_app/widget/trouble_container.dart';

class FavoritesPage extends StatelessWidget {
  static const id = 'favorites_page';
  static Future<void> fetchPanelData(BuildContext context) async {
    final fetchResults = List<Future>();
    fetchResults.add(context.read<SecurityModel>().fetchPartitions());
    fetchResults.add(context.read<SecurityModel>().fetchSensors());
    fetchResults.add(context.read<EventsModel>().fetchHistoryEvents());
    fetchResults.add(context.read<AutomationModel>().fetchAutomationDevices());
    for (var result in fetchResults) await result;
    return;
  }

  @override
  Widget build(BuildContext context) {
    final automationModel = context.watch<AutomationModel>();
    final securityModel = context.watch<SecurityModel>();
    final userModel = context.watch<UserModel>();
    final pageModel = context.watch<PageModel>();
    final lightCount = automationModel.lights.length;
    final thermostatCount = automationModel.thermostats.length;
    final activeSensorCount = securityModel
        .getSensorsByPartition(pageModel.activePartition)
        .where((d) => activeSensorStatuses.contains(d.sensorStatus))
        .length;
    final lockCount = automationModel.locks.length;
    final connectionStatus = userModel.accountDetails?.connectionStatus;
    final wifiStatus = userModel.panelProperties?.wifiStatus;
    final troublesList = <Widget>[
      if (securityModel.alarms.isNotEmpty) AlarmsContainer(),
      if (connectionStatus != 'connected') NoConnectionContainer(),
      if (connectionStatus == 'connected' && wifiStatus != 'on')
        NoWifiContainer(),
    ];
    final cardsList = [
      FavoriteArmingCard(),
      FavoriteHistoryCard(),
      if (activeSensorCount > 0) FavoriteActiveCard(),
      if (lockCount > 0) FavoriteLocksCard(),
      if (lightCount > 0) FavoriteLightsCard(),
      if (thermostatCount > 0) FavoriteThermostatsCard(),
    ];
    final favoritesList = troublesList + cardsList;
    return Container(
      child: RefreshIndicator(
        color: kGreen,
        onRefresh: () async => fetchPanelData(context),
        child: ListView.builder(
            itemCount: favoritesList.length,
            padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0),
                child: favoritesList[index],
              );
            }),
      ),
    );
  }
}
