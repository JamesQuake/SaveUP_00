import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:pay_or_save/pages/select_mode.dart';
import 'package:pay_or_save/pages/sign_in.dart';

class ResetPassword extends StatelessWidget {
  // const ResetPassword({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Image.asset(
              "assets/images/wyzly-ico.png",
              height: 50.0,
              width: 220.0,
            ),
          ],
        ),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50, 100, 50, 15.0),
        child: Center(
          child: Column(
            children: [
              Text(
                'Reset Password',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 35.0,
              ),
              Container(
                // padding: EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  cursorColor: Colors.black,
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                  decoration: InputDecoration(
                    // focusColor: Colors.black,
                    // labelText: 'Last Name:',
                    hintText: 'password',
                    hintStyle: TextStyle(fontSize: 16.0, color: Colors.grey),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 0.0, vertical: 8),
                    isDense: true,
                    // filled: true,
                    // fillColor: Colors.grey.withOpacity(0.2),
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat', color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Container(
                // padding: EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  cursorColor: Colors.black,
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                  decoration: InputDecoration(
                    // focusColor: Colors.black,
                    // labelText: 'Last Name:',
                    hintText: 'verify password',
                    hintStyle: TextStyle(fontSize: 16.0, color: Colors.grey),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 0.0, vertical: 8),
                    isDense: true,
                    // filled: true,
                    // fillColor: Colors.grey.withOpacity(0.2),
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat', color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              SizedBox(
                height: 35.0,
              ),
              ElevatedButton(
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
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignInRegistrationPage(
                                // uid: _uid,
                                )));
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
            ],
          ),
        ),
      ),
    );
  }
}
