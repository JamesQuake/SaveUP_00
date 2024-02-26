import 'package:flutter/material.dart';

class MainServices {
  static Future onLoading(context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 200,
            height: 100,
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                ),
                new CircularProgressIndicator(
                  color: Color(0xff0070c0),
                ),
                SizedBox(
                  width: 20,
                ),
                new Text("Loading"),
              ],
            ),
          ),
        );
      },
    );
  }
}
