import 'package:flutter/material.dart';
import 'package:qolsys_app/utils/font_styles.dart';

class PageTitleText extends StatelessWidget {
  final String title;
  PageTitleText({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      padding: EdgeInsets.all(4.0),
      child: Text(
        title,
        style: favorite_pages_title_style,
      ),
    );
  }
}
