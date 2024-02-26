// import 'dart:async';
// import 'dart:io';
// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// // import 'package:pay_or_save/assets/buttonting.dart';
// // import 'package:pay_or_save/assets/custom_row.dart';
// import 'package:pay_or_save/assets/dropdown/expanded_section.dart';
// // import 'package:pay_or_save/assets/dropdown/new_dropdown.dart';
// import 'package:pay_or_save/assets/dropdown/scrollbar.dart';
// // import 'package:pay_or_save/assets/dropdown.dart';
// import 'package:pay_or_save/assets/main_drawer.dart';
// // import 'package:pay_or_save/models/investment_goal_model.dart';
// import 'package:pay_or_save/models/saving_goal_model.dart';
// // import 'package:pay_or_save/pages/about_savings.dart';
// import 'package:pay_or_save/pages/investment_goal.dart';
// // import 'package:pay_or_save/pages/save_now.dart';
// import 'package:pay_or_save/providers/total_provider.dart';
// // import 'package:pay_or_save/pages/about.dart';
// import 'package:pay_or_save/services/services.dart';
// import 'package:pay_or_save/utilities/validator.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'edit_saving_goal.dart';
// // import 'invest_now.dart';
// // import 'package:pay_or_save/widgets/menu.dart';

// class SavingGoals extends StatefulWidget {
//   final String uid;

//   @override
//   _SavingGoalsState createState() => _SavingGoalsState(uid);

//   SavingGoals({Key key, @required this.uid}) : super(key: key);
// }

// class _SavingGoalsState extends State<SavingGoals> {
//   String _uid,
//       _savingFor,
//       // _other,
//       _savingAmount,
//       _savingTime,
//       _fileURL,
//       _path,
//       _fileName;
//   int _newIndex = 1;

//   // _extension;
//   Map<String, String> _paths;
//   // bool _loadingPath = false;
//   // bool _multiPick = false;
//   // bool _hasValidMime = false;
//   // FileType _pickingType;
//   bool isStrechedDropDown = false;
//   int groupValue;
//   String title = 'Select';
//   String timeTitle = 'Select';
//   int group2Value;
//   bool isStrechedDropDown2 = false;
//   List savingsTotalList;
//   int savingsTotal;
//   Future<int> _totalProvider;
//   SharedPreferences _prefss;
//   // String nativeRoute = '/'

//   List<String> dropList = [
//     'Car',
//     'Computer/Electronics',
//     'Education',
//     'Emergency fund',
//     'Rainy Day',
//     'Furnishings',
//     'General Savings',
//     'Home',
//     'Start a business',
//     'Travel/Vacation',
//     'Wedding',
//     'I do not have a goal at this time',
//     'Other'
//   ];
//   List<String> secondDropList = [
//     '6 months',
//     '12 months',
//     '18 months',
//     '24 months',
//     '30 months',
//     '3 years',
//     '5 years',
//     '7 years',
//     '8 years',
//     '10 years',
//     '15 years',
//   ];
//   int total;
//   bool isClosed = true;
//   int numberItems = 0;
//   String formattedDigit;
//   List<SavingModel> _goalSavings;
//   Future<List<SavingModel>> _goalFuture;
//   int providerTotal;
//   String route = '/saving';
//   // List<InvestmentModel> _listInvestment;
//   final myController = TextEditingController();
//   final firestoreInstance = FirebaseFirestore.instance;
//   final GlobalKey<FormState> _inputFormKey = GlobalKey<FormState>();
//   // var itemsIcons = {
//   //   'Car': 'assets/images/iconsgoals/auto.png',
//   //   'Computer':
//   //       'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fcalculator.png?alt=media&token=4d377200-d8db-417a-96c5-5f000249597e',
//   //   'Education':
//   //       'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Feducation.png?alt=media&token=b9dc9675-7c42-4758-a1b2-febf3eec6f01',
//   //   'Emergency found':
//   //       'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fcalculator.png?alt=media&token=4d377200-d8db-417a-96c5-5f000249597e',
//   //   'Electronics':
//   //       'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fcalculator.png?alt=media&token=4d377200-d8db-417a-96c5-5f000249597e',
//   //   'Furnishings':
//   //       'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fcalculator.png?alt=media&token=4d377200-d8db-417a-96c5-5f000249597e',
//   //   'General':
//   //       'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fcalculator.png?alt=media&token=4d377200-d8db-417a-96c5-5f000249597e',
//   //   'Home':
//   //       'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fhouse-icon.png?alt=media&token=34581f0a-62a5-4096-bd7b-33321ff92dca',
//   //   'Start a business':
//   //       'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fcalculator.png?alt=media&token=4d377200-d8db-417a-96c5-5f000249597e',
//   //   'Vacation':
//   //       'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fcalculator.png?alt=media&token=4d377200-d8db-417a-96c5-5f000249597e',
//   //   'Wedding':
//   //       'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fengegment.png?alt=media&token=3cbf08e8-e69b-4d7f-89e7-36b85ff79ced',
//   //   'Other':
//   //       'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fcalculator.png?alt=media&token=4d377200-d8db-417a-96c5-5f000249597e'
//   // };
//   var itemsIcons = {
//     'Car':
//         'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FAuto.png?alt=media&token=f4d0ab35-b62d-4613-b3d4-61cef7c41425',
//     'Computer/Electronics':
//         'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FComputer-Electronics.png?alt=media&token=f80cedfc-b1af-4a7f-82fe-86adc9ef4648', //check
//     'Education':
//         'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FEducation.png?alt=media&token=3fba9b33-0ad3-403c-8921-fd7090cda3d4',
//     'Emergency found':
//         'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fcalculator.png?alt=media&token=4d377200-d8db-417a-96c5-5f000249597e',
//     'Electronics':
//         'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FComputer-Electronics.png?alt=media&token=f80cedfc-b1af-4a7f-82fe-86adc9ef4648',
//     'Furnishings':
//         'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FFurnishing.png?alt=media&token=aa005a28-b999-4057-b0bb-360920dcb5c7',
//     'General':
//         'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FGeneral.png?alt=media&token=03dfe2a4-2b14-41f0-b4e7-c059bc9d1e8b',
//     'Home':
//         'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FHome.png?alt=media&token=d5b66d28-3302-4904-9f5c-4b0b4bfcc987',
//     'Start a business':
//         'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FBusiness.png?alt=media&token=6f9deeb6-3892-4b95-b34f-120553d9fecd',
//     'Vacation':
//         'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FTravel.png?alt=media&token=a3b69bd0-4796-4932-89bb-6b9bc8ffee1b',
//     'Wedding':
//         'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FWedding.png?alt=media&token=b451e6e2-2c10-4d08-89c5-1336c24d5cd4',
//     'Other':
//         'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FOther.png?alt=media&token=61ab369f-0da5-47cd-8d85-b90bca35e15d'
//   };

