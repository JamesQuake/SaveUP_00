// import 'dart:async';

// import 'package:flare_flutter/flare_actor.dart';
// import 'package:flutter/material.dart';
// // import 'package:pay_or_save/pages/congratulation_saving.dart';
// import 'package:pay_or_save/pages/overdraft_balances.dart';
// import 'package:pay_or_save/widgets/menu.dart';

// class Overdraft extends StatefulWidget {
//   final String uid;
//   final double overdraftAmount;

//   @override
//   _OverdraftState createState() => _OverdraftState(uid, overdraftAmount);

//   Overdraft({Key key, @required this.uid, this.overdraftAmount})
//       : super(key: key);
// }

// class _OverdraftState extends State<Overdraft> {
//   String _uid;
//   double _overdraftAmount;

//   _OverdraftState(this._uid, this._overdraftAmount);

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   Future navigateToCongradulations(context) async {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => OverdraftBalances(
//                   uid: _uid,
//                   overdraftAmount: _overdraftAmount,
//                 )));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.red,
//         actions: <Widget>[MyManue.childPopup(context)],
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text("Overdraft Notice"),
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
//               Text.rich(
//                 TextSpan(
//                   text: 'Your virtual checking account balance Is ',
//                   style: TextStyle(fontSize: 18),
//                   children: <TextSpan>[
//                     (_overdraftAmount <= 0)
//                         ? TextSpan(
//                             text: '\$' + _overdraftAmount.toStringAsFixed(2),
//                             style: TextStyle(
//                                 color: Colors.red,
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold))
//                         : TextSpan(
//                             text: '\$' + _overdraftAmount.toStringAsFixed(2),
//                             style: TextStyle(
//                                 color: Colors.green,
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold)),
//                     TextSpan(
//                         text:
//                             " Please add money to your account to complete this transaction.",
//                         style: TextStyle(color: Colors.black, fontSize: 18))
//                     // can add more TextSpans here...
//                   ],
//                 ),
//               ),
// //              Text("Your virtual checking account balance Is -\$"+_overdraftAmount.toString()+".  Please add money to your account to complete this transaction.", style: TextStyle(fontSize: 18),),
//               Container(
//                 height: 300,
//                 child: FlareActor(
//                   'assets/animation/overdraft_coins.flr',
//                   alignment: Alignment.center,
//                   fit: BoxFit.fitHeight,
//                   animation: "overdraft",
//                 ),
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
//                           navigateToCongradulations(context);
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
