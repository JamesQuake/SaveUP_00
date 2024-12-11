import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
// import 'package:pay_or_save/models/account_model.dart';
import 'package:pay_or_save/models/investment_goal_model.dart';
import 'package:pay_or_save/models/saving_goal_model.dart';
import 'package:pay_or_save/pages/edit_investment_goal.dart';
import 'package:pay_or_save/pages/edit_saving_goal.dart';
// import 'package:pay_or_save/pages/home_video.dart';
import 'package:pay_or_save/pages/login.dart';
// import 'package:pay_or_save/pages/sign_in.dart';
import 'package:pay_or_save/providers/total_provider.dart';
// import 'package:pay_or_save/widgets/menu.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class DashBoard extends StatefulWidget {
  final String uid;
  final String incomingRoute;

  @override
  _DashBoardState createState() => _DashBoardState(uid);

  DashBoard({Key key, @required this.uid, this.incomingRoute})
      : super(key: key);
}

class _DashBoardState extends State<DashBoard> {
  String _uid, _checking, _savings, _investment, _rewardPoints;
  // List<AccountModel> _list;
  List<SavingModel> _listSavings;
  List<InvestmentModel> _listInvestment;
  final firestoreInstance = FirebaseFirestore.instance;
  // Future<List<SavingModel>> _futureSavings;
  // Future<List<InvestmentModel>> _futureInvestments;
  String dashboardRoute = '/dashboard';

  _DashBoardState(this._uid);

