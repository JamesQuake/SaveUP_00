import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthProvider extends ChangeNotifier {
  // AuthProvider(){}
  FirebaseAuth _auth = FirebaseAuth.instance;
  // UserCredential _user;
  String _uid = '';
  Status _status = Status.Uninitialized;
  // User user;

  User _user; // Holds the current user

  User get user => _user;

  // AuthService _authService = AuthService();

  AuthProvider() {
    // Listen for auth state changes and update the user
    _auth.authStateChanges().listen((User user) {
      _user = user;
      notifyListeners();
    });
  }

  // Stream<User> get authStateChanges => _auth.authStateChanges();

  // AuthProvider.instance() : _auth = FirebaseAuth.instance {
  //   _auth.authStateChanges().listen((event) {
  //     user = event;
  //     _uid = user.uid;
  //   });
  // }

   String _userIdFirebaseUser(User user) {
    return user != null ? _uid = user.uid : null;
   }

   Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

    Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _userIdFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Status get status => _status;
  // UserCredential get user => _user;
  // String get uid => _uid;
}

// onAuthStateChanged.listen(_onAuthStateChanged)