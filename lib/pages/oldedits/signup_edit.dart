// import 'dart:io';
// import 'dart:math';
// import 'package:pay_or_save/pages/congratulation_saving.dart';
// import 'package:pay_or_save/pages/select_mode.dart';
// import 'package:pay_or_save/pages/sign_in.dart';
// import 'package:pay_or_save/utilities/validator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/services.dart' show PlatformException;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:video_player/video_player.dart';

// enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

// class RegistrationPage extends StatefulWidget {
//   const RegistrationPage({Key key}) : super(key: key);
//   @override
//   RegistrationPageTabs createState() => RegistrationPageTabs();
// }

// class RegistrationPageTabs extends State<RegistrationPage>
//     with SingleTickerProviderStateMixin {
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
//       _fullName,
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
//   VideoPlayerController _controller;

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
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => SelectMode(
//               uid: _uid,
//             ),
//           ),
//         );
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
//         'fullName': _fullName,
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
//         'fullName': _fullName,
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
//           title: new Text("Alert"),
//           content: new Text(error),
//           actions: <Widget>[
//             // usually buttons at the bottom of the dialog
//             new FlatButton(
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

//   Widget build(BuildContext context) {
//     double heigh = MediaQuery.of(context).size.height;
//     double widhM = MediaQuery.of(context).size.width;
//     double yourHeight = heigh * 1.4;
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text("Pay or Save"),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Container(
//               child: Container(
// //              color: Colors.transparent,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: new BorderRadius.only(
//                       topLeft: Radius.circular(15.0),
//                       topRight: Radius.circular(15.0)),
//                 ),
//                 height: yourHeight,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.max,
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.all(36.0),
//                       child: Column(
//                         children: <Widget>[
//                           Text(
//                             "Registration",
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             "Enter your information to create an account!",
//                             style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Form(
//                       key: _registerFormKey,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(horizontal: 20),
//                             child: TextFormField(
//                               cursorColor: Colors.black,
//                               style: TextStyle(
//                                 color: Colors.black,
//                               ),
//                               decoration: InputDecoration(
//                                 fillColor: Colors.black,
//                                 focusColor: Colors.black,
//                                 labelText: 'Full name',
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
//                               validator: Validator.validateFullName,
//                               onSaved: (value) => _fullName = value.trim(),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(horizontal: 20),
//                             child: TextFormField(
//                               cursorColor: Colors.black,
//                               style: TextStyle(
//                                 color: Colors.black,
//                               ),
//                               decoration: InputDecoration(
//                                 fillColor: Colors.black,
//                                 focusColor: Colors.black,
//                                 labelText: 'Username',
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
//                               validator: Validator.validateUsername,
//                               onSaved: (value) => _username = value.trim(),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(horizontal: 20),
//                             child: TextFormField(
//                               cursorColor: Colors.black,
//                               style: TextStyle(
//                                 color: Colors.black,
//                               ),
//                               decoration: InputDecoration(
//                                 fillColor: Colors.black,
//                                 focusColor: Colors.black,
//                                 labelText: 'Enter your email',
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
//                               keyboardType: TextInputType.emailAddress,
//                               validator: Validator.validateEmail,
//                               onSaved: (value) => _email = value.trim(),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(horizontal: 20),
//                             child: TextFormField(
//                               cursorColor: Colors.black,
//                               style: TextStyle(
//                                 color: Colors.black,
//                               ),
//                               decoration: InputDecoration(
//                                 fillColor: Colors.black,
//                                 focusColor: Colors.black,
//                                 labelText: 'Verify email',
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
//                               keyboardType: TextInputType.emailAddress,
//                               validator: Validator.validateEmail,
//                               onSaved: (value) => _verifyEmail = value.trim(),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(horizontal: 20),
//                             child: TextFormField(
//                               style: TextStyle(
//                                 color: Colors.black,
//                               ),
//                               obscureText: true,
//                               decoration: InputDecoration(
//                                 labelText: 'Enter your password',
//                                 labelStyle: TextStyle(color: Colors.black),
//                                 hintStyle: TextStyle(
//                                     fontSize: 20.0, color: Color(0xFFc73a56)),
//                                 border: OutlineInputBorder(
//                                   borderSide: const BorderSide(
//                                       color: Color(0xFFc73a56), width: 2.0),
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: const BorderSide(
//                                       color: Colors.black, width: 2.0),
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                               ),
//                               validator: Validator.validatePassword,
//                               onSaved: (value) => _password = value.trim(),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(24.0),
//                             child: DropdownButton(
//                               hint: howDidHear == null
//                                   ? Text('I have heard about Pay or Save from:')
//                                   : Text(
//                                       howDidHear,
//                                       style: TextStyle(color: Colors.black),
//                                     ),
//                               isExpanded: true,
//                               iconSize: 30.0,
//                               style:
//                                   TextStyle(color: Colors.blue, fontSize: 20),
//                               items: [
//                                 'Friend or family member',
//                                 'Business',
//                                 'Facebook',
//                                 'Twitter',
//                                 'Instagram',
//                                 'Blog',
//                                 'Google Search',
//                                 'Other'
//                               ].map(
//                                 (val) {
//                                   return DropdownMenuItem<String>(
//                                     value: val,
//                                     child: Text(val),
//                                   );
//                                 },
//                               ).toList(),
//                               onChanged: (val) {
//                                 setState(
//                                   () {
//                                     howDidHear = val;
//                                     if (val == "Friend or family member") {
//                                       isClosed = false;
//                                     } else {
//                                       isClosed = true;
//                                     }
//                                   },
//                                 );
//                               },
//                             ),
//                           ),
//                           !isClosed
//                               ? Container(
//                                   width: widhM,
//                                   padding: EdgeInsets.symmetric(horizontal: 20),
//                                   child: Row(
//                                     children: <Widget>[
//                                       Container(
//                                         width: widhM - 100,
//                                         child: TextFormField(
//                                           controller: myController,
//                                           cursorColor: Colors.black,
//                                           style: TextStyle(
//                                             color: Colors.black,
//                                           ),
//                                           decoration: InputDecoration(
//                                             fillColor: Colors.black,
//                                             focusColor: Colors.black,
//                                             labelText: 'Friend Code',
//                                             labelStyle:
//                                                 TextStyle(color: Colors.black),
//                                             hintStyle: TextStyle(
//                                                 fontSize: 20.0,
//                                                 color: Colors.white),
//                                             border: OutlineInputBorder(
//                                               borderSide: const BorderSide(
//                                                   color: Colors.white,
//                                                   width: 2.0),
//                                               borderRadius:
//                                                   BorderRadius.circular(10.0),
//                                             ),
//                                             focusedBorder: OutlineInputBorder(
//                                               borderSide: const BorderSide(
//                                                   color: Colors.black,
//                                                   width: 2.0),
//                                               borderRadius:
//                                                   BorderRadius.circular(10.0),
//                                             ),
//                                           ),
//                                           keyboardType: TextInputType.text,
//                                           onSaved: (value) =>
//                                               _source = value.trim(),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         width: 15,
//                                       ),
//                                       GestureDetector(
//                                         onTap: () {
//                                           _showDialog(
//                                               "Code that your friend shared with you.");
//                                         },
//                                         child: Icon(
//                                           Icons.help_outline,
//                                           color: Colors.blue,
//                                           size: 42,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               : Container(),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 16),
//                                 child: Text('Do you have an account?',
//                                     style: TextStyle(fontSize: 20)),
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   navigateSiginUpPage(context);
//                                 },
//                                 child: Padding(
//                                   padding: EdgeInsets.only(top: 16),
//                                   child: Text('Sign in',
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                         decoration: TextDecoration.underline,
//                                       )),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 30,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(left: 0.0, right: 0.0),
//                       child: ButtonTheme(
//                         minWidth: 300.0,
//                         height: 50.0,
//                         child: RaisedButton(
//                           textColor: Colors.white,
//                           color: Color(0xFFc73a56),
//                           child: Text("Sign up"),
//                           onPressed: () {
//                             _validateInputs();
//                           },
//                           shape: new RoundedRectangleBorder(
//                             borderRadius: new BorderRadius.circular(10.0),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
