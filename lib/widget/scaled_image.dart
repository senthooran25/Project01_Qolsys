import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qolsys_app/constants/integer_constants.dart';

class ScaledImage extends StatelessWidget {
  final String svgAsset;
  final String pngAsset;

  final double height;
  final double width;
  final Color color;

  ScaledImage({
    this.svgAsset,
    this.pngAsset,
    this.height,
    this.width,
    this.color,
  })  : assert(svgAsset != null || pngAsset != null,
            'Must provide either an svg or png asset'),
        assert(svgAsset == null || pngAsset == null,
            'Cannot provide both an svg and png asset');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double scaleFactor = 1.0;
    if (size.width < phoneSmallWidth)
      scaleFactor = 3 / 4;
    else if (size.width < phoneMediumWidth)
      scaleFactor = 5 / 6;
    else if (size.width < phoneLargeWidth)
      scaleFactor = 1.0;
    else if (size.width < tabletSmallWidth)
      scaleFactor = 6 / 5;
    else if (size.width >= tabletSmallWidth) scaleFactor = 5 / 3;

    return svgAsset != null
        ? SvgPicture.asset(
            svgAsset,
            height: height == null ? null : height * scaleFactor,
            width: width == null ? null : width * scaleFactor,
            color: color,
          )
        : Image.asset(
            pngAsset,
            height: height == null ? null : height * scaleFactor,
            width: width == null ? null : width * scaleFactor,
            color: color,
          );
  }
}
