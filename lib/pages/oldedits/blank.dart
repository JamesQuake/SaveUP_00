// import 'dart:convert';
// import 'dart:io';
// import 'package:meta/meta.dart';

// import 'package:http/http.dart' as http;
// import 'package:mvvm_flutter_app/model/apis/app_exception.dart';

// class MediaService {
//   final String _baseUrl = "https://itunes.apple.com/search?term=";

//   Future<dynamic> get(String url) async {
//     dynamic responseJson;
//     try {
//       final response = await http.get(_baseUrl + url);
//       responseJson = returnResponse(response);
//     } on SocketException {
//       throw FetchDataException('No Internet Connection');
//     }
//     return responseJson;
//   }

//   @visibleForTesting
//   dynamic returnResponse(http.Response response) {
//     switch (response.statusCode) {
//       case 200:
//         dynamic responseJson = jsonDecode(response.body);
//         return responseJson;
//       case 400:
//         throw BadRequestException(response.body.toString());
//       case 401:
//       case 403:
//         throw UnauthorisedException(response.body.toString());
//       case 500:
//       default:
//         throw FetchDataException(
//             'Error occured while communication with server' +
//                 ' with status code : ${response.statusCode}');
//     }
//   }
// }


///alt starts here
///
///
///
// import 'dart:html';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:loading_animations/loading_animations.dart';
// import 'package:pay_or_save/models/investment_goal_model.dart';
// import 'package:pay_or_save/models/saving_goal_model.dart';
// import 'package:pay_or_save/pages/investment_goal.dart';
// import 'dart:async';
// // import 'package:google_mobile_ads/google_mobile_ads.dart';

// import 'package:pay_or_save/pages/select_mode.dart';
// import 'package:pay_or_save/pages/starting_balances.dart';

// import 'saving_goals.dart';

// class AltLoadingPage extends StatefulWidget {
//   final String uid;
//   final bool isUser;

//   const AltLoadingPage({
//     Key key,
//     this.uid,
//     this.isUser,
//   }) : super(key: key);

//   @override
//   _AltLoadingPageState createState() => _AltLoadingPageState();
// }

// class _AltLoadingPageState extends State<AltLoadingPage> {
//   NetworkImage _secondImage = NetworkImage(
//       'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fmycompany.png?alt=media&token=1e790717-3543-4796-a2f5-537dd87fbeef');
//   NetworkImage _image = NetworkImage(
//       'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fshopwyzly.png?alt=media&token=5340d6da-3488-4d21-9121-08c1038c2994');
//   // bool _loading = true;
//   // Image _image = new
//   bool _loading = true;

//   bool isUser;
//   String uid;
//   Timer t;
//   int loadingLevel;
//   bool test = true;
//   final firestoreInstance = FirebaseFirestore.instance;
//   bool _savGoalList;
//   bool _investGoalList;
//   bool _savListReturn = false;
//   bool _invListReturn = false;
//   String routeIn;

//   @override
//   initState() {
//     super.initState();
//     loadScreen();
//     _image.resolve(ImageConfiguration()).addListener(
//       ImageStreamListener(
//         (info, call) {
//           print('Networkimage is fully loaded and saved');
//           setState(() {
//             loadingLevel = 1;
//           });
//           // do something
//         },
//       ),
//     );
//     _secondImage.resolve(ImageConfiguration()).addListener(
//       ImageStreamListener(
//         (info, call) {
//           print('Networkimage is fully loaded and saved');
//           setState(() {
//             loadingLevel = 2;
//           });
//           // do something
//         },
//       ),
//     );
//     // print('printingggg');
//     // print(widget.uid);
//     // getGoalList();
//     // print('OBSEREREEEE');
//     // print(widget.uid);
//     // _initGoogleMobileAds();
//   }

//   loadScreen() {
//     getGoalList();
//     getInvList();
//   }

//   getGoalList() async {
//     return firestoreInstance
//         .collection("savingGoals")
//         .doc('users')
//         .collection(widget.uid)
//         .get()
//         .then((snapshot) {
//       setState(() {
//         _savListReturn = true;
//       });
//       _savGoalList = (snapshot.docs.length < 1);
//     });
//   }

//   getInvList() async {
//     return firestoreInstance
//         .collection("investmentGoals")
//         .doc('users')
//         .collection(widget.uid)
//         .get()
//         .then((snapshot) {
//       setState(() {
//         _invListReturn = true;
//       });
//       _investGoalList = (snapshot.docs.length < 1);
//     });
//     // print('object');
//   }

//   // _noAds() {
//   //   print('ad did not load');
//   // }

//   // Future<InitializationStatus> _initGoogleMobileAds() {
//   //   var stuff = MobileAds.instance.initialize();
//   //   print('obs stuff');
//   //   print(stuff);
//   //   return stuff;
//   // }

