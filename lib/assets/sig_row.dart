import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SigRow extends StatelessWidget {
  final String firstRowText;
  final String assetName;
  final String secondRowText;

  final String newHintText;
  const SigRow({
    Key key,
    @required this.firstRowText,
    @required this.assetName,
    @required this.secondRowText,
    @required this.newHintText,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Text(
                firstRowText,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
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
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
