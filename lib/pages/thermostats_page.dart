import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:qolsys_app/constants/color_constants.dart';
import 'package:qolsys_app/constants/svg_constants.dart';
import 'package:qolsys_app/generated/locale_keys.g.dart';
import 'package:qolsys_app/models/automation_device.dart';
import 'package:qolsys_app/providers/automation_model.dart';
import 'package:qolsys_app/utils/font_styles.dart';
import 'package:qolsys_app/utils/utils.dart';
import 'package:qolsys_app/widget/page_button_list.dart';
import 'package:qolsys_app/widget/page_title_text.dart';
import 'package:qolsys_app/widget/page_view_with_indicator.dart';
import 'package:qolsys_app/widget/scaled_image.dart';
import 'package:qolsys_app/widget/page_container.dart';

class ThermostatsPage extends StatelessWidget {
  static const String id = 'thermostat_page';
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 6 / 5,
            child: ThermostatsPageView(),
          ),
          Spacer(),
          PageButtonList(pageId: id),
        ],
      ),
    );
  }
}

class ThermostatsPageView extends StatefulWidget {
  @override
  _ThermostatViewState createState() => _ThermostatViewState();
}

class _ThermostatViewState extends State<ThermostatsPageView> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final automationModel = context.watch<AutomationModel>();
    final thermostats = automationModel.thermostats;

    return PageViewWithIndicator(
      children: [
        for (var thermostat in thermostats) ThermostatCard(thermostat),
      ],
      onPageChanged: (int index) {
        setState(() {
          activeIndex = index;
        });
      },
    );
  }
}

class ThermostatCard extends StatelessWidget {
  final AutomationDevice thermostat;
  final bool isFullSize;

  ThermostatCard(this.thermostat, {this.isFullSize = true});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ThermostatTopBar(thermostat, showPageTitle: isFullSize),
        ThermostatTempControls(
          thermostat,
          isFullSize: isFullSize,
        ),
        ThermostatNameBar(thermostat)
      ],
    );
  }
}

class ThermostatTopBar extends StatelessWidget {
  //TODO: use constants for thermostats mode
  String getModeIcon(String currentMode) {
    if (currentMode == "HEAT") return ICON_THERMOSTAT_MODE_HEAT_ICON;
    if (currentMode == "COOL") return ICON_THERMOSTAT_MODE_COOL_ICON;
    if (currentMode == "AUTO") return ICON_THERMOSTAT_MODE_ICON;
    if (currentMode == "EMERGENCY") return ICON_THERMOSTAT_MODE_EMERGENCY_ICON;
    return ICON_THERMOSTAT_MODE_ICON;
  }

  final AutomationDevice thermostat;
  final bool showPageTitle;
  ThermostatTopBar(this.thermostat, {this.showPageTitle = false});

  @override
  Widget build(BuildContext context) {
    double height = 50.0;
    return Row(
      children: [
        GestureDetector(
          child: ScaledImage(
            svgAsset: getModeIcon(thermostat.mode),
            height: height,
          ),
        ),
        ScaledImage(
          svgAsset: ICON_THERMOSTAT_FAN_CONTINOUS_ICON,
          height: height,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: ScaledImage(
            svgAsset: getBatteryAsset(thermostat.batteryStatus),
            height: height * 0.8,
          ),
        ),
        ScaledImage(
          svgAsset: ICON_THERMOSTAT_ECO_ICON,
          height: height,
        ),
        Spacer(),
        if (showPageTitle)
          PageTitleText(title: LocaleKeys.thermostatsPageTitle.tr()),
      ],
    );
  }
}

class ThermostatTempControls extends StatelessWidget {
  final AutomationDevice thermostat;
  final bool isFullSize;
  ThermostatTempControls(this.thermostat, {this.isFullSize = true});
  @override
  Widget build(BuildContext context) {
    //TODO: change layout based on thermostat mode
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ThermostatSetPointView(
          thermostat: thermostat,
          isHeatSetPoint: true,
          isFullSize: isFullSize,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: ScaledImage(
            svgAsset: ICON_THERMOSTAT_HYPHAN_ICON,
            height: 10,
            width: 10,
          ),
        ),
        ThermostatSetPointView(
          thermostat: thermostat,
          isFullSize: isFullSize,
          isHeatSetPoint: false,
        )
      ],
    );
  }
}

