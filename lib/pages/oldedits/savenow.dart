// import 'dart:async';
// import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:pay_or_save/models/account_model.dart';
// import 'package:pay_or_save/models/saving_goal_model.dart';
// import 'package:pay_or_save/pages/congratulation_saving.dart';
// import 'package:pay_or_save/pages/invest_now.dart';
// import 'package:pay_or_save/pages/overdraft.dart';
// import 'package:pay_or_save/utilities/validator.dart';
// import 'package:pay_or_save/widgets/menu.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';

// class SaveNow extends StatefulWidget {
//   final String uid, selectedAccount;
//   final SavingModel accountModel;

//   @override
//   _SaveNowState createState() =>
//       _SaveNowState(uid, selectedAccount, accountModel);

//   SaveNow(
//       {Key key, @required this.uid, this.selectedAccount, this.accountModel})
//       : super(key: key);
// }

// class _SaveNowState extends State<SaveNow> {
//   String _uid, _total, _percents, selectedAccount;
//   int countPecentage;
//   double _checking, _savings, _rewardPoints, _orderAmount, res, totalSaved;
//   List<AccountModel> _list;
//   var x;
//   SavingModel accountModel;
//   final firestoreInstance = Firestore.instance;
//   var items = {
//     '10%': '10',
//     '20%': '20',
//     '30%': '30',
//     '40%': '40',
//     '50%': '50',
//     '60%': '60',
//     '70%': '70',
//     '80%': '80',
//     '90%': '90',
//     '100%': '100'
//   };

//   _SaveNowState(this._uid, this.selectedAccount, this.accountModel);

