import 'package:flutter/material.dart';
import 'package:qolsys_app/constants/color_constants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PageViewWithIndicator extends StatefulWidget {
  PageViewWithIndicator({
    @required this.children,
    this.onPageChanged,
    this.initialIndex,
    this.childrenPadding = EdgeInsets.zero,
  });

  final List<Widget> children;
  final Function onPageChanged;
  final int initialIndex;
  final EdgeInsets childrenPadding;

  @override
  _PageViewWithIndicatorState createState() => _PageViewWithIndicatorState();
}

class _PageViewWithIndicatorState extends State<PageViewWithIndicator> {
  int activeIndex;

  @override
  void initState() {
    activeIndex = widget.initialIndex ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: widget.childrenPadding,
          child: PageView(
            controller: PageController(initialPage: activeIndex ?? 0),
            children: widget.children,
            scrollDirection: Axis.vertical,
            onPageChanged: (i) {
              setState(() {
                activeIndex = i;
              });
              if (widget.onPageChanged != null) widget.onPageChanged(i);
            },
          ),
        ),
        if (widget.children.length > 1)
          Align(
            alignment: Alignment.centerLeft,
            child: PageIndicator(
              activeIndex: activeIndex,
              count: widget.children.length,
            ),
          ),
      ],
    );
  }
}

class PageIndicator extends StatelessWidget {
  PageIndicator({@required this.activeIndex, @required this.count});

  final int activeIndex;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0),
      child: AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: count,
        effect: WormEffect(
          activeDotColor: kGray,
          dotColor: kLight2,
          dotHeight: 8.0,
          dotWidth: 8.0,
        ),
        axisDirection: Axis.vertical,
      ),
    );
  }
}
