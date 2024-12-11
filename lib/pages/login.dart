import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:pay_or_save/pages/loading_in.dart';
import 'package:pay_or_save/pages/login_email.dart';
// import 'package:pay_or_save/pages/save.dart';
// import 'package:pay_or_save/pages/saving_goals.dart';
import 'package:pay_or_save/pages/sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'alt_loading_page.dart';
import 'heard_from.dart';

class LoginPage extends StatefulWidget {
  // const LoginEmail({ Key? key }) : super(key: key);
  final bool userFound;

  const LoginPage({Key key, this.userFound}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _uid;
  SharedPreferences _newUserStatus;
  // bool _isNewUser;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    showAlert();
  }

  showAlert() {
    if (widget.userFound == false) {
      _showCodeDialog(context);
    }
  }

  void _loginWithFacebook() async {
    // print('ran1');
    setState(() {
      _loading = true;
    });
    // print('ran2');
    // await FacebookAuth.instance.logOut();
    try {
      // final FacebookAuth fbInstance = FacebookAuth.instance;
      final facebookLoginResult = await FacebookAuth.instance.login();
      print('ran3');
      if (facebookLoginResult.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        final facebookAuthCredential = FacebookAuthProvider.credential(
            facebookLoginResult.accessToken.token);
        final resultData = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);

        final User _user = resultData.user;

        final snapShot = await FirebaseFirestore.instance
            .collection('users')
            .doc(_user.uid)
            .get();

        _setPrefs(snapShot.exists);

        if (snapShot.exists) {
          // FacebookAuth.instance.logOut().then((_) {
          //   showDialog(
          //       context: context,
          //       builder: (context) => AlertDialog(
          //             title: Text('Sign-up Unauthorized'),
          //             content: Text(
          //                 'Account already exists. Redirecting to log-in page'),
          //             actions: [
          //               TextButton(
          //                   onPressed: () {
          //                     Navigator.of(context).pop();
          //                     Navigator.of(context).push(
          //                       MaterialPageRoute(builder: (_) => LoginEmail()),
          //                     );
          //                   },
          //                   child: Text('Ok'))
          //             ],
          //           ));
          // });
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (_) => LoadingInApp(
                        uid: _user.uid,
                      )),
              (route) => false);
        } else {
          FirebaseFirestore.instance.collection('users').doc(_user.uid).set({
            'email': userData['email'],
            'name': userData['name'],
            'checking': 2500,
            'savings': 2500,
            'reward_points': 1500,
            'investment': 2500,
            'ads_status': 0,
            'user_status': 0,
          }).then((_) {
            _uid = _user.uid;
            print("facebook" + _uid);
          }).then((_) => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (_) => HeardFrom(
                        uid: _uid,
                      )),
              (route) => false));
        }
      }
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(
      //         builder: (_) => HeardFrom(
      //               uid: _uid,
      //             )),
      //     (route) => false);

    } on FirebaseAuthException catch (e) {
      var content = '';
      switch (e.code) {
        case 'account-exists-with-different-credential':
          content = 'This account exists with a different sign in provider';
          break;
        case 'invalid-credential':
          content = 'Unknown error has occurred';
          break;
        case 'operation-not-allowed':
          content = 'This operation is not allowed';
          break;
        case 'user-disabled':
          content = 'The user you tried to log into is disabled';
          break;
        case 'user-not-found':
          content = 'The user you tried to log into was not found';
          break;
      }

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Log in with facebook failed'),
                content: Text(content),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Ok'))
                ],
              ));
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _loginWithGoogle() async {
    setState(() {
      _loading = true;
    });

    final googleSignIn = GoogleSignIn(scopes: ["email"]);

    try {
      bool isSignedIn = await googleSignIn.isSignedIn();

      // if (isSignedIn == false) {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        setState(() {
          _loading = false;
        });
        return;
      }
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential signInUser =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final User googleUser = signInUser.user;

      final userSnapShot = await FirebaseFirestore.instance
          .collection('users')
          .doc(googleUser.uid)
          .get();

      _setPrefs(userSnapShot.exists);

      if (userSnapShot.exists) {
        // googleSignIn.signOut().then((_) {
        //   showDialog(
        //       context: context,
        //       builder: (context) => AlertDialog(
        //             title: Text('Sign-up Unauthorized'),
        //             content: Text(
        //                 'Account already exists. Redirecting to log-in page'),
        //             actions: [
        //               TextButton(
        //                   onPressed: () {
        //                     Navigator.of(context).pop();
        //                     Navigator.of(context).push(
        //                       MaterialPageRoute(builder: (_) => LoginEmail()),
        //                     );
        //                   },
        //                   child: Text('Ok'))
        //             ],
        //           ));
        // });
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (_) => LoadingInApp(
                      uid: googleUser.uid,
                    )),
            (route) => false);
      } else {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(googleUser.uid)
            .set({
          'email': googleSignInAccount.email,
          'name': googleSignInAccount.displayName,
          'checking': 2500,
          'savings': 2500,
          'reward_points': 1500,
          'investment': 2500,
          'ads_status': 0,
          'user_status': 0,
        }).then((_) {
          _uid = googleUser.uid;
          print("google" + _uid);
        }).then((_) => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (_) => HeardFrom(
                          uid: _uid,
                        )),
                (route) => false));
      }
      // } else {
      // print(googleSignIn.currentUser.id);
      // print(googleSignIn.)
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => AltLoadingPage(
      //               uid: googleSignIn.clientId,
      //             )));

      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(
      //         builder: (_) => AltLoadingPage(
      //               uid: googleSignIn.clientId,
      //             )),
      //     (route) => false);
      // }
    } on FirebaseAuthException catch (e) {
      var content = '';
      switch (e.code) {
        case 'account-exists-with-different-credential':
          content = 'This account exists with a different sign in provider';
          break;
        case 'invalid-credential':
          content = 'Unknown error has occurred';
          break;
        case 'operation-not-allowed':
          content = 'This operation is not allowed';
          break;
        case 'user-disabled':
          content = 'The user you tried to log into is disabled';
          break;
        case 'user-not-found':
          content = 'The user you tried to log into was not found';
          break;
      }
      debugPrint('e -> $e');
      debugPrint('e.code -> ${e.code}');
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Log in with google failed'),
                content: Text(content),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Ok'))
                ],
              ));
    } catch (e) {
      debugPrint('e -> $e');
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Log in with google failed'),
                content: Text('An unknown error occurred'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              ));
    } finally {
      if (mounted)
        setState(() {
          _loading = false;
        });
    }
  }

  _setPrefs(bool status) async {
    _newUserStatus = await SharedPreferences.getInstance();
    await _newUserStatus.setBool('userExists', status);
  }

  // void _alreadyLoggedIn() async {
  //   final googleSignIn = GoogleSignIn(scopes: ["email"]);
  //   final signedInAccount = googleSignIn.currentUser;
  //   // signedInAccount

  //   Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => SavingGoals(
  //               // uid: widget.uid,
  //               )));
  // }

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        // width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 70.0.h),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => Colors.transparent,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                minimumSize: MaterialStateProperty.resolveWith(
                    (states) => Size(double.infinity, 45)),
                side: MaterialStateProperty.all<BorderSide>(
                  BorderSide(
                    color: Colors.black,
                  ),
                ),
                overlayColor: MaterialStateProperty.resolveWith(
                  (states) {
                    return states.contains(MaterialState.pressed)
                        ? Colors.blue.withOpacity(0.1)
                        : null;
                  },
                ),
              ),
              onPressed: () => Timer(
                const Duration(milliseconds: 400),
                () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginEmail(
                              // uid: widget.uid,
                              )));
                },
              ),
              child: Column(
                children: [
                  Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 18.0.h,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'If you have an account',
                    style: TextStyle(
                      fontSize: 18.0.h,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 70.0.h,
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  height: 1.5,
                  fontSize: 18.5.h,
                ),
                children: [
                  TextSpan(
                    text: 'Sign Up ',
                    style: TextStyle(height: 1.4, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'for SaveUp',
                    style: TextStyle(
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (_loading) ...[
              SizedBox(
                height: 40.0.h,
              ),
              const SizedBox(height: 15),
              Center(
                child: LoadingBouncingGrid.circle(
                  size: 30,
                  backgroundColor: Color(0xff0070c0),
                ),
              ),
            ],
            if (!_loading) ...[
              Divider(
                color: Colors.black,
                thickness: 0.4,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationPage(
                              // uid: widget.uid,
                              )));
                },
                leading: Image.asset(
                  'assets/images/emailicon.png',
                  height: 45.0,
                ),
                contentPadding: EdgeInsets.all(0.0),
                title: Text(
                  'Use your email',
                  style: TextStyle(
                    fontSize: 18.0.h,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Divider(
                color: Colors.black,
                thickness: 0.4,
              ),
              ListTile(
                onTap: () {
                  _loginWithFacebook();
                },
                leading: Image(
                  image: AssetImage('assets/images/facebookicon.png'),
                  height: 45,
                ),
                contentPadding: EdgeInsets.all(0.0),
                title: Text(
                  'Continue with Facebook',
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 18.0.h,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Divider(
                color: Colors.black,
                thickness: 0.4,
              ),
              ListTile(
                onTap: () {
                  _loginWithGoogle();
                },
                leading: Image.asset(
                  'assets/images/google-logo-2.png',
                  height: 45.0,
                ),
                contentPadding: EdgeInsets.all(0.0),
                title: Text(
                  'Continue with Google',
                  style: TextStyle(
                    fontSize: 18.0.h,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Divider(
                color: Colors.black,
                thickness: 0.4,
              ),
            ],
          ],
        ),
      ),
    );
  }

  _showCodeDialog(BuildContext context) {
    // set up the buttons
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        // _alreadyLoggedIn();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      content: Column(
        children: [
          Text(
            'User is signed in already.',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
