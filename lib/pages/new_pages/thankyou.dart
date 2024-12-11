import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';

import 'package:pay_or_save/assets/main_drawer.dart';

import '../select_mode.dart';

class ThankYou extends StatelessWidget {
  // const ThankYou({ Key? key }) : super(key: key);
  final String uid;

  const ThankYou({Key key, this.uid}) : super(key: key);

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
          'Thank You',
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      endDrawer: MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thank you for your payment \$7.50',
              style: TextStyle(
                fontSize: 17.0.h,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 18.0.h,
            ),
            Text(
              'We appreciate the opportuinity to help you achieve your financial goals',
              style: TextStyle(
                fontSize: 17.0.h,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 18.0.h,
            ),
            Text(
              'Check your email for receipt',
              style: TextStyle(
                fontSize: 17.0.h,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(20.0),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectMode(
                                  uid: uid,
                                )));
                  },
                ),
                child: Text(
                  'Return',
                  style: TextStyle(
                    fontSize: 20.0.h,
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
