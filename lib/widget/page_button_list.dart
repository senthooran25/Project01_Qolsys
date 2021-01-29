import 'package:flutter/material.dart';
import 'package:qolsys_app/constants/color_constants.dart';
import 'package:qolsys_app/generated/locale_keys.g.dart';
import 'package:qolsys_app/pages/lights_page.dart';
import 'package:qolsys_app/pages/locks_page.dart';
import 'package:qolsys_app/pages/security_page.dart';
import 'package:qolsys_app/pages/thermostats_page.dart';
import 'package:qolsys_app/providers/automation_model.dart';
import 'package:provider/provider.dart';
import 'package:qolsys_app/providers/page_model.dart';
import 'package:easy_localization/easy_localization.dart';

class PageButtonList extends StatelessWidget {
  static final pagesWithButtons = [
    SecurityPage.id,
    LocksPage.id,
    LightsPage.id,
    ThermostatsPage.id,
  ];
  final String pageId;
  PageButtonList({this.pageId});

  @override
  Widget build(BuildContext context) {
    final automationModel = context.watch<AutomationModel>();
    final lightCount = automationModel.lights.length;
    final lockCount = automationModel.locks.length;
    final thermostatCount = automationModel.thermostats.length;

    final pageButtons = [
      if (pageId != SecurityPage.id)
        PageButton(name: LocaleKeys.security.tr(), pageId: SecurityPage.id),
      if (pageId != LocksPage.id && lockCount > 0)
        PageButton(name: LocaleKeys.locksPageTitle.tr(), pageId: LocksPage.id),
      if (pageId != LightsPage.id && lightCount > 0)
        PageButton(
            name: LocaleKeys.lightsPageTitle.tr(), pageId: LightsPage.id),
      if (pageId != ThermostatsPage.id && thermostatCount > 0)
        PageButton(
            name: LocaleKeys.thermostatsPageTitle.tr(),
            pageId: ThermostatsPage.id),
    ];

    double indent = 8.0;
    final buttonsWithDividers = [
      for (var button in pageButtons) ...<Widget>[
        Divider(
          thickness: 0.3,
          indent: indent,
          endIndent: indent,
          color: kGray,
        ),
        button
      ]
    ];

    if (buttonsWithDividers.length > 0) {
      buttonsWithDividers[0] = Divider(
        thickness: 0.6,
        indent: indent,
        endIndent: indent,
        color: kGray,
      );
      return Column(children: buttonsWithDividers);
    } else
      return SizedBox();
  }
}

class PageButton extends StatelessWidget {
  final String name;
  final String pageId;

  PageButton({
    @required this.name,
    @required this.pageId,
  }) : super(key: Key(pageId));

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<PageModel>().currentPage = pageId,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        color: Colors.transparent,
        child: Text(
          name,
          style: TextStyle(
            fontSize: 24.0,
            color: kGray,
            fontFamily: 'Brandon_bld',
          ),
        ),
      ),
    );
  }
}
