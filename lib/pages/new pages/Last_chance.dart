import 'package:flutter/material.dart';
import 'dart:async';

import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/pages/new%20pages/see_you.dart';

class LastChance extends StatefulWidget {
  // const LastChance({ Key? key }) : super(key: key);

  @override
  _LastChanceState createState() => _LastChanceState();
}

class _LastChanceState extends State<LastChance> {
  String _selected = 'first';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffcb0909),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // actions: <Widget>[
        //   MyManue.childPopup(context)
        // ],
        title: Text(
          "Last Chance",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 23.0,
          ),
        ),
        centerTitle: true,
      ),
      endDrawer: MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25.0, 40.0, 25.0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Radio(
                activeColor: Color(0xffcb0909),
                value: 'first',
                groupValue: _selected,
                onChanged: (value) {
                  setState(() {
                    _selected = value;
                  });
                },
              ),
              title: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    height: 1.5,
                    fontSize: 17,
                  ),
                  children: [
                    TextSpan(
                      text: "Yes, ",
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: "i'd like to add ",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    TextSpan(
                      text: "FREE MONEY ",
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: "to my virtual account so that i continue shopping",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ListTile(
              leading: Radio(
                activeColor: Color(0xffcb0909),
                value: 'second',
                groupValue: _selected,
                onChanged: (value) {
                  setState(() {
                    _selected = value;
                  });
                },
              ),
              title: Text(
                "I'll continue shopping at a later time.",
                style: TextStyle(fontSize: 17.0),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
              child: TextButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.resolveWith(
                      (states) => Size(double.infinity, 50)),
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => Color(0xffcb0909),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  overlayColor: MaterialStateProperty.resolveWith(
                    (states) {
                      return states.contains(MaterialState.pressed)
                          ? Colors.red
                          : null;
                    },
                  ),
                ),
                onPressed: () => Timer(
                  const Duration(milliseconds: 400),
                  () {
                    if (_selected == 'second') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SeeYou(
                                  // uid: widget.uid,
                                  )));
                    } else if (_selected == 'first') {
                      // Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => Plan2(
                      //               // uid: widget.uid,
                      //               )));
                    }
                  },
                ),
                child: Text(
                  'Next',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
