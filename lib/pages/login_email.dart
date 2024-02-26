// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_animations/loading_animations.dart';
// import 'package:pay_or_save/pages/alt_loading_page.dart';
import 'package:pay_or_save/pages/loading_in.dart';
// import 'package:pay_or_save/pages/saving_goals.dart';
import 'package:pay_or_save/pages/sign_in.dart';
// import 'package:pay_or_save/pages/welcomepos.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:pay_or_save/pages/starting_balances.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'heard_from.dart';

// import 'heard_from.dart';

class LoginEmail extends StatefulWidget {
  // const LoginPage({ Key? key }) : super(key: key);

  @override
  _LoginEmailState createState() => _LoginEmailState();
}

class _LoginEmailState extends State<LoginEmail> {
  String _uid;
  bool _loading = false;
  bool _isNewUser;
  SharedPreferences _newUserStatus;

  _googleLogin() async {
    setState(() {
      _loading = true;
    });
    final googleSignIn = GoogleSignIn(scopes: ["email"]);
    try {
      bool isSignedIn = await googleSignIn.isSignedIn();
      if (isSignedIn == true) {
        print('Signing user out');
        await googleSignIn.signOut();
        print('user signed out');
      }
      // print('code block running');
      final googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        setState(() {
          _loading = false;
        });
        return;
      }

      // print('code executing in earnest');

      final googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final signInUser =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final User googleUser = signInUser.user;

      final userSnapShot = await FirebaseFirestore.instance
          .collection('users')
          .doc(googleUser.uid)
          .get();

      _setPrefs(userSnapShot.exists);

      _uid = googleUser.uid;
      // print("looks like this:" + _uid);

      if (userSnapShot.exists == false) {
        // if (_isNewUser == true) {
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
          // print("google" + _uid);
        }).then((_) => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (_) => HeardFrom(
                          uid: _uid,
                        )),
                (route) => false));
        // } else {
        //   Navigator.of(context).pushAndRemoveUntil(
        //       MaterialPageRoute(
        //           builder: (_) => StartingBalances(
        //                 uid: _user.uid,
        //               )),
        //       (route) => false);
        // }
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (_) => LoadingInApp(
                      uid: _uid,
                    )),
            (route) => false);
      }
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
      setState(() {
        _loading = false;
      });
    }
  }

  _facebookLogin() async {
    setState(() {
      _loading = true;
    });

    try {
      final checkGoogleSignIn = GoogleSignIn(scopes: ["email"]);
      bool _isGoogleSignedIn = await checkGoogleSignIn.isSignedIn();
      if (_isGoogleSignedIn == true) {
        print('Signing excess user out');
        await checkGoogleSignIn.signOut();
        print('exess user signed out');
      }
    } catch (e) {
      print(e + ' needs to be fixed');
    }
    try {
      final facebookLoginResult = await FacebookAuth.instance.login();
      // bool facebookSignedIn = await facebookLoginResult.status
      if (facebookLoginResult.status == LoginStatus.success) {
        // final facebookLoginResult = await FacebookAuth.instance.login();
        // print('ran3');
        final userData = await FacebookAuth.instance.getUserData();
        final facebookAuthCredential = FacebookAuthProvider.credential(
            facebookLoginResult.accessToken.token);
        final resultData = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);

        final User _user = resultData.user;

        // _isNewUser = resultData.additionalUserInfo.isNewUser;

        final _snapShot = await FirebaseFirestore.instance
            .collection('users')
            .doc(_user.uid)
            .get();

        _setPrefs(_snapShot.exists);
        // _isNewUser = resultData.additionalUserInfo.isNewUser

        if (_snapShot.exists == false) {
          // if (_isNewUser == true) {
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
            // print("facebook" + _uid);
          }).then((_) => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (_) => HeardFrom(
                        uid: _uid,
                      )),
              (route) => false));
          // } else {
          //   Navigator.of(context).pushAndRemoveUntil(
          //       MaterialPageRoute(
          //           builder: (_) => StartingBalances(
          //                 uid: _user.uid,
          //               )),
          //       (route) => false);
          // }
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (_) => LoadingInApp(
                        uid: _user.uid,
                      )),
              (route) => false);
        }
      }
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

  _setPrefs(bool status) async {
    _newUserStatus = await SharedPreferences.getInstance();
    await _newUserStatus.setBool('userExists', status);
  }

  // handleLogginIn() {}

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
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 50.0),
        child: Column(
          children: [
            SizedBox(height: 60.0.h),
            Text(
              'Login',
              style: TextStyle(
                fontSize: 25.0.h,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 90.0.h), //50 when normal
            Divider(
              color: Colors.black,
              thickness: 0.4,
            ),
            if (_loading) ...[
              SizedBox(height: 55.h),
              Center(
                child: LoadingBouncingGrid.circle(
                  size: 30.h,
                  backgroundColor: Color(0xff0070c0),
                ),
              ),
            ],
            if (!_loading) ...[
              ListTile(
                onTap: () {
                  print('ran1');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignInRegistrationPage(
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
                  _facebookLogin();
                },
                leading: Image.asset(
                  'assets/images/Social/IconFacebook.png',
                  height: 45.0,
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
                  _googleLogin();
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
}