//   _SavingGoalsState(this._uid);

//   // func() async {
//   //   TotalValues totalValues = Provider.of<TotalValues>(context, listen: false);
//   //   await totalValues.getSavingsTotal(widget.uid);
//   // }

//   @override
//   void initState() {
//     // Future.delayed(Duration.zero).then((value) {
//     //   providerTotal = Provider.of<TotalValues>(context, listen: false)
//     //       .getSavingsTotal(widget.uid);
//     // });
//     super.initState();
//     // getSavingsItems();
//     // _totalProvider = Provider.of<TotalValues>(context, listen: false)
//     // .getSavingsTotal(widget.uid);
//     _goalFuture = getSavingsItems();
//     _goalSavings = List<SavingModel>();
//     // _getTotal();
//     // refreshProvider(context);
//     // setState(() {});
//     // getPrefs();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   // getPrefs() async {
//   //   _prefss = await SharedPreferences.getInstance();
//   //   await _prefss.setString('storedUid', widget.uid);
//   // }

//   Future navigateToSetInvestmentGoals(context) async {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => InvestmentGoals(
//                   uid: _uid,
//                 )));
//   }

//   // Future navigateToAbout(context) async {
//   //   Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
//   // }

//   // _updateGoal() {
//   //   if (_path != null) {}
//   // }

//   void _validateInputs() {
//     if (_inputFormKey.currentState.validate()) {
//       //    If all data are correct then save data to out variables

//       if (_savingTime != null && _savingFor != null) {
//         _inputFormKey.currentState.save();
//         // _inputFormKey.currentState.build();
//         // _goalItem(context, index);
//         _saveGoal(context);
//       } else {
//         Validator.onErrorDialog("Make sure you fill all forms!", context);
//       }
//     } else {
// //    If all data are not valid then start auto validation.
//       Validator.onErrorDialog("Make sure you fill all forms!", context);
//     }
//   }

//   // Future<List> _getItems() async {
//   //   return [
//   //     _forSaving = _savingFor,
//   //     _amountSaving = _savingAmount,
//   //   ];
//   // }

//   Future navigateEditSavingGoal(
//       context, SavingModel model, String route) async {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => EditSavingGoal(
//                   uid: _uid,
//                   savingModel: model,
//                   route: route,
//                 )));
//   }

//   // did

//   _saveGoal(context) {
//     if (numberItems < 10) {
//       MainServices.onLoading(context);
//       if (_path != null) {
//         uploadFile().then((value) {
//           // print('stuff');
//           // print(value);
//           firestoreInstance
//               .collection("savingGoals")
//               .doc("users")
//               .collection(_uid)
//               .add({
//             'savingFor': _savingFor,
//             'savingAmount': 0,
//             'savingGoal': _savingAmount,
//             'savingTime': _savingTime,
//             'defaultIcon': (_savingFor == 'Other') ? '' : _savingFor,
//             'photo': (_fileURL != null)
//                 ? _fileURL
//                 : (itemsIcons.containsKey(_savingFor))
//                     ? itemsIcons[_savingFor]
//                     : itemsIcons['Other'],
//             'created': DateTime.now().millisecondsSinceEpoch.toString(),
//             // 'goalId':
//           }).then((value) async {
//             var goalDocId = value.id;
//             // print('running');
//             // print(goalDocId);

//             await firestoreInstance
//                 .collection("savingGoals")
//                 .doc("users")
//                 .collection(_uid)
//                 .doc(goalDocId)
//                 .update({
//               'goalId': goalDocId,
//             });
//             // var listDetails = value.get().asStream().forEach((item) {
//             //   var individual = item.data();
//             //   print(individual);
//             // });
//             // print('PATH HERE');
//             // print(listDetails);
//             // print('OT');
//             // print(value.id + ' eon');
//             // print(value);
//             if (mounted)
//               setState(() {
//                 title = 'Select';
//                 timeTitle = 'Select';
//                 groupValue = null;
//                 group2Value = null;
//               });
//             Navigator.pop(context);
//             // _getTotal();
//             refreshProvider(context);
//             // setState(() {
//             //   getSavingsItems();
//             // });
//             // Validator.onErrorDialog("Saved", context);
//             if (mounted)
//               setState(() {
//                 _savingFor = null;
//                 _savingTime = null;
//                 _goalFuture = getSavingsItems();
//               });
//             _inputFormKey.currentState?.reset();
//             _path = null;
//             numberItems = numberItems + 1;
//           });
//           // print('TEST HERE');
//           // print(testVar);
//         });
//       } else {
//         firestoreInstance
//             .collection("savingGoals")
//             .doc("users")
//             .collection(_uid)
//             .add({
//           'savingFor': _savingFor,
//           'savingAmount': 0,
//           'savingGoal': _savingAmount,
//           'savingTime': _savingTime,
//           'defaultIcon': (_savingFor == 'Other') ? '' : _savingFor,
//           'photo': (_fileURL != null)
//               ? _fileURL
//               : (itemsIcons.containsKey(_savingFor))
//                   ? itemsIcons[_savingFor]
//                   : itemsIcons['Other'],
//           'created': DateTime.now().millisecondsSinceEpoch.toString(),
//         }).then((value) async {
//           var goalDocId = value.id;
//           print('running');
//           print(goalDocId);

