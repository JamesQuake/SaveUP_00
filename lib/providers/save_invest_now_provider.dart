// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:developer' as dev;

// // import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'dart:math' as math;

// import '../models/investment_goal_model.dart';
// import '../utilities/validator.dart';
// import '../widgets/invest_chart.dart';
// import 'total_provider.dart';

// class SaveInvestNowProvider extends ChangeNotifier {
//   String _uid, _total, _investPercents, selectedAccount, _time, _percents;
//   int orderPercentage, stockPercentage, years;
//   double _investment, res, _orderAmount, _willBeWorth;
//   int _checking, _rewardPoints;
//   double x = 0.0;
//   double totalInvested = 0.0;
//   // List<AccountModel> _list;
//   InvestmentModel accountModel;
//   List<TimeSeriesSales> data = [];
//   final firestoreInstance = FirebaseFirestore.instance;
//   List<InvestmentModel> _listInvestment;
//   Future<List<InvestmentModel>> _futureInvestments;
//   List _investToDateList;
//   List _investTotalList;
//   int investTotal;
//   int investToDate;
//   List _highlightedIndex;
//   bool _isSelected = false;
//   dynamic _getInvBal;
//   int _investValueItem;
//   // SharedPreferences _prefs;
//   double _investOrderAmount;
//   bool _editedGoal = false;
//   bool _undoEdited = false;
//   int percentage = 100;
//   int iPercent = 10;
//   int iYears = 10;
//   Future<int> _invToDateTot;
//   Future<int> _invTotalVal;
//   String _incomingRoute = '/invest_now';
//   String _modelId;
//   InvestmentModel updatedModel;
//   String currentInvestAmount;
//   double totalInv;
//   double _undoAmount;
//   InvestmentModel _editedModel;
//   bool _activeEdit = false;
//   List investValues = [];
//   int _savedIndex;
//   bool goalSaved = false;

//   int acceptDrag = 0;

//   bool _isFav = false;

//   drawChart() {
//     if (_orderAmount != 0 && stockPercentage != 0) {
//       res = (_orderAmount / 100) * orderPercentage;
//       List<int> yearsArr = [];
//       List<double> profit = [];
//       for (int i = 0; i <= years; i++) {
//         yearsArr.add(i);
//         if (i == 0) {
//           var a = res;
//           profit.add(double.parse(a.toStringAsFixed(2)));
//         } else {
//           var b = (res * math.pow((1 + (stockPercentage / 100)), i));
//           profit.add(double.parse(b.toStringAsFixed(2)));
//         }
//       }
//       data = [];
//       int month = new DateTime.now().month;
//       int day = new DateTime.now().day;
//       _willBeWorth = profit.last;
//       for (int i = 0; i < profit.length; i++) {
//         data.add(
//           new TimeSeriesSales(new DateTime(2022 + i, month, day), profit[i]),
//         );
//       }
//       if (orderPercentage == 0 || years == 0) {
//         // setState(() {
//         //   _willBeWorth = 0;
//         //   res = 0;
//         // });
//       }
//     } else {
//       // setState(() {
//       //   _willBeWorth = 0;
//       //   res = 0;
//       // });
//     }
//   }

//   selectInvestGoalDialog(BuildContext context) {
//     // set up the buttons
//     Widget okButton = TextButton(
//       child: Text(
//         "OK",
//         style: TextStyle(
//           color: Color(0xff0070c0),
//         ),
//       ),
//       onPressed: () {
//         Navigator.of(context).pop();
//       },
//     );

//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       elevation: 4.0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(30.0),
//       ),
//       content: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             '•',
//             style: TextStyle(
//               fontSize: 45.0.h,
//               height: 1.2,
//               color: Color(0xff0070c0),
//             ),
//           ),
//           SizedBox(
//             width: 5.0.w,
//           ),
//           Text(
//             'Please select a goal.',
//             style: TextStyle(
//               fontSize: 19.0.h,
//               color: Color(0xff0070c0),
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         okButton,
//       ],
//     );

//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }

//   showAlertDialog(BuildContext context) {
//     // set up the button
//     Widget okButton = TextButton(
//       child: Text("OK"),
//       onPressed: () {
//         Navigator.of(context).pop();
//       },
//     );

