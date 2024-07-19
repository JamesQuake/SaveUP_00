import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/pages/new_pages/place_order.dart';
import 'package:pay_or_save/pages/new_pages/reward_points.dart';
import 'package:provider/provider.dart';

import '../../providers/total_provider.dart';
import 'acquire_reward_points.dart';

class WinPrizes extends StatefulWidget {
  final String uid;

  const WinPrizes({Key key, this.uid}) : super(key: key);

  // const WinPrizes({ Key? key }) : super(key: key);

  @override
  _WinPrizes createState() => _WinPrizes();
}

class _WinPrizes extends State<WinPrizes> {
  final firestoreInstance = FirebaseFirestore.instance;
  int _rewardPoints;
  String name;
  // int amount = 100;
  // var _newAmount = '\$' + amount;

  @override
  void initState() {
    super.initState();
    _getRewardPointBal();
    // print(widget.uid);
  }

  _getRewardPointBal() async {
    var prov = Provider.of<TotalValues>(context, listen: false);
    await prov.getRewardPointBal(widget.uid);
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
          'Win Amazing Prices',
          style: TextStyle(
            fontSize: 25.h,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      endDrawer: MainDrawer(uid: widget.uid),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
        child: Consumer<TotalValues>(
          builder: (context, details, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  details.getName +
                      ". You have " +
                      details.getRewardPoint.toString() +
                      " points",
                  style: TextStyle(
                    color: Colors.black,
                    height: 1.5,
                    fontSize: 18.h,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 20.0.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: RichText(
                        // overflow: TextOverflow.visible,
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            height: 1.5,
                            fontSize: 18.h,
                          ),
                          children: [
                            TextSpan(
                              text: 'Enter Drawing to Win:',
                              style: TextStyle(
                                fontSize: 19.0.h,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0.h,
                ),
                Container(
                  width: 320.0.w,
                  height: 220.0.h,
                  decoration: BoxDecoration(
                    // color: Color(0xff3790ce),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(9.0),
                  ),
                  child: Image.asset('assets/images/amazonnew.jpg'),
                  // color: Color(0xff3790ce),
                ),
                SizedBox(
                  height: 30.h,
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
                          text: 'Entry Deadline: ',
                          style: TextStyle(
                            fontSize: 18.0.h,
                          ),
                        ),
                        TextSpan(
                          text: ' Sept 15, 2021',
                          style: TextStyle(
                            fontSize: 18.h,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                          text: 'Drawing Date: ',
                          style: TextStyle(
                            fontSize: 18.0.h,
                          ),
                        ),
                        TextSpan(
                          text: ' Sept 16, 2021',
                          style: TextStyle(
                            fontSize: 18.h,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0.h,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  child: Container(
                    child: Text(
                      'To enter drawing, you must have at least 1,500 reward points. Drawings are held weekly. Winner(s) will be notified by email.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 15.h,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 130.0.w,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Color(0xff0e8646),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
                          // fixedSize: MaterialStateProperty.resolveWith((states)=> Size(width, height))
                        ),
                        onPressed: () => Timer(
                          const Duration(milliseconds: 400),
                          () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => RewardPoints(
                            //             // uid: widget.uid,
                            //             )));
                            if (details.getRewardPoint < 1500) {
                              _showRewardPointNotice(
                                  context, details.getRewardPoint);
                            } else{
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RewardPoints(
                                        uid: widget.uid,
                                      )));
                              // Navigator.pushNamedAndRemoveUntil(context, '/starting', (route) => false);
                            }
                          },
                        ),
                        child: Text(
                          'Enter\nDrawing',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17.0.h,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0.w,
                    ),
                    // _validateInputs();
                    // navigateToSetInvestmentGoals(context);
                    SizedBox(
                      width: 130.0.w,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Color(0xff1ba0fb),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => PlaceOrder(
                            //               uid: widget.uid,
                            //             )));
                          },
                        ),
                        child: Container(
                          child: Text(
                            'Skip\nDrawing',
                            textAlign: TextAlign.center,
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
          },
        ),
      ),
    );
  }

  _showRewardPointNotice(BuildContext context, amount) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      elevation: 24.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      contentPadding: EdgeInsets.zero,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 16.h,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 20.0),
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
                    text: 'You have ',
                    style: TextStyle(
                      fontSize: 18.h,
                    ),
                  ),
                  // (_overdraftAmount <= 0) ?
                  TextSpan(
                    text: amount.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' reward points.',
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextSpan(
                    text:
                        ' To enter drawing for fabulous prizes, you need at least ',
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextSpan(
                    text: '1,500 points',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '.',
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        ),
                  ),
                  // WidgetSpan(
                  //   alignment: PlaceholderAlignment.middle,
                  //   child: IconButton(
                  //     padding: EdgeInsets.zero,
                  //     constraints: BoxConstraints(
                  //       minWidth: 0.0,
                  //       minHeight: 0.0,
                  //     ),
                  //     splashRadius: 18.0,
                  //     icon: Icon(
                  //       Icons.help,
                  //       color: Colors.black,
                  //     ),
                  //     onPressed: () {},
                  //   ),
                  // ),
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
            'assets/images/Kid.png',
            height: 489.0.h,
            // width: 500.0,
            fit: BoxFit.cover,
            alignment: Alignment(-0.6, 0.0),
          ),
        ],
      ),
      actions: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox.fromSize(
                size: Size(
                  130.0.w,
                  53.0.h,
                ),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Color(0xff11a858),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
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
                              builder: (context) => AcquirePoints(
                                    uid: widget.uid,
                                  )));
                    },
                  ),
                  child: Container(
                    child: Text(
                      'Acquire Points',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0.h,
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
                  130.0.w,
                  53.0.h,
                ),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Color(0xff000000),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    overlayColor: MaterialStateProperty.resolveWith(
                      (states) {
                        return states.contains(MaterialState.pressed)
                            ? Colors.grey
                            : null;
                      },
                    ),
                  ),
                  onPressed: () => Timer(
                    const Duration(milliseconds: 400),
                    () {
                      Navigator.pushNamedAndRemoveUntil(context, '/starting', (route) => false);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => PlaceOrder(
                      //             // uid: widget.uid,
                      //             )));
                    },
                  ),
                  child: Container(
                    child: Text(
                      'Skip\nDrawing',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0.h,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
}
