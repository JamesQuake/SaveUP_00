import 'dart:async';
import 'dart:io' show Platform;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/element/revcat/paywall.dart';
import 'package:pay_or_save/pages/dashboard.dart';
import 'package:pay_or_save/pages/new%20pages/add_to_account.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:square_in_app_payments/in_app_payments.dart';
// import 'package:square_in_app_payments/models.dart';
// import 'package:square_in_app_payments/google_pay_constants.dart'
// as google_pay_constants;

class AcquirePoints extends StatefulWidget {
  final String uid;

  const AcquirePoints({Key key, this.uid}) : super(key: key);
  @override
  _AcquirePointsState createState() => _AcquirePointsState();
}

class _AcquirePointsState extends State<AcquirePoints> {
  FirebaseFunctions functions = FirebaseFunctions.instance;
  String _selected = 'first';
  GlobalKey<State> _acquireKey = GlobalKey<State>();
  bool _googlePayEnabled = false;
  bool stt;
  Offerings offerings;
  Offering offerin;
  bool showConfirmation;

  @override
  void initState() {
    initPlatformState();
    // dispDialog();
    super.initState();
  }

  Future<void> initPlatformState() async {
    await Purchases.setDebugLogsEnabled(true);

    PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration =
          PurchasesConfiguration("goog_mTnovWESImOkGyILfzVxWrllpsg");
      // print("this gibberish");
      // if (buildingForAmazon) {
      //   // use your preferred way to determine if this build is for Amazon store
      //   // checkout our MagicWeather sample for a suggestion
      //   configuration = AmazonConfiguration("public_amazon_sdk_key");
      // }
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration("public_ios_sdk_key");
    }
    await Purchases.configure(configuration);
    // print("this a benchmark");
  }

  altFunc() async {
    setState(() {
      // _isLoading = true;
    });

    CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    {
      try {
        offerings = await Purchases.getOfferings();
      } on PlatformException catch (e) {
        await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text("Error"),
            content: Text(e.message),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          ),
        );
      }

      setState(() {
        // _isLoading = false;
      });

      if (offerings == null || offerings.current == null) {
        // offerings are empty, show a message to your user
      } else {
        // current offering is available, show paywall
        var result = await showModalBottomSheet(
          useRootNavigator: true,
          isDismissible: true,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
              return Paywall(
                offering: offerings.current,
                uid: widget.uid,
              );
            });
          },
        );
        setState(() {
          showConfirmation = result;
        });
        dispDialog();
      }
    }
  }

  _makePurchase() async {
    try {
      Package _stuff;
      // Purchases.getProducts([]);
      CustomerInfo customerInfo = await Purchases.purchasePackage(_stuff);
      var isPro = customerInfo.entitlements.all["reward_points"].isActive;
      if (isPro) {
        // Unlock that great "pro" content
        print("client is pro");
      } else {
        print("this man is not pro");
      }
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        // showError(e);
      }
    }
  }

  dispDialog() {
    if (showConfirmation == true)
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:
                  Image.asset('assets/images/gifs/cngrts.gif', height: 120.0),
              content: Text(
                "Congrats!. You are now an eWyzly premium user.",
                textAlign: TextAlign.center,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35.0))),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      showConfirmation = false;
                    });
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashBoard(
                                  uid: widget.uid,
                                )));
                  },
                  child: Text('OK'),
                )
              ],
            );
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff11a858),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // actions: <Widget>[
        //   MyManue.childPopup(context)
        // ],
        title: Text(
          "Buy Reward Points",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 23.0,
          ),
        ),
        centerTitle: true,
      ),
      endDrawer: MainDrawer(uid: widget.uid),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40.0, 40.0, 40.0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select one:',
              // textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Divider(
              color: Colors.black,
              thickness: 0.4,
            ),
            SizedBox(
              height: 20.0,
            ),
            Column(
              key: _acquireKey,
              children: [
                RadioListTile(
                  activeColor: Color(0xff11a858),
                  value: 'first',
                  groupValue: _selected,
                  onChanged: (value) {
                    setState(() {
                      _selected = value;
                    });
                  },
                  title: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        height: 1.5,
                        fontSize: 17,
                      ),
                      children: [
                        TextSpan(
                          text: "I'd like to ",
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                        TextSpan(
                          text: "buy reward points and ",
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                        TextSpan(
                          text: "STOP ADS",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                RadioListTile(
                  // leading: Radio(
                  activeColor: Color(0xff11a858),
                  value: 'second',
                  groupValue: _selected,
                  onChanged: (value) {
                    setState(() {
                      _selected = value;
                    });
                  },
                  // ),
                  title: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        height: 1.5,
                        fontSize: 17,
                      ),
                      children: [
                        TextSpan(
                          text: "I'd like to ",
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                        TextSpan(
                          text: "earn reward points and ",
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                        TextSpan(
                          text: "KEEP ADS",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text:
                              " by continuing to shop and save. (Remember that you earn one reward point for each dollar that you save.)",
                          style: TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            TextButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.resolveWith(
                    (states) => Size(double.infinity, 50)),
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => Color(0xff11a858),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                overlayColor: MaterialStateProperty.resolveWith(
                  (states) {
                    return states.contains(MaterialState.pressed)
                        ? Colors.green
                        : null;
                  },
                ),
              ),
              onPressed: () => Timer(
                const Duration(milliseconds: 400),
                () {
                  if (_selected == 'second') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddToAccount(
                                // uid: widget.uid,
                                )));
                  } else
                    altFunc();
                },
              ),
              child: Text(
                'Next',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
