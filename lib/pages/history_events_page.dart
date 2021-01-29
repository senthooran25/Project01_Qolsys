import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qolsys_app/constants/color_constants.dart';
import 'package:qolsys_app/generated/locale_keys.g.dart';
import 'package:qolsys_app/models/history_event.dart';
import 'package:qolsys_app/providers/events_model.dart';
import 'package:qolsys_app/utils/date_time_utils.dart';
import 'package:qolsys_app/utils/font_styles.dart';
import 'package:qolsys_app/widget/page_container.dart';
import 'package:qolsys_app/widget/page_title_text.dart';

class HistoryEventsPage extends StatelessWidget {
  static const String id = 'history_events_page';

  @override
  Widget build(BuildContext context) {
    final eventsModel = context.watch<EventsModel>();
    final events = eventsModel.historyEvents;
    return PageContainer(
      child: Column(children: [
        PageTitleText(title: LocaleKeys.favHistoryEventsCardTitle.tr()),
        if (events.isEmpty)
          NoHistoryRecords()
        else
          Expanded(
            child: Scrollbar(
              child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  children: events
                      .map((e) => Padding(
                            padding: EdgeInsets.only(bottom: 4.0),
                            child: HistoryEventRow(e),
                          ))
                      .toList()),
            ),
          ),
      ]),
    );
  }
}

class NoHistoryRecords extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        LocaleKeys.noRecords.tr(),
        style: TextStyle(
          fontSize: 25.0,
          color: kGray,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class HistoryEventRow extends StatelessWidget {
  final HistoryEvent event;

  HistoryEventRow(this.event);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FittedBox(
        alignment: Alignment.centerLeft,
        fit: BoxFit.contain,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              event.eventDescription ?? event.eventType,
              textAlign: TextAlign.start,
              style: history_event_title_style,
            ),
            Text(
              DateTimeUtils.getHistoryEventDate(event.eventTime),
              style: history_event_desc_style,
            ),
          ],
        ),
      ),
    );
  }
}
