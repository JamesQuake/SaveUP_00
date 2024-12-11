import 'dart:async';
import 'dart:io';
// import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pay_or_save/assets/custom_button.dart';
// import 'package:pay_or_save/assets/text_field.dart';
// import 'package:pay_or_save/pages/congratulation_saving.dart';
import 'package:pay_or_save/pages/heard_from.dart';
// import 'package:pay_or_save/pages/select_mode.dart';
import 'package:pay_or_save/pages/sign_in.dart';
import 'package:pay_or_save/utilities/validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/services.dart' show PlatformException;
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key key}) : super(key: key);
  @override
  RegistrationPageTabs createState() => RegistrationPageTabs();
}

class RegistrationPageTabs extends State<RegistrationPage>
    with SingleTickerProviderStateMixin {
  final firestoreInstance = FirebaseFirestore.instance;
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  authProblems errorType;
  String _path,
      _email,
      _verifyEmail,
      _password,
      _verifyPassword,
      _uid,
      _extension,
      _firstName,
      _lastName,
      _username,
      _fileURL,
      _fileName,
      howDidHear,
      _source;
  Map<String, String> _paths;
  bool _loadingPath = false;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickingType;
  bool isClosed = true;
  bool _isHidden = true;
  bool _isHidden1 = true;
  bool passwordsMatch = true;
  bool emailsMatch = true;
  final myController = TextEditingController();
  VideoPlayerController _controller;
  bool _loggedAcc;
  SharedPreferences _userStatusPref;

  Future<User> handleSignUp(email, password) async {
    UserCredential result;
    try {
      result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final User user = result.user;
      await user.updateDisplayName(_fileName);
      _loggedAcc = result.additionalUserInfo.isNewUser;
      //updateInfo.displayName = _fileName;
      assert(user != null);
      assert(await user.getIdToken() != null);
      _uid = user.uid;
      _setPrefs(true);
      createUser(_uid).then((dynam) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HeardFrom(
                      uid: _uid,
                    )));
      });
      return user;
    } catch (error) {
      if (Platform.isAndroid) {
        switch (error.message) {
          case 'There is no user record corresponding to this identifier. The user may have been deleted.':
            errorType = authProblems.UserNotFound;
            _showDialog(error.message);
            break;
          case 'The password is invalid or the user does not have a password.':
            errorType = authProblems.PasswordNotValid;
            _showDialog(error.message);
            break;
          case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
            errorType = authProblems.NetworkError;
            _showDialog(error.message);
            break;
          // ...
          default:
            print('Case ${error.message} is not jet implemented');
            _showDialog(error.message);
        }
      } else if (Platform.isIOS) {
        switch (error.code) {
          case 'Error 17011':
            errorType = authProblems.UserNotFound;
            _showDialog(error.message);
            break;
          case 'Error 17009':
            errorType = authProblems.PasswordNotValid;
            _showDialog(error.message);
            break;
          case 'Error 17020':
            errorType = authProblems.NetworkError;
            _showDialog(error.message);
            break;
          // ...
          default:
            print('Case ${error.message} is not jet implemented');
            _showDialog(error.message);
        }
      }
    }
    return null;
  }

  _setPrefs(bool userInfo) async {
    _userStatusPref = await SharedPreferences.getInstance();
    await _userStatusPref.setBool('isNewUser', userInfo);
  }

  Future<void> navigateToSubPage(context) async {
//    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AccountPage()));
  }
  Future<void> navigateSiginUpPage(context) async {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => SignInRegistrationPage()));
  }

  Future createUser(uid) async {
    firestoreInstance.collection("users").doc(uid).set({
      'firstName': _firstName,
      'lastName': _lastName,
      'username': _username,
      'email': _email,
      'heard_about_us': '',
      'checking': 2500,
      'savings': 2500,
      'reward_points': 1500,
      'investment': 2500,
      'ads_status': 0,
      'user_status': 0,
    });
  }

  // Make sure you fill all forms!
  Future _onErrorDialog(String s) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Registration"),
          content: Text(
            s,
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            new FlatButton(
              child: const Text("Ok"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void _validateInputs() {
    if (errorType == null) {
      print(_firstName);
      print(_lastName);
      if (_registerFormKey.currentState.validate() &&
          _firstName != null &&
          _firstName != "" &&
          _lastName != null &&
          _lastName != "") {
//    If all data are correct then save data to out variabless
        if (_email == _verifyEmail && _password == _verifyPassword) {
          setState(() {
            passwordsMatch = true;
            emailsMatch = true;
          });
          _registerFormKey.currentState.save();
          handleSignUp(_email, _password);
          // print('object');
        } else {
          setState(() {
            passwordsMatch = false;
            emailsMatch = false;
          });
          if (_email != _verifyEmail) {
            setState(() {
              emailsMatch = false;
            });
          }
          if (_password != _verifyPassword) {
            setState(() {
              passwordsMatch = false;
            });
          }
        }
      } else {
//    If all data are not valid then start auto validation.
        _onErrorDialog("You skipped an item");
      }
    }
  }

  void _showDialog(String error) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Alert"),
          content: Text(error),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            ElevatedButton(
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

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _toggleOtherVisibility() {
    setState(() {
      _isHidden1 = !_isHidden1;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    double heigh = MediaQuery.of(context).size.height;
    double widhM = MediaQuery.of(context).size.width;
    double yourHeight = heigh * 1.4;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0070c0),
        title: Text(
          'Sign Up',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25.h,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: _registerFormKey,
              child: ListView(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      cursorColor: Colors.black,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        // focusColor: Colors.black,
                        labelText: 'first name',
                        hintStyle:
                            TextStyle(fontSize: 20.0, color: Colors.white),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 0.0,
                          vertical: 0.0,
                        ),
                        isDense: true,
                        // filled: true,
                        // fillColor: Colors.grey.withOpacity(0.2),
                        labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black.withOpacity(0.4),
                        ),

                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      // validator: Validator.validateFullName,
                      onChanged: (value) => _firstName = value.trim(),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      cursorColor: Colors.black,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        // focusColor: Colors.black,
                        labelText: 'last name',
                        hintStyle:
                            TextStyle(fontSize: 20.0, color: Colors.white),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 0.0,
                          vertical: 0.0,
                        ),
                        isDense: true,
                        // filled: true,
                        // fillColor: Colors.grey.withOpacity(0.2),
                        labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black.withOpacity(0.4),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      // validator: Validator.validateFullName,
                      onChanged: (value) => _lastName = value.trim(),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      cursorColor: Colors.black,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        // focusColor: Colors.black,
                        labelText: 'email',
                        errorText:
                            emailsMatch == false ? 'emails do not match' : null,
                        hintStyle:
                            TextStyle(fontSize: 20.0, color: Colors.white),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 0.0,
                          vertical: 0.0,
                        ),
                        isDense: true,
                        // filled: true,
                        // fillColor: Colors.grey.withOpacity(0.2),
                        labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black.withOpacity(0.4),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: Validator.validateEmail,
                      onChanged: (value) => _email = value.trim(),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      cursorColor: Colors.black,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        // focusColor: Colors.black,
                        labelText: 'verify email',
                        errorText:
                            emailsMatch == false ? 'emails do not match' : null,
                        hintStyle:
                            TextStyle(fontSize: 20.0, color: Colors.white),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 0.0,
                          vertical: 0.0,
                        ),
                        isDense: true,
                        // filled: true,
                        // fillColor: Colors.grey.withOpacity(0.2),
                        labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black.withOpacity(0.4),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: Validator.validateEmail,
                      onChanged: (value) => _verifyEmail = value.trim(),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      obscureText: _isHidden ? true : false,
                      decoration: InputDecoration(
                        labelText: 'password',
                        errorText: passwordsMatch == false
                            ? 'passwords do not match'
                            : null,
                        hintStyle:
                            TextStyle(fontSize: 20.0, color: Colors.white),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 0.0,
                          vertical: 0.0,
                        ),
                        isDense: true,
                        // filled: true,
                        // fillColor: Colors.grey.withOpacity(0.2),
                        labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black.withOpacity(0.4),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        suffixIcon: IconButton(
                          iconSize: 20,
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
                      validator: Validator.validatePassword,
                      onChanged: (value) => _password = value.trim(),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      obscureText: _isHidden1 ? true : false,
                      decoration: InputDecoration(
                        labelText: 'verify password',
                        errorText: passwordsMatch == false
                            ? 'passwords do not match'
                            : null,
                        hintStyle:
                            TextStyle(fontSize: 20.0, color: Colors.white),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 0.0),
                        isDense: true,
                        // filled: true,
                        // fillColor: Colors.grey.withOpacity(0.2),
                        labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black.withOpacity(0.4),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        suffixIcon: IconButton(
                          iconSize: 20,
                          icon: _isHidden1
                              ? Icon(
                                  Icons.visibility_off,
                                  color: Colors.grey,
                                )
                              : Icon(
                                  Icons.visibility,
                                  color: Color(0xff0070c0),
                                ),
                          onPressed: _toggleOtherVisibility,
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
                      validator: Validator.validatePassword,
                      onChanged: (value) => _verifyPassword = value.trim(),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            'If you already have an account,',
                            style: TextStyle(
                              fontSize: 18.h,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            navigateSiginUpPage(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text(
                              ' sign in',
                              style: TextStyle(
                                fontSize: 18.h,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                color: Color(0xff0070c0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 15.0,
              left: 30.0,
              right: 30.0,
            ),
            child: ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.resolveWith(
                    (states) => Size(double.infinity, 50)),
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => Color(0xff0070c0),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
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
                  _validateInputs();
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => HeardFrom(uid: _uid)));
                },
              ),
              child: Text(
                'Next',
                style: TextStyle(
                  fontSize: 20.0.h,
                  color: Colors.white,
                ),
              ),
              // color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