//           await firestoreInstance
//               .collection("savingGoals")
//               .doc("users")
//               .collection(_uid)
//               .doc(goalDocId)
//               .update({
//             'goalId': goalDocId,
//           });
//           if (mounted)
//             setState(() {
//               title = 'Select';
//               timeTitle = 'Select';
//               groupValue = null;
//               group2Value = null;
//             });
//           Navigator.pop(context);
//           // _getTotal();
//           refreshProvider(context);
//           // Validator.onErrorDialog("Saved", context);
//           // setState(() {
//           //   Navigator.of(context).pop();
//           // });
//           if (mounted)
//             setState(() {
//               _savingFor = null;
//               _savingTime = null;
//               _goalFuture = getSavingsItems();
//             });
//           _inputFormKey.currentState?.reset();
//           _path = null;
//           numberItems = numberItems + 1;
//         });
//       }
//     } else {
//       Validator.onErrorDialog(
//           "You have reached limit of 10 saving goals", context);
//     }
//   }

//   refreshProvider(context) async {
//     var _referesh = Provider.of<TotalValues>(context, listen: false);
//     await _referesh.getSavingsTotal(widget.uid);
//   }

//   Future<List<SavingModel>> getSavingsItems() async {
//     return firestoreInstance
//         .collection("savingGoals")
//         .doc('users')
//         .collection(_uid)
//         .get()
//         .then((querySnapshot) {
//       _goalSavings = List<SavingModel>();
//       // _goalSavings = querySnapshot.docs.map((result) {
//       //   // print(result);
//       //   // _goalSavings.add(SavingModel.fromJson(result.id, result.data()));
//       //   return SavingModel.fromJson(result.id, result.data());
//       // }).toList();
//       querySnapshot.docs.forEach((result) {
//         _goalSavings.add(SavingModel.fromJson(result.id, result.data()));
//       });
//       // print('yuo');
//       // print(_goalSavings.length);
//     }).then((value) {
//       // if (mounted) setState(() {});
//       // _getTotal();
//       return _goalSavings;
//     });
//   }

//   // Future<int> _getTotal() async {
//   //   savingsTotalList = [];
//   //   List _goalNum = await getSavingsItems();
//   //   if (_goalNum.isNotEmpty) {
//   //     _goalNum.forEach((element) {
//   //       savingsTotalList.add(int.parse(element.goalAmount));
//   //     });
//   //     if (mounted)
//   //       setState(() {
//   //         savingsTotal = savingsTotalList?.reduce((sumSoFar, currentNum) {
//   //           return sumSoFar + currentNum;
//   //         });
//   //       });
//   //   }
//   //   // print(savingsTotalList);

//   //   // print(investTotal);
//   //   return savingsTotal;
//   // }

//   // Widget _goalItem(BuildContext context, int index) {
//   //   // if (_path != null && _savingFor != null && _savingAmount != null)
//   //   // _newIndex = index + 1;
//   //   // total = _goalSavings

//   //   return Column(
//   //     children: [
//   //       Row(
//   //         children: [
//   //           Text((_newIndex++).toString()),
//   //           SizedBox(
//   //             width: 10.0,
//   //           ),
//   //           Container(
//   //             // width: 50,
//   //             child: CircleAvatar(
//   //               // backgroundImage: NetworkImage(_listSavings[index].url),
//   //               backgroundImage: NetworkImage(_goalSavings[index].url),
//   //             ),
//   //           ),
//   //           SizedBox(
//   //             width: 10.0,
//   //           ),
//   //           Text(
//   //             _goalSavings[index].goal,
//   //             // textAlign: TextAlign.left,
//   //             style: TextStyle(
//   //               fontSize: 14,
//   //               fontWeight: FontWeight.w400,
//   //               // color: Colors.grey[450],
//   //             ),
//   //           ),
//   //           Spacer(),
//   //           Text(
//   //             "\$" +
//   //                 double.parse(_goalSavings[index].goalAmount)
//   //                     .toStringAsFixed(2),
//   //             textAlign: TextAlign.end,
//   //             style: TextStyle(
//   //               fontWeight: FontWeight.bold,
//   //               fontSize: 15,
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //       Divider(
//   //         color: Colors.black,
//   //         thickness: 0.4,
//   //       ),
//   //     ],
//   //   );
//   // }

//   Future<String> uploadFile() async {
//     final String fileGEn = Random().nextInt(10000).toString();
//     Reference storageReference = FirebaseStorage.instance
//         .ref()
//         .child('SavingGoals')
//         .child(_uid)
//         .child(fileGEn + _fileName);
//     UploadTask uploadTask = storageReference.putFile(File(_path));
//     await uploadTask.then((TaskSnapshot snapshot) {
//       print('File Uploaded');
//       // setState(() {
//       //   _path = "Uploaded";
//       // });
//     }).catchError((Object e) {
//       print(e); // FirebaseException
//     });
//     // print('File Uploaded');
//     // if (mounted)
//     //   setState(() {
//     //     _path = "Uploaded";
//     //   });
//     await storageReference.getDownloadURL().then((fileURL) {
//       // if (mounted)
//       setState(() {
//         _fileURL = fileURL;
//       });
//       return fileURL;
//     });

