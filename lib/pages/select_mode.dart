import 'dart:async';
// import 'dart:convert';

// import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:http/http.dart';
// import 'package:pay_or_save/assets/custom_button.dart';
import 'package:pay_or_save/assets/dropdown/expanded_section.dart';
import 'package:pay_or_save/assets/dropdown/scrollbar.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/assets/dropdown/new_dropdown.dart';
import 'package:pay_or_save/element/ad_helper.dart';
import 'package:pay_or_save/element/amazon/Provider/categories_provider.dart';
// import 'package:pay_or_save/pages/heard_from.dart';
// import 'package:pay_or_save/pages/new_pages/current_balances.dart';
// import 'package:pay_or_save/pages/new_pages/acquire_reward_points.dart';
// import 'package:pay_or_save/pages/new_pages/add_to_account.dart';
// import 'package:pay_or_save/pages/new_pages/congratulations_investment.dart';
// import 'package:pay_or_save/pages/new_pages/overdraft_reminder.dart';
// import 'package:pay_or_save/pages/new_pages/reward_points.dart';
// import 'package:pay_or_save/pages/new_pages/save_new.dart';
// import 'package:pay_or_save/pages/new_pages/select_store.dart';
// import 'package:pay_or_save/pages/new_pages/...select_store.dart';
// import 'package:pay_or_save/pages/new_pages/win.dart';
// import 'package:pay_or_save/pages/overdraft_notice.dart';
// import 'package:pay_or_save/pages/save.dart';
// import 'package:pay_or_save/pages/save_now.dart';
// import 'package:pay_or_save/pages/saving_goals.dart';
import 'package:pay_or_save/pages/sign_in.dart';
// import 'package:pay_or_save/pages/slot_webview.dart';
import 'package:pay_or_save/pages/starting_balances.dart';
import 'package:pay_or_save/utilities/validator.dart';
import 'package:provider/provider.dart';
// import 'package:pay_or_save/widgets/menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../element/amazon/Provider/amazon_provider.dart';
import '../element/amazon/sigV4/sigv4-client.dart';
import 'amazon_page.dart';
import 'ebay_page.dart';
import 'walmart_page.dart';
// import './new_pages/invest_new.dart';
// import 'invest_now.dart';
// import 'new_pages/options.dart';

class SelectMode extends StatefulWidget {
  final String uid;

  @override
  _SelectModeState createState() => _SelectModeState(uid);

  SelectMode({Key key, @required this.uid}) : super(key: key);
}

enum SingingCharacter { live, game }

class _SelectModeState extends State<SelectMode> {
  final firestoreInstance = FirebaseFirestore.instance;
  String _uid, retailer = 'eBay';
  InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;
  int _loadAttempts = 0;
  int adStat;
  // SingingCharacter _character = SingingCharacter.game;

  // String valueChoose = 'Amazon';

  _SelectModeState(this._uid);

  bool isStrechedDropDown = false;
  int groupValue;
  String title = 'eBay'; //Where would you like to shop?