  @override
  void initState() {
    super.initState();
    _getBalances();
    _listInvestment = List<InvestmentModel>();
    _listSavings = List<SavingModel>();
    // _futureSavings = getSavingsItems();
    // _futureInvestments = getInvestmentItems();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future navigateSignOut(context) async {
    // Navigator.pushReplacement(context,
    //     MaterialPageRoute(builder: (context) => SignInRegistrationPage()));

    // Navigator.of(context).push

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (_) => LoginPage(
                // uid: _uid,
                )),
        (route) => false);

    //     Navigator.of(context)
    // .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  Future navigateEditSavingGoal(
      context, SavingModel model, String route) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditSavingGoal(
                  uid: _uid,
                  savingModel: model,
                  route: dashboardRoute,
                )));
  }

  Future navigateEditInvestmentGoal(
      context, InvestmentModel model, String route) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditInvestmentGoal(
                  uid: _uid,
                  investmentModel: model,
                  route: dashboardRoute,
                )));
  }

  _signOutT() async {
    final googleAcc = GoogleSignIn(scopes: ["email"]);
    bool isGoogleActive = await googleAcc.isSignedIn();
    if (isGoogleActive == true) {
      print('Signing google out');
      await googleAcc.signOut();
      print('google signed out');
    }
    await FacebookAuth.instance.logOut();
    print('facebook signed out');
    await FirebaseAuth.instance.signOut().then((_) {
      navigateSignOut(context);
    });
  }

  _getBalances() {
    firestoreInstance.collection("users").doc(_uid).get().then((value) {
      _checking = value.data()['checking'].round().toString();
      _savings = value.data()['savings'].round().toString();
      _investment = value.data()['investment'].round().toString();
      _rewardPoints = value.data()['reward_points'].round().toString();
      if (mounted) setState(() {});
    });
  }

  double convertToDecimal(amount, goal) {
    ///parse here should return a null value (incase of runtime error)
    if ((double.tryParse(goal) == 0.0) && (double.tryParse(amount) == 0.0))
      return 0;
    if (double.tryParse(goal) == double.tryParse(amount)) {
      return 1;
    } else {
//      if(amount == "10"){
//        return 0.01;
//      }
      var view = double.parse(goal);
      // print('THISISIT');
      // print(view);
      var res =
          (double.tryParse(amount).floor() / double.tryParse(goal).floor());

      ///parse here should return a null value (incase of runtime error)
//      var s = res.floor();
//      var a = "0."+s.toString();
//      return double.parse(a);
      return res;
    }
  }

  Future<List<SavingModel>> getSavingsItems() async {
    return firestoreInstance
        .collection("savingGoals")
        .doc('users')
        .collection(_uid)
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

  Widget _itemSavings(BuildContext context, int index, SavingModel saveModel) {
    return Column(
      children: [
        Divider(
          thickness: 0.8,
          color: Colors.black,
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            navigateEditSavingGoal(context, saveModel, dashboardRoute);
          },
          child: Row(
            children: [
              Text((index + 1).toString() + '.'),
              SizedBox(
                width: 15.0.w,
              ),
              // Spacer(),
              Container(
                // width: 50,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(saveModel.url),
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
                            saveModel.goal,
                            // textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 14.2.h,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[450]),
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 50.w,
                          child: Text(
                            NumberFormat.simpleCurrency(
                              locale: "en-us",
                              decimalDigits: 0,
                            ).format(int.parse(saveModel.amount)),
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   width: 15.0,
                        // ),
                        Container(
                          width: 65.w,
                          child: Text(
                            NumberFormat.simpleCurrency(
                              locale: "en-us",
                              decimalDigits: 0,
                            ).format(
                              int.parse(saveModel.goalAmount),
                            ),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
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

  // Widget _itemSavis(BuildContext context, int index) {
  //   return Container(
  //     child: ListTile(
  //       title: Text(
  //         _listSavings[index].goal,
  //         style: TextStyle(fontSize: 16),
  //       ),
  //       subtitle: LinearPercentIndicator(
  //         width: 80.0,
  //         lineHeight: 8.0,
  //         percent: convertToDecimal(
  //           _listSavings[index].amount,
  //           _listSavings[index].goalAmount,
  //         ),
  //         backgroundColor: Colors.grey,
  //         progressColor: Color(0xFF17bf4f),
  //       ),
  //       leading: CircleAvatar(
  //         backgroundImage: AssetImage(_listSavings[index].url),
  //       ),
  //       trailing: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           Text(
  //             NumberFormat.simpleCurrency(locale: "en-us", decimalDigits: 0)
  //                 .format(int.parse(_listSavings[index].goalAmount)),
  //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  //           ),
  //           Text(
  //             NumberFormat.simpleCurrency(
  //               locale: "en-us",
  //               decimalDigits: 0,
  //             ).format(int.parse(_listSavings[index].amount)),
  //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //           ),
  //         ],
  //       ),
  //       onTap: () {
  //         navigateEditSavingGoal(context, _listSavings[index]);
  //       },
  //     ),
  //   );
  // }

  Widget _itemInvestment(
      BuildContext context, int index, InvestmentModel invModel) {
    return Column(
      children: [
        Divider(
          thickness: 0.8,
          color: Colors.black,
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            await navigateEditInvestmentGoal(context, invModel, dashboardRoute);
            setState(() {});
          },
          child: Row(
            children: [
              Text((index + 1).toString() + '.'),
              SizedBox(
                width: 15.0.w,
              ),
              // Spacer(),
              Container(
                // width: 50,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(invModel.url),
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
                            invModel.goal,
                            // textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 14.2.h,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[450]),
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 50.w,
                          child: Text(
                            NumberFormat.simpleCurrency(
                              locale: "en-us",
                              decimalDigits: 0,
                            ).format(int.parse(invModel.amount)),
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   width: 5.0,
                        // ),
                        Container(
                          padding: EdgeInsets.only(left: 0.0),
                          width: 65.w,
                          child: Text(
                            NumberFormat.simpleCurrency(
                                    locale: "en-us", decimalDigits: 0)
                                .format(int.parse(invModel.goalAmount)),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
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
                            (invModel != null) ? invModel.amount : '0',
                            (invModel != null) ? invModel.goalAmount : '0'),
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

  // Widget _itemInvest(BuildContext context, int index) {
  //   return Container(
  //     child: ListTile(
  //       title: Text(
  //         _listInvestment[index].goal,
  //         style: TextStyle(fontSize: 16),
  //       ),
  //       subtitle: LinearPercentIndicator(
  //         width: 80.0,
  //         lineHeight: 8.0,
  //         percent: convertToDecimal(
  //             _listInvestment[index].amount, _listInvestment[index].goalAmount),
  //         backgroundColor: Colors.grey,
  //         progressColor: Color(0xFF17bf4f),
  //       ),
  //       leading: CircleAvatar(
  //         backgroundImage: AssetImage(_listInvestment[index].url),
  //       ),
  //       trailing: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           Text(
  //             NumberFormat.simpleCurrency(locale: "en-us", decimalDigits: 0)
  //                 .format(int.parse(_listInvestment[index].goalAmount)),
  //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  //           ),
  //           Text(
  //             NumberFormat.simpleCurrency(
  //               locale: "en-us",
  //               decimalDigits: 0,
  //             ).format(int.parse(_listInvestment[index].amount)),
  //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  //           )
  //         ],
  //       ),
  //       onTap: () {
  //         navigateEditInvestmentGoal(context, _listInvestment[index]);
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // var _totalVal = Provider.of<TotalValues>(context, listen: false);

    // var _invToDateVal = _totalVal.investToDateVal;
    // var _investTotVal = _totalVal.invTot;
    // var _savToDateVal = _totalVal.savToDat;
    // var _savTotVal = _totalVal.savingsTot;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              // Navigator.of(context).pushReplacementNamed(widget.incomingRoute);
            }),
        backgroundColor: Color(0xff0070c0),
        title: Text('Dashboard'),
        centerTitle: true,
        elevation: 0.0,
      ),
      endDrawer: MainDrawer(
        uid: widget.uid,
        incomingRoute: widget.incomingRoute,
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Click on goals to edit or delete. Use',
              style: TextStyle(
                fontSize: 16.0.h,
                fontWeight: FontWeight.w400,
              ),
            ),
            Consumer<TotalValues>(
              builder: (context, provider, child) {
                return Expanded(
                  child: ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          SizedBox(
                            height: 16.h,
                          ),
                          Text(
                            "Virtual Account Balances",
                            style: TextStyle(
                                fontSize: 16.h, fontWeight: FontWeight.bold),
                          ),
                          // SizedBox(
                          //   height: 16,
                          // ),
                          FutureBuilder(
                            future: _getBalances(), // async work
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
                                              Container(
                                                width: 40.w,
                                                height: 40.h,
                                                child: CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                    'assets/images/Accounts/AcctChecking.png',
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 11.0.w,
                                              ),
                                              Text(
                                                'Checking',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15.h,
                                                ),
                                              ),
                                              Spacer(),
                                              (_checking != null)
                                                  ? Text(
                                                      NumberFormat
                                                              .simpleCurrency(
                                                                  locale:
                                                                      "en-us",
                                                                  decimalDigits:
                                                                      2)
                                                          .format(int.parse(
                                                              _checking)),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15.h,
                                                      ),
                                                    )
                                                  : Text(
                                                      '--',
                                                      // textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 20.0.h,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.black,
                                          thickness: 0.4,
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 40.w,
                                                height: 40.h,
                                                // width: 50,
                                                child: CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      'assets/images/Accounts/AcctSavings.png'),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 11.0.w,
                                              ),
                                              Text(
                                                'Savings',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15.h,
                                                ),
                                              ),
                                              Spacer(),
                                              (_savings != null)
                                                  ? Text(
                                                      NumberFormat
                                                              .simpleCurrency(
                                                                  locale:
                                                                      "en-us",
                                                                  decimalDigits:
                                                                      2)
                                                          .format(int.parse(
                                                              _savings)),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15.h,
                                                      ),
                                                    )
                                                  : Text(
                                                      '--',
                                                      // textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 20.0.h,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.black,
                                          thickness: 0.4,
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 40.w,
                                                height: 40.h,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  backgroundImage: AssetImage(
                                                    'assets/images/Accounts/AcctInvestment.png',
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 11.0.w,
                                              ),
                                              Text(
                                                "Investment",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15.h,
                                                ),
                                              ),
                                              Spacer(),
                                              (_investment != null)
                                                  ? Text(
                                                      NumberFormat
                                                              .simpleCurrency(
                                                                  locale:
                                                                      "en-us",
                                                                  decimalDigits:
                                                                      2)
                                                          .format(int.parse(
                                                              _investment)),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15.h,
                                                      ),
                                                    )
                                                  : Text(
                                                      '--',
                                                      // textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 20.0.h,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.black,
                                          thickness: 0.4,
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 40.w,
                                                height: 40.h,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  backgroundImage: AssetImage(
                                                    "assets/images/Accounts/AcctReward.png",
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 11.0.w,
                                              ),
                                              Text(
                                                "Reward Points",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15.h,
                                                ),
                                              ),
                                              Spacer(),
                                              (_rewardPoints != null)
                                                  ? Text(
                                                      _rewardPoints,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15.h,
                                                      ),
                                                    )
                                                  : Text(
                                                      '--',
                                                      // textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 20.0.h,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                              }
                            },
                          ),
                          SizedBox(
                            height: 40.0.h,
                          ),
                          Row(
                            children: [
                              Text(
                                'Savings Goals',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0.h,
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: 50.w,
                                child: Text(
                                  'Savings To Date',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15.0.w,
                              ),
                              Container(
                                width: 50.w,
                                child: Text(
                                  'Savings Goal',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              FutureBuilder(
                                future: provider.getSavingsInProvider(
                                    widget.uid), // async work
                                builder: (BuildContext context, snapshot) {
                                  if (provider.savingModelInstance != null) {
                                    return ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount:
                                          (provider.savingModelInstance != null)
                                              ? provider
                                                  .savingModelInstance.length
                                              : 0,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return _itemSavings(
                                          context,
                                          index,
                                          provider.savingModelInstance[index],
                                        );
                                      },
                                    );
                                  } else
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return new Text('Loading....');
                                      default:
                                        if (snapshot.hasError)
                                          return new Text(
                                              'Error: ${snapshot.error}');
                                        else
                                          return ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount: (snapshot.data != null)
                                                ? snapshot.data.length
                                                : 0,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return _itemSavings(
                                                context,
                                                index,
                                                provider
                                                    .savingModelInstance[index],
                                              );
                                            },
                                          );
                                    }
                                },
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 0.8,
                            color: Colors.black,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 76.w,
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
                                                fontSize: 14.2.h,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey[450]),
                                          ),
                                        ),
                                        Spacer(),
                                        Row(
                                          children: [
                                            FutureBuilder(
                                                future: provider.savToDat ==
                                                        null
                                                    ? provider.getSavingsToDate(
                                                        widget.uid)
                                                    : null,
                                                builder: (context, snapshot) {
                                                  if (provider.savToDat !=
                                                      null) {
                                                    return Container(
                                                      width: 60.0.w,
                                                      child: Text(
                                                        NumberFormat
                                                            .simpleCurrency(
                                                          locale: 'en-us',
                                                          decimalDigits: 0,
                                                        ).format(
                                                            provider.savToDat),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
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
                                                      default:
                                                        if (snapshot.hasError) {
                                                          print(
                                                              'Error: ${snapshot.error}');
                                                          return Container(
                                                            width: 80.0.w,
                                                            child: Text(
                                                              '--',
                                                              textAlign:
                                                                  TextAlign.end,
                                                              style: TextStyle(
                                                                fontSize:
                                                                    20.0.h,
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
                                                                decimalDigits:
                                                                    0,
                                                              ).format(provider
                                                                  .savToDat),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          );
                                                    }
                                                }),
                                            SizedBox(
                                              width: 15.0.w,
                                            ),
                                            FutureBuilder(
                                                future: provider.savingsTot ==
                                                        null
                                                    ? provider.getSavingsTotal(
                                                        widget.uid)
                                                    : null,
                                                builder: (context, snapshot) {
                                                  if (provider.savingsTot !=
                                                      null) {
                                                    return Container(
                                                      width: 60.0.w,
                                                      child: Text(
                                                        NumberFormat
                                                            .simpleCurrency(
                                                          locale: 'en-us',
                                                          decimalDigits: 0,
                                                        ).format(provider
                                                            .savingsTot),
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w500,
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
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                              fontSize: 20.0.h,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                                          );
                                                        } else
                                                          return Container(
                                                            width: 60.0.w,
                                                            child: Text(
                                                              NumberFormat
                                                                  .simpleCurrency(
                                                                locale: 'en-us',
                                                                decimalDigits:
                                                                    0,
                                                              ).format(provider
                                                                  .savingsTot),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          );
                                                    }
                                                }),
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
                                            (provider.savToDat != null)
                                                ? provider.savToDat.toString()
                                                : '0',
                                            (provider.savingsTot != null)
                                                ? provider.savingsTot.toString()
                                                : '0'),
                                        // valueColor: ,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30.0.h,
                          ),
                          Row(
                            children: [
                              Text(
                                'Investment Goals',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0.h,
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: 50.w,
                                child: Text(
                                  'Investments To Date',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
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
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          FutureBuilder(
                            future: provider.getInvestmentProvider(
                                widget.uid), // async work
                            builder: (BuildContext context, snapshot) {
                              if (provider.investModelInstance != null) {
                                return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount:
                                      (provider.investModelInstance != null)
                                          ? provider.investModelInstance.length
                                          : 0,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return _itemInvestment(
                                      context,
                                      index,
                                      provider.investModelInstance[index],
                                    );
                                  },
                                );
                              } else
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return new Text('Loading....');
                                  default:
                                    if (snapshot.hasError)
                                      return new Text(
                                          'Error: ${snapshot.error}');
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
                                          return _itemInvestment(
                                            context,
                                            index,
                                            provider.investModelInstance[index],
                                          );
                                        },
                                      );
                                }
                            },
                          ),
                          Divider(
                            thickness: 0.8,
                            color: Colors.black,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 76.w,
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
                                                fontSize: 14.2.h,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey[450]),
                                          ),
                                        ),
                                        Spacer(),
                                        Row(
                                          children: [
                                            FutureBuilder(
                                                future: provider
                                                            .investToDateVal ==
                                                        null
                                                    ? provider.getInvestToDate(
                                                        widget.uid)
                                                    : null,
                                                builder: (context, snapshot) {
                                                  if (provider
                                                          .investToDateVal !=
                                                      null) {
                                                    return Container(
                                                      width: 60.0.w,
                                                      child: Text(
                                                        NumberFormat
                                                            .simpleCurrency(
                                                          locale: 'en-us',
                                                          decimalDigits: 0,
                                                        ).format(provider
                                                            .investToDateVal),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
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
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize: 20.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize:
                                                                    20.0.h,
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
                                                                decimalDigits:
                                                                    0,
                                                              ).format(provider
                                                                  .investToDateVal),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          );
                                                    }
                                                }),
                                            SizedBox(
                                              width: 15.0.w,
                                            ),
                                            FutureBuilder(
                                                future: provider.invTot == null
                                                    ? provider.getInvestTotal(
                                                        widget.uid)
                                                    : null,
                                                builder: (context, snapshot) {
                                                  if (provider.invTot != null) {
                                                    return Container(
                                                      width: 60.0.w,
                                                      child: Text(
                                                        NumberFormat
                                                            .simpleCurrency(
                                                          locale: 'en-us',
                                                          decimalDigits: 0,
                                                        ).format(
                                                            provider.invTot),
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
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
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                              fontSize: 20.0.h,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                                          );
                                                        } else
                                                          return Container(
                                                            width: 60.0.w,
                                                            child: Text(
                                                              NumberFormat
                                                                  .simpleCurrency(
                                                                locale: 'en-us',
                                                                decimalDigits:
                                                                    0,
                                                              ).format(provider
                                                                  .invTot),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          );
                                                    }
                                                }),
                                            // Spacer(),
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
                                        value: (provider.investToDateVal ==
                                                    null &&
                                                provider.invTot == null)
                                            ? 0.1
                                            : convertToDecimal(
                                                (provider.investToDateVal !=
                                                        null)
                                                    ? provider.investToDateVal
                                                        .toString()
                                                    : '0',
                                                (provider.invTot != null)
                                                    ? provider.invTot.toString()
                                                    : '0'),
                                        // valueColor: ,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 25.0.h,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: ButtonTheme(
                minWidth: double.infinity,
                height: 50.0.h,
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Color(0xff0070c0),
                  child: Text(
                    "Log Out",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.h),
                  ),
                  onPressed: () {
                    _signOutT();
                    // getSavingsItems();
                    // convertToDecimal(_listSavings[index].amount,
                    //     _listSavings[index].goalAmount);
                  },
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
