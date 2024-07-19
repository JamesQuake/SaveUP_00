import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pay_or_save/assets/custom_button.dart';
// import 'package:pay_or_save/assets/dropdown.dart';
import 'package:pay_or_save/assets/dropdown/expanded_section.dart';
import 'package:pay_or_save/assets/dropdown/scrollbar.dart';
import 'package:pay_or_save/pages/saving_goals.dart';
import 'package:pay_or_save/pages/set_goal_info.dart';
// import 'package:pay_or_save/pages/select_mode.dart';
// import 'package:pay_or_save/pages/sign_in.dart';
// import 'package:pay_or_save/pages/sign_up.dart';

import 'login.dart';
// import 'package:ms_pp/assets/main_drawer.dart';

class HeardFrom extends StatefulWidget {
  final String uid;
  @override
  _HeardFromState createState() => _HeardFromState(uid);
  const HeardFrom({Key key, this.uid}) : super(key: key);
}

class _HeardFromState extends State<HeardFrom> {
  String _uid, _source, howDidHear;
  String isClosed = 'true';
  final firestoreInstance = FirebaseFirestore.instance;

  _HeardFromState(this._uid);
  bool isStrechedDropDown = false;
  int groupValue;
  String title = 'I heard about SaveUp from:';

  List<String> dropList = [
    "Friend or Family",
    "Group, Orgn or Business",
    "Instagram",
    "Facebook",
    "Other Social Media",
    "Google Search",
    'Other',
    "Display friend code",
  ];

  Future navigateToSelectMode(context) async {
    if (_uid != null) {
      forwardUser(_uid).then((value) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => SetGoalInfo(
                      uid: _uid,
                    )));
      });
      // forwardUser(_uid).then((value) => null)
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(
            userFound: false,
          ),
        ),
      );
      print('Something is wrong');
    }
  }

  Future forwardUser(uid) async {
    if (howDidHear == "Friend or family member" ||
        howDidHear == "friend code") {
      firestoreInstance.collection("users").doc(uid).set({
        'friend_code': _source,
        'reward_points': 1650,
        'heard_about_us': howDidHear,
      });
    } else {
      firestoreInstance.collection("users").doc(uid).update({
        'heard_about_us': howDidHear,
      });
    }
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
        title: Text('Sign Up'),
        centerTitle: true,
        elevation: 0.0,
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                // verticalDirection: VerticalDirection.down,
                children: [
                  SizedBox(height: 25.0.h),
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
                                    bottom: BorderSide(
                                        width: 1.0, color: Colors.grey),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 10),
                                              child: Text(
                                                title,
                                                style:
                                                    TextStyle(fontSize: 17.0.h),
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
                                              size: 30.h,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    ExpandedSection(
                                      expand: isStrechedDropDown,
                                      height: 450,
                                      child: MyScrollbar(
                                        dispBar: false,
                                        builder: (context, scrollController2) =>
                                            ListView.builder(
                                          padding: EdgeInsets.all(0),
                                          controller: scrollController2,
                                          shrinkWrap: true,
                                          itemCount: dropList.length,
                                          itemBuilder: (context, index) {
                                            return RadioListTile(
                                              title: Text(
                                                  dropList.elementAt(index)),
                                              activeColor: Color(0xff0070c0),
                                              value: index,
                                              groupValue: groupValue,
                                              onChanged: (val) {
                                                // print(val);
                                                setState(() {
                                                  groupValue = val;
                                                  if (dropList
                                                          .elementAt(index) ==
                                                      "Display friend code") {
                                                    title = "Input friend code";
                                                  } else
                                                    title = dropList
                                                        .elementAt(index);
                                                  // retailer = val;
                                                });

                                                if (isStrechedDropDown ==
                                                    true) {
                                                  if (mounted)
                                                    setState(() {
                                                      isStrechedDropDown =
                                                          false;
                                                      if (mounted)
                                                        switch (val) {
                                                          case 0:
                                                            val =
                                                                'Friend or Family';
                                                            // print(val);
                                                            break;
                                                          case 1:
                                                            val =
                                                                'Group, Orgn or Buisness';
                                                            break;
                                                          case 2:
                                                            val = 'Instagram';
                                                            break;
                                                          case 3:
                                                            val = 'Facebook';
                                                            break;
                                                          case 4:
                                                            val =
                                                                'Other Social Media';
                                                            break;
                                                          case 5:
                                                            val =
                                                                'Google Search';
                                                            break;
                                                          case 6:
                                                            val = 'Other';
                                                            break;
                                                          case 7:
                                                            val =
                                                                "Display friend code";
                                                            break;
                                                          default:
                                                            print(
                                                                'choose an option');
                                                        }
                                                      if (val ==
                                                          "Display friend code") {
                                                        howDidHear =
                                                            "friend code";
                                                      } else
                                                        howDidHear = val;
                                                      print(howDidHear);
                                                    });
                                                }
                                                if (val == "Friend or Family" ||
                                                    val ==
                                                        "Display friend code") {
                                                  setState(() {
                                                    isClosed = 'false';
                                                  });
                                                } else if (val == "Other") {
                                                  setState(() {
                                                    isClosed = 'kind of false';
                                                  });
                                                } else {
                                                  setState(() {
                                                    isClosed = 'true';
                                                  });
                                                }
                                              },
                                            );
                                          },
                                        ),
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
                  SizedBox(
                    height: 30.0.h,
                  ),
                  isClosed == 'kind of false'
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: TextFormField(
                                  // controller: myController,
                                  cursorColor: Colors.black,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    fillColor: Colors.black,
                                    focusColor: Colors.black,
                                    labelText: 'Other',
                                    labelStyle: TextStyle(color: Colors.black),
                                    hintStyle: TextStyle(
                                        fontSize: 20.0.h, color: Colors.white),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.white, width: 2.0),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.black, width: 2.0),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                  onSaved: (value) => howDidHear = value.trim(),
                                  onTap: () {
                                    setState(() {
                                      isStrechedDropDown = false;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0.h,
                            ),
                          ],
                        )
                      : Container(),
                  (isClosed == 'false')
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 0.0,
                          ),
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    hoverColor: Colors.purpleAccent,
                                    icon: Icon(
                                      Icons.help,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      showCodeDialog(context);
                                    },
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 0.0,
                                    vertical: 5.0,
                                  ),
                                  // filled: true,
                                  // fillColor: Colors.grey.withOpacity(0.2),
                                  labelText: 'Friend code:',
                                  // focusColor: Colors.black,
                                  labelStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                ),
                                onSaved: (value) => _source = value.trim(),
                                onTap: () {
                                  setState(() {
                                    isStrechedDropDown = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  // Spacer(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 130.0, vertical: 10.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.resolveWith(
                        (states) => Size(double.infinity, 50)),
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
                      // print("thisss" + _uid);
                      navigateToSelectMode(context);
                      // print('again' + _uid);
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => SelectMode(
                      //               uid: _uid,
                      //             )));
                    },
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 20.0.h,
                      color: Colors.white,
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

  showCodeDialog(BuildContext context) {
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
      content: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.black,
            height: 1.5,
            fontSize: 16,
          ),
          children: [
            TextSpan(
              text: 'When you hear about ',
              style: TextStyle(
                height: 1.4,
              ),
            ),
            TextSpan(
              text: 'SaveUp ',
              style: TextStyle(
                height: 1.4,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text:
                  "from a friend via social media, look for a friend code that's good for an extra 1,000 free Reward Points. (Offer applies to first time users only.)",
              style: TextStyle(
                height: 1.4,
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
}
