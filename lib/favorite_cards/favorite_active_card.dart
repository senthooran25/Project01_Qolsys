import 'package:flutter/material.dart';
import 'package:qolsys_app/constants/text_constants.dart';
import 'package:qolsys_app/pages/security_page.dart';
import 'package:qolsys_app/providers/page_model.dart';
import 'package:qolsys_app/providers/security_model.dart';
import 'favorite_base_card.dart';
import 'package:provider/provider.dart';

class FavoriteActiveCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final partitionId = context.select((PageModel pm) => pm.activePartition);
    final sensorList =
        context.watch<SecurityModel>().getSensorsByPartition(partitionId);
    final active = sensorList
        .where((d) => activeSensorStatuses.contains(d.sensorStatus))
        .toList();
    return FavoritesBaseCard(
      cardTitle: 'ACTIVE',
      children: splitChildren(
          countPerPage: 5,
          rowWidgetFunction: (sensor) => SensorRow(sensor),
          rowData: active),
      pageId: SecurityPage.id,
      padding: EdgeInsets.only(
        top: 40.0,
        left: 20.0,
        right: 12.0,
      ),
    );
  }
}
