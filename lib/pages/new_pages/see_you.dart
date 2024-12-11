import 'package:flutter/material.dart';
// import 'package:pay_or_save/assets/chewie_player.dart';
// import 'dart:async';

import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/assets/videoplayer.dart';
import 'package:video_player/video_player.dart';

class SeeYou extends StatelessWidget {
  // @override
  // void initState() {
  //   super.initState();
  //   _videoController = VideoPlayerController.asset(
  //       'assets/images/new/videoassets/ExitVideo.mov');
  //   _videoController.play();
  //   _videoController.setLooping(true);
  //   _videoController.setVolume(0.0);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffcb0909),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // actions: <Widget>[
        //   MyManue.childPopup(context)
        // ],
        title: Text(
          "See You Next Time",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 23.0,
          ),
        ),
        centerTitle: true,
      ),
      endDrawer: MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 30.0,
          right: 25.0,
          left: 25.0,
        ),
        child: Column(
          children: [
            Text(
              'Thank you for shopping at Pay or Save',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                // color: Colors.blue,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            // Image.asset('assets/images/dog.jpg'),
            AspectRatio(
              aspectRatio: 8 / 7,
              child: VidPlayer(
                videoPlayerController: VideoPlayerController.asset(
                  'assets/images/new/videoassets/ExitVideo.mp4',
                ),
                looping: true,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(
              'We look forward to see you next time :)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                // color: Colors.blue,
              ),
            )
          ],
        ),
      ),
    );
  }
}
