// import 'dart:ffi';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class SoftVideoPlayer extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final String placeHolder;
  // final Widget

  SoftVideoPlayer({
    @required this.videoPlayerController,
    // this.overLay,
    this.looping,
    this.placeHolder,
    Key key,
  }) : super(key: key);

  @override
  _SoftVideoPlayerState createState() => _SoftVideoPlayerState();
}

class _SoftVideoPlayerState extends State<SoftVideoPlayer> {
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: 3 / 2,
      // autoInitialize: true,
      // overlay: Image.asset('assets/images/video1.png'),
      placeholder: Image.asset(
        widget.placeHolder,
        fit: BoxFit.fill,
      ),
      looping: widget.looping,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
    _chewieController.addListener(() {
      if (!_chewieController.isFullScreen)
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        0.0,
        0.0,
        0.0,
        0.0,
      ),
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

  @override
  void dispose() {
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
}
