import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qolsys_app/constants/color_constants.dart';

class CircularIndicator extends StatelessWidget {
  final double maxSideLength;
  CircularIndicator({this.maxSideLength = 80.0});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final side =
          min(maxSideLength, min(constraints.maxHeight, constraints.maxWidth));
      return Container(
        width: side,
        height: side,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(side / 2),
          color: Colors.transparent.withOpacity(0.5),
        ),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kGreen),
          ),
        ),
      );
    });
  }
}
