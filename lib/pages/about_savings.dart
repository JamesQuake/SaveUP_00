import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pay_or_save/assets/custom_button.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:flutter/cupertino.dart';
// import 'package:pay_or_save/pages/saving_goals.dart';

class AboutSavings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
        backgroundColor: Color(0xff0070c0),
        title: Text(
          'Setting Savings Goals',
          style: TextStyle(
            fontSize: 20.0.h,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      endDrawer: MainDrawer(),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          15.0.w,
          15.0.h,
          15.0.w,
          0.0.h,
        ),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 13.0.h,
                ),
                Row(
                  children: [
                    Flexible(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Saving and investing are both crucial to your financial health, but they are not the same.',
                          maxLines: 4,
                          style: TextStyle(height: 1.4, fontSize: 18.h),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0.h,
                ),
                Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Savings',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0070c0),
                        fontSize: 20.0.h,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0.h,
                ),
                Container(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                          color: Colors.black, height: 1.4, fontSize: 18.h),
                      children: [
                        TextSpan(text: 'When you save, you put money in a '),
                        TextSpan(
                          text: 'safe ',
                          style: TextStyle(
                            height: 1.4,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                            text:
                                'place – like a savings account or CD – where you can easily access it for future use.'),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0.h,
                ),
                Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Savings Goals',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0070c0),
                        fontSize: 20.0.h,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0.h,
                ),
                Container(
                  child: Text(
                    "Most people typically save for things like a computer, vacation, or a down payment -- things they'd like to purchase within the next few months or years.",
                    style: TextStyle(height: 1.4, fontSize: 18.h),
                  ),
                ),
                SizedBox(
                  height: 15.0.h,
                ),
                Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Saving Rewards',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0070c0),
                        fontSize: 20.0.h,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0.h,
                ),
                Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Savings are safe, but they don't earn much interest.",
                      style: TextStyle(height: 1.4, fontSize: 18.h),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0.h,
                ),
                Container(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                          color: Colors.black, height: 1.5, fontSize: 18.h),
                      children: [
                        TextSpan(
                          text:
                              'For more information on saving, investing, and achieving your long-term financial goals, read ',
                          style: TextStyle(
                            height: 1.4,
                          ),
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = () {},
                          text: 'The \$500 Cup of Coffee, ',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            height: 1.4,
                            color: Colors.blue,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        TextSpan(
                          text: 'co-authored by Steven Lome, the developer of ',
                          style: TextStyle(
                            height: 1.4,
                          ),
                        ),
                        TextSpan(
                          text: 'Pay or Save.',
                          recognizer: TapGestureRecognizer()..onTap = () {},
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            height: 1.4,
                            color: Colors.blue,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.0.h,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.resolveWith(
                        (states) => Size(double.infinity, 50.w)),
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
                      Navigator.popAndPushNamed(context, '/saving');
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
