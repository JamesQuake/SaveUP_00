// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pay_or_save/assets/chewie_player.dart';
// import 'package:pay_or_save/assets/custom_button.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
// import 'package:pay_or_save/pages/introductory2.dart';
import 'package:video_player/video_player.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';

// const colorizeColors = [
//   Color(0xff0070c0),
//   Color(0xff0070c0),
//   Color(0xff0070c0),
//   Color(0xff0070c0),
// ];

// const colorizeTextStyle = TextStyle(
//   fontSize: 20.0,
//   fontFamily: 'Horizon',
// );

class Introductory1 extends StatefulWidget {
  final String uid;

  const Introductory1({Key key, this.uid}) : super(key: key);
  @override
  State<Introductory1> createState() => _Introductory1State();
}

class _Introductory1State extends State<Introductory1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70.0.h,
        leading: Container(),
        iconTheme: IconThemeData(
          color: Color(0xff0070c0),
          size: 28.0.h,
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
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
            // SizedBox(
            //   width: 10.0,
            // ),
            // Text(
            //   'Pay or \$ave',
            //   style: TextStyle(
            //     fontSize: 27.0,
            //     color: Colors.black,
            //   ),
            // ),
          ],
        ),
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
                          children: [
                            // AnimatedTextKit(
                            //   animatedTexts: [
                            //     ColorizeAnimatedText(
                            //         'The Smart Way to Shop\n The Fun Way to Save',
                            //         textStyle: colorizeTextStyle,
                            //         colors: colorizeColors,
                            //         speed: const Duration(milliseconds: 60)),
                            //     // ColorizeAnimatedText(
                            //     //   'The Fun Way to Save',
                            //     //   textStyle: colorizeTextStyle,
                            //     //   colors: colorizeColors,
                            //     // ),
                            //   ],
                            //   isRepeatingAnimation: true,
                            //   repeatForever: true,
                            //   onTap: () {
                            //     print("Tap Event");
                            //   },
                            // ),
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
                                  'assets/images/new/videoassets/eW-2.mp4',
                                ),
                                looping: false,
                                placeHolder: 'assets/images/introvid.png',
                              ),
                            ),
                            SizedBox(
                              height: 35.0.h,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Video 2 of 3. SaveUp, the Game',
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
                                    fontSize: 18.h),
                                children: [
                                  TextSpan(
                                    text: 'SaveUp ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      // fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        'is one app with two modes: Game and Live. In Game mode, you simulate savings in  virtual accounts. In Live mode, you save real dollars and watch them grow.',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // CustomButton(
                  //   newText: 'Next',
                  //   // routeName: '/Introductory2',
                  //   widget: Introductory2(),
                  //   width: double.infinity,
                  //   pp: 'true',
                  // ),
                ],
              )),
        ),
      ),
    );
  }
}
