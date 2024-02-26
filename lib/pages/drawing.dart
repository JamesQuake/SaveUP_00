import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pay_or_save/pages/dashboard.dart';
import 'package:pay_or_save/pages/virtual_closet.dart';
import 'package:pay_or_save/services/services.dart';
import 'package:pay_or_save/utilities/validator.dart';
import 'package:pay_or_save/widgets/menu.dart';

class Drawing extends StatefulWidget {
  final String uid;

  @override
  _DrawingState createState() => _DrawingState(uid);

  Drawing({Key key, @required this.uid}) : super(key: key);
}

class _DrawingState extends State<Drawing> {
  String _uid;
  final firestoreInstance = FirebaseFirestore.instance;

  _DrawingState(this._uid);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future navigateToVirtualCloset(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VirtualCloset(
                  uid: _uid,
                )));
  }

  Future navigateToDashboard(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DashBoard(
                  uid: _uid,
                )));
  }

  _enterDrawing() {
    MainServices.onLoading(context);
    firestoreInstance.collection("drawings").doc("users").collection(_uid).add({
      'uid': _uid,
      'created': DateTime.now().millisecondsSinceEpoch.toString(),
    }).then((value) {
      Navigator.pop(context);
      Validator.onErrorDialog("Entered", context);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[MyManue.childPopup(context)],
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Win Amazing Prizes"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 200.h,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/amazon.jpg"),
                        fit: BoxFit.cover)),
              ),
              SizedBox(
                height: 16.h,
              ),
              Text(
                "Win: \$150 Amazon Gift Card",
                style: TextStyle(fontSize: 18.h),
              ),
              SizedBox(
                height: 16.h,
              ),
              Text(
                "Entry Deadline:  June 21, midnight",
                style: TextStyle(fontSize: 18.h),
              ),
              SizedBox(
                height: 16.h,
              ),
              Text(
                "Drawing Date: June 22, 2020",
                style: TextStyle(fontSize: 18.h),
              ),
//              SizedBox(height: 32,),
//              Text("Earn 150 bonus Reward Points by telling your friends and family about Pay or Save", style: TextStyle(fontSize: 18),),
//              SizedBox(height: 32,),
//              Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  ButtonTheme(
//                    minWidth: 100.0,
//                    height: 50.0,
//                    child: RaisedButton(
//                      textColor: Colors.white,
//                      color: Colors.deepPurple,
//                      child: Text("Share"),
//                      onPressed: () {
//                        navigateToVirtualCloset(context);
//                      },
//                      shape: new RoundedRectangleBorder(
//                        borderRadius: new BorderRadius.circular(10.0),
//                      ),
//                    ),
//                  ),
//                ],
//              ),
              SizedBox(
                height: 50.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 0.0, right: 0.0),
                    child: ButtonTheme(
                      minWidth: 300.0.w,
                      height: 50.0.h,
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Color(0xFF660066),
                        child: Text("Next"),
                        onPressed: () {
                          navigateToDashboard(context);
                        },
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 0.0, right: 0.0),
                    child: ButtonTheme(
                      minWidth: 300.0.w,
                      height: 50.0.h,
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Color(0xFF660066),
                        child: Text("Enter Drawing"),
                        onPressed: () {
                          _enterDrawing();
                        },
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