//   @override
//   void initState() {
//     super.initState();
//     _list = List<AccountModel>();
//     totalSaved = 0.0;
//     _orderAmount = 100;
//     countPecentage = 0;
//     res = 0;
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   Future navigateToCongradulations(context) async {
//     double x = convertToDecimal(accountModel.amount, accountModel.goalAmount);
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => CongratulationsSaving(
//                   uid: _uid,
//                   savingModel: accountModel,
//                   savingAmount: _savings.toString(),
//                   savedPerSession: totalSaved.toString(),
//                   decimalForProgress: x,
//                 )));
//   }

//   Future navigateToOverdraft(context) async {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => Overdraft(
//                   uid: _uid,
//                   overdraftAmount: _checking,
//                 )));
//   }

//   _getBalances() {
//     return firestoreInstance
//         .collection("users")
//         .document(_uid)
//         .get()
//         .then((value) {
//       _checking = value.data['checking'].toDouble();
//       _savings = value.data['savings'].toDouble();
//       _rewardPoints = value.data['reward_points'].toDouble();
//     }).then((v) {
//       _list.add(AccountModel(
//           "https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fdollar-green.png?alt=media&token=b1720f47-5c6b-4c57-a37c-98884f8590c1",
//           "Total Savings",
//           _savings.toStringAsFixed(2),
//           ''));
//       _list.add(AccountModel(
//           "https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fcheking-icon.png?alt=media&token=9d278e21-7097-453c-b253-187a700d03bc",
//           "Checking account balance",
//           _checking.toStringAsFixed(2),
//           ''));
//       _list.add(AccountModel(
//           "", "Reward Point balance", _rewardPoints.toStringAsFixed(2), ''));
//       return _list;
//     });
//   }

//   saveAmount() {
//     if (_orderAmount >= 1 &&
//         _orderAmount >= res &&
//         countPecentage != 0 &&
//         countPecentage != null) {
//       if (_checking < 0) {
//         navigateToOverdraft(context);
//       } else {
//         x = num.parse(res.toStringAsFixed(2));
//         var c = _checking - x;
//         var s = _savings + x;
//         var r = _rewardPoints + x;
//         var calcChecking = num.parse(c.toStringAsFixed(2));
//         var calcSavings = num.parse(s.toStringAsFixed(2));
//         var calcReward = num.parse(r.toStringAsFixed(2));
//         firestoreInstance.collection("users").document(_uid).updateData({
//           "checking": calcChecking,
//           "savings": calcSavings,
//           "reward_points": calcReward
//         }).then((_) {
//           totalSaved = totalSaved + x;

//           var a = double.parse(accountModel.amount) + x;
//           firestoreInstance
//               .collection("savingGoals")
//               .document("users")
//               .collection(_uid)
//               .document(accountModel.key)
//               .updateData({
//             "savingAmount": a,
//           });
//         }).then((_) {
//           var goalAmount = double.parse(accountModel.amount);
//           goalAmount = goalAmount + x;
//           setState(() {
//             _orderAmount = _orderAmount - x;
//             accountModel.amount = goalAmount.toStringAsFixed(2);
//             _list[0].amount = (_savings + x).toStringAsFixed(2);
//             _list[1].amount = (_checking - x).toStringAsFixed(2);
//             _list[2].amount = (_rewardPoints + x).toStringAsFixed(2);
//             res = (_orderAmount / 100) * countPecentage;
//             x = (_orderAmount / 100) * countPecentage;
//           });
//         });
//       }
//     } else {
//       Validator.onErrorDialog(
//           "You cannot save more than your order amount!", context);
//     }
//   }

//   double convertToDecimal(amount, goal) {
//     if (double.parse(goal) == double.parse(amount)) {
//       return 1;
//     } else {
//       var res = (double.parse(amount).floor() / double.parse(goal).floor());
// //      var s = res.floor();
// //      var a = "0."+s.toString();
// //      return double.parse(a);
//       return res;
//     }
//   }

//   Widget _item(BuildContext context, int index) {
//     return Container(
//       child: ListTile(
//         title: Text(
//           _list[index].title,
//           style: TextStyle(fontSize: 16),
//         ),
//         subtitle: (index == 0)
//             ? LinearPercentIndicator(
//                 width: 140.0,
//                 lineHeight: 14.0,
//                 percent: 0.1,
//                 backgroundColor: Colors.grey,
//                 progressColor: Colors.blue,
//               )
//             : Container(),
//         leading: CircleAvatar(
//           backgroundImage: NetworkImage(_list[index].url),
//         ),
//         trailing: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               "\$" + double.parse(_list[index].amount).toStringAsFixed(2),
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
//         automaticallyImplyLeading: false,
//         actions: <Widget>[MyManue.childPopup(context)],
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text("Save Now"),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Container(
//               height: 80,
//               color: Colors.deepPurple,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Text(
//                     "Order amount = \$" + _orderAmount.toString(),
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                         color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 16,
//             ),
//             Padding(
//               padding: EdgeInsets.only(left: 24, right: 24),
//               child: Column(
//                 children: <Widget>[
//                   DropdownButton(
//                     hint: _percents == null
//                         ? Text('I want to save XX% of order amount')
//                         : Text(
//                             _percents,
//                             style: TextStyle(color: Colors.black),
//                           ),
//                     isExpanded: true,
//                     iconSize: 30.0,
//                     style: TextStyle(color: Colors.blue, fontSize: 20),
//                     items: items.entries
//                         .map<DropdownMenuItem<String>>(
//                             (MapEntry<String, String> e) =>
//                                 DropdownMenuItem<String>(
//                                   value: e.value,
//                                   child: Text(e.key),
//                                 ))
//                         .toList(),
//                     onChanged: (val) {
//                       setState(
//                         () {
//                           _percents = val + "%";
//                           countPecentage = int.parse(val);
//                           res = (_orderAmount / 100) * int.parse(val);
//                         },
//                       );
//                     },
//                   ),
//                   SizedBox(
//                     height: 26,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Text(
//                         "Total Savings:",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 20),
//                       ),
//                       Text(
//                         "\$" + res.toStringAsFixed(2),
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 20),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 30,
//                   ),
//                   Container(
//                     child: ListTile(
//                       title: Text(
//                         accountModel.goal,
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       subtitle: LinearPercentIndicator(
//                         width: 140.0,
//                         lineHeight: 14.0,
//                         percent: convertToDecimal(
//                             accountModel.amount, accountModel.goalAmount),
//                         backgroundColor: Colors.grey,
//                         progressColor: Color(0xFF17bf4f),
//                       ),
//                       leading: CircleAvatar(
//                         backgroundImage: NetworkImage(accountModel.url),
//                       ),
//                       trailing: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Text(
//                             "\$" +
//                                 double.parse(accountModel.amount)
//                                     .toStringAsFixed(2),
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 18),
//                           )
//                         ],
//                       ),
//                       onTap: () {},
//                     ),
//                   ),
//                   FutureBuilder(
//                     future: _getBalances(), // async work
//                     builder: (BuildContext context, snapshot) {
//                       switch (snapshot.connectionState) {
//                         case ConnectionState.waiting:
//                           return new Text('Loading....');
//                         default:
//                           if (snapshot.hasError)
//                             return new Text('Error: ${snapshot.error}');
//                           else
//                             return ListView.builder(
//                               scrollDirection: Axis.vertical,
//                               shrinkWrap: true,
//                               itemCount: (snapshot.data != null) ? 3 : 0,
//                               itemBuilder: (BuildContext context, int index) {
//                                 return _item(context, index);
//                               },
//                             );
//                       }
//                     },
//                   ),
//                   SizedBox(
//                     height: 30,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: <Widget>[
//                       Padding(
//                         padding: EdgeInsets.only(left: 0.0, right: 0.0),
//                         child: ButtonTheme(
//                           minWidth: 120.0,
//                           height: 50.0,
//                           child: RaisedButton(
//                             textColor: Colors.white,
//                             color: Colors.green,
//                             child: Text("Save"),
//                             onPressed: () {
//                               saveAmount();
//                             },
//                             shape: new RoundedRectangleBorder(
//                               borderRadius: new BorderRadius.circular(10.0),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(left: 0.0, right: 0.0),
//                         child: ButtonTheme(
//                           minWidth: 120.0,
//                           height: 50.0,
//                           child: RaisedButton(
//                             textColor: Colors.white,
//                             color: Color(0xFF660066),
//                             child: Text("Next"),
//                             onPressed: () {
//                               navigateToCongradulations(context);
//                             },
//                             shape: new RoundedRectangleBorder(
//                               borderRadius: new BorderRadius.circular(10.0),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
