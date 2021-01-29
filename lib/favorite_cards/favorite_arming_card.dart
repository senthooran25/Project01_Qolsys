import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qolsys_app/favorite_cards/favorite_base_card.dart';
import 'package:qolsys_app/generated/locale_keys.g.dart';
import 'package:qolsys_app/pages/security_page.dart';
import 'package:provider/provider.dart';
import 'package:qolsys_app/providers/page_model.dart';

class FavoriteArmingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FavoritesBaseCard(
      cardTitle: LocaleKeys.security.tr(),
      body: ArmingCardScrollable(
          initialPartitionId:
              context.select((PageModel pm) => pm.activePartition)),
      pageId: SecurityPage.id,
    );
  }
}
