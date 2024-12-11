// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:pay_or_save/assets/main_drawer.dart';
// import 'package:pay_or_save/pages/save.dart';
// import 'package:pay_or_save/pages/saving_goals.dart';
// import 'package:pay_or_save/pages/sign_in.dart';
// import 'package:pay_or_save/utilities/validator.dart';
// import 'package:pay_or_save/widgets/menu.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SelectMode extends StatefulWidget {
//   final String uid;

//   @override
//   _SelectModeState createState() => _SelectModeState(uid);

//   SelectMode({Key key, @required this.uid}) : super(key: key);
// }

// enum SingingCharacter { live, game }

// class _SelectModeState extends State<SelectMode> {
//   String _uid, retailer;
//   SingingCharacter _character = SingingCharacter.game;
//   final List<String> _dropdownValues = [
//     "Start Again",
//     "Virtual Closet",
//     "Dashboard",
//     "Sign out",
//   ];

//   _SelectModeState(_uid);

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   saveRetailer() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('Retailer', retailer);
//   }

//   _signOutT() async {
//     await FirebaseAuth.instance.signOut().then((v) {
//       navigateSiginUp(context);
//     });
//   }

//   Future navigateToSetSavingGoals(context) async {
//     if (retailer != null) {
//       saveRetailer();
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => SavingGoals(
//                     uid: _uid,
//                   )));
//     } else {
//       Validator.onErrorDialog("Please Select Retailer first!", context);
//     }
//   }

//   Future navigateSiginUp(context) async {
//     Navigator.push(context,
//         MaterialPageRoute(builder: (context) => SignInRegistrationPage()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         backgroundColor: Color(0xff0070c0),
//         title: Text(
//           'Select Mode',
//         ),
//         centerTitle: true,
//         elevation: 0.0,
//       ),
//       endDrawer: MainDrawer(),
//       body: Column(
//         children: <Widget>[
//           ListTile(
//             title: const Text('Game'),
//             leading: Radio(
//               value: SingingCharacter.game,
//               groupValue: _character,
//               onChanged: (SingingCharacter value) {
//                 setState(() {
//                   _character = value;
//                 });
//               },
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(right: 30, left: 30),
//             child: Text(
//               "Build your virtual wealth with virtual dollars. And qualify for cool prizes.",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//           ListTile(
//             title: const Text(
//               'Live',
//               style: TextStyle(color: Colors.grey),
//             ),
//             leading: Radio(
//               value: SingingCharacter.live,
//               groupValue: _character,
//               onChanged: (SingingCharacter value) {
//                 // value = null;
//                 setState(() {
//                   _character = value;
//                 });
//               },
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(right: 30, left: 30),
//             child: Text(
//               "Build your personal wealth with real dollars. And qualify for cool prizes.",
//               style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: DropdownButton(
//               hint: retailer == null
//                   ? Text('Where would you like to shop:')
//                   : Text(
//                       retailer,
//                       style: TextStyle(color: Colors.black),
//                     ),
//               isExpanded: true,
//               iconSize: 30.0,
//               style: TextStyle(color: Colors.blue, fontSize: 20),
//               items: ['Amazon', 'Ebay'].map(
//                 (val) {
//                   return DropdownMenuItem<String>(
//                     value: val,
//                     child: Text(val),
//                   );
//                 },
//               ).toList(),
//               onChanged: (val) {
//                 setState(
//                   () {
//                     retailer = val;
//                   },
//                 );
//               },
//             ),
//           ),
//           SizedBox(
//             height: 200,
//           ),
//           Padding(
//             padding: EdgeInsets.only(left: 0.0, right: 0.0),
//             child: ButtonTheme(
//               minWidth: 300.0,
//               height: 50.0,
//               child: RaisedButton(
//                 textColor: Colors.white,
//                 color: Color(0xFF660066),
//                 child: Text("Set Saving Goals"),
//                 onPressed: () {
//                   navigateToSetSavingGoals(context);
//                 },
//                 shape: new RoundedRectangleBorder(
//                   borderRadius: new BorderRadius.circular(10.0),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//         ],
//       ),
//     );
//   }
// }
