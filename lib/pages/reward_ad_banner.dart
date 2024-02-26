// // import 'dart:io';
// import 'package:firebase_admob/firebase_admob.dart';
// import 'package:pay_or_save/pages/sign_up.dart';
// import 'package:pay_or_save/services/ad_mob.dart';
// import 'package:flutter/material.dart';

// class RewardedVideo extends StatefulWidget {
//   @override
//   _RewardedVideoState createState() => _RewardedVideoState();
// }

// const testDevices = "Your_DEVICE_ID";

// class _RewardedVideoState extends State<RewardedVideo> {
//   double _coins;

//   static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
//     testDevices: testDevices != null ? <String>['testDevices'] : null,
//     keywords: <String>['Book', 'Game', 'Other'],
//     nonPersonalizedAds: true,
//   );

//   RewardedVideoAd videoAd = RewardedVideoAd.instance;
//   AdMobService adMobService = new AdMobService();
//   @override
//   void initState() {
//     super.initState();
//     _coins = 0.0;
//     FirebaseAdMob.instance.initialize(appId: adMobService.getAdMobAppId());
//     videoAd.listener =
//         (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
//       print("REWARDED VIDEO AD $event");
//       if (event == RewardedVideoAdEvent.rewarded) {
//         setState(() {
//           _coins += rewardAmount;
//         });
//       }
//     };
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   Future navigateToRegister(context) async {
//     Navigator.push(
//         context, MaterialPageRoute(builder: (context) => RegistrationPage()));
//   }

//   void _showDialog(String error) {
//     // flutter defined function
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         // return object of type Dialog
//         return AlertDialog(
//           title: new Text("Alert"),
//           content: new Text(error),
//           actions: <Widget>[
//             // usually buttons at the bottom of the dialog
//             new FlatButton(
//               child: new Text("Ok"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     double heigh = MediaQuery.of(context).size.height;
//     double yourHeight = heigh * 0.7;
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text("Pay or Save"),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             SizedBox(
//               height: 30,
//             ),
//             Text('LOAD REWARDED VIDEO AD'),
//             RaisedButton(
//               child: Text("LOAD REWARDED AD"),
//               onPressed: () {
//                 videoAd.load(
//                     adUnitId: adMobService.getRewardedVidoAdId(),
//                     targetingInfo: targetingInfo);
//               },
//             ),
//             RaisedButton(
//               child: Text("SHOW REWARDED VIDEOAD"),
//               onPressed: () {
//                 videoAd.show();
//               },
//             ),
//             Text("YOU HAVE $_coins coins"),
//           ],
//         ),
//       ),
//     );
//   }
// }
