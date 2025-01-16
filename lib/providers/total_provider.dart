import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pay_or_save/models/investment_goal_model.dart';
import 'package:pay_or_save/models/saving_goal_model.dart';

class TotalValues extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // AsyncMemoizer
  // String uid;

  // TotalValues({this.uid})
  int sum;
  int _savTotal;
  List<int> _savingsTotList;
  int _savToDate;
  List<int> _savToDateList;
  List<SavingModel> _savings;
  List<SavingModel> _saveNow;

  int sumInv;
  int _invTotal;
  List<int> _invTotList;
  int _invToDate;
  List<int> _invToDateList;
  List<InvestmentModel> _investment;
  List<InvestmentModel> _investNow;
  int _rewardPoints;
  String _name;
  // Future<List<SavingModel>> savFuture;

  // List<SavingModel> listOfModelElements;
  // SavingModel modelWithDeleteItem;

  Future getSavingsInProvider(_uid) {
    // print(_uid);
    return _db
        .collection("savingGoals")
        .doc('users')
        .collection(_uid)
        .orderBy("created")
        .get()
        .then((querySnapshot) {
      // _savings = <SavingModel>[];
      // querySnapshot.docs.forEach((result) {
      //   _savings.add(SavingModel.fromJson(result.id, result.data()));
      // });
      savingModelInstance = querySnapshot.docs
          .map((result) => SavingModel.fromJson(result.id, result.data()))
          .toList();

          saveNowList = querySnapshot.docs
          .map((result) => SavingModel.fromJson(result.id, result.data()))
          .toList();

          saveNowList.removeWhere((element) => num.parse(element.amount) >= num.parse(element.goalAmount));

      // List dateCreated = querySnapshot.docs
      //     .map((result) => SavingModel.fromJson(result.id, result.data()).created)
      //     .toList();
      if (savingModelInstance == null) {
        // savingModelInstance = <SavingModel>[];
        print('test1');
      }
    }).then((_) {
      // _getTotal();
      // print('Look');
      // print(_savings);
      // return _savings;
    });
  }

  sortGoals() {}

  Future getInvestmentProvider(_uid) {
    return _db
        .collection("investmentGoals")
        .doc('users')
        .collection(_uid)
        .orderBy("created")
        .get()
        .then((querySnapshot) {
      investModelInstance = querySnapshot.docs
          .map((result) => InvestmentModel.fromJson(result.id, result.data()))
          .toList();
      investNowList = querySnapshot.docs
          .map((result) => InvestmentModel.fromJson(result.id, result.data()))
          .toList();
      // investNowList = investModelInstance;
      investNowList.removeWhere((element) => num.parse(element.amount) >= num.parse(element.goalAmount));
    }).then((_) {
      // return _investment;
    });
  }

  Future getInvestTotal(_uid) async {
    _invTotList = [];
    await getInvestmentProvider(_uid);
    if (investModelInstance.isNotEmpty) {
      _invTotList =
          investModelInstance.map((e) => int.tryParse(e.goalAmount)).toList();
      // _invTotList.s
      invTot = _invTotList.reduce((sumSoFar, currentNum) {
        return sumSoFar + currentNum;
      });
      // notifyListeners();
    } else {
      invTot = 0;
    }
    // return _invTotal;
  }

  Future getSavingsTotal(_uid) async {
    // print('i did run');
    _savingsTotList = [];
    await getSavingsInProvider(_uid);
    // if (savingModelInstance == null) {
    //   savingModelInstance = [];
    // }
    if (savingModelInstance.isNotEmpty) {
      _savingsTotList =
          savingModelInstance.map((e) => int.tryParse(e.goalAmount)).toList();
      savingsTot = _savingsTotList.reduce((sumSoFar, currentNum) {
        return sumSoFar + currentNum;
      });
      // print("savings total ran eere");
      // notifyListeners();
    } else {
      savingsTot = 0;
    }
    // return savingsTot;
  }

  // getDeleteObject(dynamic _uid, SavingModel model) async {
  //   listOfModelElements = await getSavingsInProvider(_uid);
  //   listOfModelElements.forEach((goal) {
  //     if (model == goal && model.goalAmount == goal.goalAmount) {
  //       modelWithDeleteItem = model;
  //       notifyListeners();
  //     }
  //     // if (model)
  //     return modelWithDeleteItem;
  //   });
  // }

  // deleteVal(SavingModel del) {
  //   print(_savingsTotList);
  //   _savingsTotList.remove(del.goalAmount);
  //   print('OBS THIS');
  //   print(_savingsTotList);
  //   notifyListeners();
  // }

  // getAllValues (_uid) async {
  //   _savingsTotList = [];
  //   List _goalNum = await getSavingsInProvider(_uid);
  //   if (_goalNum.isNotEmpty) {
  //     _goalNum.forEach((element) {
  //       _savingsTotList.add(int.parse(element.goalAmount));
  //     });
  //     _savTotal = _savingsTotList.reduce((sumSoFar, currentNum) {
  //       return sumSoFar + currentNum;
  //     });
  //     notifyListeners();
  // }

  Future getSavingsToDate(_uid) async {
    _savToDateList = [];
    await getSavingsInProvider(_uid);
    if (savingModelInstance.isNotEmpty) {
      // savingModelInstance.forEach((element) {
      //   _savToDateList.add(int.parse(element.amount));
      // });
      _savToDateList =
          savingModelInstance.map((e) => int.tryParse(e.amount)).toList();
      if (_savToDateList.isNotEmpty)
        savToDat = _savToDateList.reduce((sumSoFar, currentNum) {
          return sumSoFar + currentNum;
        });
      // notifyListeners();
    }
    return _savToDate;
  }

  Future getInvestToDate(_uid) async {
    _invToDateList = [];
    await getInvestmentProvider(_uid);
    if (investModelInstance != null) {
      // _goalInvNum.forEach((element) {
      //   _invToDateList.add(int.parse(element.amount));
      // });
      _invToDateList =
          investModelInstance.map((e) => int.tryParse(e.amount)).toList();
      if (_invToDateList.isNotEmpty)
        investToDateVal = _invToDateList.reduce((sumSoFar, currentNum) {
          return sumSoFar + currentNum;
        });
      // else
      //   investToDateVal = 0;
      // notifyListeners();
    }
    return _invToDate;
  }

  getRewardPointBal(uid) {
    _db.collection("users").doc(uid).get().then((value) async {
      getRewardPoint = value.data()['reward_points'].toInt();
      getName = value.data()['firstName'];
      if (getName == null) getName = value.data()['name'];
    });
  }

  set savingsTot(int val) {
    _savTotal = val;
    notifyListeners();
  }

  set savToDat(int value) {
    _savToDate = value;
    notifyListeners();
  }

  set invTot(int value) {
    _invTotal = value;
    notifyListeners();
  }

  set investToDateVal(int value) {
    _invToDate = value;
    notifyListeners();
  }

  set savingModelInstance(List<SavingModel> list) {
    // list.sort();
    _savings = list;
    notifyListeners();
  }

  set saveNowList(List<SavingModel> list) {
    // list.sort();
    _saveNow = list;
    notifyListeners();
  }

  set investModelInstance(List<InvestmentModel> list) {
    _investment = list;
    notifyListeners();
  }

  set investNowList(List<InvestmentModel> list) {
    _investNow = list;
    notifyListeners();
  }

  int get getRewardPoint => _rewardPoints;
  set getRewardPoint(val) {
    _rewardPoints = val;
    notifyListeners();
  }

  String get getName => _name;
  set getName(val) {
    _name = val;
    notifyListeners();
  }
  // resetFunction () {

  // }

  // List get allPosValues {
  //   listOfValues = [];

  //   return listOfValues;
  // }
  List<InvestmentModel> get investModelInstance => _investment;
  List<InvestmentModel> get investNowList => _investNow;
  List<SavingModel> get savingModelInstance => _savings;
  List<SavingModel> get saveNowList => _saveNow;
  int get savingsTot => _savTotal;
  int get savToDat => _savToDate;
  int get invTot => _invTotal;
  int get investToDateVal => _invToDate;
  // Future<List<SavingModel>> get getSavings => getSavingsInProvider(uid);
}
