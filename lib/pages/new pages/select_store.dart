import 'package:flutter/material.dart';
import 'dart:async';

import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/assets/dropdown/new_dropdown.dart';

class SelectStore extends StatefulWidget {
  final String uid;

  const SelectStore({Key key, this.uid}) : super(key: key);
  // const SelectStore({ Key? key }) : super(key: key);

  @override
  _SelectStoreState createState() => _SelectStoreState();
}

class _SelectStoreState extends State<SelectStore> {
  List<RadioListTile> radioButton = [];

  String retailer;
  String _selected;
  String _select = '';
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
          'Select Store',
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      endDrawer: MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          17.0,
          18.0,
          17.0,
          16.0,
        ),
        child: Column(
          children: [
            ///check the drop title in widget if it breaks code
            NewDropDown(
              dropTitle: 'Where would you like to Shop?',
              dropList: [
                'Amazon',
                'eBay',
                'Apple',
                'CostCo',
                'Home Depot',
                'QVC',
                'Target',
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            NewDropDown(
              dropList: [
                'Game. Play with virtual money',
                'Live. Use real dollars',
              ],
              dropTitle: 'Select Mode',
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                    // navigateToSetSavingGoals(context);
                  },
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                // color: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
