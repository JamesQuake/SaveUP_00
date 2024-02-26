import 'package:flutter/material.dart';

class PosAlert extends StatelessWidget {
  const PosAlert({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '•',
            style: TextStyle(
              fontSize: 45.0,
              height: 1.2,
              color: Color(0xff0070c0),
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                'You can only save and undo once.',
                style: TextStyle(
                  fontSize: 19.0,
                  color: Color(0xff0070c0),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text(
            "OK",
            style: TextStyle(
              color: Color(0xff0070c0),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    // show the dialog
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return alert;
    //   },
    // );
  }
}
