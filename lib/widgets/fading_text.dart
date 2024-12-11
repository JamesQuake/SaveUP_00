import 'package:flutter/material.dart';
import 'package:pay_or_save/providers/info_provider.dart';
import 'package:provider/provider.dart';

class FadingText extends StatefulWidget {
  final String text;
  final Color color;

  const FadingText({this.text, this.color});

  @override
  _FadingTextState createState() => _FadingTextState();
}

class _FadingTextState extends State<FadingText>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return FadeTransition(
      opacity: _opacityAnimation,
      alwaysIncludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.only(top: 66.0),
        child: Text(
          widget.text,
          style: TextStyle(
            color: widget.color ?? Color(0xff0070c0),
            fontSize: 80,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
    // return AnimatedOpacity(
    //   duration: Duration(seconds: 1),
    //   curve: Curves.easeInOut,
    //   opacity: _opacityAnimation.value,
    // child: Padding(
    //   padding: const EdgeInsets.only(top: 66.0),
    //   child: Text(
    //     widget.text,
    //     style: TextStyle(
    //       color: widget.color ?? Color(0xff0070c0),
    //       fontSize: 80,
    //       fontWeight: FontWeight.w400,
    //     ),
    //   ),
    // ),
    // );
  }
}
