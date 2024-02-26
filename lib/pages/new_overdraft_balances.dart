// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_admob/firebase_admob.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:pay_or_save/assets/main_drawer.dart';
// // import 'package:pay_or_save/pages/save.dart';
// import 'package:pay_or_save/pages/select_mode.dart';
// import 'package:pay_or_save/services/ad_mob.dart';
// // import 'package:pay_or_save/utilities/validator.dart';
// // import 'package:pay_or_save/widgets/bullet.dart';
// // import 'package:pay_or_save/widgets/menu.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// class MyOverdraftBalances extends StatefulWidget {
//   final String uid;

//   const MyOverdraftBalances({Key key, this.uid}) : super(key: key);
//   // final double overdraftAmount;

//   @override
//   _MyOverdraftBalances createState() => _MyOverdraftBalances();

//   // MyOverdraftBalances({Key key, @required this.uid, this.overdraftAmount})
//   //     : super(key: key);
// }

// const testDevices = "Your_DEVICE_ID";

// class _MyOverdraftBalances extends State<MyOverdraftBalances> {
//   String _uid, retailer;
//   double _coins, _checking, overdraftAmount;
//   bool isLoaded = false;
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
//     keywords: <String>['flutterio', 'beautiful apps'],
//     contentUrl: 'https://flutter.io',
//     childDirected: false,
//     testDevices: <String>[], // Android emulators are considered test devices
//   );

//   RewardedVideoAd videoAd = RewardedVideoAd.instance;
//   AdMobService adMobService = new AdMobService();
//   final firestoreInstance = FirebaseFirestore.instance;

//   // _MyOverdraftBalances(this._uid, this.overdraftAmount);

//   @override
//   void initState() {
//     super.initState();
//     _coins = 100;
//     // _checking = overdraftAmount; ///ACTUAL THING
//     _checking = 200;

//     ///for DEV
//     FirebaseAdMob.instance.initialize(appId: adMobService.getAdMobAppId());
//     videoAd.listener =
//         (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
//       if (event == RewardedVideoAdEvent.completed) {
//         //When the video ad gets completed load a new video ad
//         if (event == RewardedVideoAdEvent.loaded) {
//           isLoaded = true;
//         }

//         videoAd
//             .load(
//                 adUnitId: adMobService.getRewardedVidoAdId(),
//                 targetingInfo: targetingInfo)
//             .catchError((e) => print('Error in loading.'));
//       }
//       if (event == RewardedVideoAdEvent.closed) {
//         //When the video ad gets completed load a new video ad
//         videoAd
//             .load(
//                 adUnitId: adMobService.getRewardedVidoAdId(),
//                 targetingInfo: targetingInfo)
//             .catchError((e) => print('Error in loading.'));
//       }

//       if (event == RewardedVideoAdEvent.rewarded) {
//         addMoneyToAccount();
//       }

//       //On every other event change pass the values to the _handleEvent Method.
//       _handleEvent(event, rewardType, 'Reward', rewardAmount);
//     };
//     //------------------------------------------------------------------//

//     videoAd
//         .load(
//             adUnitId: adMobService.getRewardedVidoAdId(),
//             targetingInfo: targetingInfo)
//         .catchError((e) => print('Error in loading.'))
//         .then((value) => isLoaded = true);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   addMoneyToAccount() {
//     firestoreInstance
//         .collection("users")
//         .doc(_uid)
//         .update({'checking': _checking + _coins}).then((value) {
//       setState(() {
//         _checking = _checking + _coins;
//       });
// //      Navigator.pop(context);
// //      Validator.onErrorDialog("Saved", context);
//     });
//   }

//   Future navigateToStartAgain(context) async {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => SelectMode(
//                   uid: _uid,
//                 )));
//   }

