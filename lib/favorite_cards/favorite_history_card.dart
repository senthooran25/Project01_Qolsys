import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qolsys_app/favorite_cards/favorite_base_card.dart';
import 'package:qolsys_app/generated/locale_keys.g.dart';
import 'package:qolsys_app/pages/history_events_page.dart';
import 'package:qolsys_app/providers/events_model.dart';

class FavoriteHistoryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final events = context.select((EventsModel p) => p.historyEvents);
    if (events.isEmpty)
      return FavoritesBaseCard(
        cardTitle: LocaleKeys.favHistoryEventsCardTitle.tr(),
        body: NoHistoryRecords(),
        pageId: HistoryEventsPage.id,
      );

    final children = splitChildren(
      countPerPage: 3,
      rowWidgetFunction: (event) => HistoryEventRow(event),
      rowData: events.take(15).toList(),
    );
    return FavoritesBaseCard(
      cardTitle: LocaleKeys.favHistoryEventsCardTitle.tr(),
      children: children,
      pageId: HistoryEventsPage.id,
      padding: EdgeInsets.only(top: 28.0, left: 25.0, right: 10.0),
    );
  }
}
