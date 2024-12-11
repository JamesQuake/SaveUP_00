import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

import 'investment_goal.dart';
import 'saving_goals.dart';
import 'starting_balances.dart';

class LoadingInApp extends StatefulWidget {
  final String uid;

  const LoadingInApp({Key key, this.uid}) : super(key: key);

  @override
  State<LoadingInApp> createState() => _LoadingInAppState();
}

class _LoadingInAppState extends State<LoadingInApp> {
  bool isUser;
  final firestoreInstance = FirebaseFirestore.instance;
  bool _savGoalList;
  bool _investGoalList;

  @override
  void initState() {
    super.initState();
    _checkList();
  }

  _getGoalList() async {
    return firestoreInstance
        .collection("savingGoals")
        .doc('users')
        .collection(widget.uid)
        .get()
        .then((snapshot) {
      _savGoalList = (snapshot.docs.length < 1);
    });
  }

  _getInvList() async {
    return firestoreInstance
        .collection("investmentGoals")
        .doc('users')
        .collection(widget.uid)
        .get()
        .then((snapshot) {
      _investGoalList = (snapshot.docs.length < 1);
    });
  }

  _checkList() async {
    await _getGoalList();
    await _getInvList();
    if (_savGoalList == true) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (_) => SavingGoals(
                    uid: widget.uid,
                  )),
          (route) => false);
    } else if (_investGoalList == true) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (_) => InvestmentGoals(
                    uid: widget.uid,
                  )),
          (route) => false);
      // return;
    } else if (_savGoalList == false && _investGoalList == false) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (_) => StartingBalances(
                    uid: widget.uid,
                  )),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Loading",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: LoadingBouncingGrid.circle(
              size: 30,
              backgroundColor: Color(0xff0070c0),
            ),
          ),
        ],
      ),
    );
  }
}
