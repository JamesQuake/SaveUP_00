import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'dart:developer' as dev;

import '../pages/investment_goal.dart';
import '../pages/saving_goals.dart';
import '../pages/starting_balances.dart';

class InfoProvider extends ChangeNotifier {
  final firestoreInstance = FirebaseFirestore.instance;
  bool _savGoalList;
  bool _investGoalList;
  bool _savListReturn = false;
  bool _invListReturn = false;
  String userUid;

  void storeUser(uid) {
    userUid = uid;
    // context.read()<InfoProvider>().userUid
  }

  loadScreen(uid) async {
    userUid = uid;
    // print("suya");
    await getGoalList(uid);
    await getInvList(uid);
  }

  getGoalList(uid) async {
    return firestoreInstance
        .collection("savingGoals")
        .doc('users')
        .collection(uid)
        .get()
        .then((snapshot) {
      savGoalList = (snapshot.docs.length < 1);
      savListReturn = true;
    });
  }

  getInvList(uid) async {
    return firestoreInstance
        .collection("investmentGoals")
        .doc('users')
        .collection(uid)
        .get()
        .then((snapshot) {
      invGoalList = (snapshot.docs.length < 1);
      invListReturn = true;
    });
  }

  checkList(context, uid, routePass) async {
    if (_savGoalList == true) {
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
              builder: (_) => SavingGoals(
                    uid: uid,
                  )),
          (route) => false);
      // });
    } else if (_investGoalList == true) {
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
              builder: (_) => InvestmentGoals(
                    uid: uid,
                    incomingRoute: routePass,
                  )),
          (route) => false);
      // });
      // return;
    } else if (_savGoalList == false && _investGoalList == false) {
      // dev.log("socks");
      // WidgetsBinding.instance.scheduleFrameCallback((_) {
      dev.log("bulldog");
      Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
              builder: (_) => StartingBalances(
                    uid: uid,
                  )),
          (route) => true);
      dev.log("relish");
      // });
      dev.log("snipe");
    }
    dev.log("0900");
  }

  bool get savListReturn => _savListReturn;
  set savListReturn(val) {
    _savListReturn = val;
    // notifyListeners();
  }

  bool get invListReturn => _invListReturn;
  set invListReturn(val) {
    _invListReturn = val;
    // notifyListeners();
  }

  bool get savGoalList => _savGoalList;
  set savGoalList(val) {
    _savGoalList = val;
    // notifyListeners();
  }

  bool get invGoalList => _investGoalList;
  set invGoalList(val) {
    _investGoalList = val;
    // notifyListeners();
  }
}
