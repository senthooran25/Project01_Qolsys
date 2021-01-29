import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qolsys_app/constants/color_constants.dart';
import 'package:qolsys_app/constants/integer_constants.dart';
import 'package:qolsys_app/constants/svg_constants.dart';
import 'package:qolsys_app/constants/text_constants.dart';
import 'package:qolsys_app/generated/locale_keys.g.dart';
import 'package:qolsys_app/models/sensor.dart';
import 'package:qolsys_app/providers/page_model.dart';
import 'package:qolsys_app/providers/security_model.dart';
import 'package:qolsys_app/widget/circular_indicator.dart';
import 'package:qolsys_app/widget/page_button_list.dart';
import 'package:qolsys_app/widget/page_title_text.dart';
import 'package:qolsys_app/widget/page_view_with_indicator.dart';
import 'package:qolsys_app/widget/scaled_image.dart';
import 'package:qolsys_app/widget/page_container.dart';
import 'package:qolsys_app/widget/trouble_dialogs.dart';

Color getArmingColor(String armStatus) {
  if (armStatus == statusDisarm) return kGreen;
  if (armStatus == statusArmStay) return kOrange;
  if (armStatus == statusArmAway) return kRed;
  return null;
}

String getArmingText(String armStatus) {
  if (armStatus == statusDisarm) return LocaleKeys.arming_status_disarm.tr();
  if (armStatus == statusArmStay) return LocaleKeys.arming_status_stay.tr();
  if (armStatus == statusArmAway) return LocaleKeys.arming_status_away.tr();
  return null;
}

String getArmingAsset(String armStatus) {
  if (armStatus == statusDisarm) return ICON_DISARM;
  if (armStatus == statusArmStay) return ICON_ARMSTAY;
  if (armStatus == statusArmAway) return ICON_ARMAWAY;
  return null;
}

Future changeSystemStatus(
  BuildContext context,
  String armStatus,
  int partitionId,
) {
  if (armStatus == statusDisarm)
    return context.read<SecurityModel>().disarm(partitionId);
  if (armStatus == statusArmStay)
    return context.read<SecurityModel>().armStay(partitionId);
  if (armStatus == statusArmAway)
    return context.read<SecurityModel>().armAway(partitionId);
  return null;
}

class SecurityPage extends StatelessWidget {
  static const String id = 'security_page';

  static Future<void> refreshSecurityPage(BuildContext context) async {
    final securityModel = context.read<SecurityModel>();
    await securityModel.fetchPartitions();
    await securityModel.fetchSensors();
    return;
  }

  SecurityPage(this.partitionId);
  final int partitionId;
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      child: Column(
        children: [
          PageTitleText(title: LocaleKeys.security.tr()),
          ArmingCardScrollable(
            initialPartitionId: partitionId,
            advancedDialog: true,
          ),
          Divider(color: kGray, indent: 10.0, endIndent: 10.0),
          Expanded(
            child: SensorList(),
          ),
          PageButtonList(pageId: id),
        ],
      ),
    );
  }
}

class ArmingCardScrollable extends StatefulWidget {
  ArmingCardScrollable({
    @required this.initialPartitionId,
    this.advancedDialog = false,
  });

  final int initialPartitionId;
  final bool advancedDialog;

  @override
  _ArmingCardScrollableState createState() => _ArmingCardScrollableState();
}

class _ArmingCardScrollableState extends State<ArmingCardScrollable> {
  int activeIndex;

  @override
  Widget build(BuildContext context) {
    final partitions = context.watch<SecurityModel>().partitions;
    final partitionIds = partitions.map((p) => p.partitionId).toList();
    final children = [
      for (int i in partitionIds)
        ArmingCard(i, advancedDialog: widget.advancedDialog)
    ];
    return AspectRatio(
      aspectRatio: 2 / 1,
      child: PageViewWithIndicator(
        children: children,
        onPageChanged: (index) =>
            context.read<PageModel>().activePartition = index,
        initialIndex: widget.initialPartitionId,
      ),
    );
  }
}

class ArmingCard extends StatelessWidget {
  final bool advancedDialog;
  final int partitionId;
  ArmingCard(this.partitionId, {this.advancedDialog = false});

  @override
  Widget build(BuildContext context) {
    final securityModel = context.watch<SecurityModel>();
    final activePartition = securityModel.getPartition(partitionId);
    final armStatus = activePartition?.armingStatus;
    final isInAlarm = securityModel.alarms
        .map((e) => e.partitionId)
        .contains(activePartition.partitionId);
    //TODO: change to ICON_IN_ALARM once assets is available
    final armAsset = isInAlarm ? ICON_ARMAWAY : getArmingAsset(armStatus);
    return Container(
      alignment: Alignment.center,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Spacer(),
              InkWell(
                onTap: () {
                  if (isInAlarm)
                    requestAlarmsDialog(context);
                  else
                    showDialog(
                        context: context,
                        builder: (context) => advancedDialog
                            ? AdvancedArmDialog(partitionId)
                            : QuickArmDialog(partitionId));
                },
                child: ScaledImage(svgAsset: armAsset, height: 150.0),
              ),
              SystemStatusText(
                armStatus: armStatus,
                fontSize: 25.0,
                isInAlarm: isInAlarm,
              ),
              Spacer(),
            ],
          ),
          if (activePartition != null && activePartition.loading)
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: CircularIndicator(),
              ),
            )
        ],
      ),
    );
  }
}

