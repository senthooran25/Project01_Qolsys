import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:qolsys_app/favorite_cards/favorite_base_card.dart';
import 'package:qolsys_app/pages/locks_page.dart';
import 'package:qolsys_app/providers/automation_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:qolsys_app/generated/locale_keys.g.dart';

class FavoriteLocksCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locks = context.watch<AutomationModel>().locks;
    final children = splitChildren(
      countPerPage: 3,
      rowWidgetFunction: (lock) => Padding(
        padding: EdgeInsets.symmetric(vertical: 4.0),
        child: FavoritesLockRow(lock),
      ),
      rowData: locks,
    );
    return FavoritesBaseCard(
      cardTitle: LocaleKeys.locksPageTitle.tr(),
      children: children,
      pageId: LocksPage.id,
      padding: EdgeInsets.only(top: 30.0, left: 30.0),
    );
  }
}
