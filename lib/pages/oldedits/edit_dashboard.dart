// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:pay_or_save/assets/main_drawer.dart';
// import 'package:pay_or_save/models/account_model.dart';
// import 'package:pay_or_save/models/investment_goal_model.dart';
// import 'package:pay_or_save/models/saving_goal_model.dart';
// import 'package:pay_or_save/pages/edit_investment_goal.dart';
// import 'package:pay_or_save/pages/edit_saving_goal.dart';
// import 'package:pay_or_save/pages/home_video.dart';
// import 'package:pay_or_save/pages/sign_in.dart';
// import 'package:pay_or_save/widgets/menu.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';

// class DashBoard extends StatefulWidget {
//   final String uid;

//   @override
//   _DashBoardState createState() => _DashBoardState(uid);

//   DashBoard({Key key, @required this.uid}) : super(key: key);
// }

// class _DashBoardState extends State<DashBoard> {
//   String _uid, _checking, _savings, _investment, _rewardPoints;
//   List<AccountModel> _list;
//   List<SavingModel> _listSavings;
//   List<InvestmentModel> _listInvestment;
//   final firestoreInstance = FirebaseFirestore.instance;
//   Future<List<SavingModel>> _futureSavings;
//   Future<List<InvestmentModel>> _futureInvestments;

//   _DashBoardState(this._uid);

//   @override
//   void initState() {
//     super.initState();
//     _getBalances();
//     _listInvestment = List<InvestmentModel>();
//     _listSavings = List<SavingModel>();
//     _futureSavings = getSavingsItems();
//     _futureInvestments = getInvestmentItems();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   Future navigateSignOut(context) async {
//     Navigator.pushReplacement(context,
//         MaterialPageRoute(builder: (context) => SignInRegistrationPage()));
//   }

//   Future navigateEditSavingGoal(context, SavingModel model) async {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => EditSavingGoal(
//                   uid: _uid,
//                   savingModel: model,
//                 )));
//   }

//   Future navigateEditInvestmentGoal(context, InvestmentModel model) async {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => EditInvestmentGoal(
//                   uid: _uid,
//                   investmentModel: model,
//                 )));
//   }

//   _signOutT() async {
//     await FirebaseAuth.instance.signOut().then((v) {
//       navigateSignOut(context);
//     });
//   }

//   _getBalances() {
//     firestoreInstance.collection("users").doc(_uid).get().then((value) {
//       _checking = value.data()['checking'].toStringAsFixed(2);
//       _savings = value.data()['savings'].toStringAsFixed(2);
//       _investment = value.data()['investment'].toStringAsFixed(2);
//       _rewardPoints = value.data()['reward_points'].toStringAsFixed(2);
//       setState(() {});
//     });
//   }

//   double convertToDecimal(amount, goal) {
//     ///parse here should return a null value (incase of runtime error)
//     if (double.tryParse(goal) == double.tryParse(amount)) {
//       return 1;
//     } else {
// //      if(amount == "10"){
// //        return 0.01;
// //      }
//       var view = double.parse(goal);
//       print('THISISIT');
//       print(view);
//       var res =
//           (double.tryParse(amount).floor() / double.tryParse(goal).floor());

//       ///parse here should return a null value (incase of runtime error)
// //      var s = res.floor();
// //      var a = "0."+s.toString();
// //      return double.parse(a);
//       return res;
//     }
//   }

//   Future<List<SavingModel>> getSavingsItems() async {
//     return firestoreInstance
//         .collection("savingGoals")
//         .doc('users')
//         .collection(_uid)
//         .get()
//         .then((querySnapshot) {
//       // print('fromHERE');
//       // print(querySnapshot);
//       _listSavings = List<SavingModel>();
//       querySnapshot.docs.forEach((result) {
//         // print(result);
//         _listSavings.add(SavingModel.fromJson(result.id, result.data()));
//       });
//     }).then((value) {
//       // print(value);
//       // print(_listSavings);
//       return _listSavings;
//     });
//   }

//   Future<List<InvestmentModel>> getInvestmentItems() async {
//     return firestoreInstance
//         .collection("investmentGoals")
//         .doc('users')
//         .collection(_uid)
//         .get()
//         .then((querySnapshot) {
//       _listInvestment = List<InvestmentModel>();
//       querySnapshot.docs.forEach((result) {
//         _listInvestment.add(InvestmentModel.fromJson(result.id, result.data()));
//       });
//     }).then((value) {
//       return _listInvestment;
//     });
//   }

