// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import 'package:ms_pp/assets/dropdown.dart';
// import 'package:ms_pp/assets/main_drawer.dart';
// import 'package:ms_pp/assets/new_button.dart';
// import 'package:ms_pp/assets/text_field.dart';

// class CustomPage extends StatelessWidget {
//   final String titleText;
//   final String firstRowText;
//   final String secondRowText;
//   final List firstDropDown;
//   final String firstHint;
//   final String thirdRowText;

//   const CustomPage({
//     Key key,
//     @required this.titleText,
//     this.firstRowText,
//     this.secondRowText,
//     this.firstDropDown,
//     this.firstHint,
//     this.thirdRowText,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xff0070c0),
//         title: Text(titleText),
//         centerTitle: true,
//         elevation: 0.0,
//         // actions: [
//         //   Icon(Icons.drag_handle_outlined),
//         //   FlatButton(
//         //     child: Text('Open Drawer'),
//         //     onPressed: () {
//         //       Scaffold.of(context).openEndDrawer();
//         //     },
//         //   ),
//         // ],
//       ),
//       endDrawer: MainDrawer(),
//       body: Container(
//         // width: double.infinity,
//         padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 24.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(height: 10.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(
//                     firstRowText,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(width: 4.0),
//                   Icon(
//                     Icons.help,
//                     color: Color(0xff7030a0),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 10.0,
//               ),
//               Column(
//                 children: [
//                   Row(
//                     children: [
//                       Align(
//                         alignment: Alignment.topLeft,
//                         child: Text(secondRowText),
//                       ),
//                       Spacer(),
//                       Container(
//                         height: 40.0,
//                         width: 150.0,
//                         color: Colors.grey.withOpacity(0.2),
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 10.0,
//                         ),
//                         margin: EdgeInsets.symmetric(
//                           vertical: 10.0,
//                         ),
//                         child: DropDown(
//                           dropDownItem: firstDropDown,
//                           newHint: firstHint,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10.0,
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Align(
//                         alignment: Alignment.topLeft,
//                         child: Text(thirdRowText),
//                       ),
//                       Spacer(),
//                       SizedBox(
//                         width: 150.0,
//                         child: TextField(
//                           // expands: false,
//                           decoration: InputDecoration(
//                             contentPadding: EdgeInsets.symmetric(
//                               horizontal: 40.0,
//                               vertical: 8.0,
//                             ),
//                             isDense: true,
//                             filled: true,
//                             fillColor: Colors.grey.withOpacity(0.2),
//                             labelStyle: TextStyle(
//                                 fontFamily: 'Montserrat', color: Colors.black),
//                             focusedBorder: UnderlineInputBorder(
//                               borderSide: BorderSide.none,
//                             ),
//                             enabledBorder: UnderlineInputBorder(
//                               borderSide: BorderSide.none,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10.0,
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Align(
//                         alignment: Alignment.topLeft,
//                         child: Text(fourthRowText),
//                       ),
//                       Spacer(),
//                       Container(
//                         height: 40.0,
//                         width: 150.0,
//                         color: Colors.grey.withOpacity(0.2),
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 10.0,
//                         ),
//                         margin: EdgeInsets.symmetric(
//                           vertical: 10.0,
//                         ),
//                         child: DropDown(
//                           dropDownItem: [
//                             '6 months',
//                             '12 months',
//                             '18 months',
//                             '24 months',
//                             '30 months',
//                             '3 years',
//                             '5 years',
//                             '7 years',
//                             '8 years',
//                             '10 years',
//                             '15 years',
//                           ],
//                           newHint: '1 year',
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10.0,
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Flexible(
//                         child: Align(
//                           alignment: Alignment.topLeft,
//                           child: Text(
//                             'Download photo of your savings goal (optional):',
//                           ),
//                         ),
//                       ),
//                       Spacer(),
//                       Container(
//                         height: 60.0,
//                         width: 150.0,
//                         color: Colors.grey.withOpacity(0.2),
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 10.0,
//                         ),
//                         margin: EdgeInsets.symmetric(
//                           vertical: 10.0,
//                         ),
//                         child: Align(
//                           alignment: Alignment.center,
//                           child: GestureDetector(
//                             onTap: () {},
//                             child: Text(
//                               'download',
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 20.0,
//                   ),
//                   Column(
//                     children: [
//                       Container(
//                         // width: MediaQuery.of(context).size.width,
//                         color: Colors.grey.withOpacity(0.2),
//                         height: 50.0,
//                         child: Row(
//                           children: [
//                             Container(
//                               child: Align(
//                                 alignment: Alignment.centerLeft,
//                                 child: Text('1.'),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 20.0,
//                             ),
//                             Container(
//                               child: CircleAvatar(
//                                 backgroundImage: AssetImage('assets/img3.png'),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 20.0,
//                             ),
//                             Container(
//                               child: Align(
//                                 alignment: Alignment.center,
//                                 child: Text('Vacation Goal:'),
//                               ),
//                             ),
//                             Spacer(),
//                             Container(
//                               width: 50.0,
//                               child: TextField(
//                                 decoration: InputDecoration(
//                                   hintText: '\$3,500',
//                                   focusedBorder: UnderlineInputBorder(
//                                     borderSide: BorderSide.none,
//                                   ),
//                                   enabledBorder: UnderlineInputBorder(
//                                     borderSide: BorderSide.none,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         color: Colors.white.withOpacity(0.2),
//                         height: 50.0,
//                         child: Row(
//                           children: [
//                             Container(
//                               child: Align(
//                                 alignment: Alignment.centerLeft,
//                                 child: Text('2.'),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 20.0,
//                             ),
//                             Container(
//                               child: CircleAvatar(
//                                 backgroundImage: AssetImage('assets/img1.png'),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 20.0,
//                             ),
//                             Container(
//                               child: Align(
//                                 alignment: Alignment.center,
//                                 child: Text('Wedding Goal:'),
//                               ),
//                             ),
//                             Spacer(),
//                             Container(
//                               width: 50.0,
//                               child: TextField(
//                                 decoration: InputDecoration(
//                                   hintText: '\$2,500',
//                                   focusedBorder: UnderlineInputBorder(
//                                     borderSide: BorderSide.none,
//                                   ),
//                                   enabledBorder: UnderlineInputBorder(
//                                     borderSide: BorderSide.none,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         // width: MediaQuery.of(context).size.width,
//                         color: Colors.grey.withOpacity(0.2),
//                         height: 50.0,
//                         child: Row(
//                           children: [
//                             Container(
//                               child: Align(
//                                 alignment: Alignment.centerLeft,
//                                 child: Text('3.'),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 20.0,
//                             ),
//                             Container(
//                               child: CircleAvatar(
//                                 backgroundImage: AssetImage('assets/img4.png'),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 20.0,
//                             ),
//                             Container(
//                               child: Align(
//                                 alignment: Alignment.center,
//                                 child: Text('Home Goal:'),
//                               ),
//                             ),
//                             Spacer(),
//                             Container(
//                               width: 60.0,
//                               child: TextField(
//                                 decoration: InputDecoration(
//                                   hintText: '\$10,000',
//                                   focusedBorder: UnderlineInputBorder(
//                                     borderSide: BorderSide.none,
//                                   ),
//                                   enabledBorder: UnderlineInputBorder(
//                                     borderSide: BorderSide.none,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20.0,
//                       ),
//                       Row(
//                         children: [
//                           Container(
//                             child: Align(
//                               alignment: Alignment.centerLeft,
//                               child: Text(
//                                 'Total Savings Goal:',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Spacer(),
//                           Container(
//                             width: 60.0,
//                             child: TextField(
//                               decoration: InputDecoration(
//                                 hintText: '\$16,000',
//                                 focusedBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide.none,
//                                 ),
//                                 enabledBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide.none,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Align(
//                         alignment: Alignment.bottomCenter,
//                         child: Row(
//                           children: [
//                             Container(
//                               child: Expanded(
//                                 child: ButtonNew(
//                                   newText: 'Set Another Savings Goal',
//                                   routeName: '/screen4',
//                                   width: 50.0,
//                                   height: 60.0,
//                                   customColor: 0xff0070c0,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10.0,
//                             ),
//                             Container(
//                               child: Expanded(
//                                 child: ButtonNew(
//                                   newText: 'Done',
//                                   routeName: '/screen4',
//                                   width: 50.0,
//                                   height: 60.0,
//                                   customColor: 0xff8eb4e3,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
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
