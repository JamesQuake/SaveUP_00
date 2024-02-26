// import 'dart:async';
// import 'dart:io';

// import 'package:pay_or_save/pages/congratulation_saving.dart';
// import 'package:pay_or_save/pages/select_mode.dart';
// import 'package:pay_or_save/pages/sign_up.dart';
// import 'package:pay_or_save/utilities/validator.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_fonts/google_fonts.dart';

// enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

// class SignInRegistrationPage extends StatefulWidget {
//   @override
//   _SignInRegistrationPageState createState() => _SignInRegistrationPageState();
// }

// class _SignInRegistrationPageState extends State<SignInRegistrationPage> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   FocusNode _myFocusNode;

//   PersistentBottomSheetController _sheetController;
//   String _email;
//   String _password;
//   String _uid;
//   bool triger = false;

//   @override
//   void initState() {
//     super.initState();
//     _myFocusNode = new FocusNode();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _myFocusNode.dispose();
//   }

//   _signOutT() async {
//     await FirebaseAuth.instance.signOut();
//   }

//   Future navigateToRegister(context) async {
//     Navigator.push(
//         context, MaterialPageRoute(builder: (context) => RegistrationPage()));
//   }

//   Future<FirebaseUser> handleSignInEmail(String email, String password) async {
//     try {
//       AuthResult result = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       final FirebaseUser user = result.user;

//       assert(user != null);
//       assert(await user.getIdToken() != null);

//       final FirebaseUser currentUser = await _auth.currentUser();
//       assert(user.uid == currentUser.uid);
//       if (user != null) {
//         Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => SelectMode(
//                       uid: _uid,
//                     )));
//       }

//       print('signInEmail succeeded: $user');

//       return user;
//     } catch (e) {
//       authProblems errorType;
//       if (Platform.isAndroid) {
//         switch (e.message) {
//           case 'There is no user record corresponding to this identifier. The user may have been deleted.':
//             errorType = authProblems.UserNotFound;
//             _showDialog(e.message);
//             break;
//           case 'The password is invalid or the user does not have a password.':
//             errorType = authProblems.PasswordNotValid;
//             _showDialog(e.message);
//             break;
//           case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
//             errorType = authProblems.NetworkError;
//             _showDialog(e.message);
//             break;
//           // ...
//           default:
//             _showDialog(e.message);
//             print('Case ${e.message} is not yet implemented');
//         }
//       } else if (Platform.isIOS) {
//         switch (e.code) {
//           case 'Error 17011':
//             errorType = authProblems.UserNotFound;
//             _showDialog(e.message);
//             break;
//           case 'Error 17009':
//             errorType = authProblems.PasswordNotValid;
//             _showDialog(e.message);
//             break;
//           case 'Error 17020':
//             errorType = authProblems.NetworkError;
//             _showDialog(e.message);
//             break;
//           // ...
//           default:
//             _showDialog(e.message);
//             print('Case ${e.message} is not yet implemented');
//         }
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

//   void _validateInputsLog() {
//     if (_formKey.currentState.validate()) {
// //    If all data are correct then save data to out variables
//       _formKey.currentState.save();
//       handleSignInEmail(_email, _password);
//     } else {
// //    If all data are not valid then start auto validation.

//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double heigh = MediaQuery.of(context).size.height;
//     double yourHeight = heigh * 0.7;
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0.0,
//         leading: Container(),
//         backgroundColor: Colors.white,
//         title: Row(
//           children: [
//             Image.asset(
//               "assets/images/new/newlogo.png",
//               height: 50.0,
//               width: 220.0,
//             ),
//           ],
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             SizedBox(
//               height: 30,
//             ),
//             new Container(
//                 height: 150,
//                 child: Image(
//                   image: AssetImage('assets/images/logo.png'),
//                   fit: BoxFit.fitHeight,
//                   width: double.infinity,
//                 )),
//             SizedBox(
//               height: 30,
//             ),
//             Container(
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: new BorderRadius.only(
//                       topLeft: Radius.circular(15.0),
//                       topRight: Radius.circular(15.0)),
//                 ),
//                 height: yourHeight,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.max,
//                   children: <Widget>[
//                     Form(
//                       key: _formKey,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Container(
//                             margin: EdgeInsets.symmetric(horizontal: 20),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10.0),
//                             ),
//                             child: TextFormField(
//                               cursorColor: Colors.black,
//                               style: TextStyle(
//                                 color: Colors.black,
//                               ),
//                               decoration: InputDecoration(
//                                 fillColor: Colors.black,
//                                 focusColor: Colors.black,
//                                 labelStyle: TextStyle(color: Colors.black),
//                                 labelText: 'Enter your Email',
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
//                             margin: EdgeInsets.symmetric(horizontal: 20),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10.0),
//                             ),
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
//                           child: Text("Sign in"),
//                           onPressed: () {
//                             _validateInputsLog();
//                           },
//                           shape: new RoundedRectangleBorder(
//                             borderRadius: new BorderRadius.circular(10.0),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(left: 0.0, right: 0.0),
//                       child: ButtonTheme(
//                         minWidth: 300.0,
//                         height: 50.0,
//                         child: RaisedButton(
//                           textColor: Colors.white,
//                           color: Color(0xFF476fbf),
//                           child: Text("Facebook Login"),
//                           onPressed: () {},
//                           shape: new RoundedRectangleBorder(
//                             borderRadius: new BorderRadius.circular(10.0),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Padding(
//                           padding: const EdgeInsets.only(top: 16),
//                           child: Text('Do not have an account?',
//                               style:
//                                   TextStyle(fontSize: 20, color: Colors.black)),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             navigateToRegister(context);
//                           },
//                           child: Padding(
//                             padding: EdgeInsets.only(top: 16),
//                             child: Text('Sign up',
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                   decoration: TextDecoration.underline,
//                                 )),
//                           ),
//                         ),
//                       ],
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