class SystemStatusText extends StatelessWidget {
  final String armStatus;
  final double fontSize;
  final bool isInAlarm;
  SystemStatusText({
    @required this.armStatus,
    this.isInAlarm = false,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    double fontSize = this.fontSize ?? 14.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          LocaleKeys.system.tr(),
          style: TextStyle(
            fontSize: fontSize * 1.2,
            color: kGray,
            fontFamily: 'Brandon_med',
            height: 1.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          isInAlarm ? LocaleKeys.inAlarm.tr() : getArmingText(armStatus),
          style: TextStyle(
            fontSize: fontSize,
            color: isInAlarm ? kRed : getArmingColor(armStatus),
            fontFamily: 'Brandon_med',
            height: 1.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class AdvancedArmDialog extends StatelessWidget {
  AdvancedArmDialog(this.partitionId);
  final int partitionId;

  @override
  Widget build(BuildContext context) {
    final activePartition =
        context.watch<SecurityModel>().getPartition(partitionId);
    final armStatus = activePartition?.armingStatus;
    final size = MediaQuery.of(context).size;
    double scaleFactor = 1.0;
    if (size.width < phoneSmallWidth)
      scaleFactor = 0.75;
    else if (size.width < phoneMediumWidth)
      scaleFactor = 0.9;
    else if (size.width < phoneLargeWidth)
      scaleFactor = 1.0;
    else if (size.width < tabletSmallWidth)
      scaleFactor = 1.1;
    else if (size.width >= tabletSmallWidth) scaleFactor = 1.2;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: size.width < phoneMediumWidth ? 20.0 : 50.0,
      ),
      child: Material(
        color: kBlack.withOpacity(0.8),
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: scaleFactor),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      SizedBox(width: 20.0),
                      SystemStatusWithTick(armStatus: armStatus),
                      Spacer(),
                      ScaledImage(
                        svgAsset: getArmingAsset(armStatus),
                        height: 35.0,
                      ),
                      SizedBox(width: 80.0),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  if (armStatus != statusDisarm)
                    ArmButtonWithStatus(partitionId, armStatus: statusDisarm),
                  if (armStatus == statusDisarm)
                    ArmButtonWithStatus(partitionId, armStatus: statusArmStay),
                  if (armStatus == statusDisarm)
                    ArmButtonWithStatus(partitionId, armStatus: statusArmAway),
                  SizedBox(height: 20.0),
                  if (armStatus == statusDisarm) ArmingOptionsRow(),
                  SizedBox(height: 20.0),
                  Divider(color: kGray, indent: 10.0, endIndent: 10.0),
                  Expanded(child: SensorList()),
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    color: Colors.transparent,
                    //need to include a color to extend the size around the button
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            border: Border.all(color: kGray)),
                        child: Icon(Icons.clear, color: kGray, size: 16.0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArmButtonWithStatus extends StatelessWidget {
  final String armStatus;
  final int partitionId;

  ArmButtonWithStatus(this.partitionId, {this.armStatus});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ArmPopupButton(partitionId, armStatus: armStatus),
        SizedBox(width: 10),
        SystemStatusText(armStatus: armStatus, fontSize: 27.0),
      ],
    );
  }
}

class ArmingOptionsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ArmingOptionButton(
          title: LocaleKeys.exitSounds.tr(),
          iconOn: ICON_EXIT_SOUNDS_ON,
          iconOff: ICON_EXIT_SOUNDS_OFF,
        ),
        ArmingOptionButton(
          title: LocaleKeys.entryDelay.tr(),
          iconOn: ICON_ENTRY_DELAY_ON,
          iconOff: ICON_ENTRY_DELAY_OFF,
        ),
      ],
    );
  }
}

class ArmingOptionButton extends StatefulWidget {
  final String title;
  final String iconOn;
  final String iconOff;

  ArmingOptionButton({
    @required this.title,
    @required this.iconOn,
    @required this.iconOff,
  });

  @override
  _ArmingOptionButtonState createState() => _ArmingOptionButtonState();
}

class _ArmingOptionButtonState extends State<ArmingOptionButton> {
  bool isOn = true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        setState(() {
          isOn = !isOn;
        })
      },
      child: Column(
        children: [
          Text(
            widget.title,
            style: TextStyle(
              color: kGray,
              fontWeight: FontWeight.w300,
              fontSize: 13.0,
            ),
          ),
          ScaledImage(
            svgAsset: isOn ? widget.iconOn : widget.iconOff,
            height: 40,
            width: 40,
          ),
          Text(
            isOn ? LocaleKeys.statusOn.tr() : LocaleKeys.statusOff.tr(),
            style: TextStyle(
              color: kGray,
              fontWeight: FontWeight.w300,
              fontSize: 13.0,
            ),
          ),
        ],
      ),
    );
  }
}

