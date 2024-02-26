// import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:pay_or_save/pages/my_web_view.dart';
// import 'package:pay_or_save/pages/save.dart';
// import 'package:pay_or_save/utilities/validator.dart';
// import 'package:pay_or_save/widgets/bullet.dart';
// import 'package:pay_or_save/widgets/menu.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class StartingInstructions extends StatefulWidget {
//   final String uid;

//   @override
//   _StartingInstructionsState createState() => _StartingInstructionsState(uid);

//   StartingInstructions({Key key, @required this.uid}) : super(key: key);
// }

// class _StartingInstructionsState extends State<StartingInstructions> {
//   String _uid, retailer;

//   _StartingInstructionsState(this._uid);

//   @override
//   void initState() {
//     super.initState();
//     getRetailer();
//   }

//   getRetailer() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     retailer = prefs.get('Retailer');
//     print(retailer);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   Future navigateToSave(context) async {
//     if (retailer != null) {
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => Save(
//                     uid: _uid,
//                   )));
//     }
//   }

//   Future navigateToWebView(context) async {
//     if (retailer != null) {
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => MyWebView(
//                     url: "",
//                     uid: _uid,
//                   )));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: <Widget>[MyManue.childPopup(context)],
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text("Starting Instructions"),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               SizedBox(
//                 height: 16,
//               ),
//               Text(
//                 "Shop at your favorite online stores. When you’re ready to check out, you can Pay or Save.",
//                 style: TextStyle(fontSize: 18),
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               Text(
//                 "When you Pay, you complete your purchase.",
//                 style: TextStyle(fontSize: 18),
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               Text(
//                 "When you Save, you:",
//                 style: TextStyle(fontSize: 18),
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               Bullet(
//                 "Build your wealth by moving money from your checking to savings and investment accounts where it will grow",
//                 style: TextStyle(fontSize: 18),
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               Bullet(
//                 "Earn Reward Points for cool prizes every time you save or invest",
//                 style: TextStyle(fontSize: 18),
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               Bullet(
//                 "Save your favorite items to your virtual closet for future use",
//                 style: TextStyle(fontSize: 18),
//               ),
//               SizedBox(
//                 height: 100,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Padding(
//                     padding: EdgeInsets.only(left: 0.0, right: 0.0),
//                     child: ButtonTheme(
//                       minWidth: 300.0,
//                       height: 50.0,
//                       child: RaisedButton(
//                         textColor: Colors.white,
//                         color: Color(0xFF660066),
//                         child: Text("Next"),
//                         onPressed: () {
//                           navigateToWebView(context);
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