//     /// touched, previously null.
//     return _fileURL;
//   }

//   PickedFile compressedImage;

//   void _openFileExplorer() async {
//     ImagePicker imagePicker = ImagePicker();
//     PickedFile compressedImage = await imagePicker.getImage(
//       source: ImageSource.gallery,
//       imageQuality: 70,
//       maxHeight: 700,
//       maxWidth: 1000,
//     );
//     _path = compressedImage.path;
//     _fileName = _path != null
//         ? _path.split('/').last
//         : _paths != null
//             ? _paths.keys.toString()
//             : '...';
//     if (_path != null && _fileName != null) {
//       if (mounted) setState(() {});
//     }
//   }

//   String valueChoose;

//   @override
//   Widget build(BuildContext context) {
//     // _getTotal();
//     // var _totalVal = Provider.of<TotalValues>(context, listen: false);
//     // var _saveGoalTot = _totalVal.savingsTot;
//     return Scaffold(
//       appBar: AppBar(
//         // leading: IconButton(
//         //   icon: Icon(Icons.arrow_back, color: Colors.white),
//         //   onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
//         // ),
//         backgroundColor: Color(0xff0070c0),
//         title: Text('Set Savings Goals'),
//         centerTitle: true,
//         elevation: 0.0,
//       ),
//       endDrawer: Padding(
//         padding: const EdgeInsets.only(right: 28.0),
//         child: MainDrawer(
//           uid: widget.uid,
//           incomingRoute: route,
//         ),
//       ),
//       body: Container(
//         padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 30,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Set up to 10 Savings Goals',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xff0e8646),
//                       fontSize: 16,
//                     ),
//                   ),
//                   Spacer(),
//                   GestureDetector(
//                     onTap: () {
//                       showPosDialog(context);
//                     },
//                     child: Icon(Icons.help, color: Colors.black),
//                   ),
//                 ],
//               ),
//               Divider(
//                 color: Colors.black,
//                 thickness: 0.4,
//               ),
//               Form(
//                 key: _inputFormKey,
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           width: MediaQuery.of(context).size.width - 50,
//                           padding:
//                               EdgeInsets.symmetric(vertical: 10, horizontal: 0),
//                           child: Column(
//                             children: [
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Flexible(
//                                       child: Container(
//                                     decoration: BoxDecoration(
//                                       border: Border(
//                                         bottom: BorderSide(
//                                             width: 0.4, color: Colors.black),
//                                       ),
//                                     ),
//                                     child: Column(
//                                       children: [
//                                         Container(
//                                           // height: 45,
//                                           width: double.infinity,
//                                           constraints: BoxConstraints(
//                                             minHeight: 45,
//                                             minWidth: double.infinity,
//                                           ),
//                                           alignment: Alignment.center,
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Text('I’m saving for:'),
//                                               Spacer(),
//                                               Flexible(
//                                                 child: Padding(
//                                                   padding: const EdgeInsets
//                                                       .symmetric(vertical: 10),
//                                                   child: Text(
//                                                     title,
//                                                     style: TextStyle(
//                                                       fontSize: 17.0,
//                                                       color: Colors.blue,
//                                                       fontWeight:
//                                                           FontWeight.w500,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   setState(() {
//                                                     isStrechedDropDown =
//                                                         !isStrechedDropDown;
//                                                   });
//                                                 },
//                                                 child: Icon(
//                                                   isStrechedDropDown
//                                                       ? Icons.expand_less
//                                                       : Icons.expand_more,
//                                                   size: 30,
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                         ExpandedSection(
//                                           expand: isStrechedDropDown,
//                                           height: 100,
//                                           child: MyScrollbar(
//                                             builder:
//                                                 (context, scrollController2) =>
//                                                     ListView.builder(
//                                               padding: EdgeInsets.all(0),
//                                               controller: scrollController2,
//                                               shrinkWrap: true,
//                                               itemCount: dropList.length,
//                                               itemBuilder: (context, index) {
//                                                 return RadioListTile(
//                                                   title: Text(
//                                                     dropList.elementAt(index),
//                                                   ),
//                                                   activeColor:
//                                                       Color(0xff0070c0),
//                                                   value: index,
//                                                   groupValue: groupValue,
//                                                   onChanged: (val) {
//                                                     setState(() {
//                                                       groupValue = val;
//                                                       title = dropList
//                                                           .elementAt(index);
//                                                       // retailer = val;
//                                                     });

//                                                     if (isStrechedDropDown ==
//                                                         true) {
//                                                       setState(() {
//                                                         isStrechedDropDown =
//                                                             false;
//                                                         if (mounted)
//                                                           switch (val) {
//                                                             case 0:
//                                                               // val = val.toString();
//                                                               val = 'Car';
//                                                               print(val);
//                                                               break;
//                                                             case 1:
//                                                               val =
//                                                                   'Computer/Electronics';
//                                                               break;
//                                                             case 2:
//                                                               val = 'Education';
//                                                               break;
//                                                             case 3:
//                                                               val =
//                                                                   'Emergency fund';
//                                                               break;
//                                                             case 4:
//                                                               val = 'Rainy Day';
//                                                               break;
//                                                             case 5:
//                                                               val =
//                                                                   'Furnishings';
//                                                               break;
//                                                             case 6:
//                                                               val =
//                                                                   'General Savings';
//                                                               break;
//                                                             case 7:
//                                                               val = 'Home';
//                                                               break;
//                                                             case 8:
//                                                               val =
//                                                                   'Start a business';
//                                                               break;
//                                                             case 9:
//                                                               val =
//                                                                   'Travel/Vacation';
//                                                               break;
//                                                             case 10:
//                                                               val = 'Wedding';
//                                                               break;
//                                                             case 11:
//                                                               val =
//                                                                   'I do not have a goal at this time';
//                                                               break;
//                                                             default:
//                                                               print(
//                                                                   'choose an option');
//                                                           }
//                                                         setState(() {
//                                                           if (val == 12) {
//                                                             isClosed = false;
//                                                           } else {
//                                                             isClosed = true;
//                                                             _savingFor = val;
//                                                           }
//                                                         });
//                                                       });
//                                                     }
//                                                   },
//                                                 );
//                                               },
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   )),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     (!isClosed)
//                         ? Container(
//                             child: TextFormField(
//                               controller: myController,
//                               cursorColor: Colors.black,
//                               style: TextStyle(
//                                 color: Colors.black,
//                               ),
//                               decoration: InputDecoration(
//                                 fillColor: Colors.black,
//                                 focusColor: Colors.black,
//                                 labelText: 'Other',
//                                 labelStyle: TextStyle(color: Colors.black),
//                                 hintStyle: TextStyle(
//                                     fontSize: 20.0, color: Colors.white),
//                                 border: OutlineInputBorder(
//                                   borderSide: const BorderSide(
//                                       color: Colors.white, width: 2.0),
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: const BorderSide(
//                                       color: Colors.black, width: 2.0),
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                               ),
//                               keyboardType: TextInputType.text,
//                               onSaved: (value) => _savingFor = value.trim(),
//                             ),
//                           )
//                         : Container(),
//                     Row(
//                       children: [
//                         Align(
//                           alignment: Alignment.topLeft,
//                           child: Text('Savings goal:'),
//                         ),
//                         Spacer(),
//                         SizedBox(
//                           width: 170.0,
//                           child: TextFormField(
//                             cursorColor: Colors.black,
//                             style: TextStyle(
//                               color: Colors.blue,
//                               fontWeight: FontWeight.w500,
//                             ),
//                             textAlign: TextAlign.right,
//                             decoration: InputDecoration(
//                               contentPadding: EdgeInsets.symmetric(
//                                 horizontal: 40.0,
//                                 vertical: 8.0,
//                               ),
//                               hintText: 'Enter amount',
//                               hintStyle: TextStyle(
//                                 color: Colors.blue,
//                                 fontSize: 13.7,
//                               ),
//                               isDense: true,
//                               // filled: true,
//                               // fillColor: Colors.grey.withOpacity(0.2),
//                               labelStyle: TextStyle(
//                                   fontFamily: 'Montserrat',
//                                   color: Colors.black),
//                               focusedBorder: UnderlineInputBorder(
//                                 borderSide: BorderSide.none,
//                               ),
//                               enabledBorder: UnderlineInputBorder(
//                                 borderSide: BorderSide.none,
//                               ),
//                             ),
//                             keyboardType: TextInputType.number,
//                             validator: Validator.validateAmount,
//                             onSaved: (value) => _savingAmount = value,

