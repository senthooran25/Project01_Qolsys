import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qolsys_app/constants/color_constants.dart';
import 'package:qolsys_app/constants/svg_constants.dart';
import 'package:qolsys_app/constants/text_constants.dart';
import 'package:qolsys_app/generated/locale_keys.g.dart';
import 'package:qolsys_app/models/automation_device.dart';
import 'package:qolsys_app/providers/automation_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:qolsys_app/widget/circular_indicator.dart';
import 'package:qolsys_app/widget/page_button_list.dart';
import 'package:qolsys_app/widget/page_title_text.dart';
import 'package:qolsys_app/widget/scaled_image.dart';
import 'package:qolsys_app/widget/page_container.dart';

class LightsPage extends StatelessWidget {
  static const String id = 'lights_page';
  @override
  Widget build(BuildContext context) {
    final automationModel = context.watch<AutomationModel>();
    final lights = automationModel.lights;
    return PageContainer(
      child: Column(
        children: [
          PageTitleText(title: LocaleKeys.lightsPageTitle.tr()),
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  children: [for (var light in lights) LightRow(light)],
                ),
              ),
            ),
          ),
          PageButtonList(pageId: id),
        ],
      ),
    );
  }
}

class LightRow extends StatefulWidget {
  final AutomationDevice light;
  LightRow(this.light);

  @override
  _LightRowState createState() {
    return _LightRowState();
  }
}

class _LightRowState extends State<LightRow> {
  int level;

  @override
  void initState() {
    level = widget.light.brightnessLevel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final automationModel = context.watch<AutomationModel>();
    String imagePath;
    String setStatus;
    if (widget.light.deviceStatus == statusOn) {
      setStatus = statusOff;
      imagePath = ICON_LIGHT_ON;
    } else {
      setStatus = statusOn;
      imagePath = ICON_LIGHT_OFF;
    }
    final overlayRadius = 24.0;
    return Row(
      children: [
        GestureDetector(
          onTap: () => automationModel.setDeviceStatus(
            widget.light.deviceId,
            setStatus,
          ),
          child: ScaledImage(
            svgAsset: imagePath,
            height: 100,
            width: 100,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: overlayRadius),
                child: Text(
                  widget.light.deviceName,
                  style: TextStyle(
                    fontSize: 25.0,
                    color: kGray,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (widget.light.deviceType == deviceTypeDimmer)
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    overlayShape:
                        RoundSliderOverlayShape(overlayRadius: overlayRadius),
                  ),
                  child: Slider(
                    value: level.toDouble(),
                    min: 0,
                    max: 100,
                    activeColor:
                        widget.light.deviceStatus == statusOn ? kYellow : kGray,
                    inactiveColor: kGray,
                    onChanged: widget.light.loading
                        ? null
                        : (val) {
                            setState(() {
                              level = val.round();
                            });
                          },
                    onChangeEnd: (val) async {
                      await automationModel.setDimmer(
                          deviceId: widget.light.deviceId,
                          status: statusOn,
                          level: val.toInt());
                      setState(() {
                        level = widget.light.brightnessLevel;
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.only(right: 10.0),
            height: 50,
            width: 50,
            child: widget.light.loading ? CircularIndicator() : SizedBox(),
          ),
        ),
      ],
    );
  }
}
