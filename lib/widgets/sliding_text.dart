import 'package:flutter/material.dart';

class SlidingText extends StatefulWidget {
  final String word;
  final int interval;
  final bool isDelay;
  final int caller;

  SlidingText({this.word, this.interval, this.isDelay, this.caller});

  @override
  _SlidingTextState createState() => _SlidingTextState();
}

class _SlidingTextState extends State<SlidingText>
    with SingleTickerProviderStateMixin {
  AnimationController _animControllerSlideIn;
  Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _animControllerSlideIn = AnimationController(
        duration: Duration(milliseconds: widget.interval), vsync: this);

    _slideIn = Tween<Offset>(begin: Offset(1.1, 0), end: Offset(0, 0)).animate(
        CurvedAnimation(parent: _animControllerSlideIn, curve: Curves.easeOut));

    if (widget.isDelay) {
      Future.delayed(
          Duration(
            milliseconds: widget.caller == 0
                ? 500
                : widget.caller == 1
                    ? 600
                    : 700,
          ), () {
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
      child: Text(
        widget.word,
        style: TextStyle(
          color: Color(0xff0070c0),
          fontSize: 35,
          fontWeight: FontWeight.w400,
        ),
      ),
      position: _slideIn,
    );
  }
}
