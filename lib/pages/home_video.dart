import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pay_or_save/pages/sign_in.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomePage extends StatefulWidget {
  final String uid;

  @override
  _HomePageState createState() => _HomePageState(uid);

  HomePage({Key key, @required this.uid}) : super(key: key);
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool isSet = false;
  bool _isPlayerReady = false;
  String videoId, uid;

  _HomePageState(this.uid);

  @override
  initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: "k-tMH8bAASk",
      flags: const YoutubePlayerFlags(
        mute: false,
        disableDragSeek: false,
        loop: true,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  intPlayer() async {
    await Future.delayed(const Duration(seconds: 2), () {
      _controller = YoutubePlayerController(
        initialVideoId: "k-tMH8bAASk",
        flags: const YoutubePlayerFlags(
          mute: false,
          disableDragSeek: false,
          loop: true,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        ),
      )..addListener(listener);
      _idController = TextEditingController();
      _seekToController = TextEditingController();
      _videoMetaData = const YoutubeMetaData();
      _playerState = PlayerState.unknown;
    });
    setState(() {
      isSet = true;
    });
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  Future navigateToRegister(context) async {
    deactivate();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SignInRegistrationPage()));
  }

//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: SingleChildScrollView(
//        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.center,
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            SizedBox(
//              height: 30,
//            ),
//            new Container(
//                height: 150,
//                child: Image(image: AssetImage('assets/images/logo.png'), fit: BoxFit.fitHeight, width: double.infinity,)
//            ),
//            SizedBox(
//              height: 30,
//            ),
////            Center(child:FutureBuilder(
////              future: _initializeVideoPlayerFuture,
////              builder: (context, snapshot) {
////                if (snapshot.connectionState == ConnectionState.done) {
////                  // If the VideoPlayerController has finished initialization, use
////                  // the data it provides to limit the aspect ratio of the video.
////                  return AspectRatio(
////                    aspectRatio: _controller.value.aspectRatio,
////                    // Use the VideoPlayer widget to display the video.
////                    child: VideoPlayer(_controller),
////                  );
////                } else {
////                  // If the VideoPlayerController is still initializing, show a
////                  // loading spinner.
////                  return Center(child: CircularProgressIndicator());
////                }
////              },
////            )),
//
////            (isSet)?YoutubePlayer(
////              controller: _controller,
////              showVideoProgressIndicator: true,
////              progressIndicatorColor: Colors.red,
////              topActions: <Widget>[
////                const SizedBox(width: 8.0),
////                Expanded(
////                  child: Text(
////                    _controller.metadata.title,
////                    style: const TextStyle(
////                      color: Colors.white,
////                      fontSize: 18.0,
////                    ),
////                    overflow: TextOverflow.ellipsis,
////                    maxLines: 1,
////                  ),
////                ),
//////              IconButton(
//////                icon: const Icon(
//////                  Icons.settings,
//////                  color: Colors.white,
//////                  size: 25.0,
//////                ),
//////                onPressed: () {
//////                  log('Settings Tapped!');
//////                },
//////              ),
////              ],
////              onReady: () {
////                _isPlayerReady = true;
////              },
////              onEnded: (data) {
//////          _controller
//////              .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
//////          _showSnackBar('Next Video Started!');
////              },
////            ):Container(),
//
//            YoutubePlayer(
//              controller: _controller,
//              showVideoProgressIndicator: true,
//              progressIndicatorColor: Colors.red,
//              topActions: <Widget>[
//                const SizedBox(width: 8.0),
//                Expanded(
//                  child: Text(
//                    _controller.metadata.title,
//                    style: const TextStyle(
//                      color: Colors.white,
//                      fontSize: 18.0,
//                    ),
//                    overflow: TextOverflow.ellipsis,
//                    maxLines: 1,
//                  ),
//                ),
////              IconButton(
////                icon: const Icon(
////                  Icons.settings,
////                  color: Colors.white,
////                  size: 25.0,
////                ),
////                onPressed: () {
////                  log('Settings Tapped!');
////                },
////              ),
//              ],
//              onReady: () {
//                _isPlayerReady = true;
//              },
//              onEnded: (data) {
////          _controller
////              .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
////          _showSnackBar('Next Video Started!');
//              },
//            ),
//            SizedBox(
//              height: 150,
//            ),
//            Padding(
//              padding: EdgeInsets.only(left: 0.0, right: 0.0),
//              child: ButtonTheme(
//                minWidth: 300.0,
//                height: 50.0,
//                child: RaisedButton(
//                  textColor: Colors.white,
//                  color: Color(0xFF660066),
//                  child: Text("Next"),
//                  onPressed: () {
//                    navigateToRegister(context);
//                  },
//                  shape: new RoundedRectangleBorder(
//                    borderRadius: new BorderRadius.circular(10.0),
//                  ),
//                ),
//              ),
//            ),
//            SizedBox(
//              height: 30,
//            ),
//          ],
//
//        ),
//      ),
//
//    );
//  }

  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title',
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value ?? '',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 400.h,
        ),
        YoutubePlayerBuilder(
          onExitFullScreen: () {
            // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
            SystemChrome.setPreferredOrientations(DeviceOrientation.values);
          },
          player: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.red,
            topActions: <Widget>[
              const SizedBox(width: 8.0),
            ],
            onReady: () {
              _isPlayerReady = true;
            },
            onEnded: (data) {
//          _controller
//              .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
//          _showSnackBar('Next Video Started!');
            },
          ),
          builder: (context, player) => Scaffold(
            key: _scaffoldKey,
            body: ListView(
              children: [
                SizedBox(
                  height: 30.h,
                ),
                new Container(
                    height: 150.h,
                    child: Image(
                      image: AssetImage('assets/images/logo.png'),
                      fit: BoxFit.fitHeight,
                      width: double.infinity,
                    )),
                SizedBox(
                  height: 30.h,
                ),
                player,
                SizedBox(
                  height: 150.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: ButtonTheme(
                    minWidth: 300.0.w,
                    height: 50.0.h,
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Color(0xFF660066),
                      child: Text("Next"),
                      onPressed: () {
                        navigateToRegister(context);
                      },
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
