import 'package:flutter/material.dart';
import 'package:qolsys_app/constants/color_constants.dart';
import 'package:qolsys_app/generated/locale_keys.g.dart';
import 'package:provider/provider.dart';
import 'package:qolsys_app/providers/security_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:qolsys_app/utils/utils.dart';
import 'package:qolsys_app/widget/trouble_dialogs.dart';

class TroublesContainer extends StatelessWidget {
  final Color color;
  final List<TroubleRow> rows;
  TroublesContainer({@required this.color, @required this.rows});
  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return SizedBox();
    return Card(
      child: Container(
        decoration: BoxDecoration(
          color: kWhite,
          border: Border.all(color: color, width: 2.3),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
          child: Column(children: rows),
        ),
      ),
    );
  }
}

class TroubleRow extends StatelessWidget {
  final Color color;
  final String description;
  TroubleRow({@required this.color, @required this.description});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.warning, color: color),
        SizedBox(width: 10.0),
        Expanded(
          child: Text(
            description,
            style: TextStyle(fontSize: 22.0),
          ),
        ),
      ],
    );
  }
}

class AlarmsContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final securityModel = context.watch<SecurityModel>();
    final alarms = securityModel.alarms;

    final alarmRows = [
      for (var alarm in alarms)
        TroubleRow(
          color: kRed,
          description: getAlarmDescription(
            alarm,
            securityModel.getSensor(alarm.deviceId),
          ),
        ),
    ];
    return InkWell(
        onTap: () => requestAlarmsDialog(context),
        child: TroublesContainer(color: kRed, rows: alarmRows));
  }
}

class NoConnectionContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rows = [
      TroubleRow(
        color: kRed,
        description: LocaleKeys.iqpanelDisconnectedText.tr(),
      ),
    ];
    return TroublesContainer(color: kRed, rows: rows);
  }
}

class NoWifiContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rows = [
      TroubleRow(
        color: kRed,
        description: LocaleKeys.wifiDisconnectedText.tr(),
      ),
    ];
    return TroublesContainer(color: kRed, rows: rows);
  }
}
