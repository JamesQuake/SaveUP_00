import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
// import 'package:pay_or_save/assets/custom_button.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/models/account_model.dart';
import 'package:pay_or_save/pages/starting_instructions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'select_mode.dart';
// import 'package:pay_or_save/widgets/menu.dart';

class StartingBalances extends StatefulWidget {
  final String uid;
  final String incomingRoute;

  @override
  _StartingBalancesState createState() => _StartingBalancesState(uid);

  StartingBalances({Key key, @required this.uid, this.incomingRoute})
      : super(key: key);
}

class _StartingBalancesState extends State<StartingBalances> {
  String _uid, _checking, _savings, _investment, _rewardPoints;
  List<AccountModel> _list;
  final firestoreInstance = FirebaseFirestore.instance;
  SharedPreferences _userPrefs;
  bool _isNewUser;
  bool _userExists;

  _StartingBalancesState(this._uid);

  Future _getBalances() {
    return firestoreInstance.collection("users").doc(_uid).get().then((value) {
      if (value.data != null) {
        _checking = value.data()['checking'].round().toString();
        _savings = value.data()['savings'].round().toString();
        _investment = value.data()['investment'].round().toString();
        _rewardPoints = value.data()['reward_points'].round().toString();
      } else {
        return [
          false,
          // print(_checking),
          // print(_savings),
          // print(_investment),
          // print(_rewardPoints),
        ];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // print(_uid);
    // _getBalances();
    getUserPrefs().then((_) {
      Timer(Duration(seconds: 1), ()=>_setPrefs(false));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future navigateToStartingInstructions(context) async {
    if (_isNewUser == false || _userExists == true) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SelectMode(
                    uid: _uid,
                  )));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StartingInstructions(
                    uid: _uid,
                  )));
    }
  }

//   checkUser() async {
//     final FirebaseAuth _auth = FirebaseAuth.instance;
//     final UserCredential _currentUser = _
// // final FirebaseUser currentUser = await _auth.currentUser();
//   }

  Future getUserPrefs() async {
    _userPrefs = await SharedPreferences.getInstance();
    setState(() {
      _isNewUser = _userPrefs.getBool('isNewUser');
      _userExists = _userPrefs.getBool('userExists');
    });
  }

  _setPrefs(bool userInfo) async {
    await SharedPreferences.getInstance().then((value) => value.setBool('isNewUser', userInfo));
  }

  // Future _getBalances() async {
  //   var gb = firestoreInstance.collection("users").document(_uid);
  //   var doSomething = await gb.get();
  //   if (doSomething.data != null) {
  //     return [
  //       _checking = doSomething.data['checking'].toStringAsFixed(2),
  //       _savings = doSomething.data['savings'].toStringAsFixed(2),
  //       _investment = doSomething.data['investment'].toStringAsFixed(2),
  //       _rewardPoints = doSomething.data['reward_points'].toStringAsFixed(2)
  //     ];
  //   } else {
  //     return false;
  //   }
  //   // _getOtherBalances();
  // }

  // Widget _item(BuildContext context, int index) {
  //   return Container(
  //     child: ListTile(
  //       title: Text(
  //         _list[index].title,
  //         style: TextStyle(fontSize: 16.h),
  //       ),
  //       leading: CircleAvatar(
  //         backgroundImage: NetworkImage(_list[index].url),
  //       ),
  //       trailing: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           Text(
  //             "\$" + _list[index].amount,
  //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.h),
  //           )
  //         ],
  //       ),
  //       onTap: () {},
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: (widget.incomingRoute != null)
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
                // onPressed: () {
                //   print('printing here');
                //   print(_isNewUser);
                // },
              )
            : Container(),
        backgroundColor: Color(0xff0070c0),
        title: (_isNewUser == false || _userExists == true)
            ? Text(
                'Current Acct Balances',
                style: TextStyle(
                  fontSize: 22.0.h,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Text(
                'Beginning Acct Balances',
                style: TextStyle(
                  fontSize: 22.0.h,
                  fontWeight: FontWeight.bold,
                ),
              ),
        centerTitle: true,
        elevation: 0.0,
      ),
      endDrawer: MainDrawer(uid: widget.uid),
      body: Padding(
        padding: EdgeInsets.fromLTRB(40.0.w, 25.0.h, 40.0.w, 10.0.h),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // SizedBox(
              //   height: 25.0,
              // ),
              if (_isNewUser == true && _userExists == false)
                Text(
                  "You need money to make money. We've funded these virtual accounts for you to get you started.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    // letterSpacing: 0.1,
                    // wordSpacing: 0.1,
                    fontSize: 16.h,
                    height: 1.3,
                  ),
                ),
              SizedBox(
                height: 30.0.h,
              ),
              FutureBuilder(
                future: _getBalances(), // async work
                builder: (BuildContext context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      // print(_isNewUser);
                      // print(_userExists);
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
                                          NumberFormat.simpleCurrency(
                                                  locale: "en-us",
                                                  decimalDigits: 2)
                                              .format(int.parse(_checking)),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.h,
                                          ),
                                        )
                                      : Text(
                                          '--',
                                          // textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20.0.h,
                                            fontWeight: FontWeight.bold,
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
                                          NumberFormat.simpleCurrency(
                                                  locale: "en-us",
                                                  decimalDigits: 2)
                                              .format(int.parse(_savings)),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.h,
                                          ),
                                        )
                                      : Text(
                                          '--',
                                          // textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20.0.h,
                                            fontWeight: FontWeight.bold,
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
                                      backgroundColor: Colors.transparent,
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
                                          NumberFormat.simpleCurrency(
                                                  locale: "en-us",
                                                  decimalDigits: 2)
                                              .format(int.parse(_investment)),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.h,
                                          ),
                                        )
                                      : Text(
                                          '--',
                                          // textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20.0.h,
                                            fontWeight: FontWeight.bold,
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
                                      backgroundColor: Colors.transparent,
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
                                          NumberFormat.decimalPattern(
                                            'en-us',
                                          ).format(
                                            int.parse(_rewardPoints),
                                          ),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.h,
                                          ),
                                        )
                                      : Text(
                                          '--',
                                          // textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20.0.h,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            if (_isNewUser == true && _userExists == false)
                              Container(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 53.0.w,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '1,000 standard',
                                          style: TextStyle(
                                            fontSize: 12.h,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        Text(
                                          '2,000 with friend code',
                                          style: TextStyle(
                                            fontSize: 12.h,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
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
              Spacer(),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 13.0.h, vertical: 10.0),
                child: TextButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.resolveWith(
                        (states) => Size(double.infinity, 45)),
                    backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Color(0xff0070c0),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
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
                      // Navigator.pushNamed(context, '');
                      _setPrefs(false);
                      navigateToStartingInstructions(context);
                      // print("willo");
                    },
                  ),
                  child: Text(
                    'Shop Now',
                    style: TextStyle(
                      fontSize: 20.0.h,
                      color: Colors.white,
                    ),
                  ),
                  // color: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
