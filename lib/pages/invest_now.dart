import 'dart:async';
// import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/models/account_model.dart';
//import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pay_or_save/models/investment_goal_model.dart';
import 'package:pay_or_save/pages/oldedits/congratulation_investment.dart';
// import 'package:pay_or_save/pages/congratulations_investment.dart';
// import 'package:pay_or_save/pages/oldedits/investnow.dart';
import 'package:pay_or_save/pages/overdraft.dart';
import 'package:pay_or_save/providers/total_provider.dart';
import 'package:pay_or_save/utilities/validator.dart';
import 'package:pay_or_save/widgets/alert_pos.dart';
import 'package:pay_or_save/widgets/invest_chart.dart';
// import 'package:pay_or_save/widgets/menu.dart';
import 'dart:math' as math;
// import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'congratulations_investment.dart';
import 'overdraft_notice.dart';

class InvestNow extends StatefulWidget {
  final String uid, selectedAccount, incomingOrder;
  final InvestmentModel accountModel;

  @override
  _InvestNowState createState() =>
      _InvestNowState(selectedAccount, accountModel);

  InvestNow(
      {Key key,
      this.selectedAccount,
      this.accountModel,
      this.incomingOrder,
      this.uid})
      : super(key: key);
}

class _InvestNowState extends State<InvestNow>
    with SingleTickerProviderStateMixin {
  String _uid, _total, _investPercents, selectedAccount, _time, _percents;
  int orderPercentage, stockPercentage, years;
  double _investment, res, _orderAmount, _willBeWorth;
  int _checking, _rewardPoints;
  double x = 0.0;
  double totalInvested = 0.0;
  List<AccountModel> _list;
  InvestmentModel accountModel;
  List<TimeSeriesSales> data = [];
  final firestoreInstance = FirebaseFirestore.instance;
  List<InvestmentModel> _listInvestment;
  Future<List<InvestmentModel>> _futureInvestments;
  List _investToDateList;
  List _investTotalList;
  int investTotal;
  int investToDate;
  List _highlightedIndex;
  bool _isSelected = false;
  dynamic _getInvBal;
  int _investValueItem;
  SharedPreferences _prefs;
  double _investOrderAmount;
  bool _editedGoal = false;
  bool _undoEdited = false;

  var itemsOrderPercentage = {
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
  var itemsOrderStockPercentage = {
    '5%': '5',
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
  var itemsYears = {
    '1 year': '1',
    '2 years': '2',
    '3 years': '3',
    '4 years': '4',
    '5 years': '5',
    '6 years': '6',
    '7 years': '7',
    '8 years': '8',
    '9 years': '9',
    '10 years': '10'
  };

  int percentage = 100;
  int iPercent = 10;
  int iYears = 10;
  Future<int> _invToDateTot;
  Future<int> _invTotalVal;
  String _incomingRoute = '/invest_now';
  String _modelId;
  InvestmentModel updatedModel;
  String currentInvestAmount;
  double totalInv;
  double _undoAmount;
  InvestmentModel _editedModel;
  bool _activeEdit = false;
  List investValues = [];
  int _savedIndex;
  bool goalSaved = false;

  int acceptDrag = 0;

  bool _isFav = false;
  AnimationController _controller;
  Animation<double> _shopIconSizeAnimation;
  Animation<double> _hangIconSizeAnimation;
  Animation _curve;

  _InvestNowState(this.selectedAccount, this.accountModel);

  @override
  void initState() {
    super.initState();
    // _getUidFromPref();
    _getInvBal = _getBalances();
    // _invToDateTot = Provider.of<TotalValues>(context, listen: false)
    //     .getInvestToDate(widget.uid);
    // _invTotalVal = Provider.of<TotalValues>(context, listen: false)
    //     .getInvestTotal(widget.uid);
    _highlightedIndex = [];
    _listInvestment = List<InvestmentModel>();
    _futureInvestments = getInvestmentItems();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

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
          _isFav = true;
        });
      }
      if (status == AnimationStatus.dismissed) {
        setState(() {
          _isFav = false;
        });
      }
    });

    _list = List<AccountModel>();
    _orderAmount = double.parse(widget.incomingOrder);
    _investOrderAmount = double.parse(widget.incomingOrder);
    orderPercentage = 100;
    stockPercentage = 6;
    _willBeWorth = 0;
    years = 20;
    res = double.parse(widget.incomingOrder);
    drawChart();
    _setInitial();
    // totalInv = double.parse(widget.incomingOrder);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  _getBalances() {
    return firestoreInstance
        .collection("users")
        .doc(widget.uid)
        .get()
        .then((value) {
      _checking = value.data()['checking'].toInt();
      _investment = value.data()['investment'].toDouble();
      _rewardPoints = value.data()['reward_points'].toInt();
    }).then((v) {
      _list.add(AccountModel(
          "https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2Fdollar-black.png?alt=media&token=ab728699-fa1a-44dd-9ef8-42a42a658a12",
          "Total investment",
          _investment.toStringAsFixed(2),
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

  Future<List<InvestmentModel>> getInvestmentItems() async {
    return firestoreInstance
        .collection("investmentGoals")
        .doc('users')
        .collection(widget.uid)
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

  _setInitial() {
    _highlightedIndex.add(0);
    setState(() {
      _isSelected = true;
    });
  }

  _highlightRow(dynamic index) {
    // _highlightedIndex = [];
    // if()
    _highlightedIndex.add(index);
    // print('OBS');
    // print(_highlightedIndex);
    setState(() {
      _isSelected = true;
      // rowColor = Colors.amber[300];
    });
  }

  _unSelect(dynamic index) async {
    _highlightedIndex.remove(index);
    // print('PUTTY');
    // print(_highlightedIndex);
    setState(() {
      _isSelected = false;
      // rowColor = Colors.transparent;
    });
  }

  Widget _item(BuildContext context, int index, InvestmentModel investModel) {
    return Column(
      children: [
        Divider(
          height: 0.0,
          thickness: 0.8,
          color: Colors.black,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: Text(
                  (index + 1).toString() + '.',
                  style: TextStyle(
                    fontSize: 13.0.h,
                  ),
                ),
              ),
              SizedBox(
                width: 15.0.w,
              ),
              // Spacer(),
              Container(
                // width: 50,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(investModel.url),
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
                            investModel.goal,
                            // textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 13.0.h,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[450]),
                          ),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 70.w,
                              child: Text(
                                NumberFormat.simpleCurrency(
                                  locale: "en-us",
                                  decimalDigits: 0,
                                ).format(int.parse(investModel.amount)),
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 13.0.h,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 3.0),
                              child: Container(
                                width: 70.w,
                                child: Text(
                                  NumberFormat.simpleCurrency(
                                          locale: "en-us", decimalDigits: 0)
                                      .format(
                                          int.parse(investModel.goalAmount)),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13.0.h,
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
                            (investModel != null) ? investModel.amount : '0',
                            (investModel != null)
                                ? investModel.goalAmount
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
      ],
    );
  }

  graphLogic() {
    if (years != 0 &&
        _orderAmount != 0 &&
        stockPercentage != 0 &&
        orderPercentage != 0) {
      // List<int> _yearsArray = [];
      // List<double> _profit = [];
      var finalOutput;
      var _myAmount;
      var _rate;
      var _duration;

      _myAmount = _orderAmount;
      _rate = (stockPercentage / 100);
      _duration = years;
      var _bracketVal = 1 + _rate;
      var _result = _myAmount * (math.pow(_bracketVal, _duration));
      finalOutput = _result;
      print(finalOutput);
    }
  }

  drawChart() {
    if (_orderAmount != 0 && stockPercentage != 0) {
      res = (_orderAmount / 100) * orderPercentage;
      List<int> yearsArr = [];
      List<double> profit = [];
      for (int i = 0; i <= years; i++) {
        yearsArr.add(i);
        if (i == 0) {
          var a = res;
          profit.add(double.parse(a.toStringAsFixed(2)));
        } else {
          var b = (res * math.pow((1 + (stockPercentage / 100)), i));
          profit.add(double.parse(b.toStringAsFixed(2)));
        }
      }
      data = [];
      int month = new DateTime.now().month;
      int day = new DateTime.now().day;
      _willBeWorth = profit.last;
      for (int i = 0; i < profit.length; i++) {
        data.add(
          new TimeSeriesSales(new DateTime(2022 + i, month, day), profit[i]),
        );
      }
      if (orderPercentage == 0 || years == 0) {
        setState(() {
          _willBeWorth = 0;
          res = 0;
        });
      }
    } else {
      setState(() {
        _willBeWorth = 0;
        res = 0;
      });
    }
  }

//   drawChart() {
//     if (years != 0 &&
//         _orderAmount != 0 &&
//         stockPercentage != 0 &&
//         orderPercentage != 0) {
//       res = (_orderAmount / 100) * orderPercentage;
//       List<int> yearsArr = [];
//       List<double> profit = [];
//       for (int i = 0; i <= years; i++) {
//         yearsArr.add(i);
//         if (i == 0) {
//           var a = (res * math.pow((1 + (stockPercentage / 100)), (years)));
//           profit.add(double.parse(a.toStringAsFixed(2)));
// //          console.log(i+" "+profit[i])
//         } else {
//           var b = (profit[i - 1] *
//               math.pow((1 + (stockPercentage / 100)), (years)));
//           profit.add(double.parse(b.toStringAsFixed(2)));
// //          console.log(i+" "+profit[i])
//         }
//       }
//       data = [];
//       int month = new DateTime.now().month;
//       int day = new DateTime.now().month;
//       _willBeWorth = profit.last;
//       for (int i = 0; i < profit.length; i++) {
//         data.add(
//           new TimeSeriesSales(new DateTime(2020 + i, month, day), profit[i]),
//         );
//       }
//     } else {
//       setState(() {
//         _willBeWorth = 0;
//         res = 0;
//       });
//     }
//   }

  _selectInvestGoalDialog(BuildContext context) {
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
              fontSize: 45.0.h,
              height: 1.2,
              color: Color(0xff0070c0),
            ),
          ),
          SizedBox(
            width: 5.0.w,
          ),
          Text(
            'Please select a goal.',
            style: TextStyle(
              fontSize: 19.0.h,
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

  ///highlighted index is checked twice
  investAmount(InvestmentModel _model) {
    if (years != 0 &&
        _orderAmount != 0 &&
        stockPercentage != 0 &&
        orderPercentage != 0) {
      if (_orderAmount >= 1 && _orderAmount >= (res / 2)) {
        if (goalSaved == false) {
          if (_checking < res) {
            // navigateToOverdraft(context);
            _showOverdraftNotice(context, double.parse(_checking.toString()));
          } else
          // if (res > num.parse(_model.goalAmount)) {
          //   Validator.onErrorDialog(
          //       "You cannot save more than your goal amount", context);
          // } else

          {
            x = double.parse(res.toString());
            _undoAmount = x;
            var c = _checking - x;
            var s = _investment + x;
            var r = _rewardPoints + x;
            var calcChecking = num.parse(c.toStringAsFixed(2));
            var calcInvest = num.parse(s.toStringAsFixed(2));
            var calcReward = num.parse(r.toStringAsFixed(2));
            firestoreInstance.collection("users").doc(widget.uid).update({
              "checking": calcChecking,
              "investment": calcInvest,
              "reward_points": calcReward
            }).then((_) {
              _investValueItem = _highlightedIndex[0];
              totalInvested = totalInvested + x;
              var a = int.parse(_model.amount) + x.round();
              // a = a.toInt();
              firestoreInstance
                  .collection("investmentGoals")
                  .doc("users")
                  .collection(widget.uid)
                  .doc((_model.goalId).trim())
                  .update({
                "investAmount": a.toString(),
              });
            }).then((_) {
              _editedModel = _model;
              var goalAmount = int.parse(_model.amount) + x.round();
              // goalAmount = goalAmount + x;
              setState(() {
                // _orderAmount = _orderAmount - x;
                _model.amount = goalAmount.toString();
                // _invToDateTot
                _modelId = _model.goalId;
                updatedModel = _model;
                currentInvestAmount = x.toString();
                Provider.of<TotalValues>(context, listen: false)
                    .getInvestToDate(widget.uid);
                Provider.of<TotalValues>(context, listen: false)
                    .getInvestTotal(widget.uid);
                _savedIndex = _highlightedIndex[0];
                _highlightedIndex.clear();
                // _list[0].amount = (_investment + x).toString();
                // _list[1].amount = (_checking - x).toString();
                // _list[2].amount = (_rewardPoints + x).toString();
                _investment = _investment + x;
                _checking = _checking - x.toInt();
                _rewardPoints = _rewardPoints + x.toInt();
                _activeEdit = true;
                x = (_orderAmount / 100) * orderPercentage;
                drawChart();
                if (_checking < 0) {
                  _showOverdraftNotice(
                      context, double.parse(_checking.toString()));
                }
                goalSaved = true;
              });
              // _orderAmount = double.parse(widget.incomingOrder);
              investValues.add(orderPercentage);
              investValues.add(stockPercentage);
              investValues.add(years);
              investValues.add(res);
              investValues.add(_willBeWorth);
              // orderPercentage = 0;
              // stockPercentage = 0;
              // _willBeWorth = 0;
              // years = 0;
              // res = 0;
              // setState(() {});
            });
          }
        } else {
          Validator.onErrorDialog(
              "You cannot save your goal multiple times", context);
        }
      } else {
        Validator.onErrorDialog(
            "You cannot save your order amount more than once", context);
      }
    } else {
      // print('startinggg');
      // print(years);
      // print(stockPercentage);
      // print(orderPercentage);
      // print(_orderAmount);
      Validator.onErrorDialog("Please complete details", context);
    }
  }

  _undoInvest(InvestmentModel _model) {
    if (_activeEdit == true) {
      var _c = _checking + _undoAmount;
      var _s = _investment - _undoAmount;
      var _r = _rewardPoints - _undoAmount;
      var calChcking = num.parse(_c.toStringAsFixed(2));
      var calInvst = num.parse(_s.toStringAsFixed(2));
      var calRwrd = num.parse(_r.toStringAsFixed(2));
      firestoreInstance.collection("users").doc(widget.uid).update({
        "checking": calChcking,
        "investment": calInvst,
        "reward_points": calRwrd
      }).then((_) {
        // _investValueItem = _highlightedIndex[0];
        totalInvested = totalInvested - _undoAmount;
        var _amount = int.parse(_model.amount) - _undoAmount.round();
        // a = a.toInt();
        firestoreInstance
            .collection("investmentGoals")
            .doc("users")
            .collection(widget.uid)
            .doc((_model.goalId).trim())
            .update({
          "investAmount": _amount.toString(),
        });
      }).then((value) {
        var _goalAmount = int.parse(_model.amount) - _undoAmount.round();
        // goalAmount = goalAmount + x;
        setState(() {
          // _orderAmount = _orderAmount + _undoAmount;
          _model.amount = _goalAmount.toString();
          // _invToDateTot
          _modelId = '';
          // updatedModel = _model;
          currentInvestAmount = '0';
          Provider.of<TotalValues>(context, listen: false)
              .getInvestToDate(widget.uid);
          Provider.of<TotalValues>(context, listen: false)
              .getInvestTotal(widget.uid);
          _highlightedIndex.clear();
          _savedIndex = null;
          // _list[0].amount = (_investment - _undoAmount).toString();
          // _list[1].amount = (_checking + _undoAmount).toString();
          // _list[2].amount = (_rewardPoints - _undoAmount).toString();
          _investment = _investment - _undoAmount;
          _checking = _checking + _undoAmount.toInt();
          _rewardPoints = _rewardPoints - _undoAmount.toInt();
          _activeEdit = false;
          // x = (_orderAmount / 100) * orderPercentage;
          // drawChart();
          // if (_checking < 0) {
          //   navigateToOverdraft(context);
          // }
          goalSaved = false;
        });
        // _orderAmount = double.parse(widget.incomingOrder);
        orderPercentage = investValues[0];
        stockPercentage = investValues[1];
        years = investValues[2];
        res = investValues[3];
        _willBeWorth = investValues[4];
      });
    } else {
      print('no active edit');
    }
  }

  double convertToDecimal(amount, goal) {
    ///parse here should return null, incase of runtime error
    if (double.tryParse(goal) == double.parse(amount)) {
      return 1;
    } else {
      if (amount == "10") {
        return 0.01;
      }

      ///parse here should return null, incase of runtime error
      var res = (double.tryParse(amount).floor() / double.parse(goal).floor());

//      var s = res.floor();
//      var a = "0."+s.toString();
//      return double.parse(a);
      return res;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff0070c0),
        title: Text(
          'Invest Now',
          style: TextStyle(
            fontSize: 27.h,
            fontWeight: FontWeight.w700,
          ),
        ),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: () => Navigator.pop(context),
        //   // onPressed: () {
        //   //   navigateToOverdraft(context);
        //   //   // Navigator.push(
        //   //   //     context,
        //   //   //     MaterialPageRoute(
        //   //   //         builder: (context) => MyOverdraft(
        //   //   //             // uid: widget.uid,
        //   //   //             )));
        //   // },
        // ),
        centerTitle: true,
        elevation: 0.0,
      ),
      endDrawer: MainDrawer(uid: widget.uid, incomingRoute: _incomingRoute),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 10.0),
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
                        .format(_investOrderAmount),
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16.h,
                      fontWeight: FontWeight.w600,
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
                            'How much of your order amount would you like to invest?.',
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
                        width: 4.0.w,
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
                            // showValueIndicator: ShowValueIndicator.always,
                          ),
                          child: Expanded(
                            child: Slider(
                              value:
                                  (double.parse(_percents ?? (100).toString())),
                              // value: 0.0,
                              onChanged: (val) {
                                setState(() {
                                  _percents = val.toString();
                                  orderPercentage = (val).toInt();
                                  graphLogic();
                                  drawChart();
                                });
                              },
                              min: 0,
                              max: 200,
                              divisions: 20,
                              label: _percents == null
                                  ? "100%"
                                  : double.parse(_percents).toStringAsFixed(0) +
                                      "%",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 4.0.w,
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
                      'Total Investments',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15.h),
                    ),
                    Spacer(),
                    // (res == 0.0)
                    //     ? Text(
                    //         NumberFormat.simpleCurrency(
                    //                 locale: "en-us", decimalDigits: 2)
                    //             .format(_orderAmount),
                    //         style: TextStyle(
                    //           // color: Colors.blue,
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 15,
                    //         ),
                    //       )
                    //     :
                    Text(
                      NumberFormat.simpleCurrency(
                              locale: "en-us", decimalDigits: 2)
                          .format(res),
                      style: TextStyle(
                        // color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.h,
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                thickness: 0.8,
                color: Colors.black,
              ),
              Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    // widthFactor: 10.0,
                    child: Row(
                      children: [
                        Text(
                          'When invested at',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15.h),
                        ),
                        IconButton(
                          // alignment: Alignment.topCenter,
                          padding: EdgeInsets.all(0.0),
                          icon: Icon(
                            Icons.help,
                            color: Colors.black,
                            size: 19.h,
                          ),
                          onPressed: () {
                            // _showAbDialog();
                            showInvestAtDialog(context);
                          },
                        ),
                      ],
                    ),
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
                      Container(
                        // width: MediaQuery.of(context).size.width - 100,
                        child: Expanded(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Colors.blue,
                              inactiveTrackColor: Colors.blue[100],
                              trackShape: RoundedRectSliderTrackShape(),
                              trackHeight: 7.0,
                              thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 12.0),
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
                            child: Slider(
                              value: (double.parse(
                                  _investPercents ?? (6).toString())),
                              // value: 0.0,
                              ///review if it breaks.
                              onChanged: (val) {
                                setState(() {
                                  _investPercents = (val.toInt()).toString();
                                  stockPercentage = (val).toInt();
                                  graphLogic();
                                  drawChart();
                                });
                              },
                              min: 0,
                              max: 12,
                              divisions: 12,
                              // inactiveColor: Colors.grey[400],
                              label: _investPercents == null
                                  ? '6%'
                                  : _investPercents + "%",
                            ),
                          ),
                        ),
                      ),
                      Text(
                        '12%',
                        style: TextStyle(
                          fontSize: 16.h,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
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
              Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    // widthFactor: 10.0,
                    child: Text(
                      'For',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15.h),
                    ),
                  ),
                  SizedBox(
                    height: 4.0.h,
                  ),
                  Row(
                    children: [
                      Text(
                        '0',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.h,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 4.0.w,
                      ),
                      Container(
                        // width: MediaQuery.of(context).size.width - 100,
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
                              value: (double.parse(_time ?? (20).toString())),
                              // value: 0.0,
                              onChanged: (val) {
                                setState(() {
                                  _time = (val.toInt()).toString();
                                  years = (val).toInt();
                                  graphLogic();
                                  drawChart();
                                });
                              },
                              min: 0,
                              max: 40,
                              divisions: 40,
                              label: _time ?? '20',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 4.0.w,
                      ),
                      Text(
                        '40yrs',
                        style: TextStyle(
                          fontSize: 16.h,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
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
              Row(
                children: [
                  Text(
                    'Which will be worth',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Spacer(),
                  Text(
                    NumberFormat.simpleCurrency(
                            locale: "en-us", decimalDigits: 0)
                        .format(_willBeWorth),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      // color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.h,
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 0.8,
                color: Colors.black,
              ),
              // Padding(
              //   padding: EdgeInsets.only(left: 0.0, right: 0.0),
              //   child: ButtonTheme(
              //     minWidth: 150,
              //     height: 50.0,
              //     child: RaisedButton(
              //       textColor: Colors.white,
              //       color: Colors.green,
              //       child: Text("Invest"),
              //       onPressed: () {
              //         investAmount();
              //         // drawChart(10, 20, 30, 20);
              //       },
              //       shape: new RoundedRectangleBorder(
              //         borderRadius: new BorderRadius.circular(10.0),
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 17.0.h,
              ),
              (data.isNotEmpty)
                  ? Container(
                      height: 200.h,
                      child: SimpleTimeSeriesChart.withSampleData(data))
                  : Container(),
              SizedBox(
                height: 20.0.h,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Investment Goals',
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
                          "These are your investment goals. Tap on the goal that you'd like to apply your savings to. ",
                    ),
                    TextSpan(text: "Use  "),
                    WidgetSpan(
                      child: Image.asset(
                        "assets/images/buttons/add-blue.png",
                        height: 18.h,
                      ),
                    ),
                    TextSpan(text: "  to save. Use  "),
                    WidgetSpan(
                      child: Image.asset(
                        "assets/images/buttons/undo-blue.png",
                        height: 18.h,
                      ),
                    ),
                    // TextSpan(
                    //   text: " < ",
                    //   style: TextStyle(
                    //     color: Colors.blue,
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 23,
                    //   ),
                    // ),
                    TextSpan(
                      text: "  to undo.",
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 18.0.h,
              ),
              Consumer<TotalValues>(
                builder: (context, valuesProvider, child) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          children: [
                            Spacer(),
                            Container(
                              width: 50.w,
                              child: Text(
                                'Invest To Date',
                                // textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15.0.w,
                            ),
                            Container(
                              width: 50.w,
                              child: Text(
                                'Invest Goal',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      FutureBuilder(
                        future: valuesProvider
                            .getInvestmentProvider(widget.uid), // async work
                        builder: (BuildContext context, snapshot) {
                          if (valuesProvider.investModelInstance != null) {
                            return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: (valuesProvider.investModelInstance !=
                                      null)
                                  ? valuesProvider.investModelInstance.length
                                  : 0,
                              itemBuilder: (BuildContext context, int index) {
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
                                  child: Container(
                                      color: _highlightedIndex.contains(index)
                                          ? Color(0xfff4ccc9)
                                          : index == _savedIndex
                                              ? Color(0xffc3e9d5)
                                              : Colors.transparent,
                                      child: _item(
                                          context,
                                          index,
                                          valuesProvider
                                              .investModelInstance[index])),
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
                                              valuesProvider
                                                  .investModelInstance[index])),
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
                            // Container(width: 14.5),
                            SizedBox(
                              width: 30.0.w,
                            ),
                            // Spacer(),
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
                                          'Total Invest Goal',
                                          // textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 13.h,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[450]),
                                        ),
                                      ),
                                      Spacer(),
                                      FutureBuilder(
                                          future: valuesProvider
                                                      .investToDateVal ==
                                                  null
                                              ? valuesProvider
                                                  .getInvestToDate(widget.uid)
                                              : null,
                                          builder: (context, snapshot) {
                                            if (valuesProvider
                                                    .investToDateVal !=
                                                null) {
                                              return Container(
                                                width: 70.0.w,
                                                child: Text(
                                                  NumberFormat.simpleCurrency(
                                                    locale: 'en-us',
                                                    decimalDigits: 0,
                                                  ).format(valuesProvider
                                                      .investToDateVal),
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                    fontSize: 13.0.h,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              );
                                            } else
                                              switch (
                                                  snapshot.connectionState) {
                                                case ConnectionState.waiting:
                                                  return Container(
                                                    width: 50.0.w,
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
                                                      width: 50.0.w,
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
                                                  } else
                                                    return Container(
                                                      width: 70.0.w,
                                                      child: Text(
                                                        NumberFormat
                                                            .simpleCurrency(
                                                          locale: 'en-us',
                                                          decimalDigits: 0,
                                                        ).format(valuesProvider
                                                            .investToDateVal),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 13.0.h,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    );
                                              }
                                          }),
                                      // SizedBox(
                                      //   width: 15.0,
                                      // ),
                                      FutureBuilder(
                                          future: valuesProvider.invTot == null
                                              ? valuesProvider
                                                  .getInvestTotal(widget.uid)
                                              : null,
                                          builder: (context, snapshot) {
                                            if (valuesProvider.invTot != null) {
                                              return Container(
                                                width: 70.0.w,
                                                child: Text(
                                                  NumberFormat.simpleCurrency(
                                                    locale: 'en-us',
                                                    decimalDigits: 0,
                                                  ).format(
                                                      valuesProvider.invTot),
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                    fontSize: 13.0.h,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              );
                                            } else
                                              switch (
                                                  snapshot.connectionState) {
                                                case ConnectionState.waiting:
                                                  return Container(
                                                    width: 50.0.w,
                                                    child: Text(
                                                      '--',
                                                      textAlign: TextAlign.end,
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
                                                      width: 50.0.w,
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
                                                  } else
                                                    return Container(
                                                      width: 70.0.w,
                                                      child: Text(
                                                        NumberFormat
                                                            .simpleCurrency(
                                                          locale: 'en-us',
                                                          decimalDigits: 0,
                                                        ).format(valuesProvider
                                                            .invTot),
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                          fontSize: 13.0.h,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    );
                                              }
                                          }),
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
                                          (valuesProvider.investToDateVal !=
                                                  null)
                                              ? valuesProvider.investToDateVal
                                                  .toString()
                                              : '0',
                                          (valuesProvider.invTot != null)
                                              ? valuesProvider.invTot.toString()
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
                          //     if (_editedModel != null) {
                          //       _undoInvest(_editedModel);
                          //     }
                          //   },
                          //   child: Text(
                          //     '<',
                          //     style: TextStyle(
                          //       fontSize: 37.5,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          //   style: ElevatedButton.styleFrom(
                          //     shape: CircleBorder(),
                          //     primary: Colors.blue,
                          //     // padding: EdgeInsets.all(10),
                          //   ),
                          // ),
                          GestureDetector(
                            onTap: () {
                              // if (_undoEdited == false) {
                              if (_editedModel != null) {
                                _undoInvest(_editedModel);
                                // setState(() {
                                //   _undoEdited = true;
                                // });
                              }
                              // } else
                              //   showDialog(
                              //     context: context,
                              //     builder: (BuildContext context) {
                              //       return PosAlert();
                              //     },
                              //   );
                            },
                            child: Image.asset(
                              "assets/images/buttons/undo-blue.png",
                              height: 38.h,
                            ),
                          ),
                          // ElevatedButton(
                          //   onPressed: () {
                          //     if (_highlightedIndex.isNotEmpty) {
                          //       investAmount(valuesProvider
                          //           .investModelInstance[_highlightedIndex[0]]);
                          //     } else {
                          //       _selectInvestGoalDialog(context);
                          //     }
                          //   },
                          //   child: Text(
                          //     '+',
                          //     style: TextStyle(
                          //       fontSize: 37.5,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          //   style: ElevatedButton.styleFrom(
                          //     shape: CircleBorder(),
                          //     primary: Colors.blue,
                          //     // padding: EdgeInsets.all(10),
                          //   ),
                          // ),
                          SizedBox(width: 10.w),
                          GestureDetector(
                            onTap: () {
                              // if (_editedGoal == false) {
                              if (_highlightedIndex.isNotEmpty) {
                                investAmount(valuesProvider
                                    .investModelInstance[_highlightedIndex[0]]);
                                // setState(() {
                                //   _editedGoal = true;
                                // });
                              } else {
                                _selectInvestGoalDialog(context);
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
                              "assets/images/buttons/add-blue.png",
                              height: 38.h,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 9.0.h,
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
                      // Divider(
                      //   thickness: 0.8,
                      //   color: Colors.black,
                      // ),
                      FutureBuilder(
                        future: _getInvBal, // async work
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
                                          // Container(width: 11.5),
                                          SizedBox(
                                            width: 26.5.w,
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
                                                                FontWeight.w600,
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
                                                    //       color: Colors.black,
                                                    //       fontWeight:
                                                    //           FontWeight.bold,
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    // SizedBox(
                                                    //   width: 15.0,
                                                    // ),
                                                    (_checking != null)
                                                        ? Container(
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
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontSize:
                                                                    13.0.h,
                                                              ),
                                                            ),
                                                          )
                                                        : Container(
                                                            width: 50.0.w,
                                                            child: Text(
                                                              '--',
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                fontSize:
                                                                    20.0.h,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
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
                                        // Container(width: 11.5),
                                        SizedBox(
                                          width: 26.5.w,
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
                                                              FontWeight.w600,
                                                          color:
                                                              Colors.grey[450]),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  (_rewardPoints != null)
                                                      ? Container(
                                                          width: 70.w,
                                                          child: Text(
                                                            NumberFormat()
                                                                .format(
                                                              int.parse(
                                                                  _rewardPoints
                                                                      .toString()),
                                                            ),
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13.0.h,
                                                            ),
                                                          ),
                                                        )
                                                      : Container(
                                                          width: 60.0.w,
                                                          child: Text(
                                                            '--',
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                              fontSize: 20.0.h,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                ],
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: LinearProgressIndicator(
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
                        thickness: 0.65,
                        color: Colors.black,
                      ),
                    ],
                  );
                },
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
                            // return Icon(
                            //   Icons.checkroom,
                            //   color: Colors.yellow[800],
                            //   size: _hangIconSizeAnimation.value,
                            // );
                          },
                        );
                      },
                      onAccept: (data) {
                        _isFav ? _controller.reverse() : _controller.forward();
                        if (_savedIndex != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CongratsInvestment(
                                        uid: widget.uid,
                                        incomingModel: updatedModel,
                                        modelId: _modelId,
                                        investAmount: currentInvestAmount,
                                      )));
                        } else {
                          Validator.onErrorDialog(
                              "Please save a goal.", context);
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

  showInvestAtDialog(BuildContext context) {
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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'INVESTMENT RATE OF RETURN',
              // textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 17.0.h,
              ),
            ),
          ),
          SizedBox(
            height: 25.0.h,
          ),
          Text(
              "The S&P 500 is widely regarded as the market. The average annualized return since it's inception in 1926 is 7%, when adjusted for inflation."),
          SizedBox(height: 20.0.h),
          Text(
              "While it's unlikely that you'll earn 12% on your real-life investments, you can in SaveUp Game. As the graph demonstrates, term and rate have a huge impact on the future value of today's investment. Due to the power of compound interest, your investments grow exponentially the longer they sit.")
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
              height: 15.0,
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  height: 1.2,
                  fontSize: 18.h,
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
                        "When you invest, you transfer money from your checking account, where you're likely to spend it on just another good time, to your investment account, where it can accumulate and grow.",
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
                  width: 7.0.w,
                ),
                Container(
                  height: 35.h,
                  width: 35.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/Accounts/AcctInvestment.png')),
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
                  height: 1.2,
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
                        "You earn one reward point for every dollar that you invest.",
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
                //             'assets/images/Accounts/AcctInvestment.png')),
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
                  width: 5.0,
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
              "Every time you invest, your checking account balance goes down while your reward point balance goes up.",
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
            SizedBox(
              height: 20.0.h,
            ),
            Text(
              "When your checking account balance gets too low, you won't have enough money to invest.",
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
                        "Let's say you want to invest \$200 by transferring funds from your checking to your investment account, but you only have \$100 left in checking. Before you can invest, you'll need to add at least \$100 to your checking account.",
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

  _showOverdraftNotice(BuildContext context, amount) {
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
            padding: EdgeInsets.fromLTRB(24.0.w, 20.0.h, 24.0.w, 4.0),
            child: RichText(
              // overflow: TextOverflow.visible,
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  height: 1.2,
                  fontSize: 18.h,
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
                  TextSpan(
                    text: 'Your virtual checking account has a balance of ',
                    style: TextStyle(
                      fontSize: 18.h,
                    ),
                  ),
                  // (_overdraftAmount <= 0) ?
                  TextSpan(
                    text: '\$' + amount.toStringAsFixed(2),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' Please add money to your account to complete your transaction.',
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
            'assets/images/EmptyPockets2.png',
            height: 450.0.h,
            // width: 500.0,
            fit: BoxFit.cover,
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
                    'You save money by transferring funds from your virtual checking account to your virtual investment account where it can accumulate and grow, and',
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
                  width: 13.0.h,
                ),
                Flexible(
                  child: Text(
                    'You save your merchandise into a virtual closet for a cooling-off period of 5 days. If you still want it, you can complete your purchase after 5 days.',
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
}
