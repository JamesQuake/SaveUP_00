import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/pages/amazon_page.dart';
import 'package:pay_or_save/pages/ebay_page.dart';
import 'package:pay_or_save/pages/invest_now.dart';
// import 'package:pay_or_save/pages/my_web_view.dart';
import 'package:pay_or_save/pages/new_pages/options.dart';
import 'package:pay_or_save/pages/save_now.dart';
// import 'package:pay_or_save/pages/save.dart';
// import 'package:pay_or_save/pages/webview.dart';
// import 'package:pay_or_save/utilities/validator.dart';
// import 'package:pay_or_save/widgets/bullet.dart';
// import 'package:pay_or_save/widgets/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../element/ad_helper.dart';
import 'select_mode.dart';

class StartingInstructions extends StatefulWidget {
  final String uid;

  @override
  _StartingInstructionsState createState() => _StartingInstructionsState(uid);

  StartingInstructions({Key key, @required this.uid}) : super(key: key);
}

class _StartingInstructionsState extends State<StartingInstructions> {
  String _uid, retailer;
  // InterstitialAd _interstitialAd;
  // bool _isInterstitialAdReady = false;
  // int _loadAttempts = 0;

  _StartingInstructionsState(this._uid);

  @override
  void initState() {
    super.initState();
    // _loadInterstitialAd();
    // getRetailer();
    // _loadInterstitialAd();
  }

  // void _loadInterstitialAd() {
  //   print('previeeeeeeew');
  //   InterstitialAd.load(
  //     adUnitId: AdHelper.interstitialAdUnitId,
  //     request: AdRequest(),
  //     adLoadCallback: InterstitialAdLoadCallback(
  //       onAdLoaded: (InterstitialAd ad) {
  //         _interstitialAd = ad;
  //         print('previeeeeeeew');
  //         print(_interstitialAd);
  //         // ad.fullScreenContentCallback = FullScreenContentCallback(
  //         //   onAdDismissedFullScreenContent: (ad) {
  //         //     // Navigator.pop(context);
  //         //     navigateToStore(context);
  //         //   },
  //         // );
  //         _isInterstitialAdReady = true;

  //         _loadAttempts = 0;
  //       },
  //       onAdFailedToLoad: (err) {
  //         print('Failed to load an interstitial ad: ${err.message}');
  //         _loadAttempts += 1;
  //         print('previeeeeeeew fail');
  //         print(_interstitialAd);
  //         _isInterstitialAdReady = null;
  //         if (_loadAttempts <= 3) {
  //           _loadInterstitialAd();
  //         }
  //       },
  //     ),
  //   );
  // }

  // void _showInterstitialAd() {
  //   // if (_interstitialAd == null) _loadInterstitialAd();
  //   if (_interstitialAd != null) {
  //     _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
  //       onAdDismissedFullScreenContent: (InterstitialAd ad) {
  //         ad.dispose();
  //         _loadInterstitialAd();
  //       },
  //       onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
  //         ad.dispose();
  //         _loadInterstitialAd();
  //         print('weirddd');
  //         print(error);
  //       },
  //     );
  //     _interstitialAd.show();
  //   }
  // }

  // getRetailer() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   retailer = prefs.get('Retailer');
  //   print(retailer);
  // }

  @override
  void dispose() {
    // _interstitialAd.dispose();
    super.dispose();
  }

  Future navigateToOptions(context) async {
    if (retailer != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Options(
                    uid: _uid,
                  )));
    }
  }

  // Future navigateToStore(context) async {
  //   if (retailer != null) {
  //     if (retailer == 'eBay') {
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => Ebay(
  //                     // url: "",
  //                     // incomingOrder: '10',
  //                     uid: _uid,
  //                   )));
  //     } else if (retailer == 'Amazon') {
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => Amazon(
  //                     // url: "",
  //                     // incomingOrder: '100',
  //                     uid: _uid,
  //                   )));
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Color(0xff0070c0),
        title: Text(
          'Getting Started',
          style: TextStyle(
            fontSize: 22.0,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      endDrawer: MainDrawer(uid: widget.uid),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            30.0,
            20.0,
            30.0,
            10.0,
          ),
          child: ListView(
            children: [
              Column(
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Image.asset(
                  //       "assets/images/rgpos.png",
                  //       height: 50.0,
                  //       width: 220.0,
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 7.0,
                  // ),
                  // Text(
                  //   'The Smart Way to Shop\n The Fun Way to Save',
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 18,
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 25.0,
                  // ),
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Text(
                  //     "INSTRUCTIONS",
                  //     style: TextStyle(
                  //         fontWeight: FontWeight.w500,
                  //         fontSize: 20.0,
                  //         color: Colors.blue),
                  //   ),
                  // ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 9.0),
                      Text(
                        "1. ",
                        style: TextStyle(
                          color: Colors.black,
                          height: 1.3,
                          fontSize: 17,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          "Select one of your favorite online stores from the dropdown menu.",
                          // textAlign: TextAlign.,
                          style: TextStyle(
                            color: Colors.black,
                            height: 1.3,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 9.0),
                      Text(
                        "2. ",
                        style: TextStyle(
                          color: Colors.black,
                          height: 1.3,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        "Shop as usual.",
                        style: TextStyle(
                          color: Colors.black,
                          height: 1.3,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 9.0),
                      Text(
                        "3. ",
                        style: TextStyle(
                          color: Colors.black,
                          height: 1.3,
                          fontSize: 17,
                        ),
                      ),
                      Flexible(
                        child: Container(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                                height: 1.3,
                                fontSize: 17,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      'When you’re ready to check out, select',
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                                TextSpan(
                                  text: ' Pay, Save',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: ' or ',
                                  style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      ),
                                ),
                                TextSpan(
                                  text: 'Invest.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 18.0,
                  ),
                  // Placeholder(
                  //   fallbackHeight: 180.0,
                  // ),
                  Image.asset(
                    'assets/images/Instructions.jpg',
                    height: 270.0,
                    width: 350.0,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        height: 1.3,
                        fontSize: 17,
                      ),
                      children: [
                        TextSpan(
                          text: 'When you ',
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        TextSpan(
                          text: 'pay',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ', you complete your purchase as usual.',
                          style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Text(
                  //     "When you save or invest, you:",
                  //     style: TextStyle(
                  //       fontSize: 17,
                  //     ),
                  //   ),
                  // ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          height: 1.3,
                          fontSize: 17,
                        ),
                        children: [
                          TextSpan(
                            text: 'When you ',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          TextSpan(
                            text: 'save',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' or ',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          TextSpan(
                            text: 'invest',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ':',
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '•',
                        style: TextStyle(
                          fontSize: 20.0,
                          height: 1.1,
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Flexible(
                        child: Text(
                          'You save your merchandise to a virtual closet for a cooling off period 5-days. If you still want it, you can complete your purchase.',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 18.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '•',
                        style: TextStyle(
                          fontSize: 20.0,
                          height: 1.1,
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Flexible(
                        child: Text(
                          'You can transfer up to 200% of your purchase price from your virtual checking account to your virtual savings or investment account where it can accumulate and grow.',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 18.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '•',
                        style: TextStyle(
                          fontSize: 20.0,
                          height: 1.1,
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Flexible(
                        child: Text(
                          'You earn reward points toward valuable prizes.',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Spacer(),
                ],
              ),
              SizedBox(
                height: 40.0,
              ),
              // Spacer(),
              TextButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.resolveWith(
                      (states) => Size(30, 50)),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectMode(
                                  uid: _uid,
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
