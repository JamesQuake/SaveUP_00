import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pay_or_save/models/investment_goal_model.dart';
import 'package:pay_or_save/models/saving_goal_model.dart';

class GoalInfo extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  bool hasInvGoal;
  bool hasSavGoal;

  Future _checkUserInvGoals(_uid) {
    return _db
        .collection("investmentGoals")
        .doc('users')
        .collection(_uid)
        .get()
        .then((snapshot) {
      hasInvGoalSetter = (snapshot.docs.length < 1);
    });
  }

  Future _checkUserSavingGoals(_uid) {
    return _db
        .collection("savingGoals")
        .doc('users')
        .collection(_uid)
        .get()
        .then((snapshot) {
      // snapshot.i
      // var stuff = snapshot == null;
      hasSavGoalSetter = (snapshot.docs.length < 1);
    });
  }

  set hasSavGoalSetter(bool val) {
    hasSavGoal = val;
    notifyListeners();
  }

  set hasInvGoalSetter(bool val) {
    hasInvGoal = val;
    notifyListeners();
  }

  bool get hasSavGoalSetter => hasSavGoal;
  bool get hasInvGoalSetter => hasInvGoal;
}
