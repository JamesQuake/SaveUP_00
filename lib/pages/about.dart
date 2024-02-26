// import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pay_or_save/utilities/validator.dart';
import 'package:pay_or_save/widgets/menu.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  double _boxHeight = 16.h;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[MyManue.childPopup(context)],
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Saving and Investing"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: _boxHeight,
              ),
              Text(
                  "Saving and investing are both crucial to your financial health, but they are not the same."),
              SizedBox(
                height: _boxHeight,
              ),
              Text(
                "Savings",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: _boxHeight,
              ),
              Text(
                  "When you save, you put money in a safe place – like a savings account or CD – where is can be easily accessed for future use."),
              SizedBox(
                height: _boxHeight,
              ),
              Text(
                "Savings Goals",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: _boxHeight,
              ),
              Text(
                  "Most people typically save for things like a vacation, furniture, or a down payment for a home, which they’d like to purchase within the next few months or years."),
              SizedBox(
                height: _boxHeight,
              ),
              Text(
                "Saving Rewards",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: _boxHeight,
              ),
              Text(
                  "While savings are safe, they pay low – or no – interest rates."),
              SizedBox(
                height: _boxHeight,
              ),
              Text(
                "Investing. Make Your Money Work for You",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: _boxHeight,
              ),
              Text(
                  "Investors buy assets that have the potential to generate an acceptable rate of return over time."),
              SizedBox(
                height: _boxHeight,
              ),
              Text(
                  "While investing can make more money than savings, it also involves more risk because typical investment vehicles like stocks, bonds, and real estate go up and down in value."),
              SizedBox(
                height: _boxHeight,
              ),
              Text(
                "Investment Goals",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: _boxHeight,
              ),
              Text(
                  "In spite of fluctuations, markets generally trend up over time.  As a result,  most people invest to achieve long-term financial goals like saving for a child’s education or retirement."),
              SizedBox(
                height: _boxHeight,
              ),
              Text(
                "Strike the Right Balance",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: _boxHeight,
              ),
              Text(
                  "Before investing, fund your rainy-day fund with at least 3-6 months of living expenses."),
              SizedBox(
                height: _boxHeight,
              ),
              Text(
                  "Then evaluate the risk/reward trade-off.  How much risk can you tolerate to gain acceptable returns and still sleep at night?  Balance your investments accordingly."),
              SizedBox(
                height: _boxHeight,
              ),
              Text(
                  "For more information on saving, investing, and achieving your long-term financial goals, read The \$500 Cup of Coffee, co-authored by Steven Lome, the developer of this app."),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
