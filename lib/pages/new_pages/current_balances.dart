///TODO : HAS BEEN WORKED ON.

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/models/account_model.dart';

class AccountBalance extends StatefulWidget {
  // const AccountBalance({ Key? key }) : super(key: key);
  final String uid;

  const AccountBalance({Key key, this.uid}) : super(key: key);

  @override
  _AccountBalanceState createState() => _AccountBalanceState();
}

class _AccountBalanceState extends State<AccountBalance> {
  String _checking, _savings, _investment, _rewardPoints;
  List<AccountModel> _list;
  final firestoreInstance = FirebaseFirestore.instance;

  Future _getBalances() {
    return firestoreInstance
        .collection("users")
        .doc(widget.uid)
        .get()
        .then((value) {
      if (value.exists) {
        _checking = value.data()['checking'].toStringAsFixed(2);
        _savings = value.data()['savings'].toStringAsFixed(2);
        _investment = value.data()['investment'].toStringAsFixed(2);
        _rewardPoints = value.data()['reward_points'].toStringAsFixed(2);
      } else {
        return [
          false,
          print(_checking),
          print(_savings),
          print(_investment),
          print(_rewardPoints),
        ];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    print(widget.uid);
    _getBalances();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
        backgroundColor: Color(0xff0070c0),
        title: Text(
          'Account Balances',
          style: TextStyle(
            fontSize: 22.0,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      endDrawer: MainDrawer(uid: widget.uid),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40.0, 25.0, 40.0, 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Account Balance',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
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
                        children: [
                          Divider(
                            color: Colors.black,
                            thickness: 0.4,
                          ),
                          Row(
                            children: [
                              Container(
                                // width: 50,
                                child: CircleAvatar(
                                  backgroundImage: AssetImage(
                                      'assets/images/retirament.jpg'),
                                ),
                              ),
                              SizedBox(
                                width: 9.0,
                              ),
                              Text(
                                'Checking',
                                style: TextStyle(),
                              ),
                              Spacer(),
                              (_checking != null)
                                  ? Text(
                                      "\$" + _checking,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    )
                                  : Text(
                                      "\$",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    )
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 0.4,
                          ),
                          Row(
                            children: [
                              Container(
                                // width: 50,
                                child: CircleAvatar(
                                  backgroundImage: AssetImage(
                                      'assets/images/retirament.jpg'),
                                ),
                              ),
                              SizedBox(
                                width: 9.0,
                              ),
                              Text(
                                'Savings',
                                style: TextStyle(),
                              ),
                              Spacer(),
                              (_savings != null)
                                  ? Text(
                                      "\$" + _savings,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    )
                                  : Text(
                                      "\$",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 0.4,
                          ),
                          Row(
                            children: [
                              Container(
                                // width: 50,
                                child: CircleAvatar(
                                  backgroundImage: AssetImage(
                                      'assets/images/retirament.jpg'),
                                ),
                              ),
                              SizedBox(
                                width: 9.0,
                              ),
                              Text(
                                'Investments',
                                style: TextStyle(),
                              ),
                              Spacer(),
                              (_investment != null)
                                  ? Text(
                                      "\$" + _investment,
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    )
                                  : Text(
                                      "\$",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 0.4,
                          ),
                          Row(
                            children: [
                              Container(
                                // width: 50,
                                child: CircleAvatar(
                                  backgroundImage: AssetImage(
                                      'assets/images/retirament.jpg'),
                                ),
                              ),
                              SizedBox(
                                width: 9.0,
                              ),
                              Text(
                                'Reward Points',
                                style: TextStyle(),
                              ),
                              Spacer(),
                              (_rewardPoints != null)
                                  ? Text(
                                      _rewardPoints,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    )
                                  : Text(
                                      "0",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                            ],
                          ),
                          Container(
                            // alignment: Alignment.topLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 50.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '1,000 standard',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Text(
                                      '2,000 with friend code',
                                      style: TextStyle(
                                        fontSize: 12,
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
            TextButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.resolveWith(
                    (states) => Size(300, 45)),
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
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => EbayPage(
                  //             // uid: _uid,
                  //             )));
                },
              ),
              child: Text(
                'Shop Now',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              // color: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
