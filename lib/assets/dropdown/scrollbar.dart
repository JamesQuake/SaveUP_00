import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const double _kScrollbarThickness = 12.0;

class MyScrollbar extends StatefulWidget {
  final ScrollableWidgetBuilder builder;
  final ScrollController scrollController;
  final bool dispBar;

  const MyScrollbar({
    Key key,
    this.scrollController,
    @required this.builder,
    this.dispBar,
  })  : assert(builder != null),
        super(key: key);

  @override
  _MyScrollbarState createState() => _MyScrollbarState();
}

class _MyScrollbarState extends State<MyScrollbar> {
  ScrollbarPainter _scrollbarPainter;
  ScrollController _scrollController;
  Orientation _orientation;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateScrollPainter(_scrollController.position);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollbarPainter = _buildMaterialScrollbarPainter();
  }

  @override
  void dispose() {
    _scrollbarPainter.dispose();
    super.dispose();
  }

  ScrollbarPainter _buildMaterialScrollbarPainter() {
    return ScrollbarPainter(
      color: Color(0xff0070c0),
      textDirection: Directionality.of(context),
      thickness: _kScrollbarThickness,
      radius: Radius.circular(20),
      fadeoutOpacityAnimation: const AlwaysStoppedAnimation<double>(1.0),
      padding: EdgeInsets.only(top: 15, right: 15, bottom: 5, left: 5),
    );
  }

  bool _updateScrollPainter(ScrollMetrics position) {
    _scrollbarPainter.update(
      position,
      position.axisDirection,
    );
    return false;
  }

  @override
  void didUpdateWidget(MyScrollbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateScrollPainter(_scrollController.position);
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        _orientation ??= orientation;
        if (orientation != _orientation) {
          _orientation = orientation;
          _updateScrollPainter(_scrollController.position);
        }
        return NotificationListener<ScrollNotification>(
          onNotification: (notification) =>
              _updateScrollPainter(notification.metrics),
          child: CustomPaint(
            painter: widget.dispBar == null ? _scrollbarPainter : null,
            child: widget.builder(context, _scrollController),
          ),
        );
      },
    );
  }
}
