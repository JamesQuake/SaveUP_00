import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DropDown extends StatefulWidget {
  final List dropDownItem;
  final String newHint;

  const DropDown({Key key, this.dropDownItem, this.newHint}) : super(key: key);

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String valueChoose;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton(
        isExpanded: true,
        dropdownColor: Color(0xfff2f2f2),
        focusColor: Color(0xfff2f2f2),
        hint: Text(
          widget.newHint,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        value: valueChoose,
        items: widget.dropDownItem.map((valueItem) {
          return DropdownMenuItem(
            value: valueItem,
            child: Text(
              valueItem,
              softWrap: true,
              style: TextStyle(
                fontSize: 15.0.h,
              ),
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            valueChoose = newValue;
          });
        },
      ),
    );
  }
}
