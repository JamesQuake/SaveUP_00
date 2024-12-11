import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pay_or_save/pages/alt_loading_page.dart';
import 'package:pay_or_save/pages/introduction/introductory.dart';

class SplashScreen extends StatefulWidget {
  final String uid;
  const SplashScreen({Key key, this.uid}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 66.0),
              child: Image.asset(
                'assets/images/logotext.png',
                width: 300,
                // height: 300.0,
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Image.asset(
              "assets/images/posmob.png",
              width: 300,
              // height: 300.0,
            ),
            SizedBox(
              height: 45.0,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'The Smart Way to Shop\n  The Fun Way to Save',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 30,
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 15.0, left: 20.0, right: 20.0),
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
                    if (widget.uid == null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Introductory(
                                  // uid: _uid,
                                  )));
                    } else {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AltLoadingPage(
                                    uid: widget.uid,
                                  )));
                    }
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
            ),
          ],
        ),
      ),
    );
  }
}
