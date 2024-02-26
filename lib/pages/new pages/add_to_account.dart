import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/pages/new%20pages/plan1.dart';
import 'package:pay_or_save/pages/new%20pages/plan2.dart';

class AddToAccount extends StatefulWidget {
  // const AddToAccount({ Key? key }) : super(key: key);

  @override
  _AddToAccountState createState() => _AddToAccountState();
}

class _AddToAccountState extends State<AddToAccount> {
  bool test = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Color(0xffcb0909),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // actions: <Widget>[
        //   MyManue.childPopup(context)
        // ],
        title: Text(
          "Add To Your Accounts",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 23.0,
          ),
        ),
        centerTitle: true,
      ),
      endDrawer: MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 10.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'FREE with ADS',
                // textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xffcb0909),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Divider(
              color: Colors.black,
              thickness: 0.4,
            ),
            SizedBox(
              height: 7.0,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0.0, 50.0, 10.0),
              child: Table(
                children: [
                  TableRow(
                    // decoration: BoxDecoration(border: BoxBorder()),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 2.5,
                          right: 2.5,
                        ),
                        child: Container(
                          padding: EdgeInsets.only(
                              right: 5.0, top: 5.0, bottom: 2.0),
                          height: 85,
                          color: Color(0xfff0f0f0),
                          child: Text(
                            'Add \$\$ to My Virtual Checking Account',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              height: 1.3,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 2.5,
                          right: 2.5,
                        ),
                        child: Container(
                          padding: EdgeInsets.only(
                              right: 5.0, top: 5.0, bottom: 3.0),
                          height: 85,
                          color: Color(0xfff0f0f0),
                          child: Text(
                            'My Cost',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 2.5,
                          right: 2.5,
                        ),
                        child: Container(
                          padding: EdgeInsets.only(
                              right: 5.0, top: 5.0, bottom: 2.0),
                          height: 85,
                          color: Color(0xfff0f0f0),
                          child: Text(
                            'My New Checking Account Balance',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              height: 1.3,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Container(
                        height: 40.0,
                        alignment: Alignment.center,
                        child: Text(
                          '\$500',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        height: 40.0,
                        alignment: Alignment.center,
                        child: Text(
                          'Free',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        height: 40.0,
                        alignment: Alignment.center,
                        child: Text(
                          '\$475',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    decoration: BoxDecoration(
                      color: Color(0xfffaeae9),
                      border: Border(
                        top: BorderSide(width: 2, color: Colors.grey[400]),
                        bottom: BorderSide(width: 2, color: Colors.grey[300]),
                      ),
                      // color: Colors.green,
                    ),
                    children: [
                      Container(
                        height: 47.0,
                        alignment: Alignment.center,
                        child: Text(
                          '\$1000',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 47.0,
                        child: Text(
                          'Free',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 47.0,
                        child: Text(
                          '\$475',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[450],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 50.0, right: 50.0, bottom: 15.0),
              child: Text(
                'Scroll over chart to select the option you want',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 15.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50.0),
              child: TextButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.resolveWith(
                      (states) => Size(double.infinity, 46)),
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => Color(0xffcb0909),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.5),
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
                  () {},
                ),
                child: Text(
                  'Select This Plan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 35.0,
            ),
            Row(
              children: [
                Text(
                  'PLAN 1: AD FREE',
                  // textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xffcb0909),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Plan1(
                                // uid: widget.uid,
                                )));
                  },
                  child: Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.black,
              thickness: 0.4,
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  height: 1.3,
                  fontSize: 17,
                ),
                children: [
                  TextSpan(
                    text: "Eliminate ads ",
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "and ",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  TextSpan(
                    text: "get 1 reward point ",
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "with every virtual dollar that you purchase.",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                Text(
                  'PLAN 2: AD FREE',
                  // textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xffcb0909),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Plan2(
                                // uid: widget.uid,
                                )));
                  },
                  child: Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.black,
              thickness: 0.4,
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  height: 1.3,
                  fontSize: 17,
                ),
                children: [
                  TextSpan(
                    text: "Eliminate ads ",
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "and ",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  TextSpan(
                    text: "get 2 reward point ",
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "with every virtual dollar that you purchase.",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
