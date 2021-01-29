import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:qolsys_app/favorite_cards/favorite_base_card.dart';
import 'package:qolsys_app/pages/lights_page.dart';
import 'package:qolsys_app/providers/automation_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:qolsys_app/generated/locale_keys.g.dart';

class FavoriteLightsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lights = context.watch<AutomationModel>().lights;
    final children = splitChildren(
      countPerPage: 2,
      rowWidgetFunction: (light) => LightRow(light),
      rowData: lights,
    );
    return FavoritesBaseCard(
      cardTitle: LocaleKeys.lightsPageTitle.tr(),
      children: children,
      pageId: LightsPage.id,
      padding: EdgeInsets.only(top: 30.0),
    );
  }
}
