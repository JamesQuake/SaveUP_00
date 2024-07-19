import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/pages/new_pages/acquire_reward_points.dart';
import 'package:pay_or_save/pages/new_pages/place_order.dart';

class RewardPoints extends StatefulWidget {
  final String uid;

  const RewardPoints({Key key, this.uid}) : super(key: key);
  // const RewardPoints({ Key? key }) : super(key: key);

  @override
  _RewardPointsState createState() => _RewardPointsState();
}

class _RewardPointsState extends State<RewardPoints> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffcb0909),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // actions: <Widget>[
        //   MyManue.childPopup(context)
        // ],
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          "Reward Points Notice",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 25.0,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      // height: MediaQuery.of(context).size.height - 75,
      // decoration: BoxDecoration(
      //       image: DecorationImage(
      //           image: AssetImage(
      //             'assets/images/ppic.jpg',
      //           ),
      //           fit: BoxFit.fill),
      //     ),
      endDrawer: MainDrawer(uid: widget.uid),
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: RichText(
                // overflow: TextOverflow.visible,
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    height: 1.5,
                    fontSize: 18,
                  ),
                  children: [
                    TextSpan(
                      text: 'WARNING. ',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17.0,
                        color: Color(0xffcb0909),
                      ),
                    ),
                    TextSpan(
                      text: 'Your have ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    TextSpan(
                      text: 'XXX ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          'reward points. To enter drawing for fabulous prizes, you need at least ',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: '1,500 points',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Image.asset('assets/images/ppic.jpg'),
            // SizedBox(
            //   height: 30,
            // ),
            Container(
              height: MediaQuery.of(context).size.height - 170,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/Kid.png',
                  ),
                  fit: BoxFit.cover,
                  alignment: Alignment.centerLeft,
                ),
              ),
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16.0),
                height: MediaQuery.of(context).size.height - 260,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox.fromSize(
                          size: Size(
                            130.0,
                            53.0,
                          ),
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                (states) => Color(0xffcb0909),
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
                                      ? Colors.red
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
                                            // uid: widget.uid,
                                            )));
                              },
                            ),
                            child: Container(
                              child: Text(
                                'Acquire\nReward Points',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 17.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        // _validateInputs();
                        // navigateToSetInvestmentGoals(context);
                        SizedBox.fromSize(
                          size: Size(
                            130.0,
                            53.0,
                          ),
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                (states) => Color(0xffcb0909),
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
                                      ? Colors.red
                                      : null;
                                },
                              ),
                            ),
                            onPressed: () => Timer(
                              const Duration(milliseconds: 400),
                              () {
                                Navigator.pop(context);
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
                                  fontSize: 17.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