//                             ///removed the dollar sign
//                           ),
//                         ),
//                       ],
//                     ),
//                     Divider(
//                       color: Colors.black,
//                       thickness: 0.4,
//                     ),
//                     Row(
//                       children: [
//                         Container(
//                           width: MediaQuery.of(context).size.width - 50,
//                           padding:
//                               EdgeInsets.symmetric(vertical: 10, horizontal: 0),
//                           child: Column(
//                             children: [
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Flexible(
//                                       child: Container(
//                                     decoration: BoxDecoration(
//                                       border: Border(
//                                         bottom: BorderSide(
//                                             width: 0.4, color: Colors.black),
//                                       ),
//                                     ),
//                                     child: Column(
//                                       children: [
//                                         Container(
//                                           // height: 45,
//                                           width: double.infinity,
//                                           constraints: BoxConstraints(
//                                             minHeight: 45,
//                                             minWidth: double.infinity,
//                                           ),
//                                           alignment: Alignment.center,
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Text('Time to achieve goal:'),
//                                               Spacer(),
//                                               Flexible(
//                                                 child: Padding(
//                                                   padding: const EdgeInsets
//                                                       .symmetric(vertical: 10),
//                                                   child: Text(
//                                                     timeTitle,
//                                                     style: TextStyle(
//                                                       fontSize: 17.0,
//                                                       color: Colors.blue,
//                                                       fontWeight:
//                                                           FontWeight.w500,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               GestureDetector(
//                                                 onTap: () {
//                                                   setState(() {
//                                                     isStrechedDropDown2 =
//                                                         !isStrechedDropDown2;
//                                                   });
//                                                 },
//                                                 child: Icon(
//                                                   isStrechedDropDown2
//                                                       ? Icons.expand_less
//                                                       : Icons.expand_more,
//                                                   size: 30,
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                         ExpandedSection(
//                                           expand: isStrechedDropDown2,
//                                           height: 100,
//                                           child: MyScrollbar(
//                                             builder:
//                                                 (context, scrollController2) =>
//                                                     ListView.builder(
//                                               padding: EdgeInsets.all(0),
//                                               controller: scrollController2,
//                                               shrinkWrap: true,
//                                               itemCount: secondDropList.length,
//                                               itemBuilder: (context, index) {
//                                                 return RadioListTile(
//                                                   title: Text(secondDropList
//                                                       .elementAt(index)),
//                                                   activeColor:
//                                                       Color(0xff0070c0),
//                                                   value: index,
//                                                   groupValue: group2Value,
//                                                   onChanged: (val) {
//                                                     setState(() {
//                                                       group2Value = val;
//                                                       timeTitle = secondDropList
//                                                           .elementAt(index);
//                                                       // retailer = val;
//                                                     });

//                                                     if (isStrechedDropDown2 ==
//                                                         true) {
//                                                       setState(() {
//                                                         isStrechedDropDown2 =
//                                                             false;
//                                                         if (mounted)
//                                                           switch (val) {
//                                                             case 0:
//                                                               setState(() {
//                                                                 // val = val.toString();
//                                                                 val =
//                                                                     '6 months';
//                                                                 print(val);
//                                                               });
//                                                               break;
//                                                             case 1:
//                                                               setState(() {
//                                                                 val =
//                                                                     '12 months';
//                                                               });
//                                                               break;
//                                                             case 2:
//                                                               setState(() {
//                                                                 val =
//                                                                     '18 months';
//                                                               });
//                                                               break;
//                                                             case 3:
//                                                               setState(() {
//                                                                 val =
//                                                                     '24 months';
//                                                               });
//                                                               break;
//                                                             case 4:
//                                                               setState(() {
//                                                                 val =
//                                                                     '30 months';
//                                                               });
//                                                               break;
//                                                             case 5:
//                                                               setState(() {
//                                                                 val = '3 years';
//                                                               });
//                                                               break;
//                                                             case 6:
//                                                               setState(() {
//                                                                 val = '5 years';
//                                                               });
//                                                               break;
//                                                             case 7:
//                                                               setState(() {
//                                                                 val = '7 years';
//                                                               });
//                                                               break;
//                                                             case 8:
//                                                               setState(() {
//                                                                 val = '8 years';
//                                                               });
//                                                               break;
//                                                             case 9:
//                                                               setState(() {
//                                                                 val =
//                                                                     '10 years';
//                                                               });
//                                                               break;
//                                                             case 10:
//                                                               setState(() {
//                                                                 val =
//                                                                     '15 years';
//                                                               });
//                                                               break;
//                                                             default:
//                                                               print(
//                                                                   'choose an option');
//                                                           }
//                                                         _savingTime = val;
//                                                       });
//                                                     }
//                                                   },
//                                                 );
//                                               },
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   )),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 10.0,
//               ),
//               Row(
//                 children: [
//                   // Consumer<TotalValues>(
//                   //   build
//                   // ),
//                   (_path == null)
//                       ? Expanded(
//                           child: Align(
//                             alignment: Alignment.topLeft,
//                             child: Text(
//                               'Upload image of your savings goal (optional)',
//                             ),
//                           ),
//                         )
//                       : Expanded(
//                           child: Align(
//                             alignment: Alignment.topLeft,
//                             child: Text(
//                               _path,
//                               textAlign: TextAlign.left,
//                               style:
//                                   TextStyle(fontSize: 16, color: Colors.green),
//                             ),
//                           ),
//                         ),
//                   Spacer(),
//                   (_path != null)

