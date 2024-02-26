import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
// import 'package:pay_or_save/models/account_model.dart';
import 'package:pay_or_save/models/investment_goal_model.dart';
import 'package:pay_or_save/models/saving_goal_model.dart';
import 'package:pay_or_save/pages/invest_now.dart';
import 'package:pay_or_save/pages/save_now.dart';
import 'package:pay_or_save/utilities/validator.dart';
// import 'package:pay_or_save/widgets/menu.dart';

class Save extends StatefulWidget {
  final String uid;

  @override
  _SaveState createState() => _SaveState(uid);

  Save({Key key, @required this.uid}) : super(key: key);
}

class _SaveState extends State<Save> {
  String _uid;

  List<SavingModel> _listSavings;
  List<InvestmentModel> _listInvestment;
  SavingModel selectedSaving;
  InvestmentModel selectedInvestment;
  bool isInvestment = false;
  bool isSavings = false;
  String selectedAccount;
  final firestoreInstance = FirebaseFirestore.instance;
  Future<List<SavingModel>> _futureSavings;
  Future<List<InvestmentModel>> _futureInvestments;

  _SaveState(this._uid);

  @override
  void initState() {
    super.initState();
    _futureSavings = getSavingsItems();
    _futureInvestments = getInvestmentItems();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future navigateToSaveNow(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SaveNow(
                  uid: _uid,
                  accountModel: selectedSaving,
                  selectedAccount: selectedAccount,
                )));
  }

  Future navigateToInvest(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InvestNow(
                  uid: _uid,
                  accountModel: selectedInvestment,
                  selectedAccount: selectedAccount,
                )));
  }

  Future<List<SavingModel>> getSavingsItems() async {
    return firestoreInstance
        .collection("savingGoals")
        .doc('users')
        .collection(_uid)
        .get()
        .then((querySnapshot) {
      _listSavings = List<SavingModel>();
      querySnapshot.docs.forEach((result) {
        _listSavings.add(SavingModel.fromJson(result.id, result.data()));
      });
    }).then((value) {
      return _listSavings;
    });
  }

  Future<List<InvestmentModel>> getInvestmentItems() async {
    return firestoreInstance
        .collection("investmentGoals")
        .doc('users')
        .collection(_uid)
        .get()
        .then((querySnapshot) {
      _listInvestment = List<InvestmentModel>();
      querySnapshot.docs.forEach((result) {
        _listInvestment.add(InvestmentModel.fromJson(result.id, result.data()));
      });
    }).then((value) {
      return _listInvestment;
    });
  }

  moveNext() {
    if (selectedAccount != null) {
      if (selectedSaving != null || selectedInvestment != null) {
        if (selectedAccount == "My Savings Account") {
          navigateToSaveNow(context);
        } else if (selectedAccount == "My Investment Account") {
          navigateToInvest(context);
        }
      } else {
        Validator.onErrorDialog("Please select account and goal!", context);
      }
    } else {
      Validator.onErrorDialog("Please select account and goal!", context);
    }
  }

  Widget _itemSaving(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
          color: (selectedSaving == _listSavings[index])
              ? Color(0xFFd0c1e8)
              : Colors.white),
      child: ListTile(
        title: Text(
          _listSavings[index].goal,
          style: TextStyle(fontSize: 16),
        ),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(_listSavings[index].url),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "\$" +
                  double.parse(_listSavings[index].amount).toStringAsFixed(2),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            )
          ],
        ),
        onTap: () {
          setState(() {
            selectedSaving = _listSavings[index];
          });
        },
      ),
    );
  }

  Widget _itemInvestment(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
          color: (selectedInvestment == _listInvestment[index])
              ? Color(0xFFd0c1e8)
              : Colors.white),
      child: ListTile(
        title: Text(
          _listInvestment[index].goal,
          style: TextStyle(fontSize: 16),
        ),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(_listInvestment[index].url),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "\$" +
                  double.parse(_listInvestment[index].amount)
                      .toStringAsFixed(2),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            )
          ],
        ),
        onTap: () {
          setState(() {
            selectedInvestment = _listInvestment[index];
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // actions: <Widget>[MyManue.childPopup(context)],
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        backgroundColor: Color(0xff0070c0),
        title: Text("Save"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      endDrawer: MainDrawer(uid: widget.uid),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: 16,
            ),
            Text(
              "I want to save money by moving it from my checking account to:",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 16,
            ),
            DropdownButton(
              hint: selectedAccount == null
                  ? Text('Select:')
                  : Text(
                      selectedAccount,
                      style: TextStyle(color: Colors.black),
                    ),
              isExpanded: true,
              iconSize: 30.0,
              style: TextStyle(color: Colors.blue, fontSize: 20),
              items: ['My Savings Account', 'My Investment Account'].map(
                (val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(val),
                  );
                },
              ).toList(),
              onChanged: (val) {
                setState(
                  () {
                    selectedAccount = val;
                    if (val == "My Savings Account") {
                      isInvestment = false;
                      isSavings = true;
                    }
                    if (val == "My Investment Account") {
                      isSavings = false;
                      isInvestment = true;
                    }
                  },
                );
              },
            ),
            SizedBox(
              height: 26,
            ),
            (isSavings)
                ? FutureBuilder<List<SavingModel>>(
                    future: _futureSavings, // async work
                    builder: (BuildContext context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return new Text('Loading....');
                        default:
                          if (snapshot.hasError)
                            return new Text('Error: ${snapshot.error}');
                          else
                            return Container(
                              height: 300,
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: (snapshot.data != null)
                                    ? snapshot.data.length
                                    : 0,
                                itemBuilder: (BuildContext context, int index) {
                                  return _itemSaving(context, index);
                                },
                              ),
                            );
                      }
                    },
                  )
                : Container(),
            (isInvestment)
                ? FutureBuilder<List<InvestmentModel>>(
                    future: _futureInvestments, // async work
                    builder: (BuildContext context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return new Text('Loading....');
                        default:
                          if (snapshot.hasError)
                            return new Text('Error: ${snapshot.error}');
                          else
                            return Container(
                              height: 300,
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: (snapshot.data != null)
                                    ? snapshot.data.length
                                    : 0,
                                itemBuilder: (BuildContext context, int index) {
                                  return _itemInvestment(context, index);
                                },
                              ),
                            );
                      }
                    },
                  )
                : Container(),
            SizedBox(
              height: 70,
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 0.0, right: 0.0),
                  child: ButtonTheme(
                    minWidth: 300.0,
                    height: 50.0,
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Color(0xff0070c0),
                      child: Text("Next"),
                      onPressed: () {
                        moveNext();
                      },
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
