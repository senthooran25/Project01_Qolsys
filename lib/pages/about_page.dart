import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:qolsys_app/constants/color_constants.dart';
import 'package:qolsys_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:qolsys_app/widget/page_container.dart';
import 'package:qolsys_app/widget/page_title_text.dart';

class AboutPage extends StatelessWidget {
  static const String id = 'about_page';

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      child: Column(
        children: [
          PageTitleText(title: LocaleKeys.about.tr()),
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    final packageInfo = snapshot.data;
                    return Column(
                      children: [
                        InfoTile(
                          title: LocaleKeys.appVersion.tr(),
                          subtitle:
                              packageInfo != null ? packageInfo.version : '',
                        ),
                        InfoTile(
                          title: LocaleKeys.buildNumber.tr(),
                          subtitle: packageInfo != null
                              ? packageInfo.buildNumber
                              : '',
                        ),
                        InfoTile(
                          title: LocaleKeys.language.tr(),
                          subtitle: context.locale.languageCode,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: LanguageDropDown(
                              language: context.locale.languageCode,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LanguageDropDown extends StatefulWidget {
  final String language;
  LanguageDropDown({@required this.language});
  @override
  _LanguageDropDownState createState() => _LanguageDropDownState();
}

class _LanguageDropDownState extends State<LanguageDropDown> {
  var selectedValue;
  @override
  void initState() {
    selectedValue = widget.language;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: selectedValue,
      items: [
        for (Locale loc in context.supportedLocales)
          DropdownMenuItem(
            value: loc.languageCode,
            child: Text(
              loc.languageCode,
              style: TextStyle(
                fontSize: 28.0,
                color: kGray,
              ),
            ),
          ),
      ],
      onChanged: (value) {
        setState(() {
          selectedValue = value;
        });
        context.locale = Locale(value);
      },
    );
  }
}

class InfoTile extends StatelessWidget {
  final String title;
  final String subtitle;
  InfoTile({this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 25.0,
              color: kGray,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            subtitle ?? '',
            style: TextStyle(
              fontSize: 20.0,
              color: kGray,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