class ThermostatSetPointView extends StatefulWidget {
  final AutomationDevice thermostat;
  final bool isHeatSetPoint;
  final bool isFullSize;

  ThermostatSetPointView({
    @required this.thermostat,
    @required this.isHeatSetPoint,
    this.isFullSize = true,
  });

  @override
  State<StatefulWidget> createState() {
    return _ThermostatSetPointViewState();
  }
}

class _ThermostatSetPointViewState extends State<ThermostatSetPointView> {
  int setPointTemp;
  Timer setPointTimer;

  @override
  void initState() {
    setPointTemp = (widget.isHeatSetPoint
            ? widget.thermostat.targetTempHigh?.toInt()
            : widget.thermostat.targetTempLow?.toInt()) ??
        0;
    super.initState();
  }

  sendSetPointRequest() async {
    bool isHeatPoint = widget.isHeatSetPoint;
    if (isHeatPoint)
      await context.read<AutomationModel>().setThermostatHeatSetPoint(
          deviceId: widget.thermostat.deviceId,
          heatSetPoint: setPointTemp.toDouble());
    else
      await context.read<AutomationModel>().setThermostatCoolSetPoint(
          deviceId: widget.thermostat.deviceId,
          coolSetPoint: setPointTemp.toDouble());
    setState(() {
      setPointTemp = (isHeatPoint
              ? widget.thermostat.targetTempHigh?.toInt()
              : widget.thermostat.targetTempLow?.toInt()) ??
          0;
    });
  }

  tempUp() {
    setState(() {
      setPointTemp++;
    });
    if (setPointTimer != null) setPointTimer.cancel();
    setPointTimer = Timer(
      Duration(seconds: 1),
      sendSetPointRequest,
    );
  }

  tempDown() {
    setState(() {
      setPointTemp--;
    });
    if (setPointTimer != null) setPointTimer.cancel();
    setPointTimer = Timer(
      Duration(seconds: 1),
      sendSetPointRequest,
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = 30.0;
    return Column(
      children: [
        GestureDetector(
          onTap: tempUp,
          child: ScaledImage(
            svgAsset: ICON_THERMOSTAT_TEMPUP_ICON,
            height: height,
          ),
        ),
        SizedBox(height: widget.isFullSize ? 20.0 : 10.0),
        SetPointText(
          temperature: setPointTemp,
          fontSize: widget.isFullSize ? 105 : 80,
          color: widget.isHeatSetPoint ? kOrange : kTeal,
        ),
        GestureDetector(
          onTap: tempDown,
          child: ScaledImage(
            svgAsset: ICON_THERMOSTAT_TEMPDOWN_ICON,
            height: height,
          ),
        ),
      ],
    );
  }
}

class SetPointText extends StatelessWidget {
  SetPointText({
    @required this.temperature,
    this.fontSize,
    this.color,
  });

  final int temperature;
  final double fontSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    /*
    Currently there is a small gap at the bottom of the text that cannot be
    avoided due to how Text works in Flutter. Cannot remove gap without using
    a complicated Stack arrangment, so will leave alone at the moment.
    https://flutter.github.io/assets-for-api-docs/assets/painting/text_height_diagram.png
    More info in flutter documentation for Text widget
    */
    return Text(
      '$temperature\u00B0',
      style: TextStyle(
        fontSize: fontSize,
        height: 1.0,
        fontFamily: 'Brandon_bld',
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0
          ..color = color,
      ),
    );
  }
}

class ThermostatNameBar extends StatelessWidget {
  final AutomationDevice thermostat;

  ThermostatNameBar(this.thermostat);
  @override
  Widget build(BuildContext context) {
    final name = thermostat.deviceName?.toUpperCase() ?? 'null';
    final temperature = thermostat.currentTemp?.toInt() ?? 0;
    return Align(
      alignment: Alignment.center,
      child: Text(
        '$name $temperature\u00B0',
        style: favorite_pages_title_style,
      ),
    );
  }
}