//   Widget _itemSavings(BuildContext context, int index) {
//     return Container(
//       child: ListTile(
//         title: Text(
//           _listSavings[index].goal,
//           style: TextStyle(fontSize: 16),
//         ),
//         subtitle: LinearPercentIndicator(
//           width: 80.0,
//           lineHeight: 8.0,
//           percent: convertToDecimal(
//             _listSavings[index].amount,
//             _listSavings[index].goalAmount,
//           ),
//           backgroundColor: Colors.grey,
//           progressColor: Color(0xFF17bf4f),
//         ),
//         leading: CircleAvatar(
//           backgroundImage: AssetImage(_listSavings[index].url),
//         ),
//         trailing: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               NumberFormat.simpleCurrency(locale: "en-us", decimalDigits: 0)
//                   .format(int.parse(_listSavings[index].goalAmount)),
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             Text(
//               NumberFormat.simpleCurrency(
//                 locale: "en-us",
//                 decimalDigits: 0,
//               ).format(int.parse(_listSavings[index].amount)),
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//         onTap: () {
//           navigateEditSavingGoal(context, _listSavings[index]);
//         },
//       ),
//     );
//   }

//   Widget _itemInvestment(BuildContext context, int index) {
//     return Container(
//       child: ListTile(
//         title: Text(
//           _listInvestment[index].goal,
//           style: TextStyle(fontSize: 16),
//         ),
//         subtitle: LinearPercentIndicator(
//           width: 80.0,
//           lineHeight: 8.0,
//           percent: convertToDecimal(
//               _listInvestment[index].amount, _listInvestment[index].goalAmount),
//           backgroundColor: Colors.grey,
//           progressColor: Color(0xFF17bf4f),
//         ),
//         leading: CircleAvatar(
//           backgroundImage: AssetImage(_listInvestment[index].url),
//         ),
//         trailing: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               NumberFormat.simpleCurrency(locale: "en-us", decimalDigits: 0)
//                   .format(int.parse(_listInvestment[index].goalAmount)),
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             Text(
//               NumberFormat.simpleCurrency(
//                 locale: "en-us",
//                 decimalDigits: 0,
//               ).format(int.parse(_listInvestment[index].amount)),
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             )
//           ],
//         ),
//         onTap: () {
//           navigateEditInvestmentGoal(context, _listInvestment[index]);
//         },
//       ),
//     );
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
//         title: Text('Dashboard'),
//         centerTitle: true,
//         elevation: 0.0,
//       ),
//       endDrawer: MainDrawer(),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.all(24),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.max,
//                     children: <Widget>[
//                       SizedBox(
//                         height: 16,
//                       ),
//                       Text(
//                         "Virtual Balances",
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(
//                         height: 16,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Text(
//                             "Account",
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             "Current",
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                       Divider(
//                         thickness: 1.5,
//                       ),
//                       ListTile(
//                         title: Text(
//                           "Checking:",
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         leading: CircleAvatar(
//                           backgroundImage: NetworkImage(
//                               "https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fcheking-icon.png?alt=media&token=9d278e21-7097-453c-b253-187a700d03bc"),
//                         ),
//                         trailing: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             (_checking != null)
//                                 ? Text(
//                                     "\$" + _checking,
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18),
//                                   )
//                                 : Text(
//                                     "\$",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18),
//                                   )
//                           ],
//                         ),
//                         onTap: () {},
//                       ),
//                       ListTile(
//                         title: Text(
//                           "Savings:",
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         leading: CircleAvatar(
//                           backgroundImage: NetworkImage(
//                               "https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fdollar-green.png?alt=media&token=b1720f47-5c6b-4c57-a37c-98884f8590c1"),
//                         ),
//                         trailing: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             (_savings != null)
//                                 ? Text(
//                                     "\$" + _savings,
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18),
//                                   )
//                                 : Text(
//                                     "\$",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18),
//                                   )
//                           ],
//                         ),
//                         onTap: () {},
//                       ),
//                       ListTile(
//                         title: Text(
//                           "Investment",
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         leading: CircleAvatar(
//                           backgroundColor: Colors.transparent,
//                           backgroundImage: NetworkImage(
//                               "https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fdollar-black.png?alt=media&token=ab728699-fa1a-44dd-9ef8-42a42a658a12"),
//                         ),
//                         trailing: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             (_investment != null)
//                                 ? Text(
//                                     "\$" + _investment,
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18),
//                                   )
//                                 : Text(
//                                     "\$",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18),
//                                   )
//                           ],
//                         ),
//                         onTap: () {},
//                       ),
//                       ListTile(
//                         title: Text(
//                           "Reward Points:",
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         leading: CircleAvatar(
//                           backgroundImage: AssetImage(
//                               "assets/images/Accounts/AcctReward.png"),
//                         ),
//                         trailing: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             (_rewardPoints != null)
//                                 ? Text(
//                                     "\$" + _rewardPoints,
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18),
//                                   )
//                                 : Text(
//                                     "\$",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18),
//                                   )
//                           ],
//                         ),
//                         onTap: () {},
//                       ),
//                       SizedBox(
//                         height: 16,
//                       ),
//                       Divider(
//                         thickness: 1.5,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Text(
//                             "Savings",
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                           Column(
//                             children: <Widget>[
//                               Text(
//                                 "Goal",
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                               Text(
//                                 "Current",
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       Divider(
//                         thickness: 1.5,
//                         // color: Colors.black,
//                       ),
//                       SizedBox(
//                         height: 16,
//                       ),
//                       FutureBuilder<List<SavingModel>>(
//                         future: _futureSavings, // async work
//                         builder: (BuildContext context, snapshot) {
//                           switch (snapshot.connectionState) {
//                             case ConnectionState.waiting:
//                               return new Text('Loading....');
//                             default:
//                               if (snapshot.hasError)
//                                 return new Text('Error: ${snapshot.error}');
//                               else
//                                 return ListView.builder(
//                                   physics: NeverScrollableScrollPhysics(),
//                                   scrollDirection: Axis.vertical,
//                                   shrinkWrap: true,
//                                   itemCount: (snapshot.data != null)
//                                       ? snapshot.data.length
//                                       : 0,
//                                   itemBuilder:
//                                       (BuildContext context, int index) {
//                                     return _itemSavings(context, index);
//                                   },
//                                 );
//                           }
//                         },
//                       ),
//                       SizedBox(
//                         height: 16,
//                       ),
//                       Divider(
//                         thickness: 1.5,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Text(
//                             "Investment",
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                           Column(
//                             children: <Widget>[
//                               Text(
//                                 "Goal",
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                               Text(
//                                 "Current",
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       Divider(
//                         thickness: 1.5,
//                       ),
//                       SizedBox(
//                         height: 16,
//                       ),
//                       FutureBuilder<List<InvestmentModel>>(
//                         future: _futureInvestments, // async work
//                         builder: (BuildContext context, snapshot) {
//                           switch (snapshot.connectionState) {
//                             case ConnectionState.waiting:
//                               return new Text('Loading....');
//                             default:
//                               if (snapshot.hasError)
//                                 return new Text('Error: ${snapshot.error}');
//                               else
//                                 return ListView.builder(
//                                   physics: NeverScrollableScrollPhysics(),
//                                   scrollDirection: Axis.vertical,
//                                   shrinkWrap: true,
//                                   itemCount: (snapshot.data != null)
//                                       ? snapshot.data.length
//                                       : 0,
//                                   itemBuilder:
//                                       (BuildContext context, int index) {
//                                     return _itemInvestment(context, index);
//                                   },
//                                 );
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//             child: ButtonTheme(
//               minWidth: double.infinity,
//               height: 50.0,
//               child: RaisedButton(
//                 textColor: Colors.white,
//                 color: Color(0xff0070c0),
//                 child: Text(
//                   "Log Out",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                 ),
//                 onPressed: () {
//                   _signOutT();
//                   // getSavingsItems();
//                   // convertToDecimal(_listSavings[index].amount,
//                   //     _listSavings[index].goalAmount);
//                 },
//                 shape: new RoundedRectangleBorder(
//                   borderRadius: new BorderRadius.circular(10.0),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
