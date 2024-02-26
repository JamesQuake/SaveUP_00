import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pay_or_save/assets/custom_button.dart';

import '../sign_in.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _emailInfo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset(
              "assets/images/wyzly-icon.png",
              height: 50.0,
              width: 220.0,
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 0.0),
          child: Column(
            children: [
              Text(
                'Forgot Password?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 35.0),
              Text(
                'Please enter your email address',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              Text(
                'Reset instructions will be sent to you.',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 30.0),
              TextField(
                style: TextStyle(
                  color: Colors.grey,
                ),
                controller: _emailInfo,
                decoration: InputDecoration(
                  fillColor: Colors.black,
                  focusColor: Colors.black,
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black),
                  hintStyle: TextStyle(fontSize: 20.0, color: Colors.white),
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              // CustomButton(
              //   width: double.infinity,
              //   newText: 'Open Email App',
              //   widget: SignInRegistrationPage(),
              //   pp: 'true',
              // ),
              // ElevatedButton(
              //   style: ButtonStyle(
              //     minimumSize: MaterialStateProperty.resolveWith(
              //         (states) => Size(double.infinity, 50)),
              //     backgroundColor: MaterialStateProperty.resolveWith(
              //       (states) => Color(0xff0070c0),
              //     ),
              //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //       RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10.0),
              //       ),
              //     ),
              //     overlayColor: MaterialStateProperty.resolveWith(
              //       (states) {
              //         return states.contains(MaterialState.pressed)
              //             ? Colors.blue
              //             : null;
              //       },
              //     ),
              //   ),
              //   onPressed: () => Timer(
              //     const Duration(milliseconds: 400),
              //     () {
              //       Navigator.pushReplacement(
              //         context,
              //         CupertinoPageRoute(
              //           builder: (context) => SignInRegistrationPage(),
              //         ),
              //       );
              //     },
              //   ),
              //   child: Text(
              //     'Open Email App',
              //     style: TextStyle(
              //       fontSize: 20.0,
              //       color: Colors.white,
              //     ),
              //   ),
              //   // color: Colors.transparent,
              // ),
              // ElevatedButton(
              //   onPressed: () {},
              //   style: ElevatedButton.styleFrom(
              //     shape: CircleBorder(),
              //     primary: Colors.blue,
              //     // padding: EdgeInsets.all(10),
              //   ),
              //   child: Align(
              //     alignment: Alignment.centerRight,
              //     child: Text(
              //       'Open Email App',
              //       style: TextStyle(
              //         fontSize: 20.0,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