//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       elevation: 4.0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(30.0),
//       ),
//       content: SingleChildScrollView(
//         child: Column(
//           children: [
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 'ACCOUNT BALANCES',
//                 // textAlign: TextAlign.left,
//                 style: TextStyle(
//                   fontWeight: FontWeight.w800,
//                   fontSize: 17.0.h,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 15.0,
//             ),
//             RichText(
//               text: TextSpan(
//                 style: TextStyle(
//                   color: Colors.black,
//                   height: 1.2,
//                   fontSize: 18.h,
//                 ),
//                 children: [
//                   TextSpan(
//                     text: 'Checking Account. ',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 17.0.h,
//                     ),
//                   ),
//                   TextSpan(
//                     text:
//                         "When you invest, you transfer money from your checking account, where you're likely to spend it on just another good time, to your investment account, where it can accumulate and grow.",
//                     style: TextStyle(
//                       fontSize: 17.0.h,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 20.0.h,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   height: 35.h,
//                   width: 35.w,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                         image: AssetImage(
//                             'assets/images/Accounts/AcctChecking.png')),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 7.0.w,
//                 ),
//                 Icon(
//                   Icons.trending_flat,
//                   size: 50.h,
//                   color: Colors.black,
//                 ),
//                 SizedBox(
//                   width: 7.0.w,
//                 ),
//                 Container(
//                   height: 35.h,
//                   width: 35.w,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                         image: AssetImage(
//                             'assets/images/Accounts/AcctInvestment.png')),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 20.0.h,
//             ),
//             RichText(
//               text: TextSpan(
//                 style: TextStyle(
//                   color: Colors.black,
//                   height: 1.2,
//                   fontSize: 17.h,
//                 ),
//                 children: [
//                   TextSpan(
//                     text: 'Reward Points. ',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 17.0.h,
//                     ),
//                   ),
//                   TextSpan(
//                     text:
//                         "You earn one reward point for every dollar that you invest.",
//                     style: TextStyle(
//                       fontSize: 17.h,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 20.0.h,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Container(
//                 //   height: 35,
//                 //   width: 35,
//                 //   decoration: BoxDecoration(
//                 //     image: DecorationImage(
//                 //         image: AssetImage(
//                 //             'assets/images/Accounts/AcctInvestment.png')),
//                 //   ),
//                 // ),
//                 // SizedBox(
//                 //   width: 5.0,
//                 // ),
//                 Text(
//                   '\$1.00',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 10.0.w,
//                 ),
//                 Text(
//                   '=',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 10.0.w,
//                 ),
//                 Text(
//                   '1',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 5.0,
//                 ),
//                 Container(
//                   height: 35.h,
//                   width: 35.w,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                         image: AssetImage(
//                             'assets/images/Accounts/AcctReward.png')),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 20.0.h,
//             ),
//             Text(
//               "Every time you invest, your checking account balance goes down while your reward point balance goes up.",
//               style: TextStyle(
//                 fontSize: 17.h,
//               ),
//             ),
//             SizedBox(
//               height: 20.0.h,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       height: 35.h,
//                       width: 35.w,
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                             image: AssetImage(
//                                 'assets/images/Accounts/AcctChecking.png')),
//                       ),
//                     ),
//                     FaIcon(
//                       FontAwesomeIcons.longArrowAltDown,
//                       size: 35.h,
//                       color: Colors.black,
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   width: 30.0.w,
//                 ),
//                 Row(
//                   children: [
//                     Container(
//                       height: 35.h,
//                       width: 35.w,
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                             image: AssetImage(
//                                 'assets/images/Accounts/AcctReward.png')),
//                       ),
//                     ),
//                     FaIcon(
//                       FontAwesomeIcons.longArrowAltUp,
//                       size: 35.h,
//                       color: Colors.black,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 20.0.h,
//             ),
//             Text(
//               "When your checking account balance gets too low, you won't have enough money to invest.",
//               style: TextStyle(
//                 fontSize: 17.h,
//               ),
//             ),
//             SizedBox(
//               height: 22.0.h,
//             ),
//             RichText(
//               text: TextSpan(
//                 style: TextStyle(
//                   color: Colors.black,
//                   height: 1.3,
//                   fontSize: 17.h,
//                 ),
//                 children: [
//                   TextSpan(
//                     text: 'Example: ',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 17.0.h,
//                     ),
//                   ),
//                   TextSpan(
//                     text:
//                         "Let's say you want to invest \$200 by transferring funds from your checking to your investment account, but you only have \$100 left in checking. Before you can invest, you'll need to add at least \$100 to your checking account.",
//                     style: TextStyle(
//                       fontSize: 17.h,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         okButton,
//       ],
//     );

//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }

//   showOverdraftNotice(BuildContext context, amount) {
//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       elevation: 24.0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(30.0),
//       ),
//       contentPadding: EdgeInsets.only(bottom: 13.0),
//       content: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           SizedBox(
//             height: 16.h,
//           ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(24.0.w, 20.0.h, 24.0.w, 4.0),
//             child: RichText(
//               // overflow: TextOverflow.visible,
//               text: TextSpan(
//                 style: TextStyle(
//                   color: Colors.black,
//                   height: 1.2,
//                   fontSize: 18.h,
//                 ),
//                 children: [
//                   TextSpan(
//                     text: 'WARNING. ',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 17.0.h,
//                       color: Color(0xffcb0909),
//                     ),
//                   ),
//                   TextSpan(
//                     text: 'Your virtual checking account has a balance of ',
//                     style: TextStyle(
//                       fontSize: 18.h,
//                     ),
//                   ),
//                   // (_overdraftAmount <= 0) ?
//                   TextSpan(
//                     text: '\$' + amount.toStringAsFixed(2),
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   TextSpan(
//                     text:
//                         ' Please add money to your account to complete your transaction.',
//                     style: TextStyle(
//                         // fontWeight: FontWeight.bold,
//                         ),
//                   ),
//                   WidgetSpan(
//                     alignment: PlaceholderAlignment.middle,
//                     child: IconButton(
//                       padding: EdgeInsets.zero,
//                       constraints: BoxConstraints(
//                         minWidth: 0.0,
//                         minHeight: 0.0,
//                       ),
//                       splashRadius: 18.0,
//                       icon: Icon(
//                         Icons.help,
//                         color: Colors.black,
//                       ),
//                       onPressed: () {},
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // IconButton(
//           //   padding: EdgeInsets.zero,
//           //   icon: Icon(
//           //     Icons.help,
//           //     color: Colors.black,
//           //   ),
//           //   onPressed: () {},
//           // ),
//           Image.asset(
//             'assets/images/Emptypockets2.png',
//             height: 450.0.h,
//             // width: 500.0,
//             fit: BoxFit.cover,
//           ),
//         ],
//       ),
//       actions: [
//         Center(
//           child: ElevatedButton(
//             style: ButtonStyle(
//               minimumSize: MaterialStateProperty.resolveWith(
//                   (states) => Size(230.w, 45.h)),
//               backgroundColor: MaterialStateProperty.resolveWith(
//                 (states) => Color(0xff0070c0),
//               ),
//               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                 RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(18.0),
//                 ),
//               ),
//               overlayColor: MaterialStateProperty.resolveWith(
//                 (states) {
//                   return states.contains(MaterialState.pressed)
//                       ? Colors.blue
//                       : null;
//                 },
//               ),
//             ),
//             onPressed: () => Timer(
//               const Duration(milliseconds: 400),
//               () {
//                 Navigator.pop(context);
//               },
//             ),
//             child: Text(
//               'Return',
//               style: TextStyle(
//                 fontSize: 20.0.h,
//                 color: Colors.white,
//               ),
//             ),
//             // color: Colors.transparent,
//           ),
//         ),
//       ],
//     );

//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }

//   showSlideDialog(BuildContext context) {
//     // set up the buttons
//     Widget okButton = TextButton(
//       child: Text("OK"),
//       onPressed: () {
//         Navigator.of(context).pop();
//       },
//     );

//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       elevation: 4.0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(30.0),
//       ),
//       content: SingleChildScrollView(
//         child: Column(
//           children: [
//             Text(
//               "When you slide the shopping bag into the closet,",
//               style: TextStyle(
//                 fontSize: 17.h,
//               ),
//             ),
//             SizedBox(
//               height: 16.0.h,
//             ),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '•',
//                   style: TextStyle(
//                     fontSize: 20.0.h,
//                     height: 1.2,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 13.0.w,
//                 ),
//                 Flexible(
//                   child: Text(
//                     'You save money by transferring funds from your virtual checking account to your virtual investment account where it can accumulate and grow, and',
//                     style: TextStyle(
//                       fontSize: 16.0.h,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 7.0.h,
//             ),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '•',
//                   style: TextStyle(
//                     fontSize: 20.0.h,
//                     height: 1.2,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 13.0.h,
//                 ),
//                 Flexible(
//                   child: Text(
//                     'You save your merchandise into a virtual closet for a cooling-off period of 5 days. If you still want it, you can complete your purchase after 5 days.',
//                     style: TextStyle(
//                       fontSize: 16.0.h,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         okButton,
//       ],
//     );

//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }

//   showInvestAtDialog(BuildContext context) {
//     // set up the buttons
//     Widget okButton = TextButton(
//       child: Text("OK"),
//       onPressed: () {
//         Navigator.of(context).pop();
//       },
//     );

//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       elevation: 4.0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(30.0),
//       ),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               'INVESTMENT RATE OF RETURN',
//               // textAlign: TextAlign.left,
//               style: TextStyle(
//                 fontWeight: FontWeight.w800,
//                 fontSize: 17.0.h,
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 25.0.h,
//           ),
//           Text(
//               "The S&P 500 is widely regarded as the market. The average annualized return since it's inception in 1926 is 7%, when adjusted for inflation."),
//           SizedBox(height: 20.0.h),
//           Text(
//               "While it's unlikely that you'll earn 12% on your real-life investments, you can in SaveUp Game. As the graph demonstrates, term and rate have a huge impact on the future value of today's investment. Due to the power of compound interest, your investments grow exponentially the longer they sit.")
//         ],
//       ),
//       actions: [
//         okButton,
//       ],
//     );

//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
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

//   Widget item(BuildContext context, int index, InvestmentModel investModel) {
//     return Column(
//       children: [
//         Divider(
//           height: 0.0,
//           thickness: 0.8,
//           color: Colors.black,
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
//           child: Row(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 3.0),
//                 child: Text(
//                   (index + 1).toString() + '.',
//                   style: TextStyle(
//                     fontSize: 13.0.h,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 15.0.w,
//               ),
//               // Spacer(),
//               Container(
//                 // width: 50,
//                 child: CircleAvatar(
//                   backgroundImage: NetworkImage(investModel.url),
//                 ),
//               ),
//               SizedBox(
//                 width: 10.0.w,
//               ),
//               Expanded(
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Align(
//                           alignment: Alignment.topLeft,
//                           child: Text(
//                             investModel.goal,
//                             // textAlign: TextAlign.left,
//                             style: TextStyle(
//                                 fontSize: 13.0.h,
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.grey[450]),
//                           ),
//                         ),
//                         Spacer(),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Container(
//                               width: 70.w,
//                               child: Text(
//                                 NumberFormat.simpleCurrency(
//                                   locale: "en-us",
//                                   decimalDigits: 0,
//                                 ).format(int.parse(investModel.amount)),
//                                 textAlign: TextAlign.end,
//                                 style: TextStyle(
//                                   color: Colors.grey[700],
//                                   fontSize: 13.0.h,
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(right: 3.0),
//                               child: Container(
//                                 width: 70.w,
//                                 child: Text(
//                                   NumberFormat.simpleCurrency(
//                                           locale: "en-us", decimalDigits: 0)
//                                       .format(
//                                           int.parse(investModel.goalAmount)),
//                                   textAlign: TextAlign.right,
//                                   style: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 13.0.h,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     Container(
//                       width: MediaQuery.of(context).size.width,
//                       child: LinearProgressIndicator(
//                         // semanticsLabel: 'Balling',
//                         backgroundColor: Colors.grey[350],
//                         minHeight: 7.0,
//                         color: Colors.green,
//                         value: convertToDecimal(
//                             (investModel != null) ? investModel.amount : '0',
//                             (investModel != null)
//                                 ? investModel.goalAmount
//                                 : '0'),
//                         // valueColor: ,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

  
//   investAmount({InvestmentModel model, widgetContext}) {
//     if (years != 0 &&
//         _orderAmount != 0 &&
//         stockPercentage != 0 &&
//         orderPercentage != 0) {
//       if (_orderAmount >= 1 && _orderAmount >= (res / 2)) {
//         if (goalSaved == false) {
//           if (_checking < res) {
//             // navigateToOverdraft(widgetContext);
//             showOverdraftNotice(widgetContext, double.parse(_checking.toString()));
//           } else
//           // if (res > num.parse(model.goalAmount)) {
//           //   Validator.onErrorDialog(
//           //       "You cannot save more than your goal amount", widgetContext);
//           // } else

//           {
//             x = double.parse(res.toString());
//             _undoAmount = x;
//             var c = _checking - x;
//             var s = _investment + x;
//             var r = _rewardPoints + x;
//             var calcChecking = num.parse(c.toStringAsFixed(2));
//             var calcInvest = num.parse(s.toStringAsFixed(2));
//             var calcReward = num.parse(r.toStringAsFixed(2));
//             firestoreInstance.collection("users").doc("widget.uid").update({
//               "checking": calcChecking,
//               "investment": calcInvest,
//               "reward_points": calcReward
//             }).then((_) {
//               _investValueItem = _highlightedIndex[0];
//               totalInvested = totalInvested + x;
//               var a = int.parse(model.amount) + x.round();
//               // a = a.toInt();
//               firestoreInstance
//                   .collection("investmentGoals")
//                   .doc("users")
//                   .collection("widget.uid")
//                   .doc((model.goalId).trim())
//                   .update({
//                 "investAmount": a.toString(),
//               });
//             }).then((_) {
//               _editedModel = model;
//               var goalAmount = int.parse(model.amount) + x.round();
//               // goalAmount = goalAmount + x;
//               setState(() {
//                 // _orderAmount = _orderAmount - x;

                
//                 // model
//                 // updatedModel
//                 // _modelId
//                 // currentInvestAmount

//                 model.amount = goalAmount.toString();
//                 // _invToDateTot
//                 _modelId = model.goalId;
//                 updatedModel = model;
//                 currentInvestAmount = x.toString();
//                 Provider.of<TotalValues>(widgetContext, listen: false)
//                     .getInvestToDate("widget.uid");
//                 Provider.of<TotalValues>(widgetContext, listen: false)
//                     .getInvestTotal("widget.uid");
//                 _savedIndex = _highlightedIndex[0];
//                 _highlightedIndex.clear();
//                 // _list[0].amount = (_investment + x).toString();
//                 // _list[1].amount = (_checking - x).toString();
//                 // _list[2].amount = (_rewardPoints + x).toString();
//                 _investment = _investment + x;
//                 _checking = _checking - x.toInt();
//                 _rewardPoints = _rewardPoints + x.toInt();
//                 _activeEdit = true;
//                 x = (_orderAmount / 100) * orderPercentage;
//                 drawChart();
//                 if (_checking < 0) {
//                   showOverdraftNotice(
//                       widgetContext, double.parse(_checking.toString()));
//                 }
//                 goalSaved = true;
//               });
//               // _orderAmount = double.parse(widget.incomingOrder);
//               investValues.add(orderPercentage);
//               investValues.add(stockPercentage);
//               investValues.add(years);
//               investValues.add(res);
//               investValues.add(_willBeWorth);
//               // orderPercentage = 0;
//               // stockPercentage = 0;
//               // _willBeWorth = 0;
//               // years = 0;
//               // res = 0;
//               // setState(() {});
//             });
//           }
//         } else {
//           Validator.onErrorDialog(
//               "You cannot save your goal multiple times", widgetContext);
//         }
//       } else {
//         Validator.onErrorDialog(
//             "You cannot save your order amount more than once", widgetContext);
//       }
//     } else {
//       // print('startinggg');
//       // print(years);
//       // print(stockPercentage);
//       // print(orderPercentage);
//       // print(_orderAmount);
//       Validator.onErrorDialog("Please complete details", widgetContext);
//     }
//   }





// }
