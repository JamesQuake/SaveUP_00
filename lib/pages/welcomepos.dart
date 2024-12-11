import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pay_or_save/pages/sign_in.dart';

class WelcomePos extends StatefulWidget {
  // const WelcomePos({ Key? key }) : super(key: key);

  @override
  _WelcomePosState createState() => _WelcomePosState();
}

class _WelcomePosState extends State<WelcomePos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: Container(),
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Image.asset(
              "assets/images/poslogo.png",
              height: 50.0,
              width: 220.0,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 50.0),
        child: Column(
          children: [
            SizedBox(height: 60.0),
            Text(
              'Welcome',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 50.0),
            Divider(
              color: Colors.black,
              thickness: 0.4,
            ),
            SizedBox(height: 15.0),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  height: 1.5,
                  fontSize: 18.5,
                ),
                children: [
                  TextSpan(
                    text: 'Are you ',
                    style: TextStyle(height: 1.4, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'Steven',
                    style: TextStyle(
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  TextSpan(
                    text: '?',
                    style: TextStyle(
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25.0),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => Color(0xff0070c0),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                minimumSize: MaterialStateProperty.resolveWith(
                    (states) => Size(double.infinity, 42)),
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
                          builder: (context) => SignInRegistrationPage(
                              // uid: widget.uid,
                              )));
                },
              ),
              child: Column(
                children: [
                  Text(
                    'Yes, I am',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25.0),
            Divider(
              color: Colors.black,
              thickness: 0.4,
            ),
            SizedBox(height: 20.0),
            Text(
              'Do you want to choose a \n different account?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                SizedBox.fromSize(
                  size: Size(
                    130.0,
                    50.0,
                  ),
                  child: TextButton(
                    style: ButtonStyle(
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
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => PlaceOrder(
                        //             // uid: widget.uid,
                        //             )));
                      },
                    ),
                    child: Container(
                      child: Text(
                        'Yes',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15.0,
                ),
                // Spacer(),
                SizedBox.fromSize(
                  size: Size(
                    130.0,
                    50.0,
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => Color(0xffcb0909),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      overlayColor: MaterialStateProperty.resolveWith(
                        (states) {
                          return states.contains(MaterialState.pressed)
                              ? Colors.red
                              : null;
                        },
                      ),
                    ),
                    onPressed: () => Timer(
                      const Duration(milliseconds: 400),
                      () {
                        Navigator.pop(context);
                      },
                    ),
                    child: Container(
                      child: Text(
                        'Cancel',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25.0),
            Divider(
              color: Colors.black,
              thickness: 0.4,
            ),
          ],
        ),
      ),
    );
  }
}


// if (_loading) ...[
//               Center(
//                   child: Text(
//                 "Loading",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//               )),
//               SizedBox(
//                 height: 20,
//               ),
//               Center(
//                 child: LoadingBouncingGrid.circle(
//                   size: 30,
//                   backgroundColor: Color(0xff0070c0),
//                 ),
//               ),
//             ],
//             if (!_loading) ...[
//               Divider(
//                 color: Colors.black,
//                 thickness: 0.4,
//               ),
//               ListTile(
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => SignInRegistrationPage(
//                               // uid: widget.uid,
//                               )));
//                 },
//                 leading: Image.asset('assets/images/social/email-logo.png'),
//                 contentPadding: EdgeInsets.all(0.0),
//                 title: Text(
//                   'Use your email',
//                   style: TextStyle(
//                     fontSize: 17.0,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//               Divider(
//                 color: Colors.black,
//                 thickness: 0.4,
//               ),
//               ListTile(
//                 onTap: () {
//                   _loginWithFacebook();
//                 },
//                 leading: Image.asset('assets/images/social/iconfacebook.png'),
//                 contentPadding: EdgeInsets.all(0.0),
//                 title: Text(
//                   'Continue with Facebook',
//                   softWrap: false,
//                   style: TextStyle(
//                     fontSize: 17.0,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//               Divider(
//                 color: Colors.black,
//                 thickness: 0.4,
//               ),
//               ListTile(
//                 onTap: () {},
//                 leading: Image.asset('assets/images/google-logo-2.png'),
//                 contentPadding: EdgeInsets.all(0.0),
//                 title: Text(
//                   'Continue with Google',
//                   style: TextStyle(
//                     fontSize: 17.0,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//               Divider(
//                 color: Colors.black,
//                 thickness: 0.4,
//               ),
//             ],
