import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qolsys_app/constants/color_constants.dart';
import 'package:qolsys_app/constants/svg_constants.dart';
import 'package:qolsys_app/generated/locale_keys.g.dart';
import 'package:qolsys_app/providers/security_model.dart';
import 'package:qolsys_app/utils/date_time_utils.dart';
import 'package:qolsys_app/utils/utils.dart';
import 'package:qolsys_app/widget/scaled_image.dart';
import 'package:easy_localization/easy_localization.dart';

bool _alarmDialogActive = false;

requestDismissAlarmsDialog(BuildContext context) {
  if (_alarmDialogActive) Navigator.pop(context);
}

requestAlarmsDialog(BuildContext context) async {
  if (_alarmDialogActive) return;
  _alarmDialogActive = true;
  await showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      insetPadding: EdgeInsets.zero,
      child: Builder(
        builder: (context) {
          Size size = MediaQuery.of(context).size;
          return Container(
            height: 165, //dialog height is 165
            width: size.width - 15 * 2, //dialog side padding is 15 each side
            child: AlarmPopupWidget(),
          );
        },
      ),
    ),
  );
  _alarmDialogActive = false;
}

class AlarmPopupWidget extends StatelessWidget {
  Widget _alarmRow(alarmDescription, dateDescription) =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        Text(
          alarmDescription,
          style: TextStyle(fontFamily: 'Brandon_bld'),
        ),
        Text(': ' + dateDescription),
      ]);

  @override
  Widget build(BuildContext context) {
    final securityModel = context.watch<SecurityModel>();
    final alarmTexts = securityModel.alarms
        .map(
          (alarm) => _alarmRow(
              getAlarmDescription(
                  alarm, securityModel.getSensor(alarm.deviceId)),
              DateTimeUtils.getHistoryEventDate(alarm.eventTime)),
        )
        .toList();
    if (alarmTexts.isEmpty) return Container();
    final controller = ScrollController();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 15.0),
        Text(
          LocaleKeys.appTitle.tr(),
          style: TextStyle(
            color: kDark,
            fontFamily: 'Brandon_bld',
          ),
        ),
        SizedBox(height: 5.0),
        Expanded(
          child: Scrollbar(
            isAlwaysShown: true,
            thickness: 4.0,
            controller: controller,
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: SingleChildScrollView(
                controller: controller,
                child: Column(children: alarmTexts),
              ),
            ),
          ),
        ),
        DismissAlarmRow(),
        SizedBox(height: 10.0),
      ],
    );
  }
}

class DismissAlarmRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final securityModel = Provider.of<SecurityModel>(context, listen: false);
    return InkWell(
      onTap: () {
        final alarmedPartitions =
            securityModel.alarms.map((e) => e.partitionId).toSet();
        for (int partitionId in alarmedPartitions)
          securityModel.disarm(partitionId);
        requestDismissAlarmsDialog(context);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          //TODO: replace image with arming icon when available
          ScaledImage(svgAsset: ICON_ARMAWAY, height: 50.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DISMISS',
                style: TextStyle(
                  height: 1.0,
                  color: kRed,
                  fontFamily: 'Brandon_bld',
                ),
              ),
              Text(
                'ALARM',
                style: TextStyle(
                  height: 1.0,
                  fontFamily: 'Brandon_reg',
                  color: kDark,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
