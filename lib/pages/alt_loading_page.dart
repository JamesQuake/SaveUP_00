// import 'dart:html';

// import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:developer' as dev;
// import 'package:loading_animations/loading_animations.dart';
// import 'package:pay_or_save/models/investment_goal_model.dart';
// import 'package:pay_or_save/models/saving_goal_model.dart';
// import 'package:pay_or_save/pages/investment_goal.dart';
import 'dart:async';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:pay_or_save/pages/select_mode.dart';
// import 'package:pay_or_save/pages/starting_balances.dart';
import 'package:pay_or_save/providers/info_provider.dart';
import 'package:pay_or_save/widgets/fadein_widget.dart';
// import 'package:pay_or_save/widgets/fading_text.dart';
// import 'package:pay_or_save/widgets/sliding_text.dart';
// import 'package:pay_or_save/widgets/sliding_widget.dart';
import 'package:provider/provider.dart';

// import '../widgets/fading_texts.dart';
// import 'saving_goals.dart';

class AltLoadingPage extends StatefulWidget {
  final String uid;
  final bool isUser;

  const AltLoadingPage({
    Key key,
    this.uid,
    this.isUser,
  }) : super(key: key);

  @override
  _AltLoadingPageState createState() => _AltLoadingPageState();
}

class _AltLoadingPageState extends State<AltLoadingPage> {
  // NetworkImage _secondImage = NetworkImage(
  //     'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fmycompany.png?alt=media&token=1e790717-3543-4796-a2f5-537dd87fbeef');
  // NetworkImage _image = NetworkImage(
  //     'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fshopwyzly.png?alt=media&token=5340d6da-3488-4d21-9121-08c1038c2994');
  // bool _loading = true;
  // Image _image = new
  bool _loading = true;

  bool isUser;
  String uid;
  Timer t;
  int loadingLevel;
  bool test = true;
  final firestoreInstance = FirebaseFirestore.instance;
  // bool _savGoalList;
  // bool _investGoalList;
  // bool _savListReturn = false;
  // bool _invListReturn = false;
  String routeIn;
  String routePass = 'alt-loading';
  // bool _slideText = false;
  // bool _displayWidget = false;
  // bool _moveText = true;
  double _size = 30.h;
  bool _showHeader;
  bool _showFirst;
  bool _showSecond;
  bool _showThird;
  bool _showWyzly;
  bool _moveOn;

  bool savGoalList;
  bool invGoalList;
  bool savListReturn;
  bool invListReturn;

  // final Future futureData = loadScreen(uid)

  @override
  initState() {
    super.initState();
    _increaseSize();
    // loadScreen();
    // WidgetsBinding.instance.addPostFrameCallback((_) => _());
    // _image.resolve(ImageConfiguration()).addListener(
    //   ImageStreamListener(
    //     (info, call) {
    //       print('Networkimage is fully loaded and saved');
    //       if (mounted)
    //         setState(
    // () {
    //           loadingLevel = 1;
    //         });
    //       // do something
    //     },
    //   ),
    // );
  }

  void _increaseSize() async {
    InfoProvider info = Provider.of<InfoProvider>(context, listen: false);
    await Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _size = 300.h;
      });
    });
    await _revealHeader();
    await _showOne();
    await _showTwo();
    await _showThree();
    await _showEwyzly();
    await info.loadScreen(widget.uid);
    Future.delayed(Duration(milliseconds: 4000), () {
      info.checkList(context, widget.uid, routePass);
    });

    // .then((_) => _revealHeader())
    // .then((_) => _showOne())
    // .then((_) => _showTwo())
    // .then((_) => _showThree());
  }

  void _revealHeader() {
    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        _showHeader = true;
      });
    });
  }

  void _showOne() {
    Future.delayed(Duration(milliseconds: 1900), () {
      setState(() {
        _showFirst = true;
      });
    });
  }

  void _showTwo() {
    Future.delayed(Duration(milliseconds: 2500), () {
      setState(() {
        _showSecond = true;
      });
    });
  }

  void _showThree() {
    Future.delayed(Duration(milliseconds: 3000), () {
      setState(() {
        _showThird = true;
      });
    });
  }

  _showEwyzly() async {
    // InfoProvider info = Provider.of<InfoProvider>(context, listen: false);
    Future.delayed(Duration(milliseconds: 3500), () {
      setState(() {
        _showWyzly = true;
      });
    }).then((_) => {});
  }

  // void _nextMove() {
  //   setState(() {
  //     _moveOn = true;
  //     _showHeader = null;
  //     _showFirst = null;
  //     _showSecond = null;
  //     _showThird = null;
  //     _showWyzly = null;
  //   });
  // }

  loadScreen(uid) async {
    // print("suya");
    await getGoalList(uid);
    await getInvList(uid);
  }

  getGoalList(uid) async {
    return firestoreInstance
        .collection("savingGoals")
        .doc('users')
        .collection(uid)
        .get()
        .then((snapshot) {
      savGoalList = (snapshot.docs.length < 1);
      savListReturn = true;
    });
  }

  getInvList(uid) async {
    return firestoreInstance
        .collection("investmentGoals")
        .doc('users')
        .collection(uid)
        .get()
        .then((snapshot) {
      invGoalList = (snapshot.docs.length < 1);
      invListReturn = true;
    });
  }

  // _showNextBtn() {
  //   Future.delayed(Duration(milliseconds: 500), () {
  //     setState(() {
  //       _showBtn = true;
  //     });
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
    // t.cancel();
  }

  Future navigateToHome(context) async {
    Future.delayed(Duration(milliseconds: 1600), () {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => SelectMode(uid: widget.uid)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (dragEndDetails) {
          // if (dragEndDetails.primaryVelocity < 0) {
          //   _checkList();
          // }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.h),
          child: Padding(
            padding: EdgeInsets.only(top: 80.0.h),
            child: Center(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SizedBox(height: 80.0),
                  if (_showHeader == true)
                    FadeInWidget(
                      child: Image.asset(
                        'assets/images/wyzly-ico.png',
                        width: 250.w,
                        // height: 300.0,
                      ),
                    ),
                  SizedBox(
                    height: 45.0.h,
                  ),
                  AnimatedContainer(
                    height: _size,
                    duration: Duration(seconds: 1),
                    curve: Curves.easeIn,
                    child: Image.asset(
                      "assets/images/mycompany2.png",
                      width: 250.w,
                      // height: 300.0,
                    ),
                  ),
                  SizedBox(
                    height: 35.0.h,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                    ],
                  ),
                  if (_showWyzly == true) ...[
                    SizedBox(height: 16.0),
                    FadeInWidget(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "      with ",
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
                  // if (_moveOn == true)
                  //   Consumer<InfoProvider>(
                  //     builder: (context, info, child) {
                  //       return FutureBuilder(
                  //           future: loadScreen(widget.uid),
                  //           builder: (context, snapshot) {
                  //             // print("pppppppppppppp");

                  //             info.loadScreen(widget.uid);

                  //             if (savListReturn == true ||
                  //                 invListReturn == true) {
                  //               // return
                  //               dev.log("statustacs");
                  //               if (mounted)
                  //                 info.checkList(
                  //                     context, widget.uid, routePass);
                  //               dev.log("strigor8");
                  //             }

                  //             // if (savListReturn == true ||
                  //             //     invListReturn == true)
                  //             //   // return
                  //             //   dev.log("statustacs");
                  //             // if (mounted)
                  //             //   info.checkList(context, widget.uid, routePass);
                  //             // dev.log("strigor8");
                  //             return Container();
                  //           });
                  //     },
                  //   ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