//   // Align(
//   //   alignment: Alignment.center,
//   //   child: Text(
//   //     'The Smart Way to Shop\n  The Fun Way to Save',
//   //     style: TextStyle(
//   //       fontWeight: FontWeight.w400,
//   //       fontSize: 30,
//   //     ),
//   //   ),
//   // ),

//   _checkList() async {
//     // await getGoalList();
//     // await getInvList();
//     if (_savGoalList == true) {
//       Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(
//               builder: (_) => SavingGoals(
//                     uid: widget.uid,
//                   )),
//           (route) => false);
//     } else if (_investGoalList == true) {
//       Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(
//               builder: (_) => InvestmentGoals(
//                     uid: widget.uid,
//                   )),
//           (route) => false);
//       // return;
//     } else if (_savGoalList == false && _investGoalList == false) {
//       Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(
//               builder: (_) => StartingBalances(
//                     uid: widget.uid,
//                   )),
//           (route) => false);
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     // t.cancel();
//   }

//   Future navigateToHome(context) async {
//     Navigator.push(context,
//         MaterialPageRoute(builder: (context) => SelectMode(uid: widget.uid)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 150.0),
//               child: Image.network(
//                 'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fshopwyzly.png?alt=media&token=5340d6da-3488-4d21-9121-08c1038c2994',
//                 width: 300,
//                 // height: 300.0,
//               ),
//             ),
//             SizedBox(
//               height: 30.0,
//             ),
//             if (loadingLevel == 2) ...[
//               Text(
//                 "with",
//                 style: TextStyle(
//                   fontSize: 23,
//                 ),
//               ),
//             ],
//             SizedBox(
//               height: 50.0,
//             ),
//             Image.network(
//               "https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fmycompany.png?alt=media&token=1e790717-3543-4796-a2f5-537dd87fbeef",
//               width: 300,
//               // height: 300.0,
//             ),
//             SizedBox(
//               height: 45.0,
//             ),
//             Spacer(),
//             if (_savListReturn == false ||
//                 _invListReturn == false ||
//                 _savGoalList != false && _investGoalList != false) ...[
//               // const SizedBox(height: 55),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 15.0),
//                 child: Center(
//                   child: LoadingBouncingGrid.circle(
//                     size: 30,
//                     backgroundColor: Color(0xff0070c0),
//                   ),
//                 ),
//               ),
//             ],
//             if (loadingLevel == 2)
//               if (_savListReturn == true ||
//                   _invListReturn == true ||
//                   _savGoalList != null && _investGoalList != null) ...[
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       bottom: 15.0, left: 20.0, right: 20.0),
//                   child: ElevatedButton(
//                     style: ButtonStyle(
//                       minimumSize: MaterialStateProperty.resolveWith(
//                           (states) => Size(double.infinity, 50)),
//                       backgroundColor: MaterialStateProperty.resolveWith(
//                         (states) => Color(0xff1680c9),
//                       ),
//                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                       overlayColor: MaterialStateProperty.resolveWith(
//                         (states) {
//                           return states.contains(MaterialState.pressed)
//                               ? Colors.blue
//                               : null;
//                         },
//                       ),
//                     ),
//                     onPressed: () => Timer(
//                       const Duration(milliseconds: 400),
//                       () {
//                         _checkList();
//                         // if (widget.uid == null) {
//                         //   Navigator.push(
//                         //       context,
//                         //       MaterialPageRoute(
//                         //           builder: (context) => Introductory(
//                         //               // uid: _uid,
//                         //               )));
//                         // } else {
//                         //   Navigator.pushReplacement(
//                         //       context,
//                         //       MaterialPageRoute(
//                         //           builder: (context) => AltLoadingPage(
//                         //                 uid: widget.uid,
//                         //               )));
//                         // }
//                       },
//                     ),
//                     child: Text(
//                       'Next',
//                       style: TextStyle(
//                         fontSize: 20.0,
//                         color: Colors.white,
//                       ),
//                     ),
//                     // color: Colors.transparent,
//                   ),
//                 ),
//               ],
//           ],
//         ),
//       ),
//       // body: Column(
//       //   crossAxisAlignment: CrossAxisAlignment.center,
//       //   mainAxisAlignment: MainAxisAlignment.center,
//       //   children: <Widget>[
//       //     Center(
//       //       child: Text(
//       //         "Loading",
//       //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//       //       ),
//       //     ),
//       //     SizedBox(
//       //       height: 20,
//       //     ),
//       //     Center(
//       //       child: LoadingBouncingGrid.circle(
//       //         size: 30,
//       //         backgroundColor: Color(0xff0070c0),
//       //       ),
//       //     ),
//       //   ],
//       // ),
//     );
//   }
// }






