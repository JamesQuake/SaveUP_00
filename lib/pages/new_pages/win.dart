import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/pages/new_pages/place_order.dart';
import 'package:pay_or_save/pages/new_pages/reward_points.dart';
import 'package:provider/provider.dart';

import '../../models/sweepstake_setup.dart';
import '../../providers/total_provider.dart';
import 'acquire_reward_points.dart';
import 'add_to_account.dart';
import '../../models/sweepstake_entry.dart';

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
  SweepstakeSetup _currentSweepstake;
  bool _isLoading = true;
  String _error;

  @override
  void initState() {
    super.initState();
    _getRewardPointBal();
    _loadSweepstakeData();
  }

  Future<void> _loadSweepstakeData() async {
    try {
      final sweepstakeDoc = await firestoreInstance
          .collection('sweepstake_setup').doc('sweepstake_setup')
          // .orderBy('updated_at', descending: true)
          // .limit(1)
          .get();

      if (!sweepstakeDoc.exists) {
        setState(() {
          _error = 'No active sweepstakes available';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _currentSweepstake = SweepstakeSetup.fromFirestore(sweepstakeDoc.data());
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load sweepstakes data';
        _isLoading = false;
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
        title: Text(
          'Win Amazing Prizes',
          style: TextStyle(fontSize: 25.h),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      endDrawer: MainDrawer(uid: widget.uid),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(20.0),
                  child: Consumer<TotalValues>(
                    builder: (context, details, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Text(
                                    '${details.getName}, You have',
                                    style: TextStyle(
                                      fontSize: 18.h,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    NumberFormat.decimalPattern('en-us')
                                        .format(details.getRewardPoint),
                                    style: TextStyle(
                                      fontSize: 32.h,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff0070c0),
                                    ),
                                  ),
                                  Text(
                                    'Reward Points',
                                    style: TextStyle(
                                      fontSize: 18.h,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          if (_currentSweepstake != null) ...[                            
                            Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  if (_currentSweepstake.image.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15),
                                      ),
                                      child: Image.network(
                                        _currentSweepstake.image,
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _currentSweepstake.title,
                                          style: TextStyle(
                                            fontSize: 24.h,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          _currentSweepstake.description,
                                          style: TextStyle(fontSize: 16.h),
                                        ),
                                        SizedBox(height: 16),
                                        _buildInfoRow(
                                          'Entry Deadline',
                                          DateFormat.yMMMd().format(_currentSweepstake.entryDeadline),
                                        ),
                                        _buildInfoRow(
                                          'Drawing Date',
                                          DateFormat.yMMMd().format(_currentSweepstake.drawingDate),
                                        ),
                                        _buildInfoRow(
                                          'Required Points',
                                          '${NumberFormat.decimalPattern().format(_currentSweepstake.requiredRewardsPoints)} points',
                                        ),
                                        SizedBox(height: 24),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: details.getRewardPoint >= _currentSweepstake.requiredRewardsPoints
                                                    ? () => _enterSweepstakes(context, details.getName)
                                                    : null,
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color(0xff0070c0),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  minimumSize: Size(0, 50),
                                                ),
                                                child: Text(
                                                  'Enter Drawing',
                                                  style: TextStyle(fontSize: 18.h),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: TextButton(
                                                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/starting', (route) => false),
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors.grey[200],
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  minimumSize: Size(0, 50),
                                                ),
                                                child: Text(
                                                  'Skip Drawing',
                                                  style: TextStyle(
                                                    fontSize: 18.h,
                                                    color: Colors.grey[800],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.h,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.h,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  _getRewardPointBal() async {
    var prov = Provider.of<TotalValues>(context, listen: false);
    await prov.getRewardPointBal(widget.uid);
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
                            builder: (context) => AddToAccount(
                                // uid: widget.uid,
                                )));
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => AcquirePoints(
                      //               uid: widget.uid,
                      //             )));
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

  Future<Map<String, dynamic>> _getCurrentUserData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      
      if (!doc.exists) {
        throw Exception('User data not found');
      }
      
      return doc.data();
    } catch (e) {
      print('Error fetching user data: $e');
      throw e;
    }
  }
  Future<void> _enterSweepstakes(BuildContext context, String displayName) async {
    try {
      EasyLoading.show(status: 'Entering drawing...');
      
      // Check if user has already entered any drawing
      final existingEntry = await firestoreInstance
          .collection('sweepstakes_entries')
          .where('userId', isEqualTo: widget.uid)
          .get();

      if (existingEntry.docs.isNotEmpty) {
        EasyLoading.showError('You have already entered the drawing');
        return;
      }

      // Get user data
      final userData = await _getCurrentUserData();
      
      // Create sweepstakes entry using the model
      final entry = SweepstakeEntry(
        userId: widget.uid,
        fullName: displayName,
        userEmail: userData['email'] ?? '',
        optedInAt: DateTime.now(),
        hasWon: false,
        additionalData: {
          'rewardPoints': userData['reward_points'] ?? 0,
        }
      );

      // Add entry to Firestore
      await firestoreInstance.collection('sweepstakes_entries')
          .add(entry.toJson());

      // Deduct points from user's account
      await firestoreInstance.collection('users').doc(widget.uid).update({
        'reward_points': FieldValue.increment(-_currentSweepstake.requiredRewardsPoints)
      });

      EasyLoading.showSuccess('Successfully entered the drawing!');
      
      // Refresh reward points
      await _getRewardPointBal();

      // In _enterSweepstakes method, replace the navigation line with:
      // After success message
      await Future.delayed(Duration(milliseconds: 500));
      Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(context, '/starting', (route) => false);
      
    } catch (e) {
      print('Error entering sweepstakes: $e');
      EasyLoading.showError('Failed to enter drawing. Please try again.');
    }
  }
}

