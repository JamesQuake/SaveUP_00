import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/models/saving_goal_model.dart';
import 'package:pay_or_save/providers/total_provider.dart';
import 'package:pay_or_save/widgets/ring.dart';
import 'package:pay_or_save/widgets/ring_shadow.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'new_pages/win.dart';
// import 'package:pay_or_save/providers/total_provider.dart';
// import 'package:provider/provider.dart';

enum SocialMedia { facebook, twitter, instagram, email }

class CongratsSaving extends StatefulWidget {
  final String uid;
  final String modelId;
  final SavingModel incomingModel;
  final String savedAmount;

  const CongratsSaving(
      {Key key, this.incomingModel, this.uid, this.modelId, this.savedAmount})
      : super(key: key);
  // const CongratsInvestment({ Key? key }) : super(key: key);

  @override
  _CongratsSaving createState() => _CongratsSaving();
}

class _CongratsSaving extends State<CongratsSaving> {
  int amount = 100;
  final firestoreInstance = FirebaseFirestore.instance;
  SavingModel receivedModel;
  Future<SavingModel> _refModel;
  Size _widgetSize;
  final key = GlobalKey();
  bool _isTapped = false;
  // = context.getSize();

  // Get the height of the widget in pixels
  double _widgetHt = 230.0.h;
  //  = size.height;

  // var _newAmount = '\$' + amount;

  @override
  void initState() {
    super.initState();
    // _getRewardPointBal();
    _refModel = getModelInfo();
  }
  // Enum

//add # to payorsave, change url
  Future share(SocialMedia socialPlatform) async {
    final subject = 'SaveUp';
    final text = "I just saved " +
        NumberFormat.simpleCurrency(locale: "en-us", decimalDigits: 2)
            .format(double.parse(widget.savedAmount)) +
        " using SaveUp, the shopping app that makes savings fun. I'd bet that it save you money too. \n\nCheck it out and receive 1000 free reward point toward valuable prizes by entering friend code 2020 when you download the app.";
    final urlShare = Uri.encodeComponent('https://www.saveupnow.biz');
    final urls = {
      SocialMedia.facebook:
          'https://www.facebook.com/sharer/sharer.php?u=$urlShare&t=$text',
      SocialMedia.twitter:
          'https://www.twitter.com/intent/tweet?text=$text\n\n$urlShare',
      // SocialMedia.email: 'mailto:?subject=$subject&body=$text\n',
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
    final urlShare = Uri.decodeComponent('www.saveupnow.biz');
    final text = "I just saved " +
        NumberFormat.simpleCurrency(locale: "en-us", decimalDigits: 2)
            .format(double.parse(widget.savedAmount)) +
        " using SaveUp, the shopping app that makes savings fun. I'd bet that it can help save you money too. \n\nCheck it out and receive 1000 free reward point toward valuable prizes by entering friend code 2020 when you download the app.";
    final Uri launchUri = Uri(
      scheme: 'mailto',
      // path: 'smith@example.com',
      query: encodeQueryParameters(<String, String>{
        "subject": "SaveUp",
        'body': text + "\n\n$urlShare",
      }),
    );
    await launchUrl(launchUri);
  }

  // final Uri emailLaunchUri = Uri(
  //   scheme: 'mailto',
  //   path: 'smith@example.com',
  //   query: encodeQueryParameters(<String, String>{
  //     'subject': 'Example Subject & Symbols are allowed!',
  //   }),
  // );

  Future<SavingModel> getModelInfo() async {
    if (widget.modelId != null && widget.uid != null) {
      print('getModelInfo');
      print('widget.uid -> ${widget.uid}');
      print('widget.modelId -> ${widget.modelId}');
      var modelInstance = await firestoreInstance
          .collection("savingGoals")
          .doc("users")
          .collection(widget.uid)
          .doc((widget.modelId).trim())
          .get();
          print('modelInstance.data() -> ${modelInstance.data()}');
      receivedModel =
          SavingModel.fromJson(modelInstance.id, modelInstance.data());
          print('receivedModel.amount _> ${receivedModel.amount}');
          print('receivedModel.goalAmount _> ${receivedModel.goalAmount}');
      // dec[];

      // print(dec);
    } else {
      if (widget.modelId == null) print('model ID is empty');
      if (widget.uid == null) print('uid is empty');
    }
    // modelInstance['amount'];
    return receivedModel;
  }

  @override
  Widget build(BuildContext context) {
    // var savingModelProvider = Provider.of<TotalValues>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        /*leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
          // onPressed: () {
          //   getModelInfo();
          // },
        ),*/
        automaticallyImplyLeading: false,
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
            future: _refModel,
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: Text('Please wait...'));
              } else if(snapshot.hasError){
                return Center(child: Text('Something went wrong...'));
              } else 
              return Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40.0.w,
                        height: 40.0.h,
                        decoration: BoxDecoration(
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
                              text: 'Congratulations! You have just saved ',
                              style: TextStyle(
                                fontSize: 17.0.h,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: NumberFormat.simpleCurrency(
                                      locale: "en-us", decimalDigits: 2)
                                  .format(double.parse(widget.savedAmount)),
                              style: TextStyle(
                                fontSize: 18.h,
                                fontWeight: FontWeight.w700,
                                color: Colors.blue,
                              ),
                            ),
                            TextSpan(
                              text: ' towards your savings goal.',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )),
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
                            child: GestureDetector(
                              onTapDown: (TapDownDetails details) {
                                  // This function is called when the user taps down on the widget
                                  setState(() => _isTapped = true);
                                },
                                onTapUp: (TapUpDetails details) {
                                  // This function is called when the user releases the tap on the widget
                                  setState(() => _isTapped = false);
                                },
                                onTapCancel: () {
                                  // This function is called when the user moves their finger away from the widget without releasing
                                  setState(() => _isTapped = false);
                                },
                              child: Ring(
                                innerColor: Colors.white.withOpacity(0.6),
                                outerColor: _isTapped ? Colors.transparent : Colors.black.withOpacity(0.6),
                                amount: int.parse(receivedModel.amount),
                                goal: int.parse(receivedModel.goalAmount),
                                minInnerSize: 0.10,
                                size: 230,
                              ),
                            ),
                          );
                        },
                      ),
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
                      GestureDetector(
                        onTap: () => share(SocialMedia.facebook),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                              'assets/images/Social/IconFacebook.png'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => share(SocialMedia.twitter),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                              'assets/images/Social/IconTwitter.png'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _sendEmail();
                        },
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/emailicon.png'),
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
                            () {
                              Navigator.pushNamedAndRemoveUntil(context, '/starting', (route) => false);
                            },
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
