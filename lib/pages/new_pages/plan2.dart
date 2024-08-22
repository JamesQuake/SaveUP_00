import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/pages/new_pages/overdraft_reminder.dart';
import 'package:pay_or_save/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import 'plan2.dart';

class Plan2 extends StatefulWidget {
  // const Plan1({ Key? key }) : super(key: key);

  @override
  _Plan2State createState() => _Plan2State();
}

class _Plan2State extends State<Plan2> {
  var formatter = NumberFormat('#,###,000');

  @override
  void initState() {
    Provider.of<AuthProvider>(context, listen: false).controllerTopRight =
        ConfettiController(duration: const Duration(seconds: 2));
    Provider.of<AuthProvider>(context, listen: false).controllerTopLeft =
        ConfettiController(duration: const Duration(seconds: 2));
    super.initState();
  }

  @override
  void dispose() {
    Provider.of<AuthProvider>(context, listen: false)
        .controllerTopRight
        .dispose();
    Provider.of<AuthProvider>(context, listen: false)
        .controllerTopLeft
        .dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, child) {
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
              "Buy Dollars",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 23.0,
              ),
            ),
            centerTitle: true,
          ),
          endDrawer: MainDrawer(),
          body: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: ConfettiWidget(
                  confettiController: provider.controllerTopRight,
                  blastDirection: 0,
                  maxBlastForce: 5, // set a lower max blast force
                  minBlastForce: 2, // set a lower min blast force
                  emissionFrequency: 0.05,
                  numberOfParticles: 30, // a lot of particles at once
                  gravity: 1,
                  minimumSize: Size(8, 8),
                  maximumSize: Size(18, 18),
                  blastDirectionality: BlastDirectionality.explosive,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: ConfettiWidget(
                  confettiController: provider.controllerTopRight,
                  blastDirection: 0.5,
                  maxBlastForce: 5, // set a lower max blast force
                  minBlastForce: 2, // set a lower min blast force
                  emissionFrequency: 0.05,
                  numberOfParticles: 30, // a lot of particles at once
                  gravity: 1,
                  minimumSize: Size(8, 8),
                  maximumSize: Size(18, 18),
                  blastDirectionality: BlastDirectionality.directional,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Plan 2: STOP Ads',
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
                            text: "STOP ADS ",
                            style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                          TextSpan(
                            text: "and receive ",
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          TextSpan(
                            text: "2 reward points ",
                            style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                          TextSpan(
                            text: "with every virtual dollar that you purchase",
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
                          decoration: BoxDecoration(
                            color: provider.selectedPlan == 1
                                ? Color(0xfffaeae9)
                                : null,
                          ),
                          children: [
                            TableRowInkWell(
                              onTap: () => provider.changeSelectedPlan(1),
                              child: Padding(
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
                            ),
                            TableRowInkWell(
                              onTap: () => provider.changeSelectedPlan(1),
                              child: Padding(
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
                            ),
                            TableRowInkWell(
                              onTap: () => provider.changeSelectedPlan(1),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Container(
                                  height: 35.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '\$${formatter.format(provider.checking + 500)}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TableRowInkWell(
                              onTap: () => provider.changeSelectedPlan(1),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Container(
                                  height: 35.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${formatter.format(provider.rewardPoints + (500*2))}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                            decoration: BoxDecoration(
                              color: provider.selectedPlan == 2
                                  ? Color(0xfffaeae9)
                                  : null,
                              border: Border(
                                top: BorderSide(
                                    width: 2, color: Colors.grey[400]),
                                // bottom: BorderSide(width: 2, color: Colors.grey[400]),
                              ),
                              // color: Colors.green,
                            ),
                            children: [
                              TableRowInkWell(
                                onTap: () => provider.changeSelectedPlan(2),
                                child: Container(
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
                              ),
                              TableRowInkWell(
                                onTap: () => provider.changeSelectedPlan(2),
                                child: Container(
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
                              ),
                              TableRowInkWell(
                                onTap: () => provider.changeSelectedPlan(2),
                                child: Container(
                                  height: 45.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '\$${formatter.format(provider.checking + 1000)}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              TableRowInkWell(
                                onTap: () => provider.changeSelectedPlan(2),
                                child: Container(
                                  height: 45.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${formatter.format(provider.rewardPoints + (1000*2))}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                              color: provider.selectedPlan == 3
                                  ? Color(0xfffaeae9)
                                  : null,
                              border: Border(
                                top: BorderSide(
                                    width: 2, color: Colors.grey[400]),
                                // bottom: BorderSide(width: 2, color: Colors.grey[300]),
                              ),
                              // color: Colors.green,
                            ),
                            children: [
                              TableRowInkWell(
                                onTap: () => provider.changeSelectedPlan(3),
                                child: Container(
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
                              ),
                              TableRowInkWell(
                                onTap: () => provider.changeSelectedPlan(3),
                                child: Container(
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
                              ),
                              TableRowInkWell(
                                onTap: () => provider.changeSelectedPlan(3),
                                child: Container(
                                  height: 45.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '\$${formatter.format(provider.checking + 2500)}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              TableRowInkWell(
                                onTap: () => provider.changeSelectedPlan(3),
                                child: Container(
                                  height: 45.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${formatter.format(provider.rewardPoints + (2500*2))}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                              color: provider.selectedPlan == 4
                                  ? Color(0xfffaeae9)
                                  : null,
                              border: Border(
                                top: BorderSide(
                                    width: 2, color: Colors.grey[400]),
                                // bottom: BorderSide(width: 2, color: Colors.grey[400]),
                              ),
                              // color: Colors.green,
                            ),
                            children: [
                              TableRowInkWell(
                                onTap: () => provider.changeSelectedPlan(4),
                                child: Container(
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
                              ),
                              TableRowInkWell(
                                onTap: () => provider.changeSelectedPlan(4),
                                child: Container(
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
                              ),
                              TableRowInkWell(
                                onTap: () => provider.changeSelectedPlan(4),
                                child: Container(
                                  height: 45.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '\$${formatter.format(provider.checking + 5000)}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              TableRowInkWell(
                                onTap: () => provider.changeSelectedPlan(4),
                                child: Container(
                                  height: 45.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${formatter.format(provider.rewardPoints + (5000*2))}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                              color: provider.selectedPlan == 5
                                  ? Color(0xfffaeae9)
                                  : null,
                              border: Border(
                                top: BorderSide(
                                    width: 2, color: Colors.grey[400]),
                                // bottom: BorderSide(width: 2, color: Colors.grey[400]),
                              ),
                              // color: Colors.green,
                            ),
                            children: [
                              TableRowInkWell(
                                onTap: () => provider.changeSelectedPlan(5),
                                child: Container(
                                  height: 45.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '\$7,500',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              TableRowInkWell(
                                onTap: () => provider.changeSelectedPlan(5),
                                child: Container(
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
                              ),
                              TableRowInkWell(
                                onTap: () => provider.changeSelectedPlan(5),
                                child: Container(
                                  height: 45.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '\$${formatter.format(provider.checking + 7500)}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              TableRowInkWell(
                                onTap: () => provider.changeSelectedPlan(5),
                                child: Container(
                                  height: 45.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${formatter.format(provider.rewardPoints + (7500*2))}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                        TableRow(
                            decoration: BoxDecoration(
                              color: provider.selectedPlan == 6
                                  ? Color(0xfffaeae9)
                                  : null,
                              border: Border(
                                top: BorderSide(
                                    width: 2, color: Colors.grey[400]),
                                // bottom: BorderSide(width: 2, color: Colors.grey[400]),
                              ),
                              // color: Colors.green,
                            ),
                            children: [
                              TableRowInkWell(
                                onTap: () => provider.changeSelectedPlan(6),
                                child: Container(
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
                              ),
                              TableRowInkWell(
                                onTap: () => provider.changeSelectedPlan(6),
                                child: Container(
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
                              ),
                              TableRowInkWell(
                                onTap: () => provider.changeSelectedPlan(6),
                                child: Container(
                                  height: 35.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '\$${formatter.format(provider.checking + 10000)}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              TableRowInkWell(
                                onTap: () => provider.changeSelectedPlan(6),
                                child: Container(
                                  height: 35.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${formatter.format(provider.rewardPoints + (10000*2))}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.bold,
                                    ),
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
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                (states) => Color(0xffcb0909),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
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
                                provider.purchasePlan(context);
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => OverdraftReminder(
                                //           // uid: widget.uid,
                                //         )));
                              },
                            ),
                            child: Container(
                              child: Text(
                                'Select Plan',
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
            ],
          ),
        );
      },
    );
  }
}