//   //---- Useful function to know exactly what is being done ----//
//   void _handleEvent(RewardedVideoAdEvent event, String rewardType,
//       String adType, int rewardAmount) {
//     switch (event) {
//       case RewardedVideoAdEvent.loaded:
//         _showSnackBar('New Admob $adType Ad loaded!', 1500);
//         break;
//       case RewardedVideoAdEvent.opened:
//         _showSnackBar('Admob $adType Ad opened!', 1500);
//         break;
//       //
//       //The way we are fixing the issue is here.
//       //This is by calling the video to be loaded when the other rewarded video is closed.
//       case RewardedVideoAdEvent.closed:
//         _showSnackBar('Admob $adType Ad closed!', 1500);
//         videoAd
//             .load(
//                 adUnitId: adMobService.getRewardedVidoAdId(),
//                 targetingInfo: targetingInfo)
//             .catchError((e) => print('Error in loading.'));
//         break;
//       case RewardedVideoAdEvent.failedToLoad:
//         _showSnackBar('Admob $adType failed to load.', 1500);
//         break;
//       case RewardedVideoAdEvent.rewarded:
//         _showSnackBar('Rewarded $rewardAmount', 3000);
//         break;
//       default:
//     }
//   }

//   //Snackbar shown with ad status
//   void _showSnackBar(String content, int duration) {
//     Scaffold.of(context).showSnackBar(SnackBar(
//       content: Text(content),
//       duration: Duration(milliseconds: duration),
//     ));
//   }

//   _displaySnackBar(BuildContext context) {
//     final snackBar =
//         SnackBar(content: Text('Please Click one more time to load an ad'));
//     _scaffoldKey.currentState.showSnackBar(snackBar);
//   }

//   showAd(context) {
// //    videoAd.load(
// //        adUnitId: adMobService.getRewardedVidoAdId(),
// //        targetingInfo: targetingInfo).then((v){
// //         videoAd.show();
// //    });

//     if (isLoaded) {
//       videoAd.show();
//     } else {
//       _displaySnackBar(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         backgroundColor: Colors.red,
//         // actions: <Widget>[MyManue.childPopup(context)],
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text("Overdraft"),
//       ),
//       endDrawer: MainDrawer(uid: widget.uid),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               SizedBox(
//                 height: 16,
//               ),
//               Text.rich(
//                 TextSpan(
//                   text: 'Your checking account has a negative balance:  ',
//                   style: TextStyle(fontSize: 18),
//                   children: <TextSpan>[
//                     (_checking <= 0)
//                         ? TextSpan(
//                             text: '\$' + _checking.toStringAsFixed(2),
//                             style: TextStyle(
//                                 color: Colors.red,
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold))
//                         : TextSpan(
//                             text: '\$' + _checking.toStringAsFixed(2),
//                             style: TextStyle(
//                                 color: Colors.green,
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold)),
//                     // can add more TextSpans here...
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               Text(
//                 "You must add money to your checking account to continue playing.",
//                 style: TextStyle(fontSize: 18),
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               Text.rich(
//                 TextSpan(
//                   text: 'If you will watch ad video you will get  ',
//                   style: TextStyle(fontSize: 18),
//                   children: <TextSpan>[
//                     TextSpan(
//                         text: '\$100',
//                         style: TextStyle(
//                             color: Colors.green,
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold)),
//                     // can add more TextSpans here...
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 250,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: <Widget>[
//                   Padding(
//                     padding: EdgeInsets.only(left: 0.0, right: 0.0),
//                     child: ButtonTheme(
//                       minWidth: 300.0,
//                       height: 50.0,
//                       child: RaisedButton(
//                         textColor: Colors.white,
//                         color: Color(0xFF660066),
//                         child: Text("Watch Ads To Add Money"),
//                         onPressed: () {
//                           showAd(context);
//                         },
//                         shape: new RoundedRectangleBorder(
//                           borderRadius: new BorderRadius.circular(10.0),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 30,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: <Widget>[
//                   Padding(
//                     padding: EdgeInsets.only(left: 0.0, right: 0.0),
//                     child: ButtonTheme(
//                       minWidth: 300.0,
//                       height: 50.0,
//                       child: RaisedButton(
//                         textColor: Colors.white,
//                         color: Color(0xFFb396da),
//                         child: Text("Add Money Later"),
//                         onPressed: () {
//                           navigateToStartAgain(context);
//                         },
//                         shape: new RoundedRectangleBorder(
//                           borderRadius: new BorderRadius.circular(10.0),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
