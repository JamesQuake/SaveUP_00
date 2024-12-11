// import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';

class SlidingWidget extends StatefulWidget {
  final Widget widget;
  final int interval;
  final bool isDelay;
  const SlidingWidget({Key key, this.interval, this.isDelay, this.widget})
      : super(key: key);

  @override
  State<SlidingWidget> createState() => _SlidingWidgetState();
}

class _SlidingWidgetState extends State<SlidingWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animControllerSlideIn;
  Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _animControllerSlideIn = AnimationController(
        duration: Duration(milliseconds: widget.interval), vsync: this);

    _slideIn = Tween<Offset>(begin: Offset(-1.1, 0), end: Offset(0, 0)).animate(
        CurvedAnimation(parent: _animControllerSlideIn, curve: Curves.easeOut));

    if (widget.isDelay) {
      Future.delayed(Duration(milliseconds: 500), () {
        _animControllerSlideIn.forward();
      });
    }
  }

  @override
  void dispose() {
    _animControllerSlideIn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      child: widget.widget,
      position: _slideIn,
    );
  }
}
