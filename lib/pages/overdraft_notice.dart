// import 'dart:async';

// // import 'package:flare_flutter/flare_actor.dart';
// import 'package:flutter/material.dart';
// // import 'package:pay_or_save/pages/congratulation_saving.dart';
// import 'package:pay_or_save/pages/overdraft_balances.dart';
// import '../assets/main_drawer.dart';

// class MyOverdraft extends StatefulWidget {
//   final String uid;
//   final double overdraftAmount;

//   const MyOverdraft({Key key, this.uid, this.overdraftAmount})
//       : super(key: key);
//   // final double overdraftAmount;

//   @override
//   _MyOverdraftState createState() => _MyOverdraftState();

//   // MyOverdraft({Key key, @required this.uid, this.overdraftAmount})
//   //     : super(key: key);
// }

// class _MyOverdraftState extends State<MyOverdraft> {
//   // String _uid;
//   // double _overdraftAmount;

//   // _MyOverdraftState(this._uid, this._overdraftAmount);

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   Future navigateToCongratulations(context) async {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => OverdraftBalances(
//                   uid: widget.uid,
//                   overdraftAmount: widget.overdraftAmount,
//                 )));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Color(0xffcb0909),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         // actions: <Widget>[
//         //   MyManue.childPopup(context)
//         // ],
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(
//           "Overdraft Notice",
//           style: TextStyle(
//             fontWeight: FontWeight.w700,
//             fontSize: 25.0,
//           ),
//         ),
//         centerTitle: true,
//         elevation: 0.0,
//       ),

//       // height: MediaQuery.of(context).size.height - 70,
//       //     decoration: BoxDecoration(
//       //       image: DecorationImage(
//       //         image: AssetImage(
//       //           'assets/images/Emptypockets2.png',
//       //         ),
//       //         fit: BoxFit.fill,
//       //       ),
//       //     ),
//       endDrawer: MainDrawer(uid: widget.uid),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             SizedBox(
//               height: 16,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 16.0, right: 16.0),
//               child: RichText(
//                 // overflow: TextOverflow.visible,
//                 text: TextSpan(
//                   style: TextStyle(
//                     color: Colors.black,
//                     height: 1.5,
//                     fontSize: 18,
//                   ),
//                   children: [
//                     TextSpan(
//                       text: 'WARNING. ',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         fontSize: 17.0,
//                         color: Color(0xffcb0909),
//                       ),
//                     ),
//                     TextSpan(
//                       text: 'Your virtual checking account has a balance of ',
//                       style: TextStyle(
//                         fontSize: 18,
//                       ),
//                     ),
//                     // (_overdraftAmount <= 0) ?
//                     TextSpan(
//                       text: '\$' + widget.overdraftAmount.toStringAsFixed(2),
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     TextSpan(
//                       text:
//                           ' Please add money to your account to complete your transaction.',
//                       style: TextStyle(
//                           // fontWeight: FontWeight.bold,
//                           ),
//                     ),
//                     WidgetSpan(
//                       alignment: PlaceholderAlignment.middle,
//                       child: IconButton(
//                         icon: Icon(
//                           Icons.help,
//                           color: Colors.black,
//                         ),
//                         onPressed: () {},
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             // Text.rich(
//             //   TextSpan(
//             //     text: 'Your virtual checking account has a balance of ',
//             //     style: TextStyle(fontSize: 18),
//             //     children: <TextSpan>[
//             //       (_overdraftAmount <= 0)
//             //           ? TextSpan(
//             //               text: '\$' + _overdraftAmount.toStringAsFixed(2),
//             //               style: TextStyle(
//             //                   color: Colors.red,
//             //                   fontSize: 22,
//             //                   fontWeight: FontWeight.bold))
//             //           : TextSpan(
//             //               text: '\$' + _overdraftAmount.toStringAsFixed(2),
//             //               style: TextStyle(
//             //                   color: Colors.green,
//             //                   fontSize: 22,
//             //                   fontWeight: FontWeight.bold)),
//             //       TextSpan(
//             //         text:
//             //             " Please add money to your account to complete this transaction.",
//             //         style: TextStyle(color: Colors.black, fontSize: 18),
//             //       ),
//             //       // can add more TextSpans here...
//             //     ],
//             //   ),
//             // ),
// //              Text("Your virtual checking account balance Is -\$"+_overdraftAmount.toString()+".  Please add money to your account to complete this transaction.", style: TextStyle(fontSize: 18),),
//             // Container(
//             //   height: 300,
//             //   child: FlareActor(
//             //     'assets/animation/overdraft_coins.flr',
//             //     alignment: Alignment.center,
//             //     fit: BoxFit.fitHeight,
//             //     animation: "overdraft",
//             //   ),
//             // ),

//             Container(
//               height: MediaQuery.of(context).size.height - 190,
//               // width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage(
//                     'assets/images/Emptypockets2.png',
//                   ),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: 30,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(left: 16, right: 16.0),
//                     child: Container(
//                       height: MediaQuery.of(context).size.height - 230,
//                       child: Align(
//                         alignment: Alignment.bottomCenter,
//                         child: TextButton(
//                           style: ButtonStyle(
//                             minimumSize: MaterialStateProperty.resolveWith(
//                                 (states) => Size(300, 50)),
//                             backgroundColor: MaterialStateProperty.resolveWith(
//                               (states) => Color(0xff0070c0),
//                             ),
//                             shape: MaterialStateProperty.all<
//                                 RoundedRectangleBorder>(
//                               RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10.0),
//                               ),
//                             ),
//                             overlayColor: MaterialStateProperty.resolveWith(
//                               (states) {
//                                 return states.contains(MaterialState.pressed)
//                                     ? Colors.blue
//                                     : null;
//                               },
//                             ),
//                           ),
//                           onPressed: () => Timer(
//                             const Duration(milliseconds: 400),
//                             () {
//                               // Navigator.pushNamed(context, '');
//                               // Navigator.push(
//                               //     context,
//                               //     MaterialPageRoute(
//                               //         builder: (context) => SelectStore(
//                               //             // uid: _uid,
//                               //             )));
//                               // navigateToCongratulations(context);
//                             },
//                           ),
//                           child: Text(
//                             'Next',
//                             style: TextStyle(
//                               fontSize: 20.0,
//                               color: Colors.white,
//                             ),
//                           ),
//                           // color: Colors.transparent,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
