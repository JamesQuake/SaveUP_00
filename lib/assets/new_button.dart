import 'dart:async';

import 'package:flutter/material.dart';

class ButtonNew extends StatelessWidget {
  final String newText;
  final String routeName;
  final double width;
  final double height;
  final int customColor;
  final void function;

  const ButtonNew({
    Key key,
    this.newText,
    this.routeName,
    this.width,
    this.height,
    this.customColor,
    this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size(
        width,
        60.0,
      ),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith(
            (states) => Color(customColor),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          overlayColor: MaterialStateProperty.resolveWith(
            (states) {
              return states.contains(MaterialState.pressed)
                  ? Colors.blue
                  : null;
            },
          ),
        ),
        onPressed: () => Timer(
          const Duration(milliseconds: 400),
          () {
            Navigator.pushNamed(context, routeName);
          },
        ),
        child: Container(
          child: Text(
            newText,
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
