import 'dart:async';
// import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/models/account_model.dart';
import 'package:pay_or_save/models/saving_goal_model.dart';
import 'package:pay_or_save/pages/oldedits/congratulation_saving.dart';
// import 'package:pay_or_save/pages/invest_now.dart';
// import 'package:pay_or_save/pages/congrats_saving.dart';
// import 'package:pay_or_save/pages/new_pages/congratulations_investment.dart';
import 'package:pay_or_save/pages/overdraft.dart';
import 'package:pay_or_save/pages/overdraft_notice.dart';
import 'package:pay_or_save/providers/total_provider.dart';
import 'package:pay_or_save/utilities/validator.dart';
// import 'package:pay_or_save/widgets/menu.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/productmodel.dart';
import '../widgets/alert_pos.dart';
import 'congrats_saving.dart';

// import 'edit_saving_goal.dart';

class SaveNow extends StatefulWidget {
  final String uid, selectedAccount, incomingOrder;
  final SavingModel accountModel;

  @override
  _SaveNowState createState() => _SaveNowState(selectedAccount, accountModel);

  SaveNow(
      {Key key,
      this.selectedAccount,
      this.accountModel,
      this.incomingOrder,
      this.uid})
      : super(key: key);
}

class _SaveNowState extends State<SaveNow> with SingleTickerProviderStateMixin {
  String _uid, _total, _percents, selectedAccount;
  int countPecentage;
  double _savings, _orderAmount, res, totalSaved;
  int _checking, _rewardPoints;
  List<AccountModel> _list;
  List _savingsTotalList;
  List _savingsToDateList;
  dynamic _getBal;
  double x;
  int _savedIndex;
  SavingModel accountModel;
  final firestoreInstance = FirebaseFirestore.instance;
  var items = {
    '10%': '10',
    '20%': '20',
    '30%': '30',
    '40%': '40',
    '50%': '50',
    '60%': '60',
    '70%': '70',
    '80%': '80',
    '90%': '90',
    '100%': '100'
  };
  int acceptDrag = 0;

  bool isFav = false;
  AnimationController _controller;
  Animation<double> _shopIconSizeAnimation;
  Animation<double> _hangIconSizeAnimation;
  Animation _curve;
  List<SavingModel> _listSavings;
  Future<List<SavingModel>> _futureSavings;
  bool _isSelected = false;
  List _highlightedIndex;
  Color rowColor;
  int _savingsTotal;
  int _savingsToDate;
  int _savingValueItem;
  Future<int> _saveTotal;
  Future<int> _saveToDate;
  String _incomingRoute = '/save_now';
  String _modelId;
  SavingModel updatedModel;
  String savedAmount;
  SharedPreferences _prefs;
  List addedVal = [];
  double undoAmount;
  SavingModel editedModel;
  bool _activeEdit = false;
  List savingValues = [];
  double _saveOrderAmount;
  bool _editedGoal = false;
  bool _undoEdited = false;
  bool goalSaved = false;
  // int a;
  // var finalVal;

  _SaveNowState(this.selectedAccount, this.accountModel);

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero, () async {
    //   _prefs = await SharedPreferences.getInstance();
    //   var currentUid = _prefs.getString('storedUid');
    //   _uid = currentUid;
    // });
    // _getUidFromPref();

    // _saveTotal = Provider.of<TotalValues>(context, listen: false)
    //     .getSavingsTotal(widget.uid);
    // _saveToDate = Provider.of<TotalValues>(context, listen: false)
    //     .getSavingsToDate(widget.uid);
    _highlightedIndex = [];
    _listSavings = List<SavingModel>();
    _getBal = _getBalances();
    _futureSavings = getSavingsItems();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    // print(currentUid);

    _curve = CurvedAnimation(parent: _controller, curve: Curves.slowMiddle);

    _shopIconSizeAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: 60.0,
            end: 0.0,
          ),
          weight: 100.0),
    ]).animate(_curve);

    _hangIconSizeAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: 70.0,
            end: 130.0,
          ),
          weight: 50.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(
            begin: 130.0,
            end: 70.0,
          ),
          weight: 50.0),
    ]).animate(_curve);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isFav = true;
        });
      }
      if (status == AnimationStatus.dismissed) {
        setState(() {
          isFav = false;
        });
      }
    });

    _list = List<AccountModel>();
    totalSaved = 0.0;
    _orderAmount = double.parse(widget.incomingOrder);
    _saveOrderAmount = double.parse(widget.incomingOrder);
    countPecentage = 100;
    res = double.parse(widget.incomingOrder);
    _setInitial();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  int percentage = 100;
  int iPercent = 10;
  int iYears = 10;

  Future<List<SavingModel>> getSavingsItems() async {
    // await _getUidFromPref();
    // print('object');
    // print(widget.uid);

    return firestoreInstance
        .collection("savingGoals")
        .doc('users')
        .collection(widget.uid)
        .get()
        .then((querySnapshot) {
      // print('fromHERE');
      // print(querySnapshot);
      _listSavings = List<SavingModel>();
      querySnapshot.docs.forEach((result) {
        // print(result);
        _listSavings.add(SavingModel.fromJson(result.id, result.data()));
      });
    }).then((value) {
      // print(value);
      // print(_listSavings);
      // _getSavingsTotal();
      // _getSavingsToDate();
      return _listSavings;
    });
  }

  _getBalances() {
    return firestoreInstance
        .collection("users")
        .doc(widget.uid)
        .get()
        .then((value) {
      _checking = value.data()['checking'].toInt();
      _savings = value.data()['savings'].toDouble();
      _rewardPoints = value.data()['reward_points'].toInt();
    }).then((v) {
      _list.add(AccountModel(
          "https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fdollar-green.png?alt=media&token=b1720f47-5c6b-4c57-a37c-98884f8590c1",
          "Total Savings",
          _savings.toStringAsFixed(2),
          ''));
      _list.add(AccountModel(
          "https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fcheking-icon.png?alt=media&token=9d278e21-7097-453c-b253-187a700d03bc",
          "Checking account balance",
          _checking.toStringAsFixed(2),
          ''));
      _list.add(AccountModel(
          "", "Reward Point balance", _rewardPoints.toStringAsFixed(2), ''));
      return _list;
    });
  }

