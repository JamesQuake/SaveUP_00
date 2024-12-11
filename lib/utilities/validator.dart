import 'package:flutter/material.dart';

class Validator {


  static String validatePassword(String value) {
    if (value.length < 6)
      return 'Password must be more than 5 charater';
    else
      return null;
  }
  static String validateProjectDuration(String value) {
    if (value.length == 0)
      return 'Project Duration must be at least 1 day';
    else
      return null;
  }



  static String validatePhone(String value) {
    if (value.length < 10 && !value.contains("+"))
      return 'Enter vailid phone number and without "+"';
    else
      return null;
  }

  static String validateUsername(String value) {
    if (value.length < 3)
      return 'Enter more than 3 charater';
    else
      return null;
  }

  static String emptyInput(String value) {
    if (value.isEmpty )
      return 'Please fill this form';
    else
      return null;
  }

  static String validateFullName(String value) {
    if (value.length < 6)
      return 'Please Enter Full Name';
    else
      return null;
  }

  static String validateCompName(String value) {
    if (value.length < 6)
      return 'Please Enter Company Name';
    else
      return null;
  }
  static String validateIncome(String value) {
    if (value.length < 2)
      return 'Please Enter Income';
    else
      return null;
  }
  static String validateAmount(String value) {
    if (value.length < 1)
      return 'Please Enter Amount';
    else
      return null;
  }

  static String validateAddress(String value) {
    if (value.length < 6)
      return 'Please Enter Address';
    else
      return null;
  }

  static String validateLocation(String value) {
    if (value.length < 2)
      return 'Please Enter Location';
    else
      return null;
  }

  static String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }


  static Future onErrorDialog(String message, context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Alert"),
          content: Text(message, style: TextStyle( fontSize: 20),),
          actions: [
            FlatButton(
              child: Text("Ok"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }


}