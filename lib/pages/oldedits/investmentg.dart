// import 'dart:async';
// import 'dart:io';
// import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:pay_or_save/pages/about.dart';
// import 'package:pay_or_save/pages/starting_balances.dart';
// import 'package:pay_or_save/services/services.dart';
// import 'package:pay_or_save/utilities/validator.dart';
// import 'package:pay_or_save/widgets/menu.dart';

// class InvestmentGoals extends StatefulWidget {
//   final String uid;

//   @override
//   _InvestmentGoalsState createState() => _InvestmentGoalsState(uid);

//   InvestmentGoals({Key key, @required this.uid}) : super(key: key);
// }

// class _InvestmentGoalsState extends State<InvestmentGoals> {
//   String _uid,
//       _investFor,
//       _other,
//       _investAmount,
//       _investTime,
//       _fileURL,
//       _path,
//       _fileName,
//       _extension;
//   Map<String, String> _paths;
//   bool _loadingPath = false;
//   bool _multiPick = false;
//   bool _hasValidMime = false;
//   FileType _pickingType;
//   int numberItems = 0;
//   bool isClosed = true;
//   final myController = TextEditingController();
//   final firestoreInstance = Firestore.instance;
//   final GlobalKey<FormState> _inputFormKey = GlobalKey<FormState>();

//   var itemsIcons = {
//     'Car': 'Car',
//     'Computer': 'Computer',
//     'Education': 'Education',
//     'Emergency found': 'Emergency found',
//     'Electronics': 'Electronics',
//     'Furnishings': 'Furnishings',
//     'General': 'General',
//     'Home': 'Home',
//     'Start a business': 'Start a business',
//     'Vacation': 'Vacation',
//     'Wedding': 'Wedding',
//     'Other': 'Other'
//   };

//   _InvestmentGoalsState(this._uid);

//   @override
//   void initState() {
//     super.initState();
//     getItems();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   Future navigateToAbout(context) async {
//     Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
//   }

//   Future navigateToStartingBalances(context) async {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => StartingBalances(
//                   uid: _uid,
//                 )));
//   }

//   void _validateInputs() {
//     if (_inputFormKey.currentState.validate()) {
//       //    If all data are correct then save data to out variables
//       if (_investTime != null && _investFor != null) {
//         _inputFormKey.currentState.save();
//         _saveGoal();
//       } else {
//         Validator.onErrorDialog("Make sure you fill all forms!", context);
//       }
//     } else {
// //    If all data are not valid then start auto validation.
//       Validator.onErrorDialog("Make sure you fill all forms!", context);
//     }
//   }

//   Future<int> getItems() async {
//     return firestoreInstance
//         .collection("investmentGoals")
//         .document('users')
//         .collection(_uid)
//         .getDocuments()
//         .then((querySnapshot) {
//       numberItems = querySnapshot.documents.length;
//       return querySnapshot.documents.length;
//     });
//   }

//   _saveGoal() {
//     if (numberItems < 5) {
//       MainServices.onLoading(context);
//       if (_path != null) {
//         uploadFile().then((value) {
//           firestoreInstance
//               .collection("investmentGoals")
//               .document("users")
//               .collection(_uid)
//               .add({
//             'investFor': _investFor,
//             'investAmount': 0,
//             'investGoal': _investAmount,
//             'investTime': _investTime,
//             'defaultIcon': (_investFor == 'Other') ? '' : _investFor,
//             'photo': (_fileURL != null)
//                 ? _fileURL
//                 : (itemsIcons.containsKey(_investFor))
//                     ? itemsIcons[_investFor]
//                     : itemsIcons['Other'],
//             'created': DateTime.now().millisecondsSinceEpoch.toString(),
//           }).then((value) {
//             Navigator.pop(context);
//             Validator.onErrorDialog("Saved", context);
//             setState(() {
//               _investFor = null;
//               _investTime = null;
//             });
//             _inputFormKey.currentState?.reset();
//             _path = null;
//             numberItems = numberItems + 1;
//           });
//         });
//       } else {
//         firestoreInstance
//             .collection("investmentGoals")
//             .document("users")
//             .collection(_uid)
//             .add({
//           'investFor': _investFor,
//           'investAmount': 0,
//           'investGoal': _investAmount,
//           'investTime': _investTime,
//           'defaultIcon': (_investFor == 'Other') ? '' : _investFor,
//           'photo': (_fileURL != null)
//               ? _fileURL
//               : (itemsIcons.containsKey(_investFor))
//                   ? itemsIcons[_investFor]
//                   : itemsIcons['Other'],
//           'created': DateTime.now().millisecondsSinceEpoch.toString(),
//         }).then((value) {
//           Navigator.pop(context);
//           Validator.onErrorDialog("Saved", context);
//           setState(() {
//             _investFor = null;
//             _investTime = null;
//           });
//           _inputFormKey.currentState?.reset();
//           _path = null;
//           numberItems = numberItems + 1;
//         });
//       }
//     } else {
//       Validator.onErrorDialog(
//           "You have reached limit of 5 investment goals", context);
//     }
//   }