  List<String> dropList = [
    'Amazon',
    'eBay',
    'Walmart',
    'Target',
    'Home Depot',
  ];
  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
    // getRetailer();
    _loadInterstitialAd();
  }

  @override
  void dispose() {
    _interstitialAd.dispose();
    super.dispose();
  }

  void _loadInterstitialAd() {
    // print('previeeeeeeew');
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          // print('previeeeeeeew');
          // print(_interstitialAd);
          // ad.fullScreenContentCallback = FullScreenContentCallback(
          //   onAdDismissedFullScreenContent: (ad) {
          //     // Navigator.pop(context);
          //     navigateToStore(context);
          //   },
          // );
          _isInterstitialAdReady = true;

          _loadAttempts = 0;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _loadAttempts += 1;
          // print('previeeeeeeew fail');
          // print(_interstitialAd);
          _isInterstitialAdReady = null;
          if (_loadAttempts <= 3) {
            _loadInterstitialAd();
          }
        },
      ),
    );
  }

  Future navigateToStore(context) async {
    if (retailer == 'eBay') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Ebay(
                    // url: "",
                    // incomingOrder: '10',
                    uid: _uid,
                  )));
    } else if (retailer == 'Amazon') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Amazon(
                    // url: "",
                    // incomingOrder: '100',
                    uid: _uid,
                  )));
    } else{
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Walmart(
                    // url: "",
                    // incomingOrder: '100',
                    uid: _uid,
                  )));
    }
  }

  void _showInterstitialAd() {
    // if (_interstitialAd == null) _loadInterstitialAd();
    if (_interstitialAd != null && adStat != 1) {
      _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          _loadInterstitialAd();
          // print('weirddd');
          print(error);
        },
      );
      _interstitialAd.show();
    }
  }

  saveRetailer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('Retailer', retailer);
  }

  _signOutT() async {
    await FirebaseAuth.instance.signOut().then((v) {
      navigateSiginUp(context);
    });
  }

  _checkClientStat() async {
    var stat =
        await firestoreInstance.collection("users").doc(widget.uid).get();
    setState(() {
      adStat = stat.data()["ads_status"];
    });

    // print(stat.data()["ads_status"]);
  }

  // Future navigateToRetailer(context) async {
  //   if (retailer != null) {
  //     saveRetailer();
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => StartingBalances(
  //                   uid: _uid,
  //                 )));
  //   } else {
  //     Validator.onErrorDialog(
  //       "Please select retailer",
  //       context,
  //     );
  //   }
  // }

  Future navigateSiginUp(context) async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SignInRegistrationPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Color(0xff0070c0),
        title: Text(
          'Select Store',
          style: TextStyle(
            fontSize: 25.0.h,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Image.asset(
        //   "assets/images/posmob.png",
        //   height: 50.0,
        //   width: 50.0,
        // ),
        // SizedBox(
        //   width: 18.0,
        // ),
        centerTitle: true,
        elevation: 0.0,
      ),
      endDrawer: MainDrawer(uid: widget.uid),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          17.0,
          18.0,
          17.0,
          16.0,
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom:
                                  BorderSide(width: 1.0, color: Colors.black),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                // height: 45,
                                width: double.infinity,
                                constraints: BoxConstraints(
                                  minHeight: 45.h,
                                  minWidth: double.infinity,
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 10),
                                        child: Text(
                                          title,
                                          style: TextStyle(fontSize: 17.0.h),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isStrechedDropDown =
                                              !isStrechedDropDown;
                                        });
                                      },
                                      child: Icon(
                                        isStrechedDropDown
                                            ? Icons.expand_less
                                            : Icons.expand_more,
                                        size: 30,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              ExpandedSection(
                                expand: isStrechedDropDown,
                                height: 100,
                                child: (dropList.length > 3)
                                    ? MyScrollbar(
                                        builder: (context, scrollController2) =>
                                            ListView.builder(
                                          padding: EdgeInsets.all(0),
                                          controller: scrollController2,
                                          shrinkWrap: true,
                                          itemCount: dropList.length,
                                          itemBuilder: (context, index) {
                                            return RadioListTile(
                                              title: (index == 3 ||
                                                      index == 4)
                                                  ? Text(
                                                      dropList.elementAt(index),
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                    )
                                                  : Text(
                                                      dropList.elementAt(index),
                                                    ),
                                              activeColor: Color(0xff0070c0),
                                              value: index,
                                              groupValue: groupValue ?? 1,
                                              onChanged: (val) {
                                                if (val == 0 || val == 1 || val == 2) {
                                                  setState(() {
                                                    groupValue = val;
                                                    title = dropList
                                                        .elementAt(index);
                                                    // retailer = val;
                                                  });
                                                }
                                                if (val == 0 || val == 1 || val == 2) {
                                                  if (isStrechedDropDown ==
                                                      true) {
                                                    setState(() {
                                                      isStrechedDropDown =
                                                          false;
                                                    });
                                                    switch (val) {
                                                      case 0:
                                                        setState(() {
                                                          val = "Amazon";
                                                        });
                                                        break;
                                                      case 1:
                                                        setState(() {
                                                          val = "eBay";
                                                        });
                                                        break;
                                                      case 2:
                                                        setState(() {
                                                          val = "Walmart";
                                                        });
                                                        break;
                                                      case 3:
                                                        setState(() {
                                                          val = "Target";
                                                        });
                                                        break;
                                                      case 4:
                                                        setState(() {
                                                          val = "Home Depot";
                                                        });
                                                        break;
                                                    }
                                                    retailer = val;
                                                  }
                                                }
                                              },
                                            );
                                          },
                                        ),
                                      )
                                    : ListView.builder(
                                        padding: EdgeInsets.all(0),
                                        // controller: scrollController2,
                                        shrinkWrap: true,
                                        itemCount: dropList.length,
                                        itemBuilder: (context, index) {
                                          return RadioListTile(
                                            title: Text(
                                              dropList.elementAt(index),
                                            ),
                                            activeColor: Color(0xff0070c0),
                                            value: index,
                                            groupValue: groupValue,
                                            onChanged: (val) {
                                              setState(() {
                                                groupValue = val;
                                                title =
                                                    dropList.elementAt(index);
                                              });
                                            },
                                          );
                                        },
                                      ),
                              )
                            ],
                          ),
                        )),
                      ],
                    )
                  ],
                ),
              ),
            ),
            // NewDropDown(
            //   dropTitle: 'Where would you like to Shop?',
            //   dropList: [
            //     'Amazon',
            //     'eBay',
            //     'Apple',
            //     'CostCo',
            //     'Home Depot',
            //     'QVC',
            //     'Target',
            //   ],
            // ),
            SizedBox(
              height: 20.0.h,
            ),
            NewDropDown(
              dropList: [
                'Game. Play with virtual money',
                'Live. Use real dollars',
              ],
              dropTitle: 'Game. Play with virtual money',
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Consumer<AmazonProvider>(
                builder: (context, amz, child) {
                  return ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.resolveWith(
                          (states) => Size(double.infinity, 50.h)),
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
                      () async {
                        await _checkClientStat();
                        // if (adStat != 1)
                        //TODO: Enable ads here
                        // _showInterstitialAd();
                        navigateToStore(context);

                        ///
                        ///
                        ///
                        ///

                        // AmzCategoriesProvider amzInstance =
                        //     Provider.of<AmzCategoriesProvider>(context,
                        //         listen: false);
                        // List sitty = [];
                        // amzInstance.cat.forEach((element) {
                        //   sitty.add(element["category"]["categoryName"]);
                        // });

                        // sitty.sort();
                      },
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 20.0.h,
                        color: Colors.white,
                      ),
                    ),
                    // color: Colors.transparent,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
