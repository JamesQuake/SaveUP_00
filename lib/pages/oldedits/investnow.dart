// import 'dart:async';
// // import 'dart:ffi';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:pay_or_save/assets/main_drawer.dart';
// import 'package:pay_or_save/models/account_model.dart';
// // import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:pay_or_save/models/investment_goal_model.dart';
// import 'package:pay_or_save/pages/congratulation_investment.dart';
// import 'package:pay_or_save/pages/overdraft.dart';
// import 'package:pay_or_save/utilities/validator.dart';
// import 'package:pay_or_save/widgets/invest_chart.dart';
// // import 'package:pay_or_save/widgets/menu.dart';
// import 'dart:math' as math;
// import 'package:percent_indicator/linear_percent_indicator.dart';

// class InvNow extends StatefulWidget {
//   final String uid, selectedAccount;
//   final InvestmentModel accountModel;

//   @override
//   _InvNowState createState() =>
//       _InvNowState(uid, selectedAccount, accountModel);

//   InvNow({Key key, @required this.uid, this.selectedAccount, this.accountModel})
//       : super(key: key);
// }

// class _InvNowState extends State<InvNow> {
//   String _uid, _total, _percents, _investPercents, selectedAccount, _time;
//   int orderPercentage, stockPercentage, years;
//   double _checking, _investment, _rewardPoints, _orderAmount, res, _willBeWorth;
//   double x = 0.0;
//   double totalInvested = 0.0;
//   List<AccountModel> _list;
//   InvestmentModel accountModel;
//   List<TimeSeriesSales> data = [];
//   final firestoreInstance = FirebaseFirestore.instance;

//   var itemsOrderPercentage = {
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
//   var itemsOrderStockPercentage = {
//     '5%': '5',
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
//   var itemsYears = {
//     '1 year': '1',
//     '2 years': '2',
//     '3 years': '3',
//     '4 years': '4',
//     '5 years': '5',
//     '6 years': '6',
//     '7 years': '7',
//     '8 years': '8',
//     '9 years': '9',
//     '10 years': '10'
//   };

//   _InvNowState(this._uid, this.selectedAccount, this.accountModel);

//   @override
//   void initState() {
//     super.initState();
//     _list = List<AccountModel>();
//     _orderAmount = 100;
//     orderPercentage = 0;
//     stockPercentage = 0;
//     _willBeWorth = 0;
//     years = 0;
//     res = 0;
//   }

//   @override
//   void dispose() {
//     super.dispose();
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