//   Future<String> uploadFile() async {
//     final String fileGEn = Random().nextInt(10000).toString();
//     StorageReference storageReference = FirebaseStorage.instance
//         .ref()
//         .child('InvestmentGoals')
//         .child(_uid)
//         .child(fileGEn + _fileName);
//     StorageUploadTask uploadTask = storageReference.putFile(File(_path));
//     await uploadTask.onComplete;
//     print('File Uploaded');
//     setState(() {
//       _path = "Uploaded";
//     });
//     await storageReference.getDownloadURL().then((fileURL) {
//       setState(() {
//         _fileURL = fileURL;
//       });
//       return fileURL;
//     });
//     return null;
//   }

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
//       setState(() {});
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         actions: <Widget>[MyManue.childPopup(context)],
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text("Set Investment Goals"),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(24),
//           child: Column(
//             children: <Widget>[
//               SizedBox(
//                 height: 16,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Padding(
//                     padding: EdgeInsets.only(right: 10),
//                     child: Text(
//                       "Set up to 5 Investment Goals",
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                     ),
//                   ),
//                   GestureDetector(
//                       onTap: () {
//                         navigateToAbout(context);
//                       },
//                       child: Icon(
//                         Icons.help_outline,
//                         color: Colors.deepPurple,
//                         size: 32,
//                       )),
//                 ],
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               Form(
//                 key: _inputFormKey,
//                 child: Column(
//                   children: <Widget>[
//                     DropdownButton(
//                       hint: _investFor == null
//                           ? Text('I\'m investing for:')
//                           : Text(
//                               _investFor,
//                               style: TextStyle(color: Colors.black),
//                             ),
//                       isExpanded: true,
//                       iconSize: 30.0,
//                       style: TextStyle(color: Colors.blue, fontSize: 20),
//                       items: [
//                         'Car',
//                         'Computer',
//                         'Education',
//                         'Emergency found',
//                         'Electronics',
//                         'Furnishings',
//                         'General',
//                         'Home',
//                         'Start a business',
//                         'Vacation',
//                         'Wedding',
//                         'Other'
//                       ].map(
//                         (val) {
//                           return DropdownMenuItem<String>(
//                             value: val,
//                             child: Text(val),
//                           );
//                         },
//                       ).toList(),
//                       onChanged: (val) {
//                         setState(
//                           () {
//                             _investFor = val;
//                             if (val == "Other") {
//                               isClosed = false;
//                             } else {
//                               isClosed = true;
//                             }
//                           },
//                         );
//                       },
//                     ),
//                     SizedBox(
//                       height: 16,
//                     ),
//                     !isClosed
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
//                               onSaved: (value) => _investFor = value.trim(),
//                             ),
//                           )
//                         : Container(),
//                     SizedBox(
//                       height: 16,
//                     ),
//                     Container(
//                       child: TextFormField(
//                         cursorColor: Colors.black,
//                         style: TextStyle(
//                           color: Colors.black,
//                         ),
//                         decoration: InputDecoration(
//                           fillColor: Colors.black,
//                           focusColor: Colors.black,
//                           labelText: 'Investment goal amount',
//                           labelStyle: TextStyle(color: Colors.black),
//                           hintStyle:
//                               TextStyle(fontSize: 20.0, color: Colors.white),
//                           border: OutlineInputBorder(
//                             borderSide: const BorderSide(
//                                 color: Colors.white, width: 2.0),
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(
//                                 color: Colors.black, width: 2.0),
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                         ),
//                         keyboardType: TextInputType.number,
//                         validator: Validator.validateAmount,
//                         onSaved: (value) => _investAmount = value,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 16,
//                     ),
//                     DropdownButton(
//                       hint: _investTime == null
//                           ? Text('Investment goal time:')
//                           : Text(
//                               _investTime,
//                               style: TextStyle(color: Colors.black),
//                             ),
//                       isExpanded: true,
//                       iconSize: 30.0,
//                       style: TextStyle(color: Colors.blue, fontSize: 20),
//                       items: [
//                         '6 months',
//                         '12 months',
//                         '18 months',
//                         '24 months',
//                         '30 months',
//                         '3 years',
//                         '5 years',
//                         '7 years',
//                         '8+ years'
//                       ].map(
//                         (val) {
//                           return DropdownMenuItem<String>(
//                             value: val,
//                             child: Text(val),
//                           );
//                         },
//                       ).toList(),
//                       onChanged: (val) {
//                         setState(
//                           () {
//                             _investTime = val;
//                             if (val == "Other") {
//                               isClosed = false;
//                             } else {
//                               isClosed = true;
//                             }
//                           },
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 16,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Container(
//                     width: 120,
//                     child: (_path == null)
//                         ? Text(
//                             "Upload photo of your investment goal (optional)",
//                             textAlign: TextAlign.left,
//                             style: TextStyle(fontSize: 16),
//                           )
//                         : Text(
//                             _path,
//                             textAlign: TextAlign.left,
//                             style: TextStyle(fontSize: 16, color: Colors.green),
//                           ),
//                   ),
//                   ButtonTheme(
//                     minWidth: 120.0,
//                     height: 50.0,
//                     child: RaisedButton(
//                       textColor: Colors.white,
//                       color: Color(0xFF660066),
//                       child: Text("Upload"),
//                       onPressed: () {
//                         _openFileExplorer();
//                       },
//                       shape: new RoundedRectangleBorder(
//                         borderRadius: new BorderRadius.circular(10.0),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 26,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     "Total Savings Goal:",
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 100,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: <Widget>[
//                   Padding(
//                     padding: EdgeInsets.only(left: 0.0, right: 0.0),
//                     child: ButtonTheme(
//                       minWidth: 120.0,
//                       height: 50.0,
//                       child: RaisedButton(
//                         textColor: Colors.white,
//                         color: Color(0xFF660066),
//                         child: Text("Set Saving Goal"),
//                         onPressed: () {
//                           _validateInputs();
//                         },
//                         shape: new RoundedRectangleBorder(
//                           borderRadius: new BorderRadius.circular(10.0),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(left: 0.0, right: 0.0),
//                     child: ButtonTheme(
//                       minWidth: 120.0,
//                       height: 50.0,
//                       child: RaisedButton(
//                         textColor: Colors.white,
//                         color: Color(0xFFb396da),
//                         child: Text("Done"),
//                         onPressed: () {
//                           navigateToStartingBalances(context);
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
