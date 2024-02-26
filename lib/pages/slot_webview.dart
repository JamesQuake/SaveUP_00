import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pay_or_save/pages/introduction/introductory.dart';
import 'package:pay_or_save/pages/splash.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SlotWebview extends StatefulWidget {
  // const SlotWebview({ Key? key }) : super(key: key);

  @override
  _SlotWebviewState createState() => _SlotWebviewState();
}

class _SlotWebviewState extends State<SlotWebview> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 3.0,
            ),
            Image.asset(
              "assets/images/rgpos.png",
              height: 50.0,
              width: 220.0,
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 15.0,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              'The Smart Way to Shop\n The Fun Way to Save',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 24,
              ),
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          Container(
            height: 380.0,
            width: 450.0,
            child: WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: 'https://pos-slots.web.app',
            ),
          ),
          Spacer(),
          Padding(
            padding:
                const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 15.0),
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
                          builder: (context) => SplashScreen(
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
          ),
        ],
      ),
    );
  }
}
