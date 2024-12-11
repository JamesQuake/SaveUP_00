// import 'package:pay_or_save/pages/congratulation_saving.dart';
// import 'package:pay_or_save/pages/heard_from.dart';
// import 'package:pay_or_save/pages/select_mode.dart';
// import 'package:pay_or_save/pages/sign_in.dart';
// import 'package:pay_or_save/utilities/validator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:async';
// import 'dart:io';

// class Omega {
//   final firestoreInstance = Firestore.instance;
//   final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   authProblems errorType;
//   String _path,
//       _email,
//       _verifyEmail,
//       _password,
//       _uid,
//       _extension,
//       _firstName,
//       _lastName,
//       _username,
//       _fileURL,
//       _fileName,
//       howDidHear,
//       _source;
//   Map<String, String> _paths;
//   bool _loadingPath = false;
//   bool _multiPick = false;
//   bool _hasValidMime = false;
//   FileType _pickingType;
//   bool isClosed = true;
//   final myController = TextEditingController();
//   // VideoPlayerController _controller;

//   Future<FirebaseUser> handleSignUp(email, password) async {
//     AuthResult result;
//     try {
//       result = await _auth.createUserWithEmailAndPassword(
//           email: email, password: password);
//       final FirebaseUser user = result.user;
//       UserUpdateInfo updateInfo = UserUpdateInfo();
//       updateInfo.displayName = _fileName;
//       assert(user != null);
//       assert(await user.getIdToken() != null);
//       _uid = user.uid;
//       createUser(_uid).then((dynam) {
//         Navigator.pushReplacement(context,
//             MaterialPageRoute(
//                 builder: (context) => SelectMode(
//                       uid: _uid,
//                     )));
//       });
//       return user;
//     } catch (error) {
//       if (Platform.isAndroid) {
//         switch (error.message) {
//           case 'There is no user record corresponding to this identifier. The user may have been deleted.':
//             errorType = authProblems.UserNotFound;
//             _showDialog(error.message);
//             break;
//           case 'The password is invalid or the user does not have a password.':
//             errorType = authProblems.PasswordNotValid;
//             _showDialog(error.message);
//             break;
//           case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
//             errorType = authProblems.NetworkError;
//             _showDialog(error.message);
//             break;
//           // ...
//           default:
//             print('Case ${error.message} is not jet implemented');
//             _showDialog(error.message);
//         }
//       } else if (Platform.isIOS) {
//         switch (error.code) {
//           case 'Error 17011':
//             errorType = authProblems.UserNotFound;
//             _showDialog(error.message);
//             break;
//           case 'Error 17009':
//             errorType = authProblems.PasswordNotValid;
//             _showDialog(error.message);
//             break;
//           case 'Error 17020':
//             errorType = authProblems.NetworkError;
//             _showDialog(error.message);
//             break;
//           // ...
//           default:
//             print('Case ${error.message} is not jet implemented');
//             _showDialog(error.message);
//         }
//       }
//     }
//     return null;
//   }

//   Future<void> navigateToSubPage(context) async {
// //    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AccountPage()));
//   }
//   Future<void> navigateSiginUpPage(context) async {
//     Navigator.pushReplacement(context,
//         MaterialPageRoute(builder: (context) => SignInRegistrationPage()));
//   }

//   Future createUser(uid) async {
//     if (howDidHear == "Friend or family member', 'Business") {
//       firestoreInstance.collection("users").document(uid).setData({
//         'firstName': _firstName,
//         'lastName': _lastName,
//         'username': _username,
//         'email': _email,
//         'friend_code': _source,
//         'checking': 1000,
//         'savings': 0,
//         'reward_points': 0,
//         'investment': 0
//       });
//     } else {
//       firestoreInstance.collection("users").document(uid).setData({
//         'firstName': _firstName,
//         'username': _username,
//         'email': _email,
//         'heard_about_us': howDidHear,
//         'checking': 1000,
//         'savings': 0,
//         'reward_points': 0,
//         'investment': 0
//       });
//     }
//   }

//   // Make sure you fill all forms!
//   Future _onErrorDialog(String s) {
//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Registration"),
//           content: Text(
//             s,
//             style: TextStyle(fontSize: 20),
//           ),
//           actions: [
//             new FlatButton(
//               child: const Text("Ok"),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _validateInputs() {
//     if (errorType == null) {
//       if (_registerFormKey.currentState.validate()) {
// //    If all data are correct then save data to out variables
//         if (_email == _verifyEmail) {
//           _registerFormKey.currentState.save();
//           handleSignUp(_email, _password);
//         } else {
//           _onErrorDialog("Make sure you have right email");
//         }
//       } else {
// //    If all data are not valid then start auto validation.
//         _onErrorDialog("Make sure you fill all forms!");
//       }
//     }
//   }

//   void _showDialog(String error) {
//     // flutter defined function
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         // return object of type Dialog
//         return AlertDialog(
//           title: Text("Alert"),
//           content: Text(error),
//           actions: <Widget>[
//             // usually buttons at the bottom of the dialog
//             ElevatedButton(
//               child: new Text("Ok"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }
// }
