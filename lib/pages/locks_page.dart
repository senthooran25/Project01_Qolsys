import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qolsys_app/constants/color_constants.dart';
import 'package:qolsys_app/constants/svg_constants.dart';
import 'package:qolsys_app/constants/text_constants.dart';
import 'package:qolsys_app/generated/locale_keys.g.dart';
import 'package:qolsys_app/models/automation_device.dart';
import 'package:qolsys_app/providers/automation_model.dart';
import 'package:qolsys_app/utils/utils.dart';
import 'package:qolsys_app/widget/circular_indicator.dart';
import 'package:qolsys_app/widget/page_button_list.dart';
import 'package:qolsys_app/widget/page_title_text.dart';
import 'package:qolsys_app/widget/scaled_image.dart';
import 'package:qolsys_app/widget/page_container.dart';

class LocksPage extends StatelessWidget {
  static const String id = 'locks_page';
  @override
  Widget build(BuildContext context) {
    return LockPageBody();
  }
}

class LockPageBody extends StatefulWidget {
  @override
  _LockPageBodyState createState() => _LockPageBodyState();
}

class _LockPageBodyState extends State<LockPageBody> {
  var selectedIndices = <int>[];

  void toggleDevice(int id) {
    setState(() {
      if (selectedIndices.contains(id))
        selectedIndices.remove(id);
      else
        selectedIndices.add(id);
    });
  }

  void selectAll() {
    setState(() {
      selectedIndices =
          context.read<AutomationModel>().locks.map((e) => e.deviceId).toList();
    });
  }

  void unselectAll() {
    setState(() {
      selectedIndices = <int>[];
    });
  }

  void lockDevices() {
    for (int id in selectedIndices)
      context.read<AutomationModel>().setDeviceStatus(id, statusLocked);
  }

  void unlockDevices() {
    for (int id in selectedIndices)
      context.read<AutomationModel>().setDeviceStatus(id, statusUnLocked);
  }

  void refreshDevices() {
    for (int id in selectedIndices)
      context.read<AutomationModel>().refreshDoorLock(id);
  }

  @override
  Widget build(BuildContext context) {
    final locksList = context.watch<AutomationModel>().locks;
    return PageContainer(
      child: Column(
        children: [
          PageTitleText(title: LocaleKeys.locksPageTitle.tr()),
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (AutomationDevice lock in locksList) ...<Widget>[
                      DoorLockRow(
                        lock: lock,
                        selected: selectedIndices.contains(lock.deviceId),
                        onTap: () => toggleDevice(lock.deviceId),
                      ),
                      Divider(
                        indent: 15.0,
                        endIndent: 15.0,
                        thickness: 1.0,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              Divider(indent: 15.0, endIndent: 15.0, thickness: 1.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  LabeledIconButton(
                    asset: ICON_SELECT_ALL,
                    text: LocaleKeys.selectAllAction.tr(),
                    onTap: selectAll,
                  ),
                  LabeledIconButton(
                    asset:
                        ICON_DOOR_UNLOCKED_SMALL, //TODO: fix alignment if possible
                    text: LocaleKeys.unlockAction.tr(),
                    onTap: unlockDevices,
                  ),
                  LabeledIconButton(
                    asset:
                        ICON_DOOR_LOCKED_SMALL, //TODO: fix alignment if possible
                    text: LocaleKeys.lockAction.tr(),
                    onTap: lockDevices,
                  ),
                  LabeledIconButton(
                    asset: ICON_ZWAVE_REFRESH_LARGE,
                    text: LocaleKeys.refreshAction.tr(),
                    onTap: refreshDevices,
                  ),
                ],
              ),
            ],
          ),
          PageButtonList(pageId: LocksPage.id),
        ],
      ),
    );
  }
}

class DoorLockRow extends StatelessWidget {
  DoorLockRow({
    @required this.lock,
    @required this.selected,
    @required this.onTap,
  }) : super(key: Key(lock.deviceId.toString()));

  final AutomationDevice lock;
  final bool selected;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    double height = 60.0;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Stack(
            children: [
              ScaledImage(
                svgAsset: lock.deviceStatus == statusLocked
                    ? ICON_DOOR_LOCKED
                    : ICON_DOOR_UNLOCKED,
                height: height,
              ),
              if (lock.loading)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: CircularIndicator(),
                  ),
                ),
            ],
          ),
          SizedBox(width: 10.0),
          DoorLockNameStatus(lock: lock),
          Spacer(),
          ScaledImage(
            svgAsset: getBatteryAsset(lock.batteryStatus),
            height: height * 0.70,
          ),
          SizedBox(width: 10.0),
          InkWell(
            onTap: onTap,
            child: ScaledImage(
                svgAsset:
                    selected ? ICON_CHECKBOX_CHECKED : ICON_CHECKBOX_UNCHECKED,
                height: height / 2),
          ),
        ],
      ),
    );
  }
}

class DoorLockNameStatus extends StatelessWidget {
  DoorLockNameStatus({@required this.lock});

  final AutomationDevice lock;

  @override
  Widget build(BuildContext context) {
    double fontSize = 21.0;
    String lockStatus = lock.deviceStatus == statusLocked
        ? LocaleKeys.statusLocked.tr()
        : LocaleKeys.statusUnlocked.tr();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lock.deviceName.toUpperCase(),
          style: TextStyle(
            height: 1.0,
            fontSize: fontSize,
            color: kGray,
            fontFamily: 'Brandon_bld',
          ),
        ),
        Text(
          lockStatus,
          style: TextStyle(
            height: 1.0,
            fontSize: fontSize * 0.9,
            fontFamily: 'Brandon_med',
            color: lock.deviceStatus == statusLocked ? kRed : kGreen,
          ),
        ),
      ],
    );
  }
}

class LabeledIconButton extends StatelessWidget {
  final String asset;
  final String text;
  final Function onTap;

  LabeledIconButton({
    @required this.asset,
    @required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double fontSize = 16.0;
    double height = 50.0;
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Column(
          children: [
            ScaledImage(
              svgAsset: asset,
              height: height,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                color: kGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritesLockRow extends StatelessWidget {
  final AutomationDevice lock;
  FavoritesLockRow(this.lock);

  @override
  Widget build(BuildContext context) {
    double height = 60.0;
    return Row(
      children: [
        InkWell(
          onTap: () {
            context.read<AutomationModel>().setDeviceStatus(
                  lock.deviceId,
                  lock.deviceStatus == statusLocked
                      ? statusUnLocked
                      : statusLocked,
                );
          },
          child: ScaledImage(
            svgAsset: lock.deviceStatus == statusLocked
                ? ICON_DOOR_LOCKED
                : ICON_DOOR_UNLOCKED,
            height: height,
          ),
        ),
        SizedBox(width: 40),
        DoorLockNameStatus(lock: lock),
        Spacer(),
        if (lock.loading) CircularIndicator(maxSideLength: 50.0),
        SizedBox(
          width: 20.0,
        ),
      ],
    );
  }
}
