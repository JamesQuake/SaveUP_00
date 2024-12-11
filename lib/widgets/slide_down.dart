import 'package:flutter/material.dart';

class SlideDown extends StatefulWidget {
  final Widget widget;
  final int interval;
  final bool isDelay;
  const SlideDown({Key key, this.widget, this.interval, this.isDelay})
      : super(key: key);

  @override
  State<SlideDown> createState() => _SlideDownState();
}

class _SlideDownState extends State<SlideDown>
    with SingleTickerProviderStateMixin {
  AnimationController _animControllerSlideIn;
  Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _animControllerSlideIn = AnimationController(
        duration: Duration(milliseconds: widget.interval), vsync: this);

    _slideIn = Tween<Offset>(begin: Offset(0, -3.0), end: Offset(0, 0)).animate(
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
