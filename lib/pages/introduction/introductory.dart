import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pay_or_save/pages/dashboard.dart';
// import 'package:pay_or_save/assets/intro%20dropdown/dropmenu.dart';
// import 'package:pay_or_save/pages/login_email.dart';
import 'package:pay_or_save/pages/login.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'introductory0.dart';
import 'introductory1.dart';
import 'introductory2.dart';
// import '../sign_in.dart';

class Introductory extends StatefulWidget {
  final String uid;

  const Introductory({Key key, this.uid}) : super(key: key);

  @override
  _IntroductoryState createState() => _IntroductoryState();
}

class _IntroductoryState extends State<Introductory> {
  final PageController _controller = PageController();
  int currentIndex = 0;
  List _pages;
  final ValueNotifier<int> buildCount = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();

    _pages = [
      Introductory0(uid: widget.uid),
      Introductory1(uid: widget.uid),
      Introductory2(uid: widget.uid),
    ];

    ///a listener which will update the state and refresh the page index
    _controller.addListener(() {
      if (_controller.page.round() != currentIndex) {
        setState(() {
          currentIndex = _controller.page.round();
        });
      }
      // setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
// WidgetsIntroductoryBinding.instance
//         .addPostFrameCallback((_) => yourFunction(context));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            // height: MediaQuery.of(context).size.height,
            child: PageView.builder(
              controller: _controller,
              // children: [
              //   Introductory0(uid: widget.uid),
              //   Introductory1(uid: widget.uid),
              //   Introductory2(uid: widget.uid),
              // ],
              itemCount: _pages.length,
              onPageChanged: (int) {
                // closeMenu();
                // setState(() {});
                buildCount.value++;
              },
              itemBuilder: (context, index) {
                return ValueListenableBuilder(
                  valueListenable: buildCount,
                  // bldCnt here ↓↓ is buildCount.value
                  builder: (context, bldCnt, child) => _pages[index],
                );
              },
            ),
          ),
          Row(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                  child: SmoothPageIndicator(
                    controller: _controller, // PageController
                    count: 3,
                    effect: WormEffect(
                      activeDotColor: Color(0xff0070c0),
                      offset: 2.0,
                      // spacing: 40.0,
                    ),
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 10.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: (currentIndex == 2 && widget.uid == null)
                      ? TextButton(
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.resolveWith(
                                (states) => Size(20.0, 36.0)),
                            backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.transparent,
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
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
                                CupertinoPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 20.0.h,
                                  color: Color(0xff0070c0),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Color(0xff0070c0),
                              ),
                            ],
                          ),
                        )
                      : (currentIndex != 2)
                          ? TextButton(
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.resolveWith(
                                    (states) => Size(20.0, 36.0)),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                  (states) => Colors.transparent,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                overlayColor: MaterialStateProperty.resolveWith(
                                  (states) {
                                    return states
                                            .contains(MaterialState.pressed)
                                        ? Colors.blue
                                        : null;
                                  },
                                ),
                              ),
                              onPressed: () => Timer(
                                const Duration(milliseconds: 400),
                                () {
                                  _controller.nextPage(
                                    duration: Duration(milliseconds: 700),
                                    curve: Curves.ease,
                                  );
                                },
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Next',
                                    style: TextStyle(
                                      fontSize: 20.0.h,
                                      color: Color(0xff0070c0),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: Color(0xff0070c0),
                                  ),
                                ],
                              ),
                            )
                          : TextButton(
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.resolveWith(
                                    (states) => Size(20.0, 36.0)),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                  (states) => Colors.transparent,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                overlayColor: MaterialStateProperty.resolveWith(
                                  (states) {
                                    return states
                                            .contains(MaterialState.pressed)
                                        ? Colors.blue
                                        : null;
                                  },
                                ),
                              ),
                              onPressed: () => Timer(
                                const Duration(milliseconds: 400),
                                () {
                                  // Navigator.pushReplacement(
                                  //   context,
                                  //   CupertinoPageRoute(
                                  //     builder: (context) =>
                                  //         DashBoard(uid: widget.uid),
                                  //   ),
                                  // );
                                  Navigator.pop(context);
                                },
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Return',
                                    style: TextStyle(
                                      fontSize: 20.0.h,
                                      color: Color(0xff0070c0),
                                    ),
                                  ),
                                  Icon(
                                    Icons.repeat_rounded,
                                    color: Color(0xff0070c0),
                                    // size: 20.0.h,
                                  ),
                                ],
                              ),
                            ),
                  // : Container(
                  //     padding: EdgeInsets.only(bottom: 48.0),
                  //   ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
