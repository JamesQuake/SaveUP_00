import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/pages/new_pages/Last_chance.dart';

class OverdraftReminder extends StatefulWidget {
  final String uid;

  const OverdraftReminder({Key key, this.uid}) : super(key: key);
  // const OverdraftReminder({ Key? key }) : super(key: key);

  @override
  _OverdraftReminderState createState() => _OverdraftReminderState();
}

class _OverdraftReminderState extends State<OverdraftReminder> {
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
          "Overdraft Reminder",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 25.0,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      endDrawer: MainDrawer(uid: widget.uid),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: EdgeInsets.only(top: 13, left: 16, right: 16),
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
                        text:
                            'Your virtual checking account has a negative balance. You must add money to your account to continue playing.',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/Boy2.png',
                    ),
                    fit: BoxFit.cover,
                    alignment: Alignment.centerLeft,
                  ),
                ),
                height: MediaQuery.of(context).size.height - 200,
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
                                        builder: (context) => LastChance(
                                            // uid: widget.uid,
                                            )));
                              },
                            ),
                            child: Container(
                              child: Text(
                                'Add Money\nNOW',
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
                                (states) => Color(0xffe79088).withOpacity(0.5),
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
                                      ? Color(0xffe79088)
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
                                'Add Money\nLater',
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
            ],
          ),
        ),
      ),
    );
  }
}
