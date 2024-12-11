// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:pay_or_save/models/account_model.dart';
// import 'package:pay_or_save/pages/starting_instructions.dart';
// import 'package:pay_or_save/widgets/menu.dart';

// class StartingBalances extends StatefulWidget {
//   final String uid;

//   @override
//   _StartingBalancesState createState() => _StartingBalancesState(uid);

//   StartingBalances({Key key, @required this.uid}) : super(key: key);
// }

// class _StartingBalancesState extends State<StartingBalances> {
//   String _uid, _checking, _savings, _investment, _rewardPoints;
//   List<AccountModel> _list;
//   final firestoreInstance = Firestore.instance;

//   _StartingBalancesState(this._uid);

//   @override
//   void initState() {
//     super.initState();
//     print(_uid);
//     _getBalances();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   Future navigateToStartingInstructions(context) async {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => StartingInstructions(
//                   uid: _uid,
//                 )));
//   }

//   Future _getBalances() {
//     return firestoreInstance
//         .collection("users")
//         .document(_uid)
//         .get()
//         .then((value) {
//       _checking = value.data['checking'].toStringAsFixed(2);
//       _savings = value.data['savings'].toStringAsFixed(2);
//       _investment = value.data['investment'].toStringAsFixed(2);
//       _rewardPoints = value.data['reward_points'].toStringAsFixed(2);
//     });
//   }

//   Widget _item(BuildContext context, int index) {
//     return Container(
//       child: ListTile(
//         title: Text(
//           _list[index].title,
//           style: TextStyle(fontSize: 16),
//         ),
//         leading: CircleAvatar(
//           backgroundImage: NetworkImage(_list[index].url),
//         ),
//         trailing: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               "\$" + _list[index].amount,
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             )
//           ],
//         ),
//         onTap: () {},
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: <Widget>[MyManue.childPopup(context)],
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text("Starting Balances"),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.max,
//             children: <Widget>[
//               SizedBox(
//                 height: 16,
//               ),
//               Text(
//                 "Even before you start to play, we funded the following accounts for you:",
//                 style: TextStyle(fontSize: 16),
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               FutureBuilder(
//                 future: _getBalances(), // async work
//                 builder: (BuildContext context, snapshot) {
//                   switch (snapshot.connectionState) {
//                     case ConnectionState.waiting:
//                       return new Text('Loading....');
//                     default:
//                       if (snapshot.hasError)
//                         return new Text('Error: ${snapshot.error}');
//                       else
//                         return Column(
//                           children: <Widget>[
//                             ListTile(
//                               title: Text(
//                                 "Checking:",
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                               leading: CircleAvatar(
//                                 backgroundImage: NetworkImage(
//                                     "https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fcheking-icon.png?alt=media&token=9d278e21-7097-453c-b253-187a700d03bc"),
//                               ),
//                               trailing: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: <Widget>[
//                                   (_checking != null)
//                                       ? Text(
//                                           "\$" + _checking,
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 18),
//                                         )
//                                       : Text(
//                                           "\$",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 18),
//                                         )
//                                 ],
//                               ),
//                               onTap: () {},
//                             ),
//                             ListTile(
//                               title: Text(
//                                 "Savings:",
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                               leading: CircleAvatar(
//                                 backgroundImage: NetworkImage(
//                                     "https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fdollar-green.png?alt=media&token=b1720f47-5c6b-4c57-a37c-98884f8590c1"),
//                               ),
//                               trailing: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: <Widget>[
//                                   (_savings != null)
//                                       ? Text(
//                                           "\$" + _savings,
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 18),
//                                         )
//                                       : Text(
//                                           "\$",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 18),
//                                         )
//                                 ],
//                               ),
//                               onTap: () {},
//                             ),
//                             ListTile(
//                               title: Text(
//                                 "Investment",
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                               leading: CircleAvatar(
//                                 backgroundColor: Colors.transparent,
//                                 backgroundImage: NetworkImage(
//                                     "https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fdollar-black.png?alt=media&token=ab728699-fa1a-44dd-9ef8-42a42a658a12"),
//                               ),
//                               trailing: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: <Widget>[
//                                   (_investment != null)
//                                       ? Text(
//                                           "\$" + _investment,
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 18),
//                                         )
//                                       : Text(
//                                           "\$",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 18),
//                                         )
//                                 ],
//                               ),
//                               onTap: () {},
//                             ),
//                             ListTile(
//                               title: Text(
//                                 "Reward Points:",
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                               leading: CircleAvatar(
//                                 backgroundImage: NetworkImage(""),
//                               ),
//                               trailing: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: <Widget>[
//                                   (_rewardPoints != null)
//                                       ? Text(
//                                           "\$" + _rewardPoints,
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 18),
//                                         )
//                                       : Text(
//                                           "\$",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 18),
//                                         )
//                                 ],
//                               ),
//                               onTap: () {},
//                             ),
//                           ],
//                         );
//                   }
//                 },
//               ),
// //              SizedBox(
// //                width: 340.0,
// //                child: ListView.builder(
// //                    physics: ClampingScrollPhysics(),
// //                    shrinkWrap: true,
// //                    scrollDirection: Axis.vertical,
// //                    itemCount: 4,
// //                    itemBuilder: (BuildContext context, int index) => _item(context, index)
// //                ),
// //              ),
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
//                           navigateToStartingInstructions(context);
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
//                 height: 20,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
