import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/pages/saving_goals.dart';
import 'package:url_launcher/url_launcher.dart';

class SetGoalInfo extends StatefulWidget {
  final String uid;
  const SetGoalInfo({Key key, this.uid}) : super(key: key);

  @override
  State<SetGoalInfo> createState() => _SetGoalInfoState();
}

class _SetGoalInfoState extends State<SetGoalInfo> {
  bool showMore = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // endDrawer: MainDrawer(uid: widget.uid),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.0.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/Headers/SetGoals.png",
                  width: 300.w,
                ),
                SizedBox(width: 5.0.w),
                // Builder(
                //   builder: (context) => IconButton(
                //     padding: EdgeInsets.only(right: 0.0),
                //     color: Colors.black,
                //     icon: Icon(
                //       Icons.dehaze,
                //       size: 40.h,
                //     ),
                //     onPressed: () => Scaffold.of(context).openEndDrawer(),
                //     tooltip:
                //         MaterialLocalizations.of(context).openAppDrawerTooltip,
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 30.0.h),
            Padding(
              padding: const EdgeInsets.fromLTRB(18.0, 5.0, 25.0, 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Before you shop, you must set at least one savings and one investment goal.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0.h,
                    ),
                  ),
                  SizedBox(height: 15.0.h),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        height: 1.3,
                        fontSize: 16.h,
                      ),
                      children: [
                        TextSpan(
                          text:
                              "Savings and investing will both help you reach your financial goal, but they are not the same. The two biggest differences are risks and saving goals. ",
                          style: TextStyle(
                            height: 1.4,
                          ),
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              setState(() {
                                showMore = true;
                              });
                            },
                          text: showMore == false ? "(more)" : "",
                          style: TextStyle(
                            // decoration: TextDecoration.underline,
                            height: 1.4,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (showMore == true) ...[
                    SizedBox(height: 10.0.h),
                    Text(
                      "Savings typically earn low returns, but there's virtually no risk. Most people save to reach relatively short-term goals like paying for a vacation or a down payment on a car or home.",
                      style: TextStyle(fontSize: 16.0.h),
                    ),
                    SizedBox(height: 10.0.h),
                    Text(
                        "Investments typically earn higher returns, but involve greater risk because investment vehicles like stocks, bonds and real estate go up and down in value. Most people invest with the expectations of building wealth through higher returns over time",
                        style: TextStyle(fontSize: 16.0.h)),
                    SizedBox(height: 10.0.h),
                    Text(
                      "For More Information",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0.h,
                      ),
                    ),
                    SizedBox(height: 10.0.h),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          height: 1.5,
                          fontSize: 16.h,
                        ),
                        children: [
                          TextSpan(
                            text:
                                'For more information on saving, investing, and achieving your long-term financial goals, read ',
                            style: TextStyle(
                              height: 1.4,
                            ),
                          ),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // _launchUrl();
                                launch(
                                    "https://www.amazon.com/500-Cup-Coffee-Lifestyle-Independence-ebook/dp/B01ETYC3PW/ref=sr_1_6?crid=3GLRJ9JN6MGDB&keywords=500+cup+of+coffee&qid=1643138839&sprefix=500+cup+of+coffee%2Caps%2C67&sr=8-6");
                              },
                            text: 'The \$500 Cup of Coffee, ',
                            style: TextStyle(
                              // decoration: TextDecoration.underline,
                              height: 1.4,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text:
                                'co-authored by Steven Lome, the creator of this app.',
                            style: TextStyle(
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 15.0, left: 45.0, right: 45.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.resolveWith(
                      (states) => Size(double.infinity, 50)),
                  backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => Color(0xff1680c9),
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
                            builder: (context) => SavingGoals(
                                  uid: widget.uid,
                                )));
                  },
                ),
                child: Text(
                  'Set Savings Goals',
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
