// import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pay_or_save/assets/chewie_player.dart';
// import 'package:pay_or_save/assets/custom_button.dart';
// import 'package:pay_or_save/assets/intro%20dropdown/dropmenu.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
// import 'package:pay_or_save/pages/introductory1.dart';
// import 'package:pay_or_save/pages/my_web_view.dart';
import 'package:video_player/video_player.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';

// import 'introduction/introductory.dart';

// const colorizeColors = [
//   Colors.,
//   Color(0xff0070c0),
//   Color(0xff0070c0),
//   Color(0xff0070c0),
// ];

// const colorizeTextStyle = TextStyle(
//   fontSize: 20.0,
//   fontFamily: 'Horizon',
//   height: 5.0,
// );

class Introductory0 extends StatefulWidget {
  final String uid;
  const Introductory0({Key key, this.uid}) : super(key: key);
  @override
  State<Introductory0> createState() => _Introductory0State();
}

class _Introductory0State extends State<Introductory0> {
  // @override
  // void dispose() {
  //   // _controller.dispose();

  //   // IntroDropMenu()
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xff0070c0),
          size: 28.0.h,
        ),
        toolbarHeight: 70.0.h,
        // flexibleSpace: Image.asset(
        //   "assets/images/wyzly-ico.png",
        //   height: 50.0,
        //   width: 220.0,
        // ),
        leading: Container(),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        // actions: [
        //   Builder(
        //     builder: (context) => IconButton(
        //       padding: EdgeInsets.only(right: 26.0),
        //       icon: Icon(Icons.dehaze),
        //       onPressed: () => Scaffold.of(context).openEndDrawer(),
        //       tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        //     ),
        //   ),
        // ],
        title: Row(
          children: [
            SizedBox(
              width: 3.0,
            ),
            Image.asset(
              "assets/images/wyzly-ico.png",
              height: 50.0.h,
              width: 220.0.w,
            ),
          ],
        ),
      ),
      // endDrawer: MainDrawer(uid: widget.uid),
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              12.0,
              10.0,
              12.0,
              15.0,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'The Smart Way to Shop\n The Fun Way to Save',
                            style: TextStyle(
                              fontSize: 23.0.h,
                              fontFamily: 'Horizon',
                              height: 1.3,
                            ),
                          ),
                          SizedBox(
                            height: 40.0.h,
                          ),
                          AspectRatio(
                            aspectRatio: 3 / 2,
                            child: SoftVideoPlayer(
                              videoPlayerController:
                                  VideoPlayerController.asset(
                                'assets/images/new/videoassets/ew-1.mp4',
                              ),
                              looping: false,
                              placeHolder: 'assets/images/Video1.png',
                            ),
                          ),
                          SizedBox(
                            height: 35.0.h,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Video 1 of 3. How Do I Save Money?',
                              // textAlign: TextAlign.left,
                              style: TextStyle(
                                height: 1.5,
                                fontSize: 18.h,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0.h,
                          ),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                                height: 1.5,
                                fontSize: 18.h,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Learn how ',
                                ),
                                TextSpan(
                                  text: 'eWyzly ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    // fontStyle: FontStyle.italic,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      'saves you money by transforming spending into savings when you shop online.',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
