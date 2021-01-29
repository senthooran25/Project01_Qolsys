import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qolsys_app/constants/color_constants.dart';
import 'package:qolsys_app/constants/text_constants.dart';
import 'package:qolsys_app/fcm/fcm_notifications.dart';
import 'package:qolsys_app/generated/locale_keys.g.dart';
import 'package:qolsys_app/pages/about_page.dart';
import 'package:qolsys_app/providers/account_model.dart';
import 'package:qolsys_app/providers/events_model.dart';
import 'package:qolsys_app/providers/page_model.dart';
import 'package:qolsys_app/providers/user_model.dart';
import 'package:qolsys_app/widget/page_container.dart';
import 'package:qolsys_app/widget/page_title_text.dart';

class SettingsPage extends StatefulWidget {
  static const id = 'settings_page';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<String> notificationTopicsList;

  //TODO: move to constants file and use thinDivider + thickDivider universally
  // throughout all pages
  static const thinDivider = Divider(
    indent: 8.0,
    endIndent: 8.0,
    thickness: 0.8,
  );

  @override
  void initState() {
    final cache = context.read<AccountModel>().cache;
    final unmodifiableCachedList =
        cache?.loadNotificationList() ?? defaultNotificationTopics;
    notificationTopicsList = List.from(unmodifiableCachedList);
    super.initState();
  }

  void modifyList(String dbKey, bool value) {
    setState(() {
      if (value)
        notificationTopicsList.add(dbKey);
      else
        notificationTopicsList.remove(dbKey);
    });
    context
        .read<AccountModel>()
        .cache
        ?.saveNotificationList(notificationTopicsList);
    updateNotificationTopics(context, notificationTopicsList);
  }

  final _titleMap = {
    topicAlarmsNotification: LocaleKeys.alarmEvents.tr(),
    topicArmingNotification: LocaleKeys.arming_events.tr(),
    topicSensorNotification: LocaleKeys.sensor_events.tr(),
  };

  @override
  Widget build(BuildContext context) {
    final systemNotificationsList = <Widget>[
      for (String setting in _titleMap.keys) ...<Widget>[
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: NotificationSetting(
            title: _titleMap[setting],
            isActive: notificationTopicsList.contains(setting),
            onToggle: (val) => modifyList(setting, val),
          ),
        ),
        thinDivider
      ],
    ];

    return PageContainer(
      child: Column(
        children: [
          PageTitleText(title: LocaleKeys.notificationSettings.tr()),
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Heading(title: LocaleKeys.systemNotifications.tr()),
                    thinDivider,
                    ...systemNotificationsList,
                    Heading(title: LocaleKeys.aboutInfo.tr()),
                    thinDivider,
                    ClickableRow(
                      text: LocaleKeys.about.tr(),
                      onTap: () =>
                          context.read<PageModel>().currentPage = AboutPage.id,
                    ),
                    thinDivider,
                    Heading(title: LocaleKeys.logout_title.tr().toUpperCase()),
                    thinDivider,
                    ClickableRow(
                      text: LocaleKeys.logout_title.tr(),
                      onTap: () => {
                        showDialog(
                            context: context,
                            builder: (context) => LogoutWarningDialog()),
                      },
                    ),
                    thinDivider,
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              Provider.of<UserModel>(context, listen: false).userInfo.username,
              style: TextStyle(color: kGray, fontSize: 22.0),
            ),
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}

class ClickableRow extends StatelessWidget {
  final Function onTap;
  final String text;
  ClickableRow({this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: kWhite,
        alignment: Alignment.centerLeft,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(14.0, 14.0, 0, 14.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20.0,
            color: kGray,
            fontFamily: 'Brandon_med',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class Heading extends StatelessWidget {
  final String title;
  Heading({this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            color: kGreen,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class NotificationSetting extends StatelessWidget {
  final String title;
  final bool isActive;
  final Function onToggle;
  NotificationSetting({
    @required this.title,
    @required this.isActive,
    @required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Switch(
          value: isActive,
          activeTrackColor: kGray,
          activeColor: kGreen,
          onChanged: (value) => onToggle(value),
        ),
        SizedBox(width: 8.0),
        Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            color: kGray,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class LogoutWarningDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(
          LocaleKeys.logout_title.tr(),
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        content: Text(
          LocaleKeys.logout_dialog_warning.tr(),
          style: TextStyle(fontSize: 24),
        ),
        actions: <Widget>[
          FlatButton(
              child: Text(LocaleKeys.dialog_btn_yes.tr(),
                  style: TextStyle(fontSize: 20)),
              onPressed: () {
                context
                    .read<EventsModel>()
                    .unsubscribeToPushNotifications(deviceId);
                context.read<AccountModel>().logout();
                Navigator.of(context).pop();
              }),
          FlatButton(
              child: Text(
                LocaleKeys.dialog_btn_cancel.tr(),
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ]);
  }
}
