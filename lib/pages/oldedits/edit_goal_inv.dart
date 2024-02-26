// import 'dart:async';
// import 'dart:io';
// import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:pay_or_save/models/investment_goal_model.dart';
// import 'package:pay_or_save/pages/investment_goal.dart';
// import 'package:pay_or_save/pages/about.dart';
// import 'package:pay_or_save/services/services.dart';
// import 'package:pay_or_save/utilities/validator.dart';
// import 'package:pay_or_save/widgets/menu.dart';

// class EditInvestmentGoal extends StatefulWidget {
//   final String uid;
//   final InvestmentModel investmentModel;

//   @override
//   _EditInvestmentGoalState createState() =>
//       _EditInvestmentGoalState(uid, investmentModel);

//   EditInvestmentGoal({Key key, @required this.uid, this.investmentModel})
//       : super(key: key);
// }

// class _EditInvestmentGoalState extends State<EditInvestmentGoal> {
//   String _uid,
//       _goal,
//       _amount,
//       _time,
//       _fileURL,
//       _path,
//       _fileName,
//       _extension,
//       url;
//   Map<String, String> _paths;
//   bool _loadingPath = false;
//   bool _multiPick = false;
//   bool _hasValidMime = false;
//   InvestmentModel investmentModel;
//   FileType _pickingType;
//   final firestoreInstance = FirebaseFirestore.instance;
//   final GlobalKey<FormState> _inputFormKey = GlobalKey<FormState>();
//   final myGoal = TextEditingController();
//   final myAmount = TextEditingController();

//   _EditInvestmentGoalState(this._uid, this.investmentModel);

//   @override
//   void initState() {
//     super.initState();
//     myGoal.text = investmentModel.goal;
//     myAmount.text = investmentModel.goalAmount;
//     url = investmentModel.url;
//     _amount = investmentModel.amount;
//     _goal = investmentModel.goal;
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   Future navigateToAbout(context) async {
//     Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
//   }

//   void _validateInputs() {
//     if (_inputFormKey.currentState.validate()) {
//       //    If all data are correct then save data to out variables
//       if (_goal != null && _amount != null) {
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

//   Future onSubmit(String message, context) {
//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Alert"),
//           content: Text(
//             message,
//             style: TextStyle(fontSize: 20),
//           ),
//           actions: [
//             new FlatButton(
//                 child: const Text("No"),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 }),
//             new FlatButton(
//                 child: const Text("Yes"),
//                 onPressed: () {
//                   firestoreInstance
//                       .collection("investmentGoals")
//                       .doc("users")
//                       .collection(_uid)
//                       .doc(investmentModel.key)
//                       .delete()
//                       .then((_) {
//                     Navigator.pop(context);
//                     Navigator.pop(context);
//                   });
//                 }),
//           ],
//         );
//       },
//     );
//   }

//   _saveGoal() {
//     MainServices.onLoading(context);
//     if (_path != null) {
//       uploadFile().then((value) {
//         firestoreInstance
//             .collection("investmentGoals")
//             .doc("users")
//             .collection(_uid)
//             .doc(investmentModel.key)
//             .update({
//           'investFor': _goal,
//           'investGoal': _amount,
//           'photo': (_fileURL != null) ? _fileURL : '',
//         }).then((value) {
//           Navigator.pop(context);
//           Validator.onErrorDialog("Saved", context);
//           _inputFormKey.currentState?.reset();
//           _path = null;
//         });
//       });
//     } else {
//       firestoreInstance
//           .collection("investmentGoals")
//           .doc("users")
//           .collection(_uid)
//           .doc(investmentModel.key)
//           .update({
//         'investFor': _goal,
//         'investGoal': _amount,
//       }).then((value) {
//         Navigator.pop(context);
//         Validator.onErrorDialog("Saved", context);
//         _inputFormKey.currentState?.reset();
//         _path = null;
//       });
//     }
//   }

//   Future<String> uploadFile() async {
//     final String fileGEn = Random().nextInt(10000).toString();
//     firebase_storage.Reference storageReference = firebase_storage
//         .FirebaseStorage.instance
//         .ref()
//         .child('SavingGoals')
//         .child(_uid)
//         .child(fileGEn + _fileName);
//     firebase_storage.UploadTask uploadTask =
//         storageReference.putFile(File(_path));
//     //await uploadTask.onComplete;
//     await uploadTask.then((firebase_storage.TaskSnapshot snapshot) {
//       print('File Uploaded');
//       setState(() {
//         _path = "Uploaded";
//       });
//     }).catchError((Object e) {
//       print(e); // FirebaseException
//     });

//     await storageReference.getDownloadURL().then((fileURL) {
//       setState(() {
//         _fileURL = fileURL;
//         _path = null;
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
//         actions: <Widget>[MyManue.childPopup(context)],
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text("Edit Goal"),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(24),
//           child: Column(
//             children: <Widget>[
//               SizedBox(
//                 height: 16,
//               ),
//               Form(
//                 key: _inputFormKey,
//                 child: Column(
//                   children: <Widget>[
//                     SizedBox(
//                       height: 16,
//                     ),
//                     Text(
//                       "Invest For",
//                       style: TextStyle(
//                           fontSize: 20.0,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(
//                       height: 16,
//                     ),
//                     Container(
//                       child: TextFormField(
//                         controller: myGoal,
//                         cursorColor: Colors.black,
//                         style: TextStyle(
//                           color: Colors.black,
//                         ),
//                         decoration: InputDecoration(
//                           fillColor: Colors.black,
//                           focusColor: Colors.black,
//                           labelText: '',
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
//                         keyboardType: TextInputType.text,
//                         validator: Validator.emptyInput,
//                         onSaved: (value) => _goal = value,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 16,
//                     ),
//                     Text(
//                       "Investment Goal",
//                       style: TextStyle(
//                           fontSize: 20.0,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(
//                       height: 16,
//                     ),
//                     Container(
//                       child: TextFormField(
//                         controller: myAmount,
//                         cursorColor: Colors.black,
//                         style: TextStyle(
//                           color: Colors.black,
//                         ),
//                         decoration: InputDecoration(
//                           fillColor: Colors.black,
//                           focusColor: Colors.black,
//                           labelText: '',
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
//                         onSaved: (value) => _amount = value,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 32,
//                     ),
//                   ],
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: <Widget>[
//                   Padding(
//                     padding: EdgeInsets.only(right: 10),
//                     child: Text(
//                       "Remove Goal",
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(
//                       Icons.delete,
//                       color: Colors.red,
//                       size: 32,
//                     ),
//                     onPressed: () {
//                       onSubmit("Are you sure you want to delete this goal?",
//                           context);
//                     },
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 32,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Container(
//                     width: 80,
//                     height: 80,
//                     child: CircleAvatar(
//                       backgroundImage: (_path == null)
//                           ? AssetImage(url)
//                           : Image.file(File(_path)).image,
//                     ),
//                   ),
//                   ButtonTheme(
//                     minWidth: 120.0,
//                     height: 50.0,
//                     child: RaisedButton(
//                       textColor: Colors.white,
//                       color: Color(0xFF660066),
//                       child: Text("Upload New Image"),
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
//                         child: Text("Save Changes"),
//                         onPressed: () {
//                           _validateInputs();
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
