import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/pages/new_pages/plan1.dart';
import 'package:pay_or_save/pages/new_pages/plan2.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class AddToAccount extends StatefulWidget {
  // const AddToAccount({ Key? key }) : super(key: key);

  @override
  _AddToAccountState createState() => _AddToAccountState();
}

class _AddToAccountState extends State<AddToAccount> {
  bool test = true;

  @override
  void initState() {
    Provider.of<AuthProvider>(context, listen: false).getOfferingsDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Color(0xffcb0909),
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
      endDrawer: MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 10.0),
        child: Column(
          children: [
            InkWell(
              onTap: ()=> Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Plan1(
                        // uid: widget.uid,
                      ))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Plan 1: STOP Ads',
                    // textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18,
                      // color: Color(0xffcb0909),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
              Divider(
                color: Colors.black,
                thickness: 0.4,
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    height: 1.3,
                    fontSize: 17,
                  ),
                  children: [
                    TextSpan(
                      text: "STOP ADS ",
                      style:
                          TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    TextSpan(
                      text: "and receive",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    TextSpan(
                      text: " 1 reward point ",
                      style:
                          TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    TextSpan(
                      text: "with every virtual dollar that you purchase",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            InkWell(
              onTap: ()=> Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Plan2(
                        // uid: widget.uid,
                      ))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                  'Plan 2: STOP Ads',
                  // textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    // color: Color(0xffcb0909),
                    fontWeight: FontWeight.w800,
                  ),
                ),
            Divider(
              color: Colors.black,
              thickness: 0.4,
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  height: 1.3,
                  fontSize: 17,
                ),
                children: [
                  TextSpan(
                    text: "STOP ADS ",
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  TextSpan(
                    text: "and receive ",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  TextSpan(
                    text: "2 reward points ",
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  TextSpan(
                    text: "with every virtual dollar that you purchase",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
