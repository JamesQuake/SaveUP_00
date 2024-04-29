import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pay_or_save/pages/new_pages/welcome_back.dart';

class OpenEmail extends StatefulWidget {
  @override
  State<OpenEmail> createState() => _OpenEmailState();
}

class _OpenEmailState extends State<OpenEmail> {
  // const OpenEmail({ Key? key }) : super(key: key);
  TextEditingController _userEmail = TextEditingController();

  _checkEmail(BuildContext context) {
    // set up the buttons
    Widget okButton = TextButton(
      child: Text(
        "OK",
        style: TextStyle(
          color: Color(0xff0070c0),
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '•',
            style: TextStyle(
              fontSize: 50.0,
              height: 1.2,
              color: Color(0xff0070c0),
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Text(
            'Please check your email.',
            style: TextStyle(
              fontSize: 19.0,
              color: Color(0xff0070c0),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            SizedBox(
              width: 3.0,
            ),
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
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Forgot Password?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Text(
                'Please enter your email address',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Reset instructions will be sent to you',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                // padding: EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  cursorColor: Colors.black,
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                  controller: _userEmail,
                  decoration: InputDecoration(
                    // focusColor: Colors.black,
                    // labelText: 'Last Name:',
                    hintStyle: TextStyle(fontSize: 20.0, color: Colors.white),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 0.0, vertical: 8),
                    isDense: true,
                    errorText: _userEmail.text == null
                        ? 'field cannot be empty'
                        : null,
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
                height: 30.0,
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
                  () async {
                    if (_userEmail.text != null) {
                      await FirebaseAuth.instance
                          .sendPasswordResetEmail(email: _userEmail.text);
                      _checkEmail(context);
                    } else {
                      print('No email given');
                    }
                  },
                ),
                child: Text(
                  'Open Email App',
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
