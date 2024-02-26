import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:pay_or_save/models/investment_goal_model.dart';
import 'package:pay_or_save/models/saving_goal_model.dart';
import 'package:pay_or_save/pages/investment_goal.dart';
// import 'package:pay_or_save/pages/congratulation_saving.dart';
// import 'package:pay_or_save/pages/login_email.dart';
// import 'package:pay_or_save/pages/new%20pages/forgot_password.dart';
import 'package:pay_or_save/pages/new%20pages/open_email.dart';
// import 'package:pay_or_save/pages/reset_password.dart';
import 'package:pay_or_save/pages/saving_goals.dart';
import 'package:pay_or_save/pages/select_mode.dart';
// import 'package:pay_or_save/pages/select_mode.dart';
import 'package:pay_or_save/pages/sign_up.dart';
import 'package:pay_or_save/pages/starting_balances.dart';
// import 'package:pay_or_save/pages/slot_webview.dart';
// import 'package:pay_or_save/pages/welcomepos.dart';
import 'package:pay_or_save/utilities/validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'new pages/reset_password.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class SignInRegistrationPage extends StatefulWidget {
  @override
  _SignInRegistrationPageState createState() => _SignInRegistrationPageState();
}

class _SignInRegistrationPageState extends State<SignInRegistrationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FocusNode _myFocusNode;

  PersistentBottomSheetController _sheetController;
  String _email;
  String _password;
  String _uid;
  bool triger = false;
  bool _isHidden = true;
  SharedPreferences _userStatusPref;
  bool _loggedAcc;
  bool _loadingScreens = false;
  bool savGoalList;
  bool investGoalList;
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // setPrefs();
    _myFocusNode = new FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _myFocusNode.dispose();
  }

  _signOutT() async {
    await FirebaseAuth.instance.signOut();
  }

  Future navigateToRegister(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegistrationPage()));
  }

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  setPrefs(bool userInfo) async {
    _userStatusPref = await SharedPreferences.getInstance();
    await _userStatusPref.setBool('isNewUser', userInfo);
  }

  Future<User> handleSignInEmail(String email, String password) async {
    setState(() {
      _loadingScreens = true;
    });
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final User user = result.user;

      assert(user != null);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);
      _loggedAcc = result.additionalUserInfo.isNewUser;
      // _loggedAcc.toString();

      if (user != null) {
        await setPrefs(_loggedAcc);
        // print('obs here');
        // print(_loggedAcc);
        _uid = user.uid;
        await _checkUserSavingGoals(_uid);
        await _checkUserInvGoals(_uid);
        setState(() {
          _loadingScreens = false;
        });
        if (savGoalList == true) {
          // print('empty at run time');
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (_) => SavingGoals(
                        uid: _uid,
                      )),
              (route) => false);
        } else if (investGoalList == true) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (_) => InvestmentGoals(
                        uid: _uid,
                      )),
              (route) => false);
          // return;
        } else if (savGoalList == false && investGoalList == false) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (_) => StartingBalances(
                        uid: _uid,
                      )),
              (route) => false);
        }
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(
        //         builder: (_) => SavingGoals(
        //               uid: _uid,
        //             )),
        //     (route) => false);
      }

      print('signInEmail succeeded: $user');

      return user;
    } catch (e) {
      authProblems errorType;
      if (Platform.isAndroid) {
        setState(() {
          _loadingScreens = false;
        });
        switch (e.message) {
          case 'There is no user record corresponding to this identifier. The user may have been deleted.':
            errorType = authProblems.UserNotFound;
            _showDialog(e.message);
            break;
          case 'The password is invalid or the user does not have a password.':
            errorType = authProblems.PasswordNotValid;
            _showDialog(e.message);
            break;
          case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
            errorType = authProblems.NetworkError;
            _showDialog(e.message);
            break;
          // ...
          default:
            _showDialog(e.message);
            print('Case ${e.message} is not yet implemented');
        }
      } else if (Platform.isIOS) {
        setState(() {
          _loadingScreens = false;
        });
        switch (e.code) {
          case 'Error 17011':
            errorType = authProblems.UserNotFound;
            _showDialog(e.message);
            break;
          case 'Error 17009':
            errorType = authProblems.PasswordNotValid;
            _showDialog(e.message);
            break;
          case 'Error 17020':
            errorType = authProblems.NetworkError;
            _showDialog(e.message);
            break;
          // ...
          default:
            _showDialog(e.message);
            print('Case ${e.message} is not yet implemented');
        }
      }
    }
  }

  _checkUserSavingGoals(_uid) {
    return firestoreInstance
        .collection("savingGoals")
        .doc('users')
        .collection(_uid)
        .get()
        .then((snapshot) {
      // snapshot.i
      // var stuff = snapshot == null;
      savGoalList = (snapshot.docs.length < 1);
    });
  }

  _checkUserInvGoals(_uid) {
    return firestoreInstance
        .collection("investmentGoals")
        .doc('users')
        .collection(_uid)
        .get()
        .then((snapshot) {
      investGoalList = (snapshot.docs.length < 1);
    });
  }

  void _showDialog(String error) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert"),
          content: new Text(error),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // return LoadingPage(
  //             isUser: false,
  //             uid: '',
  //           );

  void _validateInputsLog() async {
    if (_formKey.currentState.validate()) {
      //  If all data are correct then save data to out variables
      _formKey.currentState.save();
      handleSignInEmail(_email, _password);
    } else {
//    If all data are not valid then start auto validation.
    }
  }

  @override
  Widget build(BuildContext context) {
    double heigh = MediaQuery.of(context).size.height;
    double yourHeight = heigh * 0.7;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: Container(),
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            SizedBox(
              width: 3.0,
            ),
            Image.asset(
              "assets/images/wyzly-ico.png",
              height: 50.0.h,
              width: 220.0.w,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: IgnorePointer(
        ignoring: _loadingScreens == false ? false : true,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100.0.h),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      style: TextStyle(fontSize: 18.h),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0.0),
                        isDense: true,
                        // filled: true,
                        // fillColor: Colors.grey.withOpacity(0.2),
                        labelText: 'email',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0.h,
                            // fontWeight: FontWeight.bold,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[500],
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: Validator.validateEmail,
                      onSaved: (value) => _email = value.trim(),
                    ),
                    SizedBox(height: 15.0.h),
                    TextFormField(
                      style: TextStyle(fontSize: 18.h),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                        isDense: true,
                        // filled: true,
                        // fillColor: Colors.grey.withOpacity(0.2),
                        labelText: 'password',
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            // fontWeight: FontWeight.bold,
                            fontSize: 16.h,
                            color: Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[500],
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        suffixIcon: IconButton(
                          iconSize: 20.h,
                          icon: _isHidden
                              ? Icon(
                                  Icons.visibility_off,
                                  color: Colors.grey,
                                )
                              : Icon(
                                  Icons.visibility,
                                  color: Color(0xff0070c0),
                                ),
                          // color: Colors.grey,
                          onPressed: _toggleVisibility,
                          constraints: BoxConstraints(
                            minHeight: 1.0,
                            minWidth: 1.0,
                          ),
                        ),
                        suffixIconConstraints: BoxConstraints(
                          minHeight: 1.0,
                          minWidth: 1.0,
                        ),
                      ),
                      obscureText: _isHidden ? true : false,
                      validator: Validator.validatePassword,
                      onSaved: (value) => _password = value.trim(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0.h,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OpenEmail(
                                // uid: _uid,
                                )));
                    // Navigator.pushNamed(context, '/screen');
                  },
                  child: Text(
                    'forgot password?',
                    style: TextStyle(
                      fontSize: 16.h,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25.0.h,
              ),
              if (_loadingScreens == false) ...[
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Color(0xff0070c0),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.resolveWith(
                        (states) => Size(double.infinity, 45)),
                    overlayColor: MaterialStateProperty.resolveWith(
                      (states) {
                        return states.contains(MaterialState.pressed)
                            ? Colors.blue
                            : null;
                      },
                    ),
                  ),
                  onPressed: () => Timer(
                    const Duration(milliseconds: 400),
                    () {
                      // setState(() {
                      //   _loadingScreens == false;
                      // });
                      FocusScope.of(context).unfocus();
                      _validateInputsLog();
                    },
                  ),
                  child: Column(
                    children: [
                      Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 18.0.h,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (_loadingScreens == true) ...[
                Container(
                  height: 300.h,
                  width: double.infinity,
                  color: Colors.transparent,
                  child: Center(
                    child: LoadingBouncingGrid.circle(
                      size: 50,
                      backgroundColor: Color(0xff0070c0),
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
