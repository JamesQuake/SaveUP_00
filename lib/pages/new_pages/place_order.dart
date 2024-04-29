import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';

import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/pages/new_pages/thankyou.dart';

class PlaceOrder extends StatefulWidget {
  final String uid;
  const PlaceOrder({Key key, this.uid}) : super(key: key);

  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
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
          'Place Your Order',
          // style: TextStyle(fontSize: 7),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      endDrawer: MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          20.0,
          20.0,
          20.0,
          8.0,
        ),
        child: Column(
          children: [
            Spacer(),
            ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.resolveWith(
                    (states) => Size(double.infinity.h, 50)),
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
                          builder: (context) => ThankYou(
                                uid: widget.uid,
                              )));
                },
              ),
              child: Text(
                'Submit',
                style: TextStyle(
                  fontSize: 20.0.h,
                  color: Colors.white,
                ),
              ),
              // color: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
