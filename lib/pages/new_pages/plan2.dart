import 'package:flutter/material.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'dart:async';

import 'overdraft_reminder.dart';

class Plan2 extends StatefulWidget {
  // const Plan2({ Key? key }) : super(key: key);

  @override
  _Plan2State createState() => _Plan2State();
}

class _Plan2State extends State<Plan2> {
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
        padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
        child: Column(
          children: [
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
                  onTap: () {},
                  child: Icon(
                    Icons.arrow_back_ios_new_outlined,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                ),
                // IconButton(
                //   onPressed: () {},
                //   icon: Icon(
                //     Icons.arrow_back_ios_new_outlined,
                //   ),
                // ),
                // IconButton(
                //   onPressed: () {},
                //   icon: Icon(
                //     Icons.arrow_forward_ios_outlined,
                //   ),
                // ),
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
            SizedBox(
              height: 15.0,
            ),
            Table(
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
                        padding:
                            EdgeInsets.only(right: 5.0, top: 5.0, bottom: 2.0),
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
                        padding:
                            EdgeInsets.only(right: 5.0, top: 5.0, bottom: 3.0),
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
                        padding:
                            EdgeInsets.only(right: 5.0, top: 5.0, bottom: 2.0),
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
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 2.5,
                        right: 2.5,
                      ),
                      child: Container(
                        padding:
                            EdgeInsets.only(right: 5.0, top: 5.0, bottom: 2.0),
                        height: 85,
                        color: Color(0xfff0f0f0),
                        child: Text(
                          'My New Reward Point Balance',
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
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                        height: 35.0,
                        alignment: Alignment.center,
                        child: Text(
                          '\$500',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                        height: 35.0,
                        alignment: Alignment.center,
                        child: Text(
                          '\$1.75',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                        height: 35.0,
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
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                        height: 35.0,
                        alignment: Alignment.center,
                        child: Text(
                          '1,975',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Divider(
            //   color: Colors.black,
            //   thickness: 0.4,
            // ),
            Table(
              children: [
                TableRow(
                    decoration: BoxDecoration(
                      // color: Color(0xfffaeae9),
                      border: Border(
                        top: BorderSide(width: 2, color: Colors.grey[400]),
                        // bottom: BorderSide(width: 2, color: Colors.grey[400]),
                      ),
                      // color: Colors.green,
                    ),
                    children: [
                      Container(
                        height: 45.0,
                        alignment: Alignment.center,
                        child: Text(
                          '\$1,000',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        height: 45.0,
                        alignment: Alignment.center,
                        child: Text(
                          '\$3.25',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        height: 45.0,
                        alignment: Alignment.center,
                        child: Text(
                          '\$2,475',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        height: 45.0,
                        alignment: Alignment.center,
                        child: Text(
                          '2,975',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]),
              ],
            ),
            // Divider(
            //   color: Colors.black,
            //   thickness: 0.4,
            // ),
            Table(
              children: [
                TableRow(
                    decoration: BoxDecoration(
                      // color: Color(0xfffaeae9),
                      border: Border(
                        top: BorderSide(width: 2, color: Colors.grey[400]),
                        // bottom: BorderSide(width: 2, color: Colors.grey[300]),
                      ),
                      // color: Colors.green,
                    ),
                    children: [
                      Container(
                        height: 45.0,
                        alignment: Alignment.center,
                        child: Text(
                          '\$2,500',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        height: 45.0,
                        alignment: Alignment.center,
                        child: Text(
                          '\$7.50',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        height: 45.0,
                        alignment: Alignment.center,
                        child: Text(
                          '\$4,975',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        height: 45.0,
                        alignment: Alignment.center,
                        child: Text(
                          '5,475',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]),
              ],
            ),
            // Divider(
            //   color: Colors.black,
            //   thickness: 0.4,
            // ),
            Table(
              children: [
                TableRow(
                    decoration: BoxDecoration(
                      color: Color(0xfffaeae9),
                      border: Border(
                        top: BorderSide(width: 2, color: Colors.grey[400]),
                        bottom: BorderSide(width: 2, color: Colors.grey[400]),
                      ),
                      // color: Colors.green,
                    ),
                    children: [
                      Container(
                        height: 45.0,
                        alignment: Alignment.center,
                        child: Text(
                          '\$5,000',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        height: 45.0,
                        alignment: Alignment.center,
                        child: Text(
                          '\$14.25',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        height: 45.0,
                        alignment: Alignment.center,
                        child: Text(
                          '\$5,475',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        height: 45.0,
                        alignment: Alignment.center,
                        child: Text(
                          '10,975',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]),
              ],
            ),
            // Divider(
            //   color: Colors.black,
            //   thickness: 0.4,
            // ),
            Table(
              children: [
                TableRow(
                    decoration: BoxDecoration(
                      // color: Color(0xfffaeae9),
                      border: Border(
                        // top: BorderSide(width: 2, color: Colors.grey[400]),
                        bottom: BorderSide(width: 2, color: Colors.grey[400]),
                      ),
                      // color: Colors.green,
                    ),
                    children: [
                      Container(
                        height: 45.0,
                        alignment: Alignment.center,
                        child: Text(
                          '\$7,000',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        height: 45.0,
                        alignment: Alignment.center,
                        child: Text(
                          '\$19.75',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        height: 45.0,
                        alignment: Alignment.center,
                        child: Text(
                          '\$7,975',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        height: 45.0,
                        alignment: Alignment.center,
                        child: Text(
                          '15,975',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]),
              ],
            ),
            // Divider(
            //   color: Colors.black,
            //   thickness: 0.4,
            // ),
            Table(
              children: [
                TableRow(children: [
                  Container(
                    height: 35.0,
                    alignment: Alignment.center,
                    child: Text(
                      '\$10,000',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    height: 35.0,
                    alignment: Alignment.center,
                    child: Text(
                      '\$26.75',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    height: 35.0,
                    alignment: Alignment.center,
                    child: Text(
                      '\$10,475',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    height: 35.0,
                    alignment: Alignment.center,
                    child: Text(
                      '20,975',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]),
              ],
            ),
            Divider(
              color: Colors.black,
              thickness: 0.4,
            ),
            SizedBox(
              height: 8.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Scroll over chart to select the option you want',
                // textAlign: TextAlign.left,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 15.0,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Use your reward points to qualify for cool prizes like Amazon gift cards',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox.fromSize(
                  size: Size(
                    130.0,
                    53.0,
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => Color(0xffcb0909),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OverdraftReminder(
                                    // uid: widget.uid,
                                    )));
                      },
                    ),
                    child: Container(
                      child: Text(
                        'Select\nThis Plan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                // _validateInputs();
                // navigateToSetInvestmentGoals(context);
                SizedBox.fromSize(
                  size: Size(
                    130.0,
                    53.0,
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => Color(0xffe79088),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      overlayColor: MaterialStateProperty.resolveWith(
                        (states) {
                          return states.contains(MaterialState.pressed)
                              ? Color(0xffcb0909)
                              : null;
                        },
                      ),
                    ),
                    onPressed: () => Timer(
                      const Duration(milliseconds: 400),
                      () {},
                    ),
                    child: Container(
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
