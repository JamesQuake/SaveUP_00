import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String newText;
  final String routeName;
  final double width;
  final String pp;
  final Widget widget;

  const CustomButton({
    Key key,
    this.newText,
    this.routeName,
    @required this.width,
    this.pp,
    this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: ElevatedButton(
          style: ButtonStyle(
            minimumSize:
                MaterialStateProperty.resolveWith((states) => Size(width, 50)),
            backgroundColor: MaterialStateProperty.resolveWith(
              (states) => Color(0xff0070c0),
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
              if (pp == 'true') {
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => widget,
                  ),
                );
              } else {
                Navigator.pushNamed(context, routeName);
              }
            },
          ),
          child: Text(
            newText,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
          // color: Colors.transparent,
        ),
      ),
    );
  }
}
