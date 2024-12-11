import 'package:flutter/material.dart';
import 'package:pay_or_save/assets/custom_button.dart';
import 'package:pay_or_save/pages/new_pages/reset_password.dart';

class WelcomeBack extends StatelessWidget {
  const WelcomeBack({Key key}) : super(key: key);

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
                "assets/images/new/newlogo.png",
                height: 50.0,
                width: 220.0,
              ),
            ],
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14.0, 35.0, 14.0, 0.0),
            child: Column(
              children: [
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Container(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                          color: Colors.black, height: 1.4, fontSize: 17),
                      children: [
                        TextSpan(
                            text:
                                'Tap the bottle below from your mobile phone to finish logging into '),
                        TextSpan(
                          text: 'Pay or Save',
                          style: TextStyle(
                            height: 1.4,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 15.0),
                  child: CustomButton(
                    width: double.infinity,
                    pp: 'true',
                    newText: 'Go to Pay or Save',
                    widget: ResetPassword(),
                  ),
                ),
                Text(
                  'This link is valid for 4 hours',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 35.0,
                ),
                Text(
                  "Don't know why you're getting this email?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  'We want this email to help you log in to your Pay or Save account.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  "If you didn't try to log in to your account or request this email, don't worry. Your email address may have been entered by mistake. You may simply ignore or delete this email and use your existing email to log in.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Happy Saving,',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                            color: Colors.black, height: 1.4, fontSize: 18),
                        children: [
                          TextSpan(text: 'The '),
                          TextSpan(
                            text: 'Pay or Save',
                            style: TextStyle(
                              height: 1.4,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: ' Team'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
