// import 'dart:async';
// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:pay_or_save/models/account_model.dart';
// import 'package:pay_or_save/models/investment_goal_model.dart';
// import 'package:pay_or_save/models/saving_goal_model.dart';
// import 'package:pay_or_save/pages/drawing.dart';
// import 'package:pay_or_save/widgets/menu.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';


// class CongratulationsSaving extends StatefulWidget {
//   final String uid, savingAmount,  savedPerSession;
//   final SavingModel savingModel;
//   final double decimalForProgress;

//   @override
//   _CongratulationsSavingState createState() => _CongratulationsSavingState(uid, savingModel, savingAmount, savedPerSession, decimalForProgress);

//   CongratulationsSaving({Key key, @required this.uid, this.savingModel, this.savingAmount, this.savedPerSession, this.decimalForProgress}) : super(key: key);

// }

// class _CongratulationsSavingState extends State<CongratulationsSaving> {
//   String _uid, savingAmount, investmentAmount, savedPerSession;
//   List<AccountModel> _list;
//   SavingModel savingModel;
//   InvestmentModel investmentModel;
//   double decimalForProgress;
//   double revesedDecimal = 0.0;

//   _CongratulationsSavingState(this._uid, this.savingModel, this.savingAmount, this.savedPerSession, this.decimalForProgress);


//   @override
//   void initState() {
//     super.initState();
//      revesedDecimal = decimalForProgress - 1.0;
//      print(revesedDecimal);
//     _list = List<AccountModel>();
//     _list.add(AccountModel(savingModel.url, savingModel.goal, savingModel.amount, ''));
//     _list.add(AccountModel("https://lh3.googleusercontent.com/X53ujeXOMglEfk6xDU7v07_aZyiczlhJoZF_dl2_L8uFPgyvguQ2QLQ3x6hZ_XVJY4rUwjQlLcSmbvStE9D3nyOkwZMj2i-cSm_TBy0", "Total saving goal:", savingAmount, ''));
//   }

//   @override
//   void dispose() {
//     super.dispose();

//   }


//   Future navigateToDrawing(context) async {
//     Navigator.push(context, MaterialPageRoute(builder: (context) =>  Drawing(uid: _uid,)));
//   }

//   Widget _item(BuildContext context, int index) {
//     return Container(
//       child: ListTile(
//         title: Text(_list[index].title, style: TextStyle(fontSize: 16),),
//         subtitle: (index != 1)?LinearPercentIndicator(
//           width: 140.0,
//           lineHeight: 14.0,
//           percent: decimalForProgress,
//           backgroundColor: Colors.grey,
//           progressColor: Color(0xFF17bf4f),
//         ):Container(),
//         leading: CircleAvatar(
//           backgroundImage:  NetworkImage(_list[index].url),
//         ),
//         trailing: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text("\$"+_list[index].amount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)
//           ],
//         ),
//         onTap: () {
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: <Widget>[
//           MyManue.childPopup(context)
//         ],
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text("Congratulations"),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.max,
//             children: <Widget>[
//               SizedBox(height: 16,),
//               Text("You just saved \$"+savedPerSession +" toward:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
//               SizedBox(height: 16,),
//               SizedBox(
//                 child: ListView.builder(
//                     physics: ClampingScrollPhysics(),
//                     shrinkWrap: true,
//                     scrollDirection: Axis.vertical,
//                     itemCount: 1,
//                     itemBuilder: (BuildContext context, int index) => _item(context, index)
//                 ),
//               ),
//               ListTile(
//                 title: Text(_list[1].title, style: TextStyle(fontSize: 16),),
//                 leading: CircleAvatar(
//                   backgroundImage:  NetworkImage("https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fdollar-green.png?alt=media&token=b1720f47-5c6b-4c57-a37c-98884f8590c1"),
//                 ),
//                 trailing: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Text("\$"+_list[1].amount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)
//                   ],
//                 ),
//                 onTap: () {
//                 },
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               Card(
//                   color: Colors.white,
//                   child: Column(
//                     children: <Widget>[
//                       new Container(
//                           height: 200,
//                           child: Stack(
//                             children: <Widget>[
//                               Image(image: AssetImage('assets/images/retirament.jpg'), fit: BoxFit.fitWidth, width: double.infinity,),
//                               ClipRect(
//                                 child: Container(
//                                   child: BackdropFilter(
//                                  filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
//                                child: Container(
//                               decoration: BoxDecoration(color: Colors.blueGrey.withOpacity(revesedDecimal.abs())),
//                             ),
//                              ),
//                                 ),
//                               ),
//                             ],
//                           )
//                       ),
//                     ],
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                   )
//               ),

//               SizedBox(height: 32,),
// //              Column(
// //                crossAxisAlignment: CrossAxisAlignment.center,
// //                children: <Widget>[
// //                  Text("Earn 150 bonus Reward Points", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
// //                  SizedBox(height: 16,),
// //                  Text("every time you share your success with family and friends", style: TextStyle(fontSize: 18),),
// //                ],
// //              ),
// //              SizedBox(height: 32,),
// //              Row(
// //                mainAxisAlignment: MainAxisAlignment.center,
// //                children: <Widget>[
// //                  ButtonTheme(
// //                    minWidth: 100.0,
// //                    height: 50.0,
// //                    child: RaisedButton(
// //                      textColor: Colors.white,
// //                      color: Colors.deepPurple,
// //                      child: Text("Share"),
// //                      onPressed: () {
// //
// //                      },
// //                      shape: new RoundedRectangleBorder(
// //                        borderRadius: new BorderRadius.circular(10.0),
// //                      ),
// //                    ),
// //                  ),
// //                ],
// //              ),
// //              SizedBox(height: 50,),
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
//                           navigateToDrawing(context);
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