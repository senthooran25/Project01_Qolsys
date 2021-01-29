import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qolsys_app/constants/color_constants.dart';
import 'package:qolsys_app/constants/svg_constants.dart';
import 'package:qolsys_app/providers/page_model.dart';
import 'package:qolsys_app/utils/font_styles.dart';
import 'package:qolsys_app/widget/page_view_with_indicator.dart';
import 'package:qolsys_app/widget/scaled_image.dart';

class FavoritesBaseCard extends StatefulWidget {
  final String cardTitle;
  final Widget body;
  final String pageId;
  final List<Widget> children;
  final EdgeInsets padding;

  FavoritesBaseCard({
    this.cardTitle,
    this.body,
    this.pageId,
    this.children,
    this.padding = const EdgeInsets.only(top: 20),
  }) : assert(body == null || children == null,
            'Cannot supply both a body and children');

  @override
  _FavoritesBaseCardState createState() => _FavoritesBaseCardState();
}

class _FavoritesBaseCardState extends State<FavoritesBaseCard> {
  int activeIndex = 0;

  setIndex(int index) {
    setState(() {
      activeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      color: kWhite,
      child: AspectRatio(
        aspectRatio: 3 / 2,
        child: Stack(
          children: [
            if (widget.body != null)
              Center(child: widget.body)
            else
              PageViewWithIndicator(
                children: widget.children,
                onPageChanged: setIndex,
                childrenPadding: widget.padding,
              ),
            Row(
              children: [
                Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TitleText(title: widget.cardTitle),
                    PageArrow(pageId: widget.pageId)
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PageArrow extends StatelessWidget {
  PageArrow({
    @required this.pageId,
  });

  final String pageId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<PageModel>().currentPage = pageId,
      child: Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: ScaledImage(
          svgAsset: ICON_JUMP_ARROW,
          height: 40.0,
        ),
      ),
    );
  }
}

class TitleText extends StatelessWidget {
  TitleText({
    @required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        title,
        style: favorite_pages_title_style,
      ),
    );
  }
}

List<Widget> splitChildren({
  int countPerPage,
  Widget Function(Object) rowWidgetFunction,
  List rowData,
}) {
  return [
    for (int i = 0; i < rowData.length; i = i + countPerPage)
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (int j = i; j < i + countPerPage && j < rowData.length; j++)
            rowWidgetFunction(rowData[j]),
          if (i > rowData.length - countPerPage) Spacer(),
        ],
      ),
  ];
}