//To retrieve the string
// String documentID = await getPosData();
  _selectGoalDialog(BuildContext context) {
    // set up the buttons
    Widget okButton = TextButton(
      child: Text(
        "OK",
        style: TextStyle(
          color: Color(0xff0070c0),
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '•',
            style: TextStyle(
              fontSize: 45.0,
              height: 1.2,
              color: Color(0xff0070c0),
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Text(
            'Please select a goal.',
            style: TextStyle(
              fontSize: 19.0,
              color: Color(0xff0070c0),
              fontWeight: FontWeight.w500,
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

  saveAmount(context, SavingModel _model) {
    if (_orderAmount >= 1 && _orderAmount >= (res / 2)) {
      if (countPecentage != 0 && countPecentage != null) {
        if (goalSaved == false) {
          if (_checking < res) {
            showOverdraftNotice(context, double.parse(_checking.toString()));
          } else {
            x = res;
            undoAmount = x;
            var c = _checking - x;
            var s = _savings + x;
            var r = _rewardPoints + x;
            var calcChecking = num.parse(c.toStringAsFixed(2));
            var calcSavings = num.parse(s.toStringAsFixed(2));
            var calcReward = num.parse(r.toStringAsFixed(2));
            firestoreInstance.collection("users").doc(widget.uid).update({
              "checking": calcChecking,
              "savings": calcSavings,
              "reward_points": calcReward
            }).then((_) {
              _savingValueItem = _highlightedIndex[0];
              totalSaved = totalSaved + x;
              // int a;
              var _num = int.parse(_model.amount) + x;
              // print("goat");
              // print(_num);
              int a = (_num.round()).toInt();

              // print("anger");
              // print(a);
              // a.toInt();
              firestoreInstance
                  .collection("savingGoals")
                  .doc("users")
                  .collection(widget.uid)
                  .doc((_model.goalId).trim())
                  .update({
                "savingAmount": a.toString(),
              });
            }).then((_) {
              // print("preeeee");
              // print(a);
              editedModel = _model;
              var goalAmt = int.parse(_model.amount) + x;

              // goalAmount = goalAmount + x;
              int goalAmount = goalAmt.toInt();

              // goalAmount.round();

              setState(() {
                // _orderAmount = _orderAmount - x;
                _model.amount = goalAmount.toString();
                _modelId = _model.goalId;
                updatedModel = _model;
                savedAmount = x.toString();
                Provider.of<TotalValues>(context, listen: false)
                    .getSavingsTotal(widget.uid);
                Provider.of<TotalValues>(context, listen: false)
                    .getSavingsToDate(widget.uid);
                _savedIndex = _highlightedIndex[0];
                _highlightedIndex.clear();
                // _list[0].amount = (_savings + x).toString();

                // _list[1].amount = (_checking - x).toString();

                // _list[2].amount = (_rewardPoints + x).toString();

                _savings = _savings + x;
                _checking = _checking - x.toInt();
                _rewardPoints = _rewardPoints + x.toInt();
                savingValues.add(res);

                res = (_orderAmount / 100) * countPecentage;

                x = (_orderAmount / 100) * countPecentage;

                _activeEdit = true;
                savingValues.add(countPecentage);
                savingValues.add(totalSaved);

                goalSaved = true;
                // totalSaved = 0;
                // countPecentage = 0;
                // res = 0;
                // res = 0;
                // x = 0;
              });
              // refreshProvider(context);
            });
          }
        } else {
          Validator.onErrorDialog(
              "You cannot save your goal multiple times", context);
        }
      } else {
        Validator.onErrorDialog(
            "Please select a percentage of your order using the slider",
            context);
      }
    } else {
      Validator.onErrorDialog(
          "You cannot save your order amount more than once", context);
    }
  }

  _undoSave(SavingModel _model) {
    if (_activeEdit == true) {
      var _chck = _checking + undoAmount;
      var _sav = _savings - undoAmount;
      var _rwdpnt = _rewardPoints - undoAmount;
      var calChecking = num.parse(_chck.toStringAsFixed(2));
      var calSavings = num.parse(_sav.toStringAsFixed(2));
      var calReward = num.parse(_rwdpnt.toStringAsFixed(2));
      firestoreInstance.collection("users").doc(widget.uid).update({
        "checking": calChecking,
        "savings": calSavings,
        "reward_points": calReward
      }).then((_) {
        totalSaved = totalSaved - undoAmount;
        var num = int.parse(_model.amount) - undoAmount;
        int amt = num.toInt();
        // amt = amt.toInt();
        // a.toInt();
        firestoreInstance
            .collection("savingGoals")
            .doc("users")
            .collection(widget.uid)
            .doc((_model.goalId).trim())
            .update({
          "savingAmount": amt.toString(),
        });
      }).then((_) {
        var g = int.parse(_model.amount) - undoAmount;

        // goalAmount = goalAmount + x;
        int gAmt = g.toInt();

        setState(() {
          // _orderAmount = _orderAmount + undoAmount;
          _model.amount = gAmt.toString();
          _modelId = '';
          // updatedModel = null;
          savedAmount = '0';
          Provider.of<TotalValues>(context, listen: false)
              .getSavingsTotal(widget.uid);
          Provider.of<TotalValues>(context, listen: false)
              .getSavingsToDate(widget.uid);
          _highlightedIndex.clear();
          _savedIndex = null;
          // setState(() {});
          // _highlightedIndex.clear();
          // _list[0].amount = (_savings - undoAmount).toString();

          // _list[1].amount = (_checking + undoAmount).toString();

          // _list[2].amount = (_rewardPoints - undoAmount).toString();

          _savings = _savings - undoAmount;
          _checking = _checking + undoAmount.toInt();
          _rewardPoints = _rewardPoints - undoAmount.toInt();

          // res = (_orderAmount / 100) * countPecentage;
          //  res = (res * 100) / countPecentage;

          // x = (_orderAmount / 100) * countPecentage;

          res = savingValues[0];
          countPecentage = savingValues[1];
          totalSaved = savingValues[2];
          _activeEdit = false;
          goalSaved = false;
          // res = 0;
          // x = 0;
        });
      });
    } else {
      print('no active edit');
    }
  }

  double convertToDecimal(amount, goal) {
    if (double.parse(goal) == double.parse(amount)) {
      return 1;
    } else {
      var res = (double.parse(amount).floor() / double.parse(goal).floor());
//      var s = res.floor();
//      var a = "0."+s.toString();
//      return double.parse(a);
      return res;
    }
  }

  _setInitial() {
    _highlightedIndex.add(0);
    setState(() {
      _isSelected = true;
    });
  }

  _highlightRow(dynamic index) {
    _highlightedIndex.add(index);
    // print(_highlightedIndex);
    setState(() {
      _isSelected = true;
    });
  }

  _unSelect(dynamic index) async {
    _highlightedIndex.remove(index);
    // print(_highlightedIndex);
    setState(() {
      _isSelected = false;
    });
  }

  Widget _item(BuildContext context, int index, SavingModel saveModel) {
    return Column(
      children: [
        Divider(
          thickness: 0.4,
          color: Colors.black,
          height: 0.0,
        ),
        Padding(
          padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: Text(
                  (index + 1).toString() + '.',
                  style: TextStyle(fontSize: 13.0),
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              // Spacer(),
              Container(
                // width: 50,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(saveModel.url),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            saveModel.goal,
                            // textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[450]),
                          ),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 70,
                              child: (saveModel.amount != null)
                                  ? Text(
                                      NumberFormat.simpleCurrency(
                                        locale: "en-us",
                                        decimalDigits: 0,
                                      ).format(int.parse(saveModel.amount)),
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 13.0),
                                    )
                                  : Text(
                                      '--',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 3.0),
                              child: Container(
                                width: 70,
                                child: (saveModel.goalAmount != null)
                                    ? Text(
                                        NumberFormat.simpleCurrency(
                                                locale: "en-us",
                                                decimalDigits: 0)
                                            .format(int.parse(
                                                saveModel.goalAmount)),
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 13.0),
                                      )
                                    : Text(
                                        '--',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: LinearProgressIndicator(
                        // semanticsLabel: 'Balling',
                        backgroundColor: Colors.grey[350],
                        minHeight: 7.0,
                        color: Colors.green,
                        value: convertToDecimal(
                            (saveModel != null) ? saveModel.amount : '0',
                            (saveModel != null) ? saveModel.goalAmount : '0'),
                        // valueColor: ,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var _totalVal = Provider.of<TotalValues>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff0e8646),
        //  leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: () => Navigator.of(context).pop(),
        //   // onPressed: () {
        //   //   getModelInfo();
        //   // },
        // ),
        title: Text(
          'Save Now',
          style: TextStyle(
            fontSize: 27.h,
            fontWeight: FontWeight.w700,
          ),
        ),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: () => Navigator.pop(context),
        //   // onPressed: () {
        //   //   print(widget.uid);
        //   // },
        // ),
        centerTitle: true,
        elevation: 0.0,
      ),
      endDrawer: MainDrawer(uid: widget.uid, incomingRoute: _incomingRoute),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 10.0),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Text(
                    'Order Amount',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.h),
                  ),
                  Spacer(),
                  Text(
                    NumberFormat.simpleCurrency(
                            locale: "en-us", decimalDigits: 2)
                        .format(_saveOrderAmount),
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16.h,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 0.8,
                color: Colors.black,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 160,
                        child: Align(
                          alignment: Alignment.topLeft,
                          // widthFactor: 10.0,
                          child: Text(
                            'How much of your order amount would you like to save?.',
                            textAlign: TextAlign.left,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 15.h,
                              // overflow: TextOverflow.clip,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4.0.h,
                  ),
                  Row(
                    children: [
                      Text(
                        '0%',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.h,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Container(
                        // width: MediaQuery.of(context).size.width - 110,
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.blue,
                            inactiveTrackColor: Colors.blue[100],
                            trackShape: RoundedRectSliderTrackShape(),
                            trackHeight: 7.0,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 12.0),
                            thumbColor: Colors.blue,
                            overlayColor: Colors.blue.withAlpha(32),
                            overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 28.0),
                            tickMarkShape: RoundSliderTickMarkShape(),
                            activeTickMarkColor: Color(0xff0070c0),
                            inactiveTickMarkColor: Colors.blue[100],
                            valueIndicatorShape:
                                PaddleSliderValueIndicatorShape(),
                            valueIndicatorColor: Colors.blue,
                            valueIndicatorTextStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          child: Expanded(
                            child: Slider(
                              value:
                                  (double.parse(_percents ?? (100).toString())),
                              // value: 0.0,
                              onChanged: (val) {
                                setState(() {
                                  _percents = (val.toInt()).toString();
                                  countPecentage = val.toInt();
                                  res = (_orderAmount / 100) * (val.toInt());
                                });
                              },
                              min: 0,
                              max: 200,
                              divisions: 20,
                              label:
                                  _percents == null ? '100%' : _percents + "%",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        '200%',
                        style: TextStyle(
                          fontSize: 16.h,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                thickness: 0.8,
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 5.0,
                  bottom: 5.0,
                ),
                child: Row(
                  children: [
                    Text(
                      'Total Savings',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.h),
                    ),
                    Spacer(),
                    Text(
                      NumberFormat.simpleCurrency(
                              locale: "en-us", decimalDigits: 2)
                          .format(res),
                      style: TextStyle(
                        // color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.h,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 0.8,
                color: Colors.black,
              ),
              SizedBox(
                height: 20.0.h,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Saving Goals',
                  // textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.h,
                  ),
                ),
              ),
              SizedBox(
                height: 15.0.h,
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    height: 1.0,
                    fontStyle: FontStyle.italic,
                    fontSize: 16.h,
                  ),
                  children: [
                    TextSpan(
                      text:
                          "These are your savings goals. Tap on the goal that you'd like to apply your savings to. ",
                    ),
                    TextSpan(text: "Use  "),
                    WidgetSpan(
                      child: Image.asset(
                        "assets/images/buttons/add-green.png",
                        height: 18.h,
                      ),
                    ),
                    TextSpan(text: "  to save. Use  "),
                    WidgetSpan(
                      child: Image.asset(
                        "assets/images/buttons/undo-green.png",
                        height: 18.h,
                      ),
                    ),
                    TextSpan(
                      text: "  to undo.",
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 18.0.h,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      children: [
                        Spacer(),
                        Container(
                          width: 50.w,
                          child: Text(
                            'Savings to Date',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 13.0.h,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15.0.w,
                        ),
                        Container(
                          width: 50.w,
                          child: Text(
                            'Savings Goals',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13.0.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Consumer<TotalValues>(
                    builder: (context, savingProvider, child) {
                      return Column(
                        children: [
                          FutureBuilder(
                            future: savingProvider
                                .getSavingsInProvider(widget.uid), // async work
                            builder: (BuildContext context, snapshot) {
                              if (savingProvider.savingModelInstance != null) {
                                return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount:
                                      (savingProvider.savingModelInstance !=
                                              null)
                                          ? savingProvider
                                              .savingModelInstance.length
                                          : 0,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    // _setInitial(0);
                                    return GestureDetector(
                                      onDoubleTap: () {
                                        if (_highlightedIndex.contains(index) ==
                                            true) {
                                          _unSelect(index);
                                        } else {
                                          print('Not selected');
                                        }
                                      },
                                      onTap: () {
                                        if (_highlightedIndex.contains(index) ==
                                            false) {
                                          _highlightedIndex.clear();
                                          _highlightRow(index);
                                        } else {
                                          print('Selected');
                                        }
                                      },
                                      // #
                                      child: Container(
                                          color:
                                              _highlightedIndex.contains(index)
                                                  ? Color(0xfff4ccc9)
                                                  : index == _savedIndex
                                                      ? Color(0xffc3e9d5)
                                                      : Colors.transparent,
                                          child: _item(
                                              context,
                                              index,
                                              savingProvider
                                                  .savingModelInstance[index])),
                                    );
                                  },
                                );
                              }
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return new Text('Loading....');
                                default:
                                  if (snapshot.hasError)
                                    return new Text('Error: ${snapshot.error}');
                                  else
                                    return ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: (snapshot.data != null)
                                          ? snapshot.data.length
                                          : 0,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onDoubleTap: () {
                                            if (_highlightedIndex
                                                    .contains(index) ==
                                                true) {
                                              _unSelect(index);
                                            } else {
                                              print('Not selected');
                                            }
                                          },
                                          onTap: () {
                                            if (_highlightedIndex
                                                    .contains(index) ==
                                                false) {
                                              _highlightedIndex.clear();
                                              _highlightRow(index);
                                            } else {
                                              print('Selected');
                                            }
                                          },
                                          child: Container(
                                              color: _highlightedIndex
                                                      .contains(index)
                                                  ? Color(0xfff4ccc9)
                                                  : index == _savedIndex
                                                      ? Color(0xffc3e9d5)
                                                      : Colors.transparent,
                                              child: _item(
                                                  context,
                                                  index,
                                                  savingProvider
                                                          .savingModelInstance[
                                                      index])),
                                        );
                                      },
                                    );
                              }
                            },
                          ),
                          Divider(
                            height: 0.0,
                            thickness: 0.8,
                            color: Colors.black,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Row(
                              children: [
                                Container(width: 30.0.w),
                                Container(
                                  // width: 50,
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'assets/images/Accounts/AcctSavings.png'),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0.w,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Total Savings Goal',
                                              // textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 13.h,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey[450]),
                                            ),
                                          ),
                                          Spacer(),
                                          FutureBuilder(
                                              future: savingProvider != null
                                                  ? savingProvider
                                                      .getSavingsToDate(
                                                          widget.uid)
                                                  : null,
                                              builder: (context, snapshot) {
                                                if (savingProvider.savToDat !=
                                                    null) {
                                                  return Container(
                                                    width: 70.0.w,
                                                    child: Text(
                                                      NumberFormat
                                                          .simpleCurrency(
                                                        locale: 'en-us',
                                                        decimalDigits: 0,
                                                      ).format(savingProvider
                                                          .savToDat),
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        fontSize: 13.0.h,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  );
                                                } else
                                                  switch (snapshot
                                                      .connectionState) {
                                                    case ConnectionState
                                                        .waiting:
                                                      return Container(
                                                        width: 60.0.w,
                                                        child: Text(
                                                          '--',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 20.0.h,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      );
                                                    default:
                                                      if (snapshot.hasError) {
                                                        print(
                                                            'Error: ${snapshot.error}');
                                                        return Container(
                                                          width: 60.0.w,
                                                          child: Text(
                                                            '--',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize: 20.0.h,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        );
                                                      } else
                                                        return Container(
                                                          width: 70.0.w,
                                                          child: Text(
                                                            NumberFormat
                                                                .simpleCurrency(
                                                              locale: 'en-us',
                                                              decimalDigits: 0,
                                                            ).format(
                                                                savingProvider
                                                                    .savToDat),
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                              fontSize: 13.0.h,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        );
                                                  }
                                              }),
                                          // SizedBox(
                                          //   width: 15.0,
                                          // ),
                                          // Spacer(),
                                          FutureBuilder(
                                              future:
                                                  savingProvider.savingsTot ==
                                                          null
                                                      ? savingProvider
                                                          .getSavingsTotal(
                                                              widget.uid)
                                                      : null,
                                              builder: (context, snapshot) {
                                                if (savingProvider.savingsTot !=
                                                    null) {
                                                  return Container(
                                                    width: 70.0.w,
                                                    child: Text(
                                                      NumberFormat
                                                          .simpleCurrency(
                                                        locale: 'en-us',
                                                        decimalDigits: 0,
                                                      ).format(savingProvider
                                                          .savingsTot),
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        fontSize: 13.0.h,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  );
                                                } else
                                                  switch (snapshot
                                                      .connectionState) {
                                                    case ConnectionState
                                                        .waiting:
                                                      return Container(
                                                        width: 60.0.w,
                                                        child: Text(
                                                          '--',
                                                          textAlign:
                                                              TextAlign.end,
                                                          style: TextStyle(
                                                            fontSize: 20.0.h,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      );
                                                    default:
                                                      if (snapshot.hasError) {
                                                        print(
                                                            'Error: ${snapshot.error}');
                                                        return Container(
                                                          width: 60.0.w,
                                                          child: Text(
                                                            '--',
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                              fontSize: 20.0.h,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        );
                                                      } else
                                                        return Container(
                                                          width: 60.0.w,
                                                          child: Text(
                                                            NumberFormat
                                                                .simpleCurrency(
                                                              locale: 'en-us',
                                                              decimalDigits: 0,
                                                            ).format(
                                                                savingProvider
                                                                    .savingsTot),
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                              fontSize: 13.0.h,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        );
                                                  }
                                              }),
                                        ],
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: LinearProgressIndicator(
                                          // semanticsLabel: 'Balling',
                                          backgroundColor: Colors.grey[350],
                                          minHeight: 7.0,
                                          color: Colors.green,
                                          value: convertToDecimal(
                                              (savingProvider.savToDat != null)
                                                  ? savingProvider.savToDat
                                                      .toString()
                                                  : '0',
                                              (savingProvider.savingsTot !=
                                                      null)
                                                  ? savingProvider.savingsTot
                                                      .toString()
                                                  : '0'),
                                          // valueColor: ,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15.0.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // ElevatedButton(
                              //   onPressed: () {
                              //     // if (_highlightedIndex.isNotEmpty) {
                              //     //   saveAmount(
                              //     //       context,
                              //     //       savingProvider.savingModelInstance[
                              //     //           _highlightedIndex[0]]);
                              //     // } else {
                              //     //   _selectGoalDialog(context);
                              //     // }
                              //     // Navigator.pop(context);
                              //     if (editedModel != null) {
                              //       _undoSave(editedModel);
                              //     } else {
                              //       print('empty model');
                              //     }
                              //   },
                              //   child: Image.asset(
                              //     "assets/images/buttons/undo-green.png",
                              //     height: 38,
                              //   ), if (_undoEdited == false) {
                              //   style: ElevatedButton.styleFrom(
                              //     shape: CircleBorder(),
                              //     primary: Colors.transparent,
                              //     // padding: EdgeInsets.all(10),
                              //   ),
                              // ),
                              GestureDetector(
                                onTap: () {
                                  // if (_undoEdited == false) {
                                  if (editedModel != null) {
                                    _undoSave(editedModel);
                                    // setState(() {
                                    //   _undoEdited = true;
                                    // });
                                  } else {
                                    print('empty model');
                                  }
                                  // } else {
                                  //   showDialog(
                                  //     context: context,
                                  //     builder: (BuildContext context) {
                                  //       return PosAlert();
                                  //     },
                                  //   );
                                  // }
                                },
                                child: Image.asset(
                                  "assets/images/buttons/undo-green.png",
                                  height: 38.h,
                                ),
                              ),
                              SizedBox(width: 10.0.w),
                              GestureDetector(
                                onTap: () {
                                  // if (_editedGoal == false) {
                                  if (_highlightedIndex.isNotEmpty) {
                                    saveAmount(
                                        context,
                                        savingProvider.savingModelInstance[
                                            _highlightedIndex[0]]);
                                    // setState(() {
                                    //   _editedGoal = true;
                                    // });
                                  } else {
                                    _selectGoalDialog(context);
                                  }
                                  // } else {
                                  //   showDialog(
                                  //     context: context,
                                  //     builder: (BuildContext context) {
                                  //       return PosAlert();
                                  //     },
                                  //   );
                                  // }
                                },
                                child: Image.asset(
                                  "assets/images/buttons/add-green.png",
                                  height: 38.h,
                                ),
                              ),
                              // ElevatedButton(
                              //   onPressed: () {
                              // if (_highlightedIndex.isNotEmpty) {
                              //   saveAmount(
                              //       context,
                              //       savingProvider.savingModelInstance[
                              //           _highlightedIndex[0]]);
                              // } else {
                              //   _selectGoalDialog(context);
                              // }
                              //   },
                              //   style: ElevatedButton.styleFrom(
                              //     shape: CircleBorder(),
                              //     primary: Colors.blue,
                              //     // padding: EdgeInsets.all(10),
                              //   ),
                              //   child: Align(
                              //     alignment: Alignment.centerRight,
                              //     child: Text(
                              //       '+',
                              //       style: TextStyle(
                              //         fontSize: 37.5,
                              //         color: Colors.white,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0.h,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                Text(
                                  'Account Balances',
                                  // textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.h,
                                  ),
                                ),
                                IconButton(
                                  // padding: EdgeInsets.only(left: 0.0),
                                  icon: Icon(
                                    Icons.help,
                                    color: Colors.black,
                                    size: 19.h,
                                  ),
                                  onPressed: () {
                                    _showAlertDialog(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                          FutureBuilder(
                            future: _getBal, // async work
                            builder: (BuildContext context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return new Text('Loading....');
                                default:
                                  if (snapshot.hasError)
                                    return new Text('Error: ${snapshot.error}');
                                  else {
                                    return Column(
                                      children: <Widget>[
                                        Divider(
                                          color: Colors.black,
                                          thickness: 0.4,
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Row(
                                            children: [
                                              Container(width: 11.5.w),
                                              SizedBox(
                                                width: 15.0.w,
                                              ),
                                              // Spacer(),
                                              Container(
                                                // width: 50,
                                                child: CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      'assets/images/Accounts/AcctChecking.png'),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.0.w,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                            'Checking Account',
                                                            // textAlign: TextAlign.left,
                                                            style: TextStyle(
                                                                fontSize: 13.h,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .grey[450]),
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        // Container(
                                                        //   width: 50,
                                                        //   child: Text(
                                                        //     '\$0',
                                                        //     style: TextStyle(
                                                        //       color:
                                                        //           Colors.black,
                                                        //       fontWeight:
                                                        //           FontWeight
                                                        //               .bold,
                                                        //     ),
                                                        //   ),
                                                        // ),
                                                        // SizedBox(
                                                        //   width: 15.0,
                                                        // ),
                                                        Container(
                                                          width: 80.w,
                                                          child: Text(
                                                            NumberFormat.simpleCurrency(
                                                                    locale:
                                                                        "en-us",
                                                                    decimalDigits:
                                                                        0)
                                                                .format(int.parse(
                                                                    _checking
                                                                        .toString())),
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child:
                                                          LinearProgressIndicator(
                                                        // semanticsLabel: 'Balling',
                                                        backgroundColor:
                                                            Colors.grey[350],
                                                        minHeight: 7.0,
                                                        color: Colors.green,
                                                        value: 0.8,
                                                        // valueColor: ,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.black,
                                          thickness: 0.4,
                                        ),
                                        Row(
                                          children: [
                                            // Text('5.'),
                                            Container(width: 11.5.w),
                                            SizedBox(
                                              width: 15.0.w,
                                            ),
                                            // Spacer(),
                                            Container(
                                              // width: 50,
                                              child: CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    'assets/images/Accounts/AcctReward.png'),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.0.w,
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          'Reward Points',
                                                          // textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                              fontSize: 13.h,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Colors
                                                                  .grey[450]),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Container(
                                                        width: 70.w,
                                                        child: Text(
                                                          NumberFormat().format(
                                                              int.parse(
                                                                  _rewardPoints
                                                                      .toString())),
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child:
                                                        LinearProgressIndicator(
                                                      // semanticsLabel: 'Balling',
                                                      backgroundColor:
                                                          Colors.grey[350],
                                                      minHeight: 7.0,
                                                      color: Colors.blue,
                                                      value: 0.1,
                                                      // valueColor: ,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  }
                              }
                            },
                          ),
                          Divider(
                            thickness: 0.4,
                            color: Colors.black,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 25.0.h,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Draggable<int>(
                      axis: Axis.horizontal,
                      data: 20,
                      child: Image.asset(
                        "assets/images/Shopping-Bag.png",
                        height: 60.h,
                        // color: Color(0xffef4136),
                      ),
                      feedback: Image.asset(
                        "assets/images/Shopping-Bag.png",
                        height: 35.h,
                        // color: Color(0xffef4136),
                      ),
                      childWhenDragging: Image.asset(
                        "assets/images/Shopping-Bag.png",
                        height: 54.h,
                        color: Colors.grey[500],
                      ),
                      // onDraggableCanceled: ,
                    ),
                    SizedBox(
                      width: 25.0.w,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 50.h,
                          child: Icon(
                            Icons.arrow_right_alt_outlined,
                            size: 80.h,
                            color: Colors.grey[400],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.zero,
                          width: 100.w,
                          child: Text(
                            'Slide to save',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 25.0.w,
                    ),
                    DragTarget<dynamic>(
                      builder: (
                        BuildContext context,
                        List<dynamic> accepted,
                        List<dynamic> rejected,
                      ) {
                        return AnimatedBuilder(
                          animation: _controller,
                          builder: (BuildContext context, _) {
                            return Container(
                              color: Color(0xffecb948),
                              child: Image.asset(
                                'assets/images/VirtualCloset.png',
                                width: 55.w,
                                height: 70.h,
                                fit: BoxFit.fill,
                              ),
                            );
                          },
                        );
                      },
                      onAccept: (data) {
                        isFav ? _controller.reverse() : _controller.forward();
                        if (_savedIndex != null) {
                          /// TODO: add the virtual closet feature here.
                          // ProductModel _ff;
                          // await productSummary.then((value) => _ff = value);
                          // print('${FirebaseAuth.instance.currentUser.uid}');
                          // FirebaseFirestore.instance.collection('virtualCloset').add({
                          //   'uid': FirebaseAuth.instance.currentUser.uid,
                          //   'pName':_productTitle,
                          //   'pPrice':_productPrice,
                          //   'pImage':_ff.image.imageUrl,
                          //   'pId': _ff.itemId,
                          //   'pUrl': _url,
                          //   'status':true,
                          //   'platform':'eBay',
                          //   'doc':DateTime.now(),
                          // });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CongratsSaving(
                                        incomingModel: updatedModel,
                                        modelId: _modelId,
                                        uid: widget.uid,
                                        savedAmount: savedAmount,
                                      )));
                          // showOverdraftNotice(
                          //     context, double.parse(_checking.toString()));
                        } else {
                          Validator.onErrorDialog(
                              "Please apply your savings to a goal.", context);
                        }
                      },
                    ),
                    IconButton(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.all(0.0),
                      icon: Icon(
                        Icons.help,
                        color: Colors.black,
                        size: 19.h,
                      ),
                      onPressed: () {
                        // _showAbDialog();
                        showSlideDialog(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'ACCOUNT BALANCES',
                // textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 17.0.h,
                ),
              ),
            ),
            SizedBox(
              height: 15.0.h,
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  height: 1.3,
                  fontSize: 17.0.h,
                ),
                children: [
                  TextSpan(
                    text: 'Checking Account. ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17.0.h,
                    ),
                  ),
                  TextSpan(
                    text:
                        "When you save, you transfer money from your checking account, where you're likely to spend it on just another good time, to your savings account, where it can grow.",
                    style: TextStyle(
                      fontSize: 17.0.h,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 35.h,
                  width: 35.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/Accounts/AcctChecking.png')),
                  ),
                ),
                SizedBox(
                  width: 7.0.w,
                ),
                Icon(
                  Icons.trending_flat,
                  size: 50.h,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 7.0,
                ),
                Container(
                  height: 35.h,
                  width: 35.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/Accounts/AcctSavings.png')),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0.h,
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  height: 1.3,
                  fontSize: 17.h,
                ),
                children: [
                  TextSpan(
                    text: 'Reward Points. ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17.0.h,
                    ),
                  ),
                  TextSpan(
                    text:
                        "Every time you save, you earn one reward point for every dollar that you save.",
                    style: TextStyle(
                      fontSize: 17.h,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Container(
                //   height: 35,
                //   width: 35,
                //   decoration: BoxDecoration(
                //     image: DecorationImage(
                //         image: AssetImage(
                //             'assets/images/Accounts/AcctSavings.png')),
                //   ),
                // ),
                // SizedBox(
                //   width: 5.0,
                // ),
                Text(
                  '\$1.00',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 10.0.w,
                ),
                Text(
                  '=',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 10.0.w,
                ),
                Text(
                  '1',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 5.0.w,
                ),
                Container(
                  height: 35.h,
                  width: 35.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/Accounts/AcctReward.png')),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0.h,
            ),
            Text(
              "So your checking account balance goes down while your reward point balance goes up.",
              style: TextStyle(
                fontSize: 17.h,
              ),
            ),
            SizedBox(
              height: 20.0.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Row(
                //   children: [
                //     Container(
                //       height: 35,
                //       width: 35,
                //       decoration: BoxDecoration(
                //         image: DecorationImage(
                //             image: AssetImage(
                //                 'assets/images/Accounts/AcctSavings.png')),
                //       ),
                //     ),
                //     FaIcon(
                //       FontAwesomeIcons.longArrowAltUp,
                //       size: 35,
                //       color: Colors.black,
                //     ),
                //   ],
                // ),
                // SizedBox(
                //   width: 10.0,
                // ),
                Row(
                  children: [
                    Container(
                      height: 35.h,
                      width: 35.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/Accounts/AcctChecking.png')),
                      ),
                    ),
                    FaIcon(
                      FontAwesomeIcons.longArrowAltDown,
                      size: 35.h,
                      color: Colors.black,
                    ),
                  ],
                ),
                SizedBox(
                  width: 30.0.w,
                ),
                Row(
                  children: [
                    Container(
                      height: 35.h,
                      width: 35.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/Accounts/AcctReward.png')),
                      ),
                    ),
                    FaIcon(
                      FontAwesomeIcons.longArrowAltUp,
                      size: 35.h,
                      color: Colors.black,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.0.h),
            Text(
              "When your checking account balance gets too low, you won't have enough money to save.",
              style: TextStyle(
                fontSize: 17.h,
              ),
            ),
            SizedBox(
              height: 22.0.h,
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  height: 1.3,
                  fontSize: 17.h,
                ),
                children: [
                  TextSpan(
                    text: 'Example: ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17.0.h,
                    ),
                  ),
                  TextSpan(
                    text:
                        "Let's say you want to save \$50 by transferring funds from your checking to your savings account, but you only have \$20 left in checking. Before you can save, you'll need to add at least \$30 to your checking account.",
                    style: TextStyle(
                      fontSize: 17.h,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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

  showOverdraftNotice(BuildContext context, amount) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      elevation: 24.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      contentPadding: EdgeInsets.only(bottom: 13.0),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 16.h,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 4.0),
            child: RichText(
              // overflow: TextOverflow.visible,
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  height: 1.2,
                  fontSize: 17.h,
                ),
                children: [
                  TextSpan(
                    text: 'WARNING. ',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17.0.h,
                      color: Color(0xffcb0909),
                    ),
                  ),
                  // You want to save $4,000, but you only have $900 left in your checking account.  You must add money to your checking account before you can save.
                  TextSpan(
                    text: 'You want to save ',
                    style: TextStyle(
                        // fontSize: 18,
                        ),
                  ),
                  // (_overdraftAmount <= 0) ?
                  TextSpan(
                    text: '\$' + res.toStringAsFixed(2),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' but you only have ',
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextSpan(
                    text: '\$' + amount.toStringAsFixed(2),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' left in your checking account. You must add money to your checking account before you can save.',
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        ),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: 0.0,
                        minHeight: 0.0,
                      ),
                      splashRadius: 18.0,
                      icon: Icon(
                        Icons.help,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          // IconButton(
          //   padding: EdgeInsets.zero,
          //   icon: Icon(
          //     Icons.help,
          //     color: Colors.black,
          //   ),
          //   onPressed: () {},
          // ),
          Image.asset(
            'assets/images/Emptypockets2.png',
            height: 450.0.h,
            // width: 500.0,
            fit: BoxFit.cover,
            // alignment: Alignment(-0.5, 0.0),
          ),
        ],
      ),
      actions: [
        Center(
          child: ElevatedButton(
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.resolveWith(
                  (states) => Size(230.w, 45.h)),
              backgroundColor: MaterialStateProperty.resolveWith(
                (states) => Color(0xff0070c0),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              overlayColor: MaterialStateProperty.resolveWith(
                (states) {
                  return states.contains(MaterialState.pressed)
                      ? Colors.blue
                      : null;
                },
              ),
            ),
            onPressed: () => Timer(
              const Duration(milliseconds: 400),
              () {
                Navigator.pop(context);
              },
            ),
            child: Text(
              'Return',
              style: TextStyle(
                fontSize: 20.0.h,
                color: Colors.white,
              ),
            ),
            // color: Colors.transparent,
          ),
        ),
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

  showSlideDialog(BuildContext context) {
    // set up the buttons
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "When you slide the shopping bag into the closet,",
              style: TextStyle(
                fontSize: 17.h,
              ),
            ),
            SizedBox(
              height: 16.0.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '•',
                  style: TextStyle(
                    fontSize: 20.0.h,
                    height: 1.2,
                  ),
                ),
                SizedBox(
                  width: 13.0.w,
                ),
                Flexible(
                  child: Text(
                    'You save money by transferring funds from your virtual checking account to your virtual savings account where it can accumulate and grow, and',
                    style: TextStyle(
                      fontSize: 16.0.h,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 7.0.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '•',
                  style: TextStyle(
                    fontSize: 20.0.h,
                    height: 1.2,
                  ),
                ),
                SizedBox(
                  width: 13.0.w,
                ),
                Flexible(
                  child: Text(
                    'You save your merchandise in a virtual closet for a cooling-off period of 5 days. If you still want it, you can complete your purchase after 5 days.',
                    style: TextStyle(
                      fontSize: 16.0.h,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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

  // val() async {
  //   var _totalVal = Provider.of<TotalValues>(context);

  //   int finalVal = await _totalVal.getSavingsTotal(widget.uid);
  //   return finalVal;
  // }
}
