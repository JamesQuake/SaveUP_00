// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:pay_or_save/models/investment_goal_model.dart';
// import 'package:pay_or_save/models/saving_goal_model.dart';
// import 'package:provider/provider.dart';

// class StreamValues extends StreamProvider {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;

//   // StreamController<int> stuff = StreamController();

//   // AsyncMemoizer
//   // String uid;

//   // TotalValues({this.uid})
//   int sum;
//   int _streamSaveTotal;
//   List savStreamTotList;
//   int streamSaveToDate;
//   List streamSaveToDateList;
//   List<SavingModel> streamSavings;

//   // int sumInv;
//   // int _invTotal;
//   // List _invTotList;
//   // int _invToDate;
//   // List _invToDateList;
//   // List<InvestmentModel> _investment;
//   // Future<List<SavingModel>> savFuture;

//   // List<SavingModel> listOfModelElements;
//   // SavingModel modelWithDeleteItem;

//   List<SavingModel> getSavingsInProvider(_uid) {
//     _db
//         .collection("savingGoals")
//         .doc('users')
//         .collection(_uid)
//         .get()
//         .then((querySnapshot) {
//       streamSavings = <SavingModel>[];
//       querySnapshot.docs.forEach((result) {
//         streamSavings.add(SavingModel.fromJson(result.id, result.data()));
//       });
//     }).then((value) {});
//     return streamSavings;
//   }

//   // Stream<List<SavingModel>> getSavingsStream(_uid) {}

//   // List<InvestmentModel> getInvestmentProvider(_uid) {
//   //   _db
//   //       .collection("investmentGoals")
//   //       .doc('users')
//   //       .collection(_uid)
//   //       .get()
//   //       .then((querySnapshot) {
//   //     _investment = <InvestmentModel>[];
//   //     querySnapshot.docs.forEach((result) {
//   //       _investment.add(InvestmentModel.fromJson(result.id, result.data()));
//   //     });
//   //   }).then((_) {});
//   //   return _investment;
//   // }

//   // getInvestTotal(_uid) async {
//   //   _invTotList = [];
//   //   List _goalInvNum = await getInvestmentProvider(_uid);
//   //   if (_goalInvNum.isNotEmpty) {
//   //     _goalInvNum.forEach((element) {
//   //       _invTotList.add(int.parse(element.goalAmount));
//   //     });
//   //     // _invTotList.s
//   //     _invTotal = _invTotList.reduce((sumSoFar, currentNum) {
//   //       return sumSoFar + currentNum;
//   //     });
//   //     notifyListeners();
//   //   }
//   // }

//   getSavingsTotal(_uid) async {
//     // print('i did run');
//     savStreamTotList = [];
//     List _goalNum = await getSavingsInProvider(_uid);
//     if (_goalNum.isNotEmpty) {
//       _goalNum.forEach((element) {
//         savStreamTotList.add(int.parse(element.goalAmount));
//       });
//       _streamSaveTotal = savStreamTotList.reduce((sumSoFar, currentNum) {
//         return sumSoFar + currentNum;
//       });
//       // print(_streamSaveTotal);
//       notifyListeners();
//     }
//     // return _streamSaveTotal;
//   }

//   Stream<int> getMeStream(_uid) {
//     List<SavingModel> _goalInstances = getSavingsInProvider(_uid);
//     StreamController<int> controller;
//     controller = StreamController<int>(
//       onListen: () {
//         if (_goalInstances.isNotEmpty) {
//           _goalInstances.forEach((element) {
//             savStreamTotList.add(int.parse(element.goalAmount));
//           });
//           _streamSaveTotal = savStreamTotList.reduce((sumSoFar, currentNum) {
//             return sumSoFar + currentNum;
//           });
//           // print(_savTotal);
//           // notifyListeners();
//         }
//       },
//     );
//     controller.onCancel = () {
//       controller.close();
//     };
//     return controller.stream;
//   }

//   getSavingsToDate(_uid) async {
//     streamSaveToDateList = [];
//     List _goalSaveNum = await getSavingsInProvider(_uid);
//     if (_goalSaveNum.isNotEmpty) {
//       _goalSaveNum.forEach((element) {
//         streamSaveToDateList.add(int.parse(element.amount));
//       });
//       streamSaveToDate = streamSaveToDateList.reduce((sumSoFar, currentNum) {
//         return sumSoFar + currentNum;
//       });
//       notifyListeners();
//     }
//     // return streamSaveToDate;
//   }

//   // getInvestToDate(_uid) async {
//   //   _invToDateList = [];
//   //   List _goalInvNum = await getInvestmentProvider(_uid);
//   //   if (_goalInvNum != null) {
//   //     _goalInvNum.forEach((element) {
//   //       _invToDateList.add(int.parse(element.amount));
//   //     });
//   //     _invToDate = _invToDateList.reduce((sumSoFar, currentNum) {
//   //       return sumSoFar + currentNum;
//   //     });
//   //     notifyListeners();
//   //   }
//   // }

//   int get savingsTot => _streamSaveTotal;
//   int get savToDat => streamSaveToDate;
//   // int get invTot => _invTotal;
//   // int get investToDateVal => _invToDate;
// }
