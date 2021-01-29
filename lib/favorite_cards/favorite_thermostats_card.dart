import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:qolsys_app/favorite_cards/favorite_base_card.dart';
import 'package:qolsys_app/generated/locale_keys.g.dart';
import 'package:qolsys_app/pages/thermostats_page.dart';
import 'package:qolsys_app/providers/automation_model.dart';

class FavoriteThermostatsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final thermostats = Provider.of<AutomationModel>(context).thermostats;
    return FavoritesBaseCard(
      children: [
        for (var thermostat in thermostats)
          ThermostatCard(thermostat, isFullSize: false),
      ],
      cardTitle: LocaleKeys.thermostatsPageTitle.tr(),
      pageId: ThermostatsPage.id,
      padding: EdgeInsets.only(top: 5),
    );
  }
}
