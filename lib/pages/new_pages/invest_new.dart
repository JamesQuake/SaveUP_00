// import 'package:flutter/material.dart';
// import 'package:pay_or_save/assets/main_drawer.dart';

// class InvestNew extends StatefulWidget {
//   // const InvestNew({ Key? key }) : super(key: key);

//   @override
//   _InvestNewState createState() => _InvestNewState();
// }

// class _InvestNewState extends State<InvestNew> {
//   // final orderPercentage = [
//   //   '100%',
//   //   '200%',
//   //   '300%',
//   //   '400%',
//   //   '500%',
//   //   '600%',
//   //   '700%',
//   //   '800%',
//   //   '900%',
//   //   '1000%',
//   // ];

//   int percentage = 0;

//   void _addPercentage() {
//     setState(() {
//       percentage + 100;
//     });
//   }

//   void _removePercentage() {
//     setState(() {
//       if (percentage != 0) {
//         percentage - 100;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xff0070c0),
//         title: Text(
//           'Invest Now',
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         centerTitle: true,
//         elevation: 0.0,
//       ),
//       endDrawer: MainDrawer(),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 10.0),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Text(
//                     'Order Amount',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   Spacer(),
//                   Text(
//                     '\$85.75',
//                     style: TextStyle(
//                       color: Colors.blue,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//               Divider(
//                 thickness: 0.8,
//                 color: Colors.black,
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'How much of your order amount would you like to save?. Enter 0% - 1,000%',
//                         style: TextStyle(
//                           fontSize: 15,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Spacer(),
//                   Text('200%'),
//                 ],
//               ),
//               Divider(
//                 thickness: 0.8,
//                 color: Colors.black,
//               ),
//               Row(
//                 children: [
//                   Text(
//                     'Total Investments',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   Spacer(),
//                   Text(
//                     '\$171.50',
//                     style: TextStyle(
//                       // color: Colors.blue,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//               Divider(
//                 thickness: 0.8,
//                 color: Colors.black,
//               ),
//               Row(
//                 children: [
//                   Text(
//                     'Which will be worth',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   Spacer(),
//                   Text(
//                     '\$3,000',
//                     style: TextStyle(
//                       // color: Colors.blue,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//               Divider(
//                 thickness: 0.8,
//                 color: Colors.black,
//               ),
//               Row(
//                 children: [
//                   Text(
//                     'When invested at',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   Spacer(),
//                   Text(
//                     '10%',
//                     style: TextStyle(
//                       // color: Colors.blue,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//               Divider(
//                 thickness: 0.8,
//                 color: Colors.black,
//               ),
//               Row(
//                 children: [
//                   Text(
//                     'For',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   Spacer(),
//                   Text(
//                     '30 years',
//                     style: TextStyle(
//                       // color: Colors.blue,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//               Divider(
//                 thickness: 0.8,
//                 color: Colors.black,
//               ),
//               SizedBox(
//                 height: 20.0,
//               ),
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   'Investment Goals',
//                   // textAlign: TextAlign.start,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 15.0,
//               ),
//               Text(
//                 "These are your investment goals. Scroll over the goal that you'd like to invest in",
//                 style: TextStyle(
//                   fontStyle: FontStyle.italic,
//                   fontSize: 15,
//                 ),
//               ),
//               SizedBox(
//                 height: 18.0,
//               ),
//               Column(
//                 children: [
//                   Row(
//                     children: [
//                       Spacer(),
//                       Container(
//                         width: 60,
//                         child: Text(
//                           'Invest To Date',
//                           // textAlign: TextAlign.right,
//                           style: TextStyle(
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 15.0,
//                       ),
//                       Container(
//                         width: 60,
//                         child: Text(
//                           'Invest Goal',
//                           textAlign: TextAlign.right,
//                           style: TextStyle(
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Divider(
//                     thickness: 0.8,
//                     color: Colors.black,
//                   ),
//                   Row(
//                     children: [
//                       Text('1.'),
//                       SizedBox(
//                         width: 15.0,
//                       ),
//                       // Spacer(),
//                       Container(
//                         // width: 50,
//                         child: CircleAvatar(
//                           backgroundImage:
//                               AssetImage('assets/images/retirament.jpg'),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10.0,
//                       ),
//                       Expanded(
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Align(
//                                   alignment: Alignment.topLeft,
//                                   child: Text(
//                                     'Retirement',
//                                     // textAlign: TextAlign.left,
//                                     style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w400,
//                                         color: Colors.grey[450]),
//                                   ),
//                                 ),
//                                 Spacer(),
//                                 Container(
//                                   width: 60,
//                                   child: Text(
//                                     '\$190,000',
//                                     style: TextStyle(
//                                       color: Colors.grey[700],
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 15.0,
//                                 ),
//                                 Container(
//                                   width: 60,
//                                   child: Text(
//                                     '\$450,000',
//                                     textAlign: TextAlign.right,
//                                     style: TextStyle(
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Container(
//                               width: MediaQuery.of(context).size.width,
//                               child: LinearProgressIndicator(
//                                 // semanticsLabel: 'Balling',
//                                 backgroundColor: Colors.grey[350],
//                                 minHeight: 7.0,
//                                 color: Colors.green,
//                                 value: 0.5,
//                                 // valueColor: ,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   Divider(
//                     thickness: 0.8,
//                     color: Colors.black,
//                   ),
//                   Row(
//                     children: [
//                       Text('2.'),
//                       SizedBox(
//                         width: 15.0,
//                       ),
//                       // Spacer(),
//                       Container(
//                         // width: 50,
//                         child: CircleAvatar(
//                           backgroundImage:
//                               AssetImage('assets/images/education.png'),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10.0,
//                       ),
//                       Expanded(
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Align(
//                                   alignment: Alignment.topLeft,
//                                   child: Text(
//                                     'Education',
//                                     // textAlign: TextAlign.left,
//                                     style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w400,
//                                         color: Colors.grey[450]),
//                                   ),
//                                 ),
//                                 Spacer(),
//                                 Container(
//                                   width: 60,
//                                   child: Text(
//                                     '\$3,500',
//                                     style: TextStyle(
//                                       color: Colors.grey[700],
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 15.0,
//                                 ),
//                                 Container(
//                                   width: 60,
//                                   child: Text(
//                                     '\$35,500',
//                                     textAlign: TextAlign.right,
//                                     style: TextStyle(
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Container(
//                               width: MediaQuery.of(context).size.width,
//                               child: LinearProgressIndicator(
//                                 // semanticsLabel: 'Balling',
//                                 backgroundColor: Colors.grey[350],
//                                 minHeight: 7.0,
//                                 color: Colors.green,
//                                 value: 0.2,
//                                 // valueColor: ,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   Divider(
//                     thickness: 0.8,
//                     color: Colors.black,
//                   ),
//                   Row(
//                     children: [
//                       Text('3.'),
//                       SizedBox(
//                         width: 15.0,
//                       ),
//                       // Spacer(),
//                       Container(
//                         // width: 50,
//                         child: CircleAvatar(
//                           backgroundImage:
//                               AssetImage('assets/images/dollar-gold.png'),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10.0,
//                       ),
//                       Expanded(
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Align(
//                                   alignment: Alignment.topLeft,
//                                   child: Text(
//                                     'Start a business',
//                                     // textAlign: TextAlign.left,
//                                     style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w400,
//                                         color: Colors.grey[450]),
//                                   ),
//                                 ),
//                                 Spacer(),
//                                 Container(
//                                   width: 60,
//                                   child: Text(
//                                     '\$16,500',
//                                     style: TextStyle(
//                                       color: Colors.grey[700],
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 15.0,
//                                 ),
//                                 Container(
//                                   width: 60,
//                                   child: Text(
//                                     '\$30,000',
//                                     textAlign: TextAlign.right,
//                                     style: TextStyle(
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Container(
//                               width: MediaQuery.of(context).size.width,
//                               child: LinearProgressIndicator(
//                                 // semanticsLabel: 'Balling',
//                                 backgroundColor: Colors.grey[350],
//                                 minHeight: 7.0,
//                                 color: Colors.green,
//                                 value: 0.3,
//                                 // valueColor: ,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   Divider(
//                     thickness: 0.8,
//                     color: Colors.black,
//                   ),
//                   Row(
//                     children: [
//                       Text('4.'),
//                       SizedBox(
//                         width: 15.0,
//                       ),
//                       // Spacer(),
//                       Container(
//                         // width: 50,
//                         child: CircleAvatar(
//                           backgroundImage:
//                               AssetImage('assets/images/new/img3.png'),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10.0,
//                       ),
//                       Expanded(
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Align(
//                                   alignment: Alignment.topLeft,
//                                   child: Text(
//                                     'Legacy',
//                                     // textAlign: TextAlign.left,
//                                     style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w400,
//                                         color: Colors.grey[450]),
//                                   ),
//                                 ),
//                                 Spacer(),
//                                 Container(
//                                   width: 60,
//                                   child: Text(
//                                     '\$21,000',
//                                     style: TextStyle(
//                                       color: Colors.grey[700],
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 15.0,
//                                 ),
//                                 Container(
//                                   width: 60,
//                                   child: Text(
//                                     '\$150,000',
//                                     textAlign: TextAlign.right,
//                                     style: TextStyle(
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Container(
//                               width: MediaQuery.of(context).size.width,
//                               child: LinearProgressIndicator(
//                                 // semanticsLabel: 'Balling',
//                                 backgroundColor: Colors.grey[350],
//                                 minHeight: 7.0,
//                                 color: Colors.green,
//                                 value: 0.8,
//                                 // valueColor: ,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   Divider(
//                     thickness: 0.8,
//                     color: Colors.black,
//                   ),
//                   Row(
//                     children: [
//                       Container(width: 11.5),
//                       SizedBox(
//                         width: 15.0,
//                       ),
//                       // Spacer(),
//                       Container(
//                         // width: 50,
//                         child: CircleAvatar(
//                           backgroundImage:
//                               AssetImage('assets/images/space-dollar.png'),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10.0,
//                       ),
//                       Expanded(
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Align(
//                                   alignment: Alignment.topLeft,
//                                   child: Text(
//                                     'Total Invest Goal',
//                                     // textAlign: TextAlign.left,
//                                     style: TextStyle(
//                                         fontSize: 13,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.grey[450]),
//                                   ),
//                                 ),
//                                 Spacer(),
//                                 Container(
//                                   width: 60,
//                                   child: Text(
//                                     '\$231,500',
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       // fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 15.0,
//                                 ),
//                                 Container(
//                                   width: 60,
//                                   child: Text(
//                                     '\$685,000',
//                                     textAlign: TextAlign.right,
//                                     style: TextStyle(
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Container(
//                               width: MediaQuery.of(context).size.width,
//                               child: LinearProgressIndicator(
//                                 // semanticsLabel: 'Balling',
//                                 backgroundColor: Colors.grey[350],
//                                 minHeight: 7.0,
//                                 color: Colors.green,
//                                 value: 0.8,
//                                 // valueColor: ,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 20.0,
//                   ),
//                   Align(
//                     alignment: Alignment.topLeft,
//                     child: Row(
//                       children: [
//                         Text(
//                           'Account Balances',
//                           // textAlign: TextAlign.start,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         IconButton(
//                           // padding: EdgeInsets.only(left: 0.0),
//                           icon: Icon(
//                             Icons.help,
//                             color: Colors.black,
//                             size: 19,
//                           ),
//                           onPressed: () {
//                             _showAlertDialog(context);
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                   Divider(
//                     thickness: 0.8,
//                     color: Colors.black,
//                   ),
//                   Row(
//                     children: [
//                       Container(width: 11.5),
//                       SizedBox(
//                         width: 15.0,
//                       ),
//                       // Spacer(),
//                       Container(
//                         // width: 50,
//                         child: CircleAvatar(
//                           backgroundImage:
//                               AssetImage('assets/images/cheking-icon.png'),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10.0,
//                       ),
//                       Expanded(
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Align(
//                                   alignment: Alignment.topLeft,
//                                   child: Text(
//                                     'Checking Account',
//                                     // textAlign: TextAlign.left,
//                                     style: TextStyle(
//                                         fontSize: 13,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.grey[450]),
//                                   ),
//                                 ),
//                                 Spacer(),
//                                 Container(
//                                   width: 50,
//                                   child: Text(
//                                     '\$1,500',
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 15.0,
//                                 ),
//                                 Container(
//                                   width: 50,
//                                   child: Text(
//                                     '\$3,500',
//                                     textAlign: TextAlign.right,
//                                     style: TextStyle(
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Container(
//                               width: MediaQuery.of(context).size.width,
//                               child: LinearProgressIndicator(
//                                 // semanticsLabel: 'Balling',
//                                 backgroundColor: Colors.grey[350],
//                                 minHeight: 7.0,
//                                 color: Colors.green,
//                                 value: 0.8,
//                                 // valueColor: ,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   Divider(
//                     thickness: 0.8,
//                     color: Colors.black,
//                   ),
//                   Row(
//                     children: [
//                       // Text('5.'),
//                       Container(width: 11.5),
//                       SizedBox(
//                         width: 15.0,
//                       ),
//                       // Spacer(),
//                       Container(
//                         // width: 50,
//                         child: CircleAvatar(
//                           backgroundImage:
//                               AssetImage('assets/images/dollar-green.png'),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10.0,
//                       ),
//                       Expanded(
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Align(
//                                   alignment: Alignment.topLeft,
//                                   child: Text(
//                                     'Reward Points',
//                                     // textAlign: TextAlign.left,
//                                     style: TextStyle(
//                                         fontSize: 13,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.grey[450]),
//                                   ),
//                                 ),
//                                 Spacer(),
//                                 Container(
//                                   width: 50,
//                                   child: Text(
//                                     '1,500',
//                                     textAlign: TextAlign.right,
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Container(
//                               width: MediaQuery.of(context).size.width,
//                               child: LinearProgressIndicator(
//                                 // semanticsLabel: 'Balling',
//                                 backgroundColor: Colors.grey[350],
//                                 minHeight: 7.0,
//                                 color: Colors.blue,
//                                 value: 0.1,
//                                 // valueColor: ,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   Divider(
//                     thickness: 0.8,
//                     color: Colors.black,
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 25.0,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.shopping_bag_rounded,
//                     size: 60,
//                     color: Colors.yellow[800],
//                   ),
//                   SizedBox(
//                     width: 25.0,
//                   ),
//                   // Icon(
//                   //   Icons.arrow_right_alt_outlined,
//                   //   size: 80,
//                   //   color: Colors.grey[400],
//                   // ),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         alignment: Alignment.centerLeft,
//                         height: 50,
//                         child: Icon(
//                           Icons.arrow_right_alt_outlined,
//                           size: 80,
//                           color: Colors.grey[400],
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             padding: EdgeInsets.zero,
//                             width: 100,
//                             child: Text(
//                               'Slide shopping bag to the right to save',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           IconButton(
//                             // padding: EdgeInsets.only(left: 0.0),
//                             icon: Icon(
//                               Icons.help,
//                               color: Colors.black,
//                               size: 19,
//                             ),
//                             onPressed: () {
//                               // _showAbDialog();
//                               showSlideDialog(context);
//                             },
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     width: 25.0,
//                   ),
//                   Icon(
//                     Icons.checkroom,
//                     color: Colors.yellow[800],
//                     size: 60,
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // _showAbDialog() {
// //   showDialog(
// //     context: context,
// //     builder: (_) => new AlertDialog(
// //       content: Text(
// //         "When you save, you put money in a safe place – like a...",
// //         style: TextStyle(
// //           color: Colors.grey[600],
// //           fontSize: 15.0,
// //         ),
// //       ),
// //       actions: <Widget>[
// //         TextButton(
// //           child: Text('More Info'),
// //           onPressed: () {
// //             Navigator.of(context);
// //           },
// //         )
// //       ],
// //       elevation: 24.0,
// //     ),
// //   );
// // }

// _showAlertDialog(BuildContext context) {
//   // set up the button
//   Widget okButton = TextButton(
//     child: Text("OK"),
//     onPressed: () {
//       Navigator.of(context).pop();
//     },
//   );

//   // set up the AlertDialog
//   AlertDialog alert = AlertDialog(
//     elevation: 4.0,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(30.0),
//     ),
//     content: SingleChildScrollView(
//       child: Column(
//         children: [
//           RichText(
//             text: TextSpan(
//               style: TextStyle(
//                 color: Colors.black,
//                 height: 1.5,
//                 fontSize: 18,
//               ),
//               children: [
//                 TextSpan(
//                   text: 'Checking Account. ',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w700,
//                     fontSize: 17.0,
//                   ),
//                 ),
//                 TextSpan(
//                   text:
//                       "When you invest, you transfer money from your checking account, where you're likely to spend it on pizza and beer, to your investment account, where it's likely to grow.",
//                   style: TextStyle(
//                     fontSize: 18,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 22.0,
//           ),
//           RichText(
//             text: TextSpan(
//               style: TextStyle(
//                 color: Colors.black,
//                 height: 1.5,
//                 fontSize: 17,
//               ),
//               children: [
//                 TextSpan(
//                   text: 'Reward Points. ',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w700,
//                     fontSize: 17.0,
//                   ),
//                 ),
//                 TextSpan(
//                   text:
//                       "You earn one reward point for every dollar that you invest.",
//                   style: TextStyle(
//                     fontSize: 17,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 22.0,
//           ),
//           Text(
//             "Every time you invest, your checking account balance goes down while your reward point balance goes up.",
//             style: TextStyle(
//               fontSize: 17,
//             ),
//           ),
//           SizedBox(
//             height: 22.0,
//           ),
//           Text(
//             "When your checking account balance gets too low, you won't have enough money to invest.",
//             style: TextStyle(
//               fontSize: 17,
//             ),
//           ),
//           SizedBox(
//             height: 22.0,
//           ),
//           RichText(
//             text: TextSpan(
//               style: TextStyle(
//                 color: Colors.black,
//                 height: 1.5,
//                 fontSize: 17,
//               ),
//               children: [
//                 TextSpan(
//                   text: 'Example: ',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w700,
//                     fontSize: 17.0,
//                   ),
//                 ),
//                 TextSpan(
//                   text:
//                       "Let's say you want to invest \$200 by transferring funds from your checking to your investment account, but you only have \$100 left in checking. Before you can invest, you'll need to add money to your checking account.",
//                   style: TextStyle(
//                     fontSize: 17,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//     actions: [
//       okButton,
//     ],
//   );

//   // show the dialog
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   );
// }

// showSlideDialog(BuildContext context) {
//   // set up the buttons
//   Widget okButton = TextButton(
//     child: Text("OK"),
//     onPressed: () {
//       Navigator.of(context).pop();
//     },
//   );

//   // set up the AlertDialog
//   AlertDialog alert = AlertDialog(
//     elevation: 4.0,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(30.0),
//     ),
//     content: SingleChildScrollView(
//       child: Column(
//         children: [
//           Text(
//             "When you slide the shopping bag into the closet,",
//             style: TextStyle(
//               fontSize: 17,
//             ),
//           ),
//           SizedBox(
//             height: 16.0,
//           ),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 '•',
//                 style: TextStyle(
//                   fontSize: 20.0,
//                   height: 1.2,
//                 ),
//               ),
//               SizedBox(
//                 width: 13.0,
//               ),
//               Flexible(
//                 child: Text(
//                   'you save money by transferring funds from your virtual checking account to your virtual investment account, and',
//                   style: TextStyle(
//                     fontSize: 16.0,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 '•',
//                 style: TextStyle(
//                   fontSize: 20.0,
//                   height: 1.2,
//                 ),
//               ),
//               SizedBox(
//                 width: 13.0,
//               ),
//               Flexible(
//                 child: Text(
//                   'you save your merchandise into a virtual closet for a cooling off period. If you still want it, you can buy it after 5 days.',
//                   style: TextStyle(
//                     fontSize: 16.0,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//     actions: [
//       okButton,
//     ],
//   );

//   // show the dialog
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   );
// }
