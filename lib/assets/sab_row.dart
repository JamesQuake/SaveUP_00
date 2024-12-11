import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SabRow extends StatelessWidget {
  final String assetName;
  final String secondRowText;

  final String newHintText;
  const SabRow({
    Key key,
    @required this.assetName,
    @required this.secondRowText,
    @required this.newHintText,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20.0,
        ),
        Container(
          child: CircleAvatar(
            backgroundImage: AssetImage(assetName),
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Container(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              secondRowText,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        Spacer(),
        Container(
          width: 60.0,
          child: Text(
            newHintText,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
