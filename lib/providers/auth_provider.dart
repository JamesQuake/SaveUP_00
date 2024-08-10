import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

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


  var selectedPlan = 1;

  changeSelectedPlan(int plan){
    selectedPlan = plan;
    notifyListeners();
  }

  Offerings offerings;
  Future getOfferingsDetails() async {
    await Purchases.setDebugLogsEnabled(true);

    PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration =
          PurchasesConfiguration("goog_ROKUqNPFksWwfOPyvIcvyZKDPvC");
      // print("this gibberish");
      // if (buildingForAmazon) {
      //   // use your preferred way to determine if this build is for Amazon store
      //   // checkout our MagicWeather sample for a suggestion
      //   configuration = AmazonConfiguration("public_amazon_sdk_key");
      // }
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration("appl_TyEUZYmaqrFBvyvETDxAnSatMwM");
    }
    await Purchases.configure(configuration);
    offerings = await Purchases.getOfferings();
  }

  Future purchasePlan() async {
    final desiredPackageId = 'Plan $selectedPlan'; // Replace with your offering ID

    // Find the specific offering
    final specificPackage = offerings.current?.availablePackages.firstWhere(
          (package) => package.identifier == desiredPackageId,
      orElse: () => null,
    );

    print('identifies -> -> ${specificPackage.identifier}');

    final purchase = await Purchases.purchasePackage(specificPackage);
  }

  num checking, rewardPoints;
  Future getBalances(String uid) async {
    print('I am in get bacl');
    await FirebaseFirestore.instance.collection("users").doc(uid).get().then((value) {
      if (value.data != null) {
        checking = value.data()['checking'].round();
        rewardPoints = value.data()['reward_points'].round();
      }
    });
  }

}

// onAuthStateChanged.listen(_onAuthStateChanged)