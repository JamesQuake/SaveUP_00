import 'package:flutter/material.dart';

showAlertDialog(BuildContext context) {
  Widget okButton = TextButton(
    child: Text(
      "OK",
      style: TextStyle(
        color: Color(0xff0070c0),
      ),
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text(
      "Help",
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 15.0,
      ),
    ),
    content: Text(
      "Some Explanatory Text Goes Here.",
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 15.0,
      ),
    ),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
