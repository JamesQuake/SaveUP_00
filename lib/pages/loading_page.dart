import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:pay_or_save/pages/introduction/introductory.dart';
// import 'package:pay_or_save/pages/home_video.dart';
// import 'package:pay_or_save/pages/introductory0.dart';
// import 'package:pay_or_save/pages/sign_in.dart';
import 'package:pay_or_save/pages/slot_webview.dart';
import 'dart:async';

import 'package:pay_or_save/pages/splash.dart';
import 'package:pay_or_save/widgets/fadein_widget.dart';
import 'package:pay_or_save/widgets/fading_text.dart';
import 'package:pay_or_save/widgets/sliding_widget.dart';

import '../widgets/slide_down.dart';
import '../widgets/sliding_text.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'introduction/introductory.dart';

class LoadingPage extends StatefulWidget {
  var uid;
  final bool isUser;

  @override
  _LoadingPageState createState() => _LoadingPageState(isUser, uid);

  LoadingPage({Key key, @required this.isUser, this.uid}) : super(key: key);
}

class _LoadingPageState extends State<LoadingPage> {
  bool isUser;
  var uid;
  bool _moveToIntro = false;
  Timer t;
  double _size = 30;
  bool _showHeader;
  bool _showFirst;
  bool _showSecond;
  bool _showThird;
  bool _showWyzly;
  bool _showDollar;
  _LoadingPageState(this.isUser, this.uid);

  @override
  initState() {
    super.initState();
    intLoading();
  }

  // intLoading() async {
  //   t = Timer(Duration(seconds: 2), () {
  //     if (isUser) {
  //     } else {
  //       setState(() {
  //         _moveToIntro = true;
  //       });
  //     }
  //   });
  // }

  intLoading() async {
    _increaseSize();
    if (isUser) {
    } else {
      // setState(() {
      //   _moveToIntro = true;
      // });
    }
  }

  void _increaseSize() async {
    await Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _size = 300;
      });
    });
    // _revealDollar();
    await _revealHeader();
    await _showOne();
    await _showTwo();
    await _showThree();
    await _showEwyzly();
    // .then((_) => _revealHeader())
    // .then((_) => _showOne())
    // .then((_) => _showTwo())
    // .then((_) => _showThree());
  }

  // void _revealDollar() {
  //   // Future.delayed(Duration(milliseconds: 1500), () {
  //   setState(() {
  //     _showDollar = true;
  //   });
  //   // });
  // }

  void _revealHeader() {
    Future.delayed(Duration(milliseconds: 1500), () {
      if (mounted)
        setState(() {
          _showHeader = true;
        });
    });
  }

  void _showOne() {
    Future.delayed(Duration(milliseconds: 1900), () {
      if (mounted)
        setState(() {
          _showFirst = true;
        });
    });
  }

  void _showTwo() {
    Future.delayed(Duration(milliseconds: 2500), () {
      if (mounted)
        setState(() {
          _showSecond = true;
        });
    });
  }

  void _showThree() {
    Future.delayed(Duration(milliseconds: 3000), () {
      if (mounted)
        setState(() {
          _showThird = true;
        });
    });
  }

  _showEwyzly() {
    Future.delayed(Duration(milliseconds: 3500), () {
      if (mounted)
        setState(() {
          _showWyzly = true;
        });
    }).then((_) => _nextMove());
  }

  void _nextMove() {
    if (mounted)
      Future.delayed(Duration(milliseconds: 1600), () {
        navigateToHome(context);
      });
  }

  @override
  void dispose() {
    super.dispose();
    // t.cancel();
  }

  // _noAds() {
  //   print('ads did not load from init loading page');
  // }

  // Future<InitializationStatus> _initGoogleMobileAds() {
  //   return MobileAds.instance.initialize();
  // }

  Future navigateToHome(context) async {
    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: (context) => Introductory()));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (dragEndDetails) {
        if (_moveToIntro == true) if (dragEndDetails.primaryVelocity < 0) {
          navigateToHome(context);
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 66.0),
            child: Column(
              children: [
                // SlidingWidget(
                //   widget:
                // FadingWidget(
                //   component:
                // SizedBox(height: 66.0),
                if (_showHeader == true)
                  FadeInWidget(
                    child: Image.asset(
                      'assets/images/wyzly-text.png',
                      width: 200.w,
                      height: 80.0.h,
                    ),
                  ),
                if (_showHeader != true) Container(height: 80.0),
                // ),
                // interval: 800,
                // isDelay: true,
                // ),
                SizedBox(
                  height: 50.0.h,
                ),
                // Image.asset(
                //   "assets/images/posmob.png",
                //   width: 300,
                //   // height: 300.0,
                // ),
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    AnimatedContainer(
                      height: _size,
                      duration: Duration(seconds: 1),
                      curve: Curves.easeIn,
                      decoration: BoxDecoration(
                        color: Color(0xff579aff),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SlidingWidget(
                      widget: Image.asset(
                        "assets/images/anim/emptycart.png",
                        width: 300.w,
                        // height: 300.0,
                      ),
                      interval: 800,
                      isDelay: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 55.0),
                      child: SlideDown(
                        widget: Image.asset(
                          "assets/images/anim/dollarsign.png",
                          width: 100.w,
                          // height: 300.0,
                        ),
                        interval: 800,
                        isDelay: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 60.0.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (_showFirst == true)
                      FadeInWidget(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "  shop ",
                              style: TextStyle(
                                color: Colors.black,
                                // height: 1.2,
                                fontSize: 35.h,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              "wisely",
                              style: TextStyle(
                                color: Color(0xff0070c0),
                                fontSize: 35.h,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            // SlidingText(
                            //   word: "wisely",
                            //   interval: 800,
                            //   isDelay: true,
                            //   caller: 0,
                            // ),
                          ],
                        ),
                      ),
                    if (_showSecond == true)
                      FadeInWidget(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "spend ",
                              style: TextStyle(
                                color: Colors.black,
                                // height: 1.2,
                                fontSize: 35.h,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              "wisely",
                              style: TextStyle(
                                color: Color(0xff0070c0),
                                fontSize: 35.h,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (_showThird == true)
                      FadeInWidget(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "   save ",
                              style: TextStyle(
                                color: Colors.black,
                                // height: 1.2,
                                fontSize: 35.h,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              "wisely",
                              style: TextStyle(
                                color: Color(0xff0070c0),
                                fontSize: 35.h,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (_showWyzly == true) ...[
                      SizedBox(height: 8.0.h),
                      FadeInWidget(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "      with  ",
                              style: TextStyle(
                                color: Colors.black,
                                // height: 1.2,
                                fontSize: 35.h,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Image.asset(
                              "assets/images/wyzly-text.png",
                              height: 35.0.h,
                            )
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
