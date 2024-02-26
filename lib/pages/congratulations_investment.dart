import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/models/investment_goal_model.dart';
import 'package:pay_or_save/pages/new%20pages/win.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/total_provider.dart';
import '../widgets/ring.dart';

enum _SocialMedia { facebook, twitter, email }

class CongratsInvestment extends StatefulWidget {
  final String uid;
  final String modelId;
  final InvestmentModel incomingModel;
  final String investAmount;

  const CongratsInvestment(
      {Key key, this.uid, this.modelId, this.incomingModel, this.investAmount})
      : super(key: key);
  // const CongratsInvestment({ Key? key }) : super(key: key);

  @override
  _CongratsInvestmentState createState() => _CongratsInvestmentState();
}

class _CongratsInvestmentState extends State<CongratsInvestment> {
  int amount = 100;
  final firestoreInstance = FirebaseFirestore.instance;
  InvestmentModel _receivedModel;
  Future<InvestmentModel> _referenceModel;
  // int _rewardPoints;
  // var _newAmount = '\$' + amount;

  @override
  void initState() {
    super.initState();
    _referenceModel = getModelInfo();
  }

  Future _share(_SocialMedia socialPlatform) async {
    final subject = 'eWyzly';
    final text = "I just invested " +
        NumberFormat.simpleCurrency(locale: "en-us", decimalDigits: 2)
            .format(double.parse(widget.investAmount)) +
        " using eWyzly, the shopping app that makes savings fun. I'd bet that it save you money too. \n\nCheck it out and receive 1000 free reward point toward valuable prizes by entering friend code 2020 when you download the app.";
    final urlShare = Uri.encodeComponent('https://www.ewyzly.com');
    final urls = {
      _SocialMedia.facebook:
          'https://www.facebook.com/sharer/sharer.php?u=$urlShare&t=$text',
      _SocialMedia.twitter:
          'https://www.twitter.com/intent/tweet?text=$text\n\n$urlShare',
      _SocialMedia.email: 'mailto:?subject=$subject&body=$text\n',
    };

    final url = urls[socialPlatform];

    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  String encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Future<void> _sendEmail() async {
    final urlShare = Uri.decodeComponent('www.eWyzly.com');
    final text = "I just invested " +
        NumberFormat.simpleCurrency(locale: "en-us", decimalDigits: 2)
            .format(double.parse(widget.investAmount)) +
        " using eWyzly, the shopping app that makes savings fun. I'd bet that it save you money too. \n\nCheck it out and receive 1000 free reward point toward valuable prizes by entering friend code 2020 when you download the app.";
    final Uri launchUri = Uri(
      scheme: 'mailto',
      // path: 'smith@example.com',
      query: encodeQueryParameters(<String, String>{
        "subject": "eWyzly",
        'body': text + "\n\n$urlShare",
      }),
    );
    await launchUrl(launchUri);
  }

  Future<InvestmentModel> getModelInfo() async {
    if (widget.modelId != null && widget.uid != null) {
      var modelInstance = await firestoreInstance
          .collection("investmentGoals")
          .doc("users")
          .collection(widget.uid)
          .doc((widget.modelId).trim())
          .get();

      _receivedModel =
          InvestmentModel.fromJson(modelInstance.id, modelInstance.data());
    } else {
      if (widget.modelId == null) print('model ID is empty');
      if (widget.uid == null) print('uid is empty');
    }
    return _receivedModel;
  }

  _calcPrgrs(amount, goal) {
    if (goal == amount) {
      return 0;
    } else {
      var val = amount * 100;
      var perc = val / goal;
      var iVal = (perc * 230.0) / 100;
      var _res = 230.0 - iVal;
      return _res;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
          // onPressed: () {
          // colorFilter: ColorFilter.mode(
          //             Colors.white.withOpacity(0.2), BlendMode.dstATop), //for image blur
          //   // getModelInfo();
          //   print('observe');
          //   print(_receivedModel.url);
          // },
        ),
        backgroundColor: Color(0xff0070c0),
        title: Text(
          'Congratulations',
          style: TextStyle(
            fontSize: 25.h,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      endDrawer: MainDrawer(uid: widget.uid),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20.0.w, 30.0.h, 20.0.w, 10.0.h),
        child: FutureBuilder(
            future: _referenceModel,
            builder: (context, snapshot) {
              return Column(
                children: [
                  Row(
                    children: [
                      Container(
                        child: Container(
                          width: 40.0.w,
                          height: 40.0.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: (_receivedModel != null)
                                  ? NetworkImage(_receivedModel.url)
                                  : AssetImage('assets/images/posmob.png'),
                              colorFilter: (_receivedModel == null)
                                  ? ColorFilter.mode(
                                      Colors.white.withOpacity(0.6),
                                      BlendMode.dstATop)
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0.w,
                      ),
                      Expanded(
                        child: RichText(
                          // overflow: TextOverflow.visible,
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              height: 1.5,
                              fontSize: 18.h,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    'Congratulations! You have just invested ',
                                style: TextStyle(
                                  fontSize: 17.0.h,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: NumberFormat.simpleCurrency(
                                        locale: "en-us", decimalDigits: 2)
                                    .format(double.parse(widget.investAmount)),
                                style: TextStyle(
                                  fontSize: 18.h,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.blue,
                                ),
                              ),
                              TextSpan(
                                text: ' towards your investment goal.',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50.0.h,
                  ),
                  Stack(
                    // fit: StackFit.,
                    children: [
                      Consumer<TotalValues>(
                        builder: (context, values, child) {
                          return Container(
                            // width: 230.0,
                            height: 230.0,
                            decoration: BoxDecoration(
                              // color: Color(0xff3790ce),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: (snapshot.data != null)
                                    ? NetworkImage(snapshot.data.url)
                                    : AssetImage('assets/images/posmob.png'),
                                colorFilter: (snapshot.data == null)
                                    ? ColorFilter.mode(
                                        Colors.white.withOpacity(0.6),
                                        BlendMode.dstATop)
                                    : null,
                                fit: BoxFit.contain,
                              ),
                            ),
                            child: Ring(
                              color: Colors.black.withOpacity(0.6),
                              color1: Colors.black.withOpacity(0.6),
                              amount: int.parse(_receivedModel.amount),
                              goal: int.parse(_receivedModel.goalAmount),
                            ),
                            // color: Color(0xff3790ce),
                          );
                        },
                      ),
                      // Ring(
                      //   radius: 93,
                      //   innerRadius: 50,
                      //   color: Colors.black.withOpacity(0.6),
                      //   color1: Colors.transparent,
                      // ),
                    ],
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  Container(
                    child: RichText(
                      textAlign: TextAlign.center,
                      // overflow: TextOverflow.visible,
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          height: 1.5,
                          fontSize: 18.h,
                        ),
                        children: [
                          TextSpan(
                            text: 'Earn 150 Bonus Reward Points \n',
                            style: TextStyle(
                              fontSize: 18.0.h,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text:
                                ' everytime you share your savings success with family and friends.',
                            style: TextStyle(
                              fontSize: 18.h,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // GestureDetector(
                      //   ///can appply to all of them
                      //   onTap: () {},
                      //   child: CircleAvatar(
                      //     backgroundImage: AssetImage(
                      //         'assets/images/social/iconlinkedin.png'),
                      //   ),
                      // ),
                      GestureDetector(
                        onTap: () => _share(_SocialMedia.facebook),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                              'assets/images/Social/iconFacebook.png'),
                        ),
                      ),
                      // CircleAvatar(
                      //   backgroundImage: AssetImage(
                      //       'assets/images/social/iconpinterest.png'),
                      // ),
                      GestureDetector(
                        onTap: () => _share(_SocialMedia.twitter),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                              'assets/images/social/icontwitter.png'),
                        ),
                      ),
                      // CircleAvatar(
                      //   backgroundImage: AssetImage(
                      //       'assets/images/social/iconinstagram.png'),
                      // ),
                      GestureDetector(
                        onTap: () => _sendEmail(),
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/social/email-logo.png'),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox.fromSize(
                        size: Size(
                          120.0.w,
                          50.0.h,
                        ),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Color(0xff0e8646),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WinPrizes(
                                            uid: widget.uid,
                                          )));
                            },
                          ),
                          child: Container(
                            child: Text(
                              'Win Prizes',
                              style: TextStyle(
                                fontSize: 17.0.h,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0.w,
                      ),
                      // _validateInputs();
                      // navigateToSetInvestmentGoals(context);
                      SizedBox.fromSize(
                        size: Size(
                          120.0.w,
                          50.0.h,
                        ),
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Color(0xff1ba0fb),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
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
                            () {},
                          ),
                          child: Container(
                            child: Text(
                              'Done',
                              style: TextStyle(
                                fontSize: 17.0.h,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
      ),
    );
  }
}