class QuickArmDialog extends StatelessWidget {
  final int partitionId;
  QuickArmDialog(this.partitionId);

  @override
  Widget build(BuildContext context) {
    final activePartition =
        context.watch<SecurityModel>().getPartition(partitionId);
    final armStatus = activePartition?.armingStatus;
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SystemStatusWithTick(armStatus: armStatus),
              Spacer(),
              ScaledImage(svgAsset: getArmingAsset(armStatus), height: 45.0),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (armStatus != statusDisarm)
                Expanded(
                    child:
                        ArmPopupButton(partitionId, armStatus: statusDisarm)),
              if (armStatus == statusDisarm)
                Expanded(
                    child:
                        ArmPopupButton(partitionId, armStatus: statusArmStay)),
              if (armStatus == statusDisarm)
                Expanded(
                    child:
                        ArmPopupButton(partitionId, armStatus: statusArmAway)),
            ],
          )
        ],
      ),
    );
  }
}

class SystemStatusWithTick extends StatelessWidget {
  final String armStatus;

  SystemStatusWithTick({@required this.armStatus});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ScaledImage(
            pngAsset: ICON_TICK,
            height: 30.0,
            color: getArmingColor(armStatus)),
        SystemStatusText(armStatus: armStatus),
      ],
    );
  }
}

class ArmPopupButton extends StatelessWidget {
  ArmPopupButton(this.partitionId, {@required this.armStatus});

  final String armStatus;
  final int partitionId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        changeSystemStatus(context, armStatus, partitionId);
      },
      child: ScaledImage(svgAsset: getArmingAsset(armStatus), height: 120),
    );
  }
}

class SensorList extends StatefulWidget {
  @override
  _SensorListState createState() => _SensorListState();
}

class _SensorListState extends State<SensorList> {
  static const String ACTIVE = 'ACTIVE';
  static const String ALL = 'ALL';

  String filterName = ACTIVE;

  void setFilter(String filter) {
    setState(() {
      filterName = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    final partitionId = context.select((PageModel pm) => pm.activePartition);
    final sensorList =
        context.watch<SecurityModel>().getSensorsByPartition(partitionId);
    final filteredList = filterName == ACTIVE
        ? sensorList.where((d) => activeSensorStatuses.contains(d.sensorStatus))
        : sensorList;
    return Column(
      children: [
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 5,
              child: FilterButton(
                title: LocaleKeys.active.tr(),
                active: filterName == ACTIVE,
                onTap: () => setFilter(ACTIVE),
              ),
            ),
            Spacer(),
            Expanded(
              flex: 5,
              child: FilterButton(
                title: LocaleKeys.all.tr(),
                active: filterName == ALL,
                onTap: () => setFilter(ALL),
              ),
            ),
            Spacer(),
          ],
        ),
        Expanded(
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var sensor in filteredList)
                    Padding(
                      padding: EdgeInsets.only(left: 25.0, right: 17.0),
                      child: SensorRow(sensor),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FilterButton extends StatelessWidget {
  final String title;
  final bool active;
  final Function onTap;

  FilterButton({this.title, this.active, this.onTap});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: active ? kGreen.withOpacity(0.2) : kGray.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      onPressed: onTap,
      child: Container(
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
              fontSize: 26.0,
              color: active ? kGreen : kGray,
              fontFamily: 'Brandon_med',
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class SensorRow extends StatelessWidget {
  final Sensor device;

  SensorRow(this.device);

  @override
  Widget build(BuildContext context) {
    String assetPath;
    Color color;
    switch (device.sensorStatus) {
      case statusOpened:
        color = kOrange;
        assetPath = device.sensorState == stateBypassNone
            ? ICON_SENSOR_OPEN
            : ICON_SENSOR_OPEN_BYPASS;
        break;
      case statusTampered:
        color = kOrange;
        assetPath = ICON_SENSOR_TAMPERED;
        break;
      case statusIdle:
        color = kGray;
        assetPath = ICON_SENSOR_IDLE;
        break;
      case statusFailure:
        color = kGray;
        assetPath = ICON_SENSOR_FAILURE;
        break;
      case statusNormal:
      case statusActive:
      case statusClosed:
      default:
        color = kGray;
        assetPath = device.sensorState == stateBypassNone
            ? ICON_SENSOR_CLOSE
            : ICON_SENSOR_CLOSE_BYPASS;
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            device.sensorName,
            style: TextStyle(
                color: kGray,
                fontSize: 25.0,
                fontFamily: 'Brandon_light',
                fontWeight: FontWeight.w600),
          ),
        ),
        ScaledImage(
          svgAsset: assetPath,
          height: 30.0,
          color: color,
        )
      ],
    );
  }
}