//   Future navigateToCongratulations(context) async {
//     double x = convertToDecimal(accountModel.amount, accountModel.goalAmount);
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => CongratulationsInvestment(
//                   uid: _uid,
//                   investmentModel: accountModel,
//                   investAmount: _investment.toString(),
//                   savedPerSession: totalInvested.toString(),
//                   decimalForProgress: x,
//                 )));
//   }

//   _getBalances() {
//     return firestoreInstance.collection("users").doc(_uid).get().then((value) {
//       _checking = value.data()['checking'].toDouble();
//       _investment = value.data()['investment'].toDouble();
//       _rewardPoints = value.data()['reward_points'].toDouble();
//     }).then((v) {
//       _list.add(AccountModel(
//           "https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fdollar-black.png?alt=media&token=ab728699-fa1a-44dd-9ef8-42a42a658a12",
//           "Total investment",
//           _investment.toStringAsFixed(2),
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

//   drawChart() {
//     if (years != 0 &&
//         _orderAmount != 0 &&
//         stockPercentage != 0 &&
//         orderPercentage != 0) {
//       res = (_orderAmount / 100) * orderPercentage;
//       List<int> yearsArr = [];
//       List<double> profit = [];
//       for (int i = 0; i <= years; i++) {
//         yearsArr.add(i);
//         if (i == 0) {
//           var a = (res *
//               math.pow((1 + (stockPercentage / (12 * 100))), (12 * years)));
//           profit.add(double.parse(a.toStringAsFixed(2)));
// //          console.log(i+" "+profit[i])
//         } else {
//           var b = (profit[i - 1] *
//               math.pow((1 + (stockPercentage / (12 * 100))), (12 * years)));
//           profit.add(double.parse(b.toStringAsFixed(2)));
// //          console.log(i+" "+profit[i])
//         }
//       }
//       data = [];
//       int month = new DateTime.now().month;
//       int day = new DateTime.now().month;
//       _willBeWorth = profit.last;
//       for (int i = 0; i < profit.length; i++) {
//         data.add(
//           new TimeSeriesSales(new DateTime(2020 + i, month, day), profit[i]),
//         );
//       }
//     }
//   }

//   investAmount() {
//     if (_orderAmount >= 1 && _orderAmount >= res) {
//       if (_checking < 0) {
//         navigateToOverdraft(context);
//       } else {
//         x = num.parse(res.toStringAsFixed(2));
//         var c = _checking - x;
//         var s = _investment + x;
//         var r = _rewardPoints + x;
//         var calcChecking = num.parse(c.toStringAsFixed(2));
//         var calcInvest = num.parse(s.toStringAsFixed(2));
//         var calcReward = num.parse(r.toStringAsFixed(2));
//         firestoreInstance.collection("users").doc(_uid).update({
//           "checking": calcChecking,
//           "investment": calcInvest,
//           "reward_points": calcReward
//         }).then((_) {
//           totalInvested = totalInvested + x;
//           var a = double.parse(accountModel.amount) + x;
//           firestoreInstance
//               .collection("investmentGoals")
//               .doc("users")
//               .collection(_uid)
//               .doc(accountModel.key)
//               .update({
//             "investAmount": a,
//           });
//         }).then((_) {
//           var goalAmount = double.parse(accountModel.amount);
//           goalAmount = goalAmount + x;
//           setState(() {
//             _orderAmount = _orderAmount - x;
//             accountModel.amount = goalAmount.toStringAsFixed(2);
//             _list[0].amount = (_investment + x).toStringAsFixed(2);
//             _list[1].amount = (_checking - x).toStringAsFixed(2);
//             _list[2].amount = (_rewardPoints + x).toStringAsFixed(2);
//             x = (_orderAmount / 100) * orderPercentage;
//             drawChart();
//             if (_checking < 0) {
//               navigateToOverdraft(context);
//             }
//           });
//         });
//       }
//     } else {
//       Validator.onErrorDialog(
//           "You cannot save more than your order amount!", context);
//     }
//   }

//   double convertToDecimal(amount, goal) {
//     ///parse here should return null, incase of runtime error
//     if (double.tryParse(goal) == double.parse(amount)) {
//       return 1;
//     } else {
//       if (amount == "10") {
//         return 0.01;
//       }

//       ///parse here should return null, incase of runtime error
//       var res = (double.tryParse(amount).floor() / double.parse(goal).floor());

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
//         leading: CircleAvatar(
//           backgroundColor: Colors.transparent,
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
//         backgroundColor: Color(0xff0070c0),
//         title: Text(
//           'Invest Now',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         centerTitle: true,
//         elevation: 0.0,
//       ),
//       endDrawer: MainDrawer(uid: widget.uid),
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
//                         ? Text('I want to invest XX% of order amount')
//                         : Text(
//                             _percents,
//                             style: TextStyle(color: Colors.black),
//                           ),
//                     isExpanded: true,
//                     iconSize: 30.0,
//                     style: TextStyle(color: Colors.blue, fontSize: 20),
//                     items: itemsOrderPercentage.entries
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
//                           orderPercentage = int.parse(val);
//                           drawChart();
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
//                         "Total investment:",
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
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.only(right: 8),
//                         child: Text(
//                           "Which will be worth:",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 20),
//                         ),
//                       ),
//                       Flexible(
//                         child: Text(
//                           "\$" + _willBeWorth.toString(),
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 2,
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 20),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 16,
//                   ),
//                   DropdownButton(
//                     hint: _investPercents == null
//                         ? Text('When invest at:')
//                         : Text(
//                             _investPercents,
//                             style: TextStyle(color: Colors.black),
//                           ),
//                     isExpanded: true,
//                     iconSize: 30.0,
//                     style: TextStyle(color: Colors.blue, fontSize: 20),
//                     items: itemsOrderStockPercentage.entries
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
//                           _investPercents = val + "%";
//                           stockPercentage = int.parse(val);
//                           drawChart();
//                         },
//                       );
//                     },
//                   ),
//                   SizedBox(
//                     height: 16,
//                   ),
//                   DropdownButton(
//                     hint: _time == null
//                         ? Text('For:')
//                         : Text(
//                             _time,
//                             style: TextStyle(color: Colors.black),
//                           ),
//                     isExpanded: true,
//                     iconSize: 30.0,
//                     style: TextStyle(color: Colors.blue, fontSize: 20),
//                     items: itemsYears.entries
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
//                           _time = val + " years";
//                           years = int.parse(val);
//                           drawChart();
//                         },
//                       );
//                     },
//                   ),
//                   SizedBox(
//                     height: 16,
//                   ),
//                   (data.isNotEmpty)
//                       ? Container(
//                           height: 200,
//                           child: SimpleTimeSeriesChart.withSampleData(data))
//                       : Container(),
//                   SizedBox(
//                     height: 16,
//                   ),
//                   Container(
//                     child: ListTile(
//                       title: Text(
//                         // accountModel.goal ?? '0',,
//                         '90',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       subtitle: LinearPercentIndicator(
//                         width: 140.0,
//                         lineHeight: 14.0,
//                         percent: convertToDecimal(accountModel.amount ?? '0',
//                             accountModel.goalAmount ?? '0'),
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
//                           minWidth: 150,
//                           height: 50.0,
//                           child: RaisedButton(
//                             textColor: Colors.white,
//                             color: Colors.green,
//                             child: Text("Invest"),
//                             onPressed: () {
//                               investAmount();
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
//                           minWidth: 150,
//                           height: 50.0,
//                           child: RaisedButton(
//                             textColor: Colors.white,
//                             color: Color(0xFFb396da),
//                             child: Text("Done"),
//                             onPressed: () {
//                               navigateToCongratulations(context);
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
