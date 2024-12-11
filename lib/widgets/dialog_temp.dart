import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';

class DialogTemp extends StatelessWidget {
  const DialogTemp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Image.asset('assets/images/gifs/cngrts.gif', height: 50.0),
      content: Text(
        "Congrats!. You are now an SaveUp premium user. We appreciate you 🫶🏽",
        textAlign: TextAlign.center,
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(35.0))),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('OK'),
        )
      ],
    );
  }
}
