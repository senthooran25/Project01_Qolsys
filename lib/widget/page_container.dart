import 'package:flutter/material.dart';
import 'package:qolsys_app/constants/color_constants.dart';

class PageContainer extends StatelessWidget {
  final Widget child;

  PageContainer({this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kWhite,
      margin: EdgeInsets.all(8.0),
      child: child,
    );
  }
}