//                       ///use circleavatar if problems
//                       ? GestureDetector(
//                           onTap: () {
//                             _openFileExplorer();
//                           },
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(80.0),
//                             child: Image.file(
//                               File(_path),
//                               fit: BoxFit.fill,
//                               height: 150.0,
//                               width: 150.0,
//                             ),
//                           ),
//                         )
//                       : GestureDetector(
//                           onTap: () {
//                             _openFileExplorer();
//                           },
//                           child: Container(
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color: Colors.blue,
//                               ),
//                               shape: BoxShape.circle,
//                               color: Colors.grey.withOpacity(0.2),
//                             ),
//                             height: 100.0,
//                             width: 100.0,
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 10.0,
//                             ),
//                             margin: EdgeInsets.symmetric(
//                               vertical: 10.0,
//                             ),
//                             child: Align(
//                               alignment: Alignment.center,
//                               child: Text(
//                                 'Upload',
//                                 style: TextStyle(
//                                   color: Colors.blue,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                 ],
//               ),
//               SizedBox(
//                 height: 20.0,
//               ),
//               Column(
//                 children: [
//                   Row(
//                     children: [
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           'Savings Goal',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 15,
//                           ),
//                         ),
//                       ),
//                       Spacer(),
//                       TextButton(
//                         style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.resolveWith(
//                             (states) => Color(0xff0e8646),
//                           ),
//                           shape:
//                               MaterialStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15.0),
//                             ),
//                           ),
//                           overlayColor: MaterialStateProperty.resolveWith(
//                             (states) {
//                               return states.contains(MaterialState.pressed)
//                                   ? Colors.green
//                                   : null;
//                             },
//                           ),
//                           minimumSize: MaterialStateProperty.resolveWith(
//                               (states) => Size(60, 12)),
//                           // maximumSize: MaterialStateProperty.resolveWith(
//                           //     (states) => Size(60, 20)),
//                         ),
//                         onPressed: () => Timer(
//                           const Duration(milliseconds: 400),
//                           () {
//                             // _validateInputs();
//                           },
//                         ),
//                         child: Container(
//                           child: Text(
//                             'Save',
//                             style: TextStyle(
//                               fontSize: 15.0,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                       // TextButton(onPressed: () {}, child: Container(
//                       //     child: Text(
//                       //       'Save',
//                       //       style: TextStyle(
//                       //         fontSize: 15.0,
//                       //         color: Colors.white,
//                       //       ),
//                       //     ),
//                       //   ),
//                       //   style: ElevatedButton.styleFrom(
//                       //     shape:  RoundedRectangleBorder(
//                       //         borderRadius: BorderRadius.circular(15.0),
//                       //       ),
//                       //      overlay
//                       //   ),
//                       //   ),
//                     ],
//                   ),
//                   Divider(
//                     color: Colors.black,
//                     thickness: 0.4,
//                   ),
//                   Consumer<TotalValues>(
//                     builder: (context, sgProvider, child) {
//                       return FutureBuilder(
//                         future: sgProvider
//                             .getSavingsInProvider(widget.uid), // async work
//                         builder: (BuildContext context, snapshot) {
//                           if (sgProvider.savingModelInstance != null) {
//                             return ListView.builder(
//                               physics: NeverScrollableScrollPhysics(),
//                               scrollDirection: Axis.vertical,
//                               shrinkWrap: true,
//                               itemCount:
//                                   (sgProvider.savingModelInstance != null)
//                                       ? sgProvider.savingModelInstance.length
//                                       : 0,
//                               itemBuilder: (BuildContext context, int index) {
//                                 return Column(
//                                   children: [
//                                     GestureDetector(
//                                       behavior: HitTestBehavior.translucent,
//                                       onTap: () {
//                                         navigateEditSavingGoal(
//                                             context,
//                                             sgProvider
//                                                 .savingModelInstance[index],
//                                             route);
//                                         // print('running');
//                                       },
//                                       child: Row(
//                                         children: [
//                                           Text((index + 1).toString() + '.'),
//                                           SizedBox(
//                                             width: 10.0,
//                                           ),
//                                           Container(
//                                             // width: 50,
//                                             child: CircleAvatar(
//                                               backgroundImage: NetworkImage(
//                                                   // if(index )
//                                                   sgProvider
//                                                       .savingModelInstance[
//                                                           index]
//                                                       .url),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 10.0,
//                                           ),
//                                           Text(
//                                             sgProvider
//                                                 .savingModelInstance[index]
//                                                 .goal,
//                                             // textAlign: TextAlign.left,
//                                             style: TextStyle(
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.w400,
//                                               // color: Colors.grey[450],
//                                             ),
//                                           ),
//                                           Spacer(),
//                                           Text(
//                                             NumberFormat.simpleCurrency(
//                                               locale: 'en-us',
//                                               decimalDigits: 0,
//                                             ).format(
//                                               int.parse(sgProvider
//                                                   .savingModelInstance[index]
//                                                   .goalAmount),
//                                             ),
//                                             textAlign: TextAlign.end,
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 15,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Divider(
//                                       color: Colors.black,
//                                       thickness: 0.4,
//                                     ),
//                                   ],
//                                 );
//                               },
//                             );
//                           }
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
//                                   itemCount: (sgProvider.savingModelInstance !=
//                                           null)
//                                       ? sgProvider.savingModelInstance.length
//                                       : 0,
//                                   itemBuilder:
//                                       (BuildContext context, int index) {
//                                     return Column(
//                                       children: [
//                                         GestureDetector(
//                                           behavior: HitTestBehavior.translucent,
//                                           onTap: () {
//                                             navigateEditSavingGoal(
//                                                 context,
//                                                 sgProvider
//                                                     .savingModelInstance[index],
//                                                 route);
//                                             // print('running');
//                                           },
//                                           child: Row(
//                                             children: [
//                                               Text(
//                                                   (index + 1).toString() + '.'),
//                                               SizedBox(
//                                                 width: 10.0,
//                                               ),
//                                               Container(
//                                                 // width: 50,
//                                                 child: CircleAvatar(
//                                                   backgroundImage: NetworkImage(
//                                                       // if(index )
//                                                       sgProvider
//                                                           .savingModelInstance[
//                                                               index]
//                                                           .url),
//                                                 ),
//                                               ),
//                                               SizedBox(
//                                                 width: 10.0,
//                                               ),
//                                               Text(
//                                                 sgProvider
//                                                     .savingModelInstance[index]
//                                                     .goal,
//                                                 // textAlign: TextAlign.left,
//                                                 style: TextStyle(
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.w400,
//                                                   // color: Colors.grey[450],
//                                                 ),
//                                               ),
//                                               Spacer(),
//                                               Text(
//                                                 NumberFormat.simpleCurrency(
//                                                   locale: 'en-us',
//                                                   decimalDigits: 0,
//                                                 ).format(
//                                                   int.parse(sgProvider
//                                                       .savingModelInstance[
//                                                           index]
//                                                       .goalAmount),
//                                                 ),
//                                                 textAlign: TextAlign.end,
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 15,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         Divider(
//                                           color: Colors.black,
//                                           thickness: 0.4,
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 );
//                           }
//                         },
//                       );
//                     },
//                   ),
//                   Row(
//                     children: [
//                       Spacer(),
//                       Container(
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             'Total Savings Goal:',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 15.0,
//                             ),
//                           ),
//                         ),
//                       ),
//                       // Spacer(),
//                       SizedBox(
//                         width: 30,
//                       ),
//                       Consumer<TotalValues>(
//                         builder: (context, totaValue, child) {
//                           return FutureBuilder(
//                               future: totaValue.savingsTot == null
//                                   ? totaValue.getSavingsTotal(widget.uid)
//                                   : null,
//                               builder: (context, snapshot) {
//                                 if (totaValue.savingsTot != null) {
//                                   return Container(
//                                     width: 80.0,
//                                     child: Text(
//                                       NumberFormat.simpleCurrency(
//                                         locale: 'en-us',
//                                         decimalDigits: 0,
//                                       ).format(totaValue.savingsTot),
//                                       textAlign: TextAlign.end,
//                                       style: TextStyle(
//                                         fontSize: 15.0,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   );
//                                 } else
//                                   switch (snapshot.connectionState) {
//                                     case ConnectionState.waiting:
//                                       return Container(
//                                         width: 80.0,
//                                         child: Text(
//                                           '--',
//                                           textAlign: TextAlign.end,
//                                           style: TextStyle(
//                                             fontSize: 20.0,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       );
//                                     default:
//                                       if (snapshot.hasError) {
//                                         print('Error: ${snapshot.error}');
//                                         return Container(
//                                           width: 80.0,
//                                           child: Text(
//                                             '--',
//                                             textAlign: TextAlign.end,
//                                             style: TextStyle(
//                                               fontSize: 20.0,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         );
//                                       } else
//                                         return Container(
//                                           width: 80.0,
//                                           child: Text(
//                                             NumberFormat.simpleCurrency(
//                                               locale: 'en-us',
//                                               decimalDigits: 0,
//                                             ).format(totaValue.savingsTot),
//                                             textAlign: TextAlign.end,
//                                             style: TextStyle(
//                                               fontSize: 15.0,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         );
//                                   }
//                               });
//                         },
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 40.0,
//                   ),
//                   // Spacer(),
//                   Padding(
//                     padding: EdgeInsets.only(bottom: 10.0),
//                     child: Row(
//                       children: <Widget>[
//                         Expanded(
//                           child: SizedBox.fromSize(
//                             size: Size(
//                               50.0,
//                               60.0,
//                             ),
//                             child: TextButton(
//                               style: ButtonStyle(
//                                 backgroundColor:
//                                     MaterialStateProperty.resolveWith(
//                                   (states) => Color(0xff0e8646),
//                                 ),
//                                 shape: MaterialStateProperty.all<
//                                     RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                 ),
//                                 overlayColor: MaterialStateProperty.resolveWith(
//                                   (states) {
//                                     return states
//                                             .contains(MaterialState.pressed)
//                                         ? Colors.green
//                                         : null;
//                                   },
//                                 ),
//                               ),
//                               onPressed: () => Timer(
//                                 const Duration(milliseconds: 400),
//                                 () {
//                                   _validateInputs();
//                                   refreshProvider(context);
//                                   setState(() {
//                                     // getSavingsItems();
//                                   });
//                                 },
//                               ),
//                               child: Container(
//                                 child: Text(
//                                   'Set Another\nSavings Goal',
//                                   style: TextStyle(
//                                     fontSize: 15.0,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 10.0,
//                         ),
//                         // _validateInputs();
//                         // navigateToSetInvestmentGoals(context);
//                         Expanded(
//                           child: SizedBox.fromSize(
//                             size: Size(
//                               50.0,
//                               60.0,
//                             ),
//                             child: TextButton(
//                               style: ButtonStyle(
//                                 backgroundColor:
//                                     MaterialStateProperty.resolveWith(
//                                   (states) => Color(0xff0070c0),
//                                 ),
//                                 shape: MaterialStateProperty.all<
//                                     RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10.0),
//                                   ),
//                                 ),
//                                 overlayColor: MaterialStateProperty.resolveWith(
//                                   (states) {
//                                     return states
//                                             .contains(MaterialState.pressed)
//                                         ? Colors.blue
//                                         : null;
//                                   },
//                                 ),
//                               ),
//                               onPressed: () => Timer(
//                                 const Duration(milliseconds: 400),
//                                 () async {
//                                   navigateToSetInvestmentGoals(context);
//                                   // SharedPreferences prefs =
//                                   //     await SharedPreferences.getInstance();
//                                   // var currentUid = prefs.getString('storedUid');
//                                   // print(currentUid);
//                                 },
//                               ),
//                               child: Container(
//                                 child: Text(
//                                   'Done',
//                                   style: TextStyle(
//                                     fontSize: 15.0,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
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

//   showPosDialog(BuildContext context) {
//     // set up the AlertDialog
//     AlertDialog alert = AlertDialog(
//       elevation: 24.0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(30.0),
//       ),
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           // crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             SizedBox(
//               height: 13.0,
//             ),
//             Row(
//               children: [
//                 Flexible(
//                   child: Align(
//                     alignment: Alignment.topLeft,
//                     child: Text(
//                       'Saving and investing are both crucial to your financial health, but they are not the same.',
//                       maxLines: 4,
//                       style: TextStyle(
//                         height: 1.4,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 17.0,
//             ),
//             Container(
//               child: Align(
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   'Savings Goals',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     // color: Color(0xff0070c0),
//                     fontSize: 17.0,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 17.0,
//             ),
//             Container(
//               child: Text(
//                   'People typically save for purchases like a computer, vacation, or a down payment for a home which they intend to make within the next few months or years. They also save for a rainy day.'),
//             ),
//             SizedBox(
//               height: 17,
//             ),
//             Container(
//               child: Align(
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   'Saving is Safe',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     // color: Color(0xff0070c0),
//                     fontSize: 17.0,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 17,
//             ),
//             Container(
//               child: Text(
//                 "When you save, you put your money in a safe place, a savings account or CD where you can easily access it when you need it. While your savings are safe, they don't earn much interest.",
//                 style: TextStyle(
//                   color: Colors.black,
//                   height: 1.4,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 17.0,
//             ),
//             Container(
//               child: Align(
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   'For More Information',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     // color: Color(0xff0070c0),
//                     fontSize: 17.0,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 17.0,
//             ),
//             Container(
//               child: RichText(
//                 text: TextSpan(
//                   style: TextStyle(
//                     color: Colors.black,
//                     height: 1.5,
//                     fontSize: 16,
//                   ),
//                   children: [
//                     TextSpan(
//                       text:
//                           'For more information on saving, investing, and achieving your long-term financial goals, read ',
//                       style: TextStyle(
//                         height: 1.4,
//                       ),
//                     ),
//                     TextSpan(
//                       recognizer: TapGestureRecognizer()..onTap = () {},
//                       text: 'The \$500 Cup of Coffee, ',
//                       style: TextStyle(
//                         // decoration: TextDecoration.underline,
//                         height: 1.4,
//                         color: Colors.blue,
//                         fontStyle: FontStyle.italic,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     TextSpan(
//                       text:
//                           'co-authored by Steven Lome, the developer of Pay or Save.',
//                       style: TextStyle(
//                         height: 1.4,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 40.0,
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         Center(
//           child: ElevatedButton(
//             style: ButtonStyle(
//               minimumSize:
//                   MaterialStateProperty.resolveWith((states) => Size(230, 45)),
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
//                 fontSize: 20.0,
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
// }
