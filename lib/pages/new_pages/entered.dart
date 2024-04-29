import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
// import 'package:pay_or_save/pages/new_pages/reward_points.dart';

class Entered extends StatefulWidget {
  // const Entered({ Key? key }) : super(key: key);

  @override
  _Entered createState() => _Entered();
}

class _Entered extends State<Entered> {
  // int amount = 100;
  // var _newAmount = '\$' + amount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Color(0xff0070c0),
        title: Text(
          'You are Entered to Win',
          style: TextStyle(
            fontSize: 23,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      endDrawer: MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: RichText(
                    // overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        height: 1.5,
                        fontSize: 18,
                      ),
                      children: [
                        TextSpan(
                          text: 'You are entered to win \n',
                          style: TextStyle(
                            fontSize: 19.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue,
                          ),
                        ),
                        TextSpan(
                          text: '\$75 Amazon Gift Card',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            // color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              width: 320.0,
              height: 220.0,
              decoration: BoxDecoration(
                color: Color(0xff3790ce),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(9.0),
              ),
              child: Align(
                  alignment: Alignment.center,
                  child: Image.asset('assets/images/amazon.jpg')),
              // color: Color(0xff3790ce),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              child: RichText(
                textAlign: TextAlign.center,
                // overflow: TextOverflow.visible,
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    height: 1.5,
                    fontSize: 18,
                  ),
                  children: [
                    TextSpan(
                      text: 'Drawing Date: ',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    TextSpan(
                      text: ' Sept 16, 2021',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: Container(
                child: Text(
                  'Drawings are held weekly. Winner(s) will be notified by email.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.resolveWith(
                      (states) => Size(double.infinity, 50)),
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => Color(0xff0070c0),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  overlayColor: MaterialStateProperty.resolveWith(
                    (states) {
                      return states.contains(MaterialState.pressed)
                          ? Colors.blue
                          : null;
                    },
                  ),
                ),
                onPressed: () => Timer(
                  const Duration(milliseconds: 400),
                  () {
                    // navigateToSetSavingGoals(context);
                  },
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                // color: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
