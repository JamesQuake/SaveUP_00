import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
// import 'package:pay_or_save/assets/buttonting.dart';
import 'package:pay_or_save/assets/dropdown/expanded_section.dart';
import 'package:pay_or_save/assets/dropdown/scrollbar.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
// import 'package:pay_or_save/assets/sig_row.dart';
import 'package:pay_or_save/models/investment_goal_model.dart';
import 'package:pay_or_save/pages/about.dart';
import 'package:pay_or_save/pages/starting_balances.dart';
// import 'package:pay_or_save/pages/starting_balances.dart';
import 'package:pay_or_save/providers/total_provider.dart';
import 'package:pay_or_save/services/services.dart';
import 'package:pay_or_save/utilities/validator.dart';
// import 'package:pay_or_save/widgets/menu.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'edit_investment_goal.dart';

class InvestmentGoals extends StatefulWidget {
  final String uid;
  final String incomingRoute;
  @override
  _InvestmentGoalsState createState() => _InvestmentGoalsState(uid);

  InvestmentGoals({Key key, @required this.uid, this.incomingRoute})
      : super(key: key);
}

class _InvestmentGoalsState extends State<InvestmentGoals> {
  String _uid,
      _investFor,
      _other,
      _investAmount,
      _investTime,
      _fileURL,
      _path,
      _fileName,
      _extension;
  ScrollController _scrollController;
  Map<String, String> _paths;
  bool _loadingPath = false;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickingType;
  int numberItems = 0;
  bool isClosed = true;
  final myController = TextEditingController();
  final invAmt = TextEditingController();
  final firestoreInstance = FirebaseFirestore.instance;
  final GlobalKey<FormState> _inputFormKey = GlobalKey<FormState>();

  bool isStrechedDropDown = false;
  int groupValue;
  String title = '';
  String timeTitle = '';
  int group2Value;
  bool isStrechedDropDown2 = false;
  String newVal;
  List<InvestmentModel> _goalInvest;
  Future<List<InvestmentModel>> _goalFuture;
  List investTotalList;
  int investTotal;
  int _totalValue;
  String investmentRoute = '/investment';
  Future<int> initProvider;
  SharedPreferences _prefs;

  // String _nativeRoute = ''

  List<String> dropList = [
    'Business Startup',
    'Education',
    'General',
    'Legacy',
    'Retirement',
    'Wealth Building',
    'Other',
    'No goal at this time',
  ];
  List<String> secondDropList = [
    '3 years',
    '5 years',
    '10 years',
    '15 years',
    '20 years',
    '25 years',
    '30 years',
    '35 years',
    '40 years',
    '45 years',
  ];

  // var itemsIcons = {
  //   'Car': 'Car',
  //   'Computer': 'Computer',
  //   'Education': 'Education',
  //   'Emergency found': 'Emergency found',
  //   'Electronics': 'Electronics',
  //   'Furnishings': 'Furnishings',
  //   'General': 'General',
  //   'Home': 'Home',
  //   'Start a business': 'Start a business',
  //   'Vacation': 'Vacation',
  //   'Wedding': 'Wedding',
  //   'Other': 'Other'
  // };

  // var itemsIcons = {
  //   'Education': 'Education',
  //   'General': 'General',
  //   'Home': 'Home',
  //   'Start a business': 'Start a business',
  //   'Wedding': 'Wedding',
  //   'Other': 'Other'
  // };

  // '',
  // 'Education',
  // 'Home Purchase',
  // 'General'
  // 'Legacy',
  // 'Retirement',
  // 'No Specific Goal',
  // 'Other',

  var itemsIcons = {
    'Education':
        'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FEducation.png?alt=media&token=3fba9b33-0ad3-403c-8921-fd7090cda3d4',
    'General Investment':
        'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FGeneral.png?alt=media&token=03dfe2a4-2b14-41f0-b4e7-c059bc9d1e8b',
    'Home':
        'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FHome.png?alt=media&token=d5b66d28-3302-4904-9f5c-4b0b4bfcc987',
    'Legacy':
        'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FLegacy.png?alt=media&token=9c3c5fed-724e-4835-8490-1fa09d1d9045',
    'Retirement':
        'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FRetirement.png?alt=media&token=3ea89e82-0c31-4397-8ef3-4b2a98dc04e5',
    'Start a Business':
        'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FBusiness.png?alt=media&token=6f9deeb6-3892-4b95-b34f-120553d9fecd',
    'Other':
        'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FOther.png?alt=media&token=61ab369f-0da5-47cd-8d85-b90bca35e15d',
    'No goal at this time':
        'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FGeneral.png?alt=media&token=03dfe2a4-2b14-41f0-b4e7-c059bc9d1e8b',
  };

  _InvestmentGoalsState(this._uid);

  // func() async {
  //   TotalValues _totalValues = Provider.of<TotalValues>(context, listen: false);
  //   await _totalValues.getInvestTotal(widget.uid);
  // }

  @override
  void initState() {
    // SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
    _scrollController = ScrollController();
    _refreshProvider(context);
    // getItems();
    // initProvider = Provider.of<TotalValues>(context, listen: false)
    //     .getInvestTotal(widget.uid);
    // _goalInvest = List<InvestmentModel>();
    // _goalFuture = getInvestmentItems();
    // _getTotal();
    // _totalValue = 0;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    invAmt.dispose();
    myController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.jumpTo(0);
  }

  Future navigateToAbout(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
  }
  // _launchURL() async {
  // const url = 'https://flutter.io';
  // if (await canLaunch(url)) {
  //   await launch(url);
  // } else {
  //   throw 'Could not launch $url';
  // }

  // _launchUrl() async {
  //   const _url =
  //       "https://www.amazon.com/500-Cup-Coffee-Lifestyle-Independence-ebook/dp/B01ETYC3PW/ref=sr_1_6?crid=3GLRJ9JN6MGDB&keywords=500+cup+of+coffee&qid=1643138839&sprefix=500+cup+of+coffee%2Caps%2C67&sr=8-6";
  //   if (await canLaunch(_url)) {
  //     await launch(_url);
  //   } else {
  //     throw "Could not launch $_url";
  //   }
  // }

  Future navigateToStartingBalances(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StartingBalances(
                  uid: _uid,
                  incomingRoute: investmentRoute,
                )));
  }

  Future navigateEditInvestmentGoal(
      context, InvestmentModel model, String route) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditInvestmentGoal(
                  uid: _uid,
                  investmentModel: model,
                  route: investmentRoute,
                )));
  }

  void _validateInputs() {
    if (_inputFormKey.currentState.validate()) {
      //    If all data are correct then save data to out variables
      if (_investTime != null && _investFor != null) {
        _inputFormKey.currentState.save();
        _saveGoal(context);
      } else {
        Validator.onErrorDialog(
            "Make sure you provide all information", context);
      }
    } else {
//    If all data are not valid then start auto validation.
      Validator.onErrorDialog("Make sure you provide all information", context);
    }
  }

  void _setAnotherGoalAndValidate() {
    //    If all data are correct then save data to out variables
    if (_investTime != null && _investFor != null && _investAmount != null) {
      if (_inputFormKey.currentState.validate())
        _inputFormKey.currentState.save();
      // _inputFormKey.currentState.build();
      // _goalItem(context, index);
      _saveGoal(context);
      setState(() {
        isStrechedDropDown = true;
      });
    } else {
      setState(() {
        title = '';
        timeTitle = '';
        groupValue = null;
        _investFor = null;
        _investTime = null;
        _investAmount = null;
        _inputFormKey.currentState?.reset();
        _path = null;
        isStrechedDropDown = true;
        isStrechedDropDown2 = false;
      });
    }
  }

  Future<int> getItems() async {
    return firestoreInstance
        .collection("investmentGoals")
        .doc('users')
        .collection(_uid)
        .get()
        .then((querySnapshot) {
      numberItems = querySnapshot.docs.length;
      return querySnapshot.docs.length;
    });
  }

  _saveGoal(context) {
    if (numberItems < 5) {
      MainServices.onLoading(context);
      if (_path != null) {
        uploadFile().then((value) {
          // print("na value:/");
          // print(value);
          firestoreInstance
              .collection("investmentGoals")
              .doc("users")
              .collection(_uid)
              .add({
            'investFor': _investFor,
            'investAmount': 0,
            'investGoal': _investAmount,
            'investTime': _investTime,
            'defaultIcon': (_investFor == 'Other') ? '' : _investFor,
            'photo': (_fileURL != null)
                ? _fileURL
                : (itemsIcons.containsKey(_investFor))
                    ? itemsIcons[_investFor]
                    : itemsIcons['Other'],
            'created': DateTime.now().millisecondsSinceEpoch,
          }).then((value) async {
            var _investGoalDocId = value.id;
            await firestoreInstance
                .collection("investmentGoals")
                .doc("users")
                .collection(_uid)
                .doc(_investGoalDocId)
                .update({
              'goalId': _investGoalDocId,
            });
            if (mounted)
              setState(() {
                title = '';
                timeTitle = '';
                groupValue = null;
                group2Value = null;
              });
            Navigator.pop(context);
            // _getTotal();
            _refreshProvider(context);
            // Validator.onErrorDialog("Saved", context);
            // print("legodi");
            // print(_inputFormKey.currentState);
            if (mounted)
              setState(() {
                myController.text = '';
                isClosed = true;
                _investFor = null;
                _investTime = null;
                _fileURL = null;
                // _goalFuture = getInvestmentItems();
              });
            _inputFormKey.currentState?.reset();
            _path = null;
            numberItems = numberItems + 1;
          });
        });
      } else {
        firestoreInstance
            .collection("investmentGoals")
            .doc("users")
            .collection(_uid)
            .add({
          'investFor': _investFor,
          'investAmount': 0,
          'investGoal': _investAmount,
          'investTime': _investTime,
          'defaultIcon': (_investFor == 'Other') ? '' : _investFor,
          'photo': (_fileURL != null)
              ? _fileURL
              : (itemsIcons.containsKey(_investFor))
                  ? itemsIcons[_investFor]
                  : itemsIcons['Other'],
          'created': DateTime.now().millisecondsSinceEpoch,
        }).then((value) async {
          var _investGoalDocId = value.id;
          await firestoreInstance
              .collection("investmentGoals")
              .doc("users")
              .collection(_uid)
              .doc(_investGoalDocId)
              .update({
            'goalId': _investGoalDocId,
          });
          if (mounted)
            setState(() {
              // _getTotal();
              title = '';
              timeTitle = '';
              groupValue = null;
              group2Value = null;
              _fileURL = null;
            });
          Navigator.pop(context);
          // _getTotal();
          _refreshProvider(context);
          // Validator.onErrorDialog("Saved", context);
          if (mounted)
            setState(() {
              myController.text = '';
              isClosed = true;
              _investFor = null;
              _investTime = null;
              // _goalFuture = getInvestmentItems();
            });
          _inputFormKey.currentState?.reset();
          _path = null;
          numberItems = numberItems + 1;
        });
      }
    } else {
      Validator.onErrorDialog(
          "You have reached limit of 5 investment goals", context);
    }
  }

  _refreshProvider(context) async {
    var _referesh = Provider.of<TotalValues>(context, listen: false);
    await _referesh.getInvestTotal(widget.uid);
  }

  // Future<List<InvestmentModel>> getInvestmentItems() async {
  //   return firestoreInstance
  //       .collection("investmentGoals")
  //       .doc('users')
  //       .collection(_uid)
  //       .get()
  //       .then((querySnapshot) {
  //     _goalInvest = List<InvestmentModel>();
  //     // _goalInvest = querySnapshot.docs.map((result) {
  //     //   return InvestmentModel.fromJson(result.id, result.data());
  //     // }).toList();
  //     querySnapshot.docs.forEach((result) {
  //       _goalInvest.add(InvestmentModel.fromJson(result.id, result.data()));
  //     });
  //   }).then((value) {
  //     ///does it keep firing??
  //     // print(_goalInvest);
  //     _getTotal();
  //     return _goalInvest;
  //   });
  // }

  // Future<int> _getTotal() async {
  //   investTotalList = [];
  //   List _goalNum = await getInvestmentItems();
  //   if (_goalNum.isNotEmpty) {
  //     _goalNum.forEach((element) {
  //       investTotalList.add(int.parse(element.goalAmount));
  //     });
  //     if (mounted)
  //       setState(() {
  //         investTotal = investTotalList.reduce((sumSoFar, currentNum) {
  //           return sumSoFar + currentNum;
  //         });
  //       });
  //   } else {
  //     print('List dey empty');
  //   }
  //   return investTotal;
  // }

  // Future _getTotal() async {
  //   return FirebaseFirestore.instance
  //       .collection("investmentGoals")
  //       .doc('users')
  //       .collection(_uid)
  //       .get()
  //       .then((value) {
  //     investTotal = List();
  //     investTotal = value.docs.map((result) {
  //       return InvestmentModel.fromJson(
  //           result.id, result.data()['investAmount']);
  //     }).toList();
  //   }).then((value) {
  //     print('stufffff');
  //     print(investTotal);
  //     return investTotal;
  //   });
  // }

  Future<String> uploadFile() async {
    final String fileGEn = Random().nextInt(10000).toString();
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('InvestmentGoals')
        .child(_uid)
        .child(fileGEn + _fileName);
    UploadTask uploadTask = storageReference.putFile(File(_path));
    await uploadTask.then((TaskSnapshot snapshot) {
      // print('File Uploaded');
      // setState(() {
      //   _path = "Uploaded";
      // });
    }).catchError((Object e) {
      print(e); // FirebaseException
    });
    await storageReference.getDownloadURL().then((fileURL) {
      if (mounted)
        setState(() {
          _fileURL = fileURL;
        });
      return fileURL;
    });
    return _fileURL;
  }

  PickedFile compressedImage;

  void _openFileExplorer() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile compressedImage = await imagePicker.getImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxHeight: 700.h,
      maxWidth: 1000.w,
    );
    _path = compressedImage.path;
    _fileName = _path != null
        ? _path.split('/').last
        : _paths != null
            ? _paths.keys.toString()
            : '...';
    if (_path != null && _fileName != null) {
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // var _totalVal = Provider.of<TotalValues>(context, listen: false);
    // var _investGoalTot = _totalVal.invTot;
    return Scaffold(
      appBar: AppBar(
        leading: (widget.incomingRoute == "alt-loading")
            ? Container()
            : IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
                // onPressed: () => _getTotal(),
              ),
        backgroundColor: Color(0xff1680c9),
        title: Text('Set Investment Goals'),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          Builder(
            builder: (context) => IconButton(
              padding: EdgeInsets.only(right: 26.0),
              icon: Icon(Icons.dehaze),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      endDrawer: MainDrawer(
        uid: widget.uid,
        incomingRoute: investmentRoute,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: GestureDetector(
          onTap: () {
            final FocusScopeNode currentScope = FocusScope.of(context);
            if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
              FocusManager.instance.primaryFocus.unfocus();
            }
          },
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  shrinkWrap: true,
                  children: [
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Set up to 5 Investment Goals, 1 at a time',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff3790ce),
                            fontSize: 16.h,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            showPosDialog(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Icon(Icons.help, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 0.4,
                    ),
                    Form(
                      key: _inputFormKey,
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                        child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 0.4, color: Colors.black),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'I’m investing for:',
                                                  style: TextStyle(
                                                      fontSize: 16.0.h),
                                                ),
                                                Spacer(),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  child: Text(
                                                    title,
                                                    style: TextStyle(
                                                      fontSize: 14.5.h,
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                            height: 100,
                                            child: MyScrollbar(
                                              builder: (context,
                                                      scrollController2) =>
                                                  ListView.builder(
                                                padding: EdgeInsets.all(0),
                                                controller: scrollController2,
                                                shrinkWrap: true,
                                                itemCount: dropList.length,
                                                itemBuilder: (context, index) {
                                                  return RadioListTile(
                                                    title: Text(dropList
                                                        .elementAt(index)),
                                                    activeColor:
                                                        Color(0xff0070c0),
                                                    value: index,
                                                    groupValue: groupValue,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        groupValue = val;
                                                        title = dropList
                                                            .elementAt(index);
                                                        // retailer = val;
                                                      });
                                                      if (isStrechedDropDown ==
                                                          true) {
                                                        setState(() {
                                                          isStrechedDropDown =
                                                              false;
                                                          if (mounted)
                                                            switch (val) {
                                                              case 0:
                                                                setState(() {
                                                                  // val = val.toString();
                                                                  val =
                                                                      "Business Startup";
                                                                  print(val);
                                                                });
                                                                break;
                                                              case 1:
                                                                setState(() {
                                                                  val =
                                                                      "Education";
                                                                });
                                                                break;
                                                              case 2:
                                                                setState(() {
                                                                  val = "General";
                                                                });
                                                                break;
                                                              case 3:
                                                                setState(() {
                                                                  val =
                                                                      "Legacy";
                                                                });
                                                                break;
                                                              case 4:
                                                                setState(() {
                                                                  val =
                                                                      "Retirement";
                                                                });
                                                                break;
                                                              case 5:
                                                                setState(() {
                                                                  val =
                                                                      "Wealth Building";
                                                                });
                                                                break;
                                                              case 6:
                                                                setState(() {
                                                                  val = "Other";
                                                                });
                                                                break;
                                                              case 7:
                                                                setState(() {
                                                                  val =
                                                                      "No goal at this time";
                                                                });
                                                                break;
                                                              default:
                                                                print(
                                                                  'choose an option',
                                                                );
                                                            }
                                                          setState(() {
                                                            if (val ==
                                                                "Other") {
                                                              isClosed = false;
                                                            } else {
                                                              isClosed = true;
                                                              _investFor = val;
                                                            }
                                                          });
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
                          (!isClosed)
                              ? Column(
                                  children: [
                                    Container(
                                      child: TextFormField(
                                        controller: myController,
                                        cursorColor: Colors.black,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                          fillColor: Colors.black,
                                          focusColor: Colors.black,
                                          labelText: 'Other',
                                          labelStyle:
                                              TextStyle(color: Colors.black),
                                          hintStyle: TextStyle(
                                              fontSize: 20.0.h,
                                              color: Colors.white),
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.white,
                                                width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.black,
                                                width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        keyboardType: TextInputType.text,
                                        onChanged: (value) =>
                                            _investFor = value.trim(),
                                        // onSaved: (_) {
                                        //     myController
                                        // },
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.black,
                                      thickness: 0.4,
                                    ),
                                  ],
                                )
                              : Container(),
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Investment goal:',
                                  style: TextStyle(fontSize: 16.0.h),
                                ),
                              ),
                              Spacer(),
                              SizedBox(
                                width: 170.0.w,
                                child: TextFormField(
                                  controller: invAmt,
                                  cursorColor: Colors.black,
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.5.h,
                                  ),
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 30.0,
                                      vertical: 8.0,
                                    ),
                                    hintText: 'enter amount',
                                    hintStyle: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 14.5.h,
                                    ),
                                    isDense: true,
                                    // suffixText: '\$',
                                    // filled: true,
                                    // fillColor: Colors.grey.withOpacity(0.2),
                                    labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.black),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: Validator.validateAmount,
                                  onSaved: (value) {
                                    final FocusScopeNode _currentScope =
                                        FocusScope.of(context);
                                    if (!_currentScope.hasPrimaryFocus &&
                                        _currentScope.hasFocus) {
                                      FocusManager.instance.primaryFocus
                                          .unfocus();
                                    }
                                    var val = value.trim();
                                    var val1 = value.trim();
                                    if (val.isNotEmpty) {
                                      if (val.contains(",") == true) {
                                        val = val1.replaceAll(",", '');
                                      }
                                      if (invAmt.text.contains('\$') == false) {
                                        invAmt.text = '\$' + val;
                                        _investAmount =
                                            val.replaceAll('\$', '');
                                      } else {
                                        invAmt.text = '\$' + val;
                                        _investAmount =
                                            val.replaceAll('\$', '');
                                      }
                                    }
                                    invAmt.clear();
                                  },
                                  onFieldSubmitted: (value) async {
                                    final FocusScopeNode _currentScope =
                                        FocusScope.of(context);
                                    if (!_currentScope.hasPrimaryFocus &&
                                        _currentScope.hasFocus) {
                                      FocusManager.instance.primaryFocus
                                          .unfocus();
                                    }
                                    var val = value.trim();
                                    // print('val her');
                                    // print(val.isNotEmpty);
                                    if (val.isNotEmpty) {
                                      if (invAmt.text.contains('\$') == false) {
                                        invAmt.text = '\$' + val;
                                        // _savingAmount = val.replaceFirst('\$', '');
                                      } else if (invAmt.text.contains('\$') ==
                                          true) {
                                        // print('nmnbvb');
                                        // ignore: await_only_futures
                                        val = val.replaceAll('\$', '');
                                        invAmt.text =
                                            invAmt.text.replaceAll('\$', '');
                                        // invAmt.text.matchAsPrefix(string)
                                        invAmt.text = '\$' + val;
                                        // _savingAmount = val;
                                      }
                                    }
                                  },
                                  onChanged: (value) {
                                    var val = value.trim();
                                    var val1 = value.trim();
                                    if (val.isNotEmpty) {
                                      if (invAmt.text.contains('\$') == false) {
                                        // print('nmnbvb');
                                        // print(val1);
                                        // print(invAmt.text);
                                        invAmt.text =
                                            NumberFormat.simpleCurrency(
                                          locale: 'en-us',
                                          decimalDigits: 0,
                                        ).format(
                                          int.parse(val),
                                        );
                                        invAmt.selection =
                                            TextSelection.fromPosition(
                                                TextPosition(
                                                    offset:
                                                        invAmt.text.length));
                                        // _savingAmount = val.replaceAll('\$', '');
                                      } else if (invAmt.text.contains('\$') ==
                                          true) {
                                        val = val1.replaceAll("\$", "");
                                        val = val.replaceAll(",", "");
                                        invAmt.text =
                                            NumberFormat.simpleCurrency(
                                          locale: 'en-us',
                                          decimalDigits: 0,
                                        ).format(
                                          int.parse(val),
                                        );
                                        invAmt.selection =
                                            TextSelection.fromPosition(
                                                TextPosition(
                                                    offset:
                                                        invAmt.text.length));
                                        // _savingAmount = val.replaceAll('\$', '');
                                      }
                                    }
                                  },
                                  onEditingComplete: () =>
                                      FocusScope.of(context).unfocus(),
                                  // onSaved: (value) => _investAmount = value,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 0.4,
                          ),
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 40,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 0),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                            child: Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  width: 0.4,
                                                  color: Colors.black),
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Time to achieve goal:',
                                                      style: TextStyle(
                                                          fontSize: 16.0.h),
                                                    ),
                                                    Spacer(),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10),
                                                      child: Text(
                                                        timeTitle,
                                                        style: TextStyle(
                                                          fontSize: 14.5.h,
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          isStrechedDropDown2 =
                                                              !isStrechedDropDown2;
                                                        });
                                                      },
                                                      child: Icon(
                                                        isStrechedDropDown2
                                                            ? Icons.expand_less
                                                            : Icons.expand_more,
                                                        size: 30.h,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              ExpandedSection(
                                                expand: isStrechedDropDown2,
                                                height: 100,
                                                child: MyScrollbar(
                                                  builder: (context,
                                                          scrollController2) =>
                                                      ListView.builder(
                                                    padding: EdgeInsets.all(0),
                                                    controller:
                                                        scrollController2,
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        secondDropList.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return RadioListTile(
                                                        title: Text(
                                                            secondDropList
                                                                .elementAt(
                                                                    index)),
                                                        activeColor:
                                                            Color(0xff0070c0),
                                                        value: index,
                                                        groupValue: group2Value,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            group2Value = val;
                                                            timeTitle =
                                                                secondDropList
                                                                    .elementAt(
                                                                        index);
                                                            // retailer = val;
                                                          });

                                                          if (isStrechedDropDown2 ==
                                                              true) {
                                                            setState(() {
                                                              isStrechedDropDown2 =
                                                                  false;
                                                              if (mounted)
                                                                switch (val) {
                                                                  case 0:
                                                                    setState(
                                                                        () {
                                                                      // val = val.toString();
                                                                      val =
                                                                          "3 years";
                                                                      print(
                                                                          val);
                                                                    });
                                                                    break;
                                                                  case 1:
                                                                    setState(
                                                                        () {
                                                                      val =
                                                                          "5 years";
                                                                    });
                                                                    break;
                                                                  case 2:
                                                                    setState(
                                                                        () {
                                                                      val =
                                                                          "10 years";
                                                                    });
                                                                    break;
                                                                  case 3:
                                                                    setState(
                                                                        () {
                                                                      val =
                                                                          "15 years";
                                                                    });
                                                                    break;
                                                                  case 4:
                                                                    setState(
                                                                        () {
                                                                      val =
                                                                          "20 years";
                                                                    });
                                                                    break;
                                                                  case 5:
                                                                    setState(
                                                                        () {
                                                                      val =
                                                                          "25 years";
                                                                    });
                                                                    break;
                                                                  case 6:
                                                                    setState(
                                                                        () {
                                                                      val =
                                                                          "30 years";
                                                                    });
                                                                    break;
                                                                  case 7:
                                                                    setState(
                                                                        () {
                                                                      val =
                                                                          "35 years";
                                                                    });
                                                                    break;
                                                                  case 8:
                                                                    setState(
                                                                        () {
                                                                      val =
                                                                          "40 years";
                                                                    });
                                                                    break;
                                                                  case 9:
                                                                    setState(
                                                                        () {
                                                                      val =
                                                                          "45 years";
                                                                    });
                                                                    break;
                                                                  default:
                                                                    print(
                                                                        'choose an option');
                                                                }
                                                              _investTime = val;
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
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Divider(
                    //   color: Colors.black,
                    //   thickness: 0.4,
                    // ),
                    SizedBox(
                      height: 10.0.h,
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 3,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Upload image of your investment goal (optional)',
                              style: TextStyle(fontSize: 16.0.h),
                            ),
                          ),
                        ),
                        Spacer(),
                        (_path != null)
                            ? GestureDetector(
                                onTap: () {
                                  _openFileExplorer();
                                },

                                ///use circleavatar if problems
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(80.0),
                                  child: Image.file(
                                    File(_path),
                                    fit: BoxFit.fill,
                                    height: 150.0.h,
                                    width: 150.0.w,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  _openFileExplorer();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.blue,
                                    ),
                                    shape: BoxShape.circle,
                                    color: Colors.grey.withOpacity(0.2),
                                  ),
                                  height: 100.0.h,
                                  width: 100.0.w,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  margin: EdgeInsets.symmetric(
                                    vertical: 10.0,
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Upload',
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0.h,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Investment Goal',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.h,
                                ),
                              ),
                            ),
                            Spacer(),
                            // TextButton(
                            //   style: ButtonStyle(
                            //     backgroundColor: MaterialStateProperty.resolveWith(
                            //       (states) => Color(0xff1680c9),
                            //     ),
                            //     shape: MaterialStateProperty.all<
                            //         RoundedRectangleBorder>(
                            //       RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(15.0),
                            //       ),
                            //     ),
                            //     overlayColor: MaterialStateProperty.resolveWith(
                            //       (states) {
                            //         return states.contains(MaterialState.pressed)
                            //             ? Colors.blue
                            //             : null;
                            //       },
                            //     ),
                            //     fixedSize: MaterialStateProperty.resolveWith(
                            //         (states) => Size(85.0, 10.0)),
                            //     // maximumSize: MaterialStateProperty.resolveWith(
                            //     //     (states) => Size(60, 20)),
                            //   ),
                            //   onPressed: () => Timer(
                            //     const Duration(milliseconds: 400),
                            //     () {
                            //       _validateInputs();
                            //       setState(() {});
                            //     },
                            //   ),
                            //   child: Text(
                            //     'Save Goal',
                            //     style: TextStyle(
                            //       fontSize: 15.0,
                            //       color: Colors.white,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 0.4,
                        ),
                        Consumer<TotalValues>(
                          builder: (context, provider, child) {
                            return FutureBuilder(
                              future: provider.getInvestmentProvider(
                                  widget.uid), // async work
                              builder: (BuildContext context, snapshot) {
                                if (provider.investModelInstance != null) {
                                  return ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: (provider.investModelInstance !=
                                            null)
                                        ? provider.investModelInstance.length
                                        : 0,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      // _getTotal();
                                      return Column(
                                        children: [
                                          GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () {
                                              // print('sup');
                                              navigateEditInvestmentGoal(
                                                  context,
                                                  provider.investModelInstance[
                                                      index],
                                                  investmentRoute);
                                            },
                                            child: Row(
                                              children: [
                                                Text((index + 1).toString() +
                                                    '.'),
                                                ((index + 1) > 9)
                                                    ? SizedBox(
                                                        width: 4.0,
                                                      )
                                                    : SizedBox(
                                                        width: 10.0,
                                                      ),
                                                Container(
                                                  // width: 50,
                                                  child: CircleAvatar(
                                                    // backgroundImage: NetworkImage(_listSavings[index].url),
                                                    backgroundImage:
                                                        NetworkImage(
                                                      provider
                                                          .investModelInstance[
                                                              index]
                                                          .url,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.0.w,
                                                ),
                                                Text(
                                                  provider
                                                      .investModelInstance[
                                                          index]
                                                      .goal,
                                                  // textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontSize: 14.h,
                                                    fontWeight: FontWeight.w400,
                                                    // color: Colors.grey[450],
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(
                                                  NumberFormat.simpleCurrency(
                                                    locale: 'en-us',
                                                    decimalDigits: 0,
                                                  ).format(
                                                    int.parse(provider
                                                        .investModelInstance[
                                                            index]
                                                        .goalAmount),
                                                  ),
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15.h,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.black,
                                            thickness: 0.4,
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return new Text('Loading....');
                                    default:
                                      if (snapshot.hasError)
                                        return new Text(
                                            'Error: ${snapshot.error}');
                                      else
                                        return ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount:
                                              (provider.investModelInstance !=
                                                      null)
                                                  ? provider.investModelInstance
                                                      .length
                                                  : 0,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            // _getTotal();
                                            return Column(
                                              children: [
                                                GestureDetector(
                                                  behavior: HitTestBehavior
                                                      .translucent,
                                                  onTap: () {
                                                    // print('sup');
                                                    navigateEditInvestmentGoal(
                                                        context,
                                                        provider.investModelInstance[
                                                            index],
                                                        investmentRoute);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text((index + 1)
                                                              .toString() +
                                                          '.'),
                                                      ((index + 1) > 9)
                                                          ? SizedBox(
                                                              width: 4.0,
                                                            )
                                                          : SizedBox(
                                                              width: 10.0,
                                                            ),
                                                      Container(
                                                        // width: 50,
                                                        child: CircleAvatar(
                                                          // backgroundImage: NetworkImage(_listSavings[index].url),
                                                          backgroundImage:
                                                              NetworkImage(
                                                            provider
                                                                .investModelInstance[
                                                                    index]
                                                                .url,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10.0.w,
                                                      ),
                                                      Text(
                                                        provider
                                                            .investModelInstance[
                                                                index]
                                                            .goal,
                                                        // textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                          fontSize: 14.h,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          // color: Colors.grey[450],
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        NumberFormat
                                                            .simpleCurrency(
                                                          locale: 'en-us',
                                                          decimalDigits: 0,
                                                        ).format(
                                                          int.parse(provider
                                                              .investModelInstance[
                                                                  index]
                                                              .goalAmount),
                                                        ),
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15.h,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(
                                                  color: Colors.black,
                                                  thickness: 0.4,
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                  }
                              },
                            );
                          },
                        ),
                        Row(
                          children: [
                            Spacer(),
                            Container(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Total Investment Goal:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0.h,
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            Consumer<TotalValues>(
                              builder: (context, invTotalValue, child) {
                                return FutureBuilder(
                                    future: invTotalValue
                                        .getInvestTotal(widget.uid),
                                    builder: (context, snapshot) {
                                      if (invTotalValue.invTot != null) {
                                        return Container(
                                          width: 80.0.w,
                                          child: (invTotalValue.invTot == 0)
                                              ? Text(
                                                  NumberFormat.simpleCurrency(
                                                    locale: 'en-us',
                                                    decimalDigits: 2,
                                                  ).format(
                                                      invTotalValue.invTot),
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                    fontSize: 15.0.h,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : Text(
                                                  NumberFormat.simpleCurrency(
                                                    locale: 'en-us',
                                                    decimalDigits: 0,
                                                  ).format(
                                                      invTotalValue.invTot),
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                    fontSize: 15.0.h,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                        );
                                      } else
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.waiting:
                                            return Container(
                                              width: 80.0.w,
                                              child: Text(
                                                '--',
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  fontSize: 20.0.h,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            );
                                          default:
                                            if (snapshot.hasError) {
                                              print('Error: ${snapshot.error}');
                                              return Container(
                                                width: 80.0.w,
                                                child: Text(
                                                  '--',
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                    fontSize: 20.0.h,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              );
                                            } else
                                              return Container(
                                                width: 80.0.w,
                                                child: (invTotalValue.invTot ==
                                                        0)
                                                    ? Text(
                                                        NumberFormat
                                                            .simpleCurrency(
                                                          locale: 'en-us',
                                                          decimalDigits: 2,
                                                        ).format(invTotalValue
                                                            .invTot),
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                          fontSize: 15.0.h,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                    : Text(
                                                        NumberFormat
                                                            .simpleCurrency(
                                                          locale: 'en-us',
                                                          decimalDigits: 0,
                                                        ).format(invTotalValue
                                                            .invTot),
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                          fontSize: 15.0.h,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                              );
                                        }
                                    });
                              },
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   height: 40.0,
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 3.0, top: 7.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                        width: 85.0.w,
                        height: 50.0.h,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Color(0xff3790ce),
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
                              // _validateInputs();/
                              // _setAnotherGoalAndValidate();
                              // _scrollToTop();
                              // setState(() {});
                              _validateInputs();
                              setState(() {});
                            },
                          ),
                          child: Container(
                            child: Text(
                              'Save\nThis Goal',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.0.h,
                                color: Colors.white,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 85.0.w,
                        height: 50.0.h,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Color(0xff3790ce),
                            ),
                            // padding: MaterialStateProperty,
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
                              // _validateInputs();/
                              _setAnotherGoalAndValidate();
                              _scrollToTop();
                              setState(() {});
                            },
                          ),
                          child: Container(
                            // margin: EdgeInsets.all(0),
                            child: Text(
                              'Set\nNew Goal',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.0.h,
                                color: Colors.white,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   width: 10.0,
                      // ),
                      // _validateInputs();
                      // navigateToSetInvestmentGoals(context);
                      SizedBox(
                        width: 85.0.w,
                        height: 50.0.h,
                        child: Consumer<TotalValues>(
                          builder: (context, modelInstancesList, state) {
                            return TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                  (states) => Color(0xff000000),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                overlayColor: MaterialStateProperty.resolveWith(
                                  (states) {
                                    return states
                                            .contains(MaterialState.pressed)
                                        ? Colors.grey[700]
                                        : null;
                                  },
                                ),
                              ),
                              onPressed: () => Timer(
                                const Duration(milliseconds: 400),
                                () async {
                                  if (modelInstancesList
                                      .investModelInstance.isNotEmpty) {
                                    navigateToStartingBalances(context);
                                  } else {
                                    Validator.onErrorDialog(
                                        "You must save at least one investment goal.",
                                        context);
                                  }
                                  // _prefs =
                                  //     await SharedPreferences.getInstance();
                                  // var currentUid =
                                  //     _prefs.getString('storedUid');
                                  // print(currentUid);
                                },
                              ),
                              child: Container(
                                child: Text(
                                  'Done',
                                  style: TextStyle(
                                    fontSize: 16.0.h,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  showPosDialog(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      elevation: 24.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 13.0.h,
            ),
            Row(
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Saving and investing will both help you reach your financial goal, but they are not the same.',
                      maxLines: 4,
                      style: TextStyle(height: 1.4, fontSize: 16.h),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 17.0.h,
            ),
            Container(
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Investing',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // color: Color(0xff0070c0),
                    fontSize: 18.0.h,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 17.0.h,
            ),
            Text(
              "Investments typically earn higher returns than savings, but involve greater risk because investment vehicles like stocks, bonds and real estate go up and down in value.",
              style: TextStyle(
                fontSize: 16.0.h,
              ),
            ),
            SizedBox(
              height: 17.h,
            ),
            Container(
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Investment Goals',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // color: Color(0xff0070c0),
                    fontSize: 17.0.h,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 17.h,
            ),
            Container(
              child: Text(
                "In spite of fluctuations, markets generally trend up over time. As a result, most people invest with the expectation of building wealth through higher returns over time. Typical investment goals include paying for a child's education and saving for retirement.",
                style: TextStyle(
                  color: Colors.black,
                  height: 1.4,
                  fontSize: 16.h,
                ),
              ),
            ),
            SizedBox(
              height: 17.0.h,
            ),
            Container(
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Strike the Right Balance',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // color: Color(0xff0070c0),
                    fontSize: 17.0.h,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 17.0.h,
            ),
            Container(
              child: Text(
                "Before investing, save at least 3-6 months of living expenses for a rainy day. Then ask yourself how much risk can you tolerate to gain the returns that you want without losing sleep at night. Balance your investments accordingly.",
                style: TextStyle(
                  color: Colors.black,
                  height: 1.4,
                  fontSize: 16.h,
                ),
              ),
            ),
            SizedBox(
              height: 17.0.h,
            ),
            Container(
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'For More Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // color: Color(0xff0070c0),
                    fontSize: 17.0.h,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 17.0.h,
            ),
            Container(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    height: 1.5,
                    fontSize: 16.h,
                  ),
                  children: [
                    TextSpan(
                      text:
                          'For more information on saving, investing, and achieving your long-term financial goals, read ',
                      style: TextStyle(
                        height: 1.4,
                      ),
                    ),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch(
                              "https://www.amazon.com/500-Cup-Coffee-Lifestyle-Independence-ebook/dp/B01ETYC3PW/ref=sr_1_6?crid=3GLRJ9JN6MGDB&keywords=500+cup+of+coffee&qid=1643138839&sprefix=500+cup+of+coffee%2Caps%2C67&sr=8-6");
                        },
                      text: 'The \$500 Cup of Coffee, ',
                      style: TextStyle(
                        // decoration: TextDecoration.underline,
                        height: 1.4,
                        color: Colors.blue,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          'co-authored by Steven Lome, the creator of this app.',
                      style: TextStyle(
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 40.0.h,
            ),
          ],
        ),
      ),
      actions: [
        Center(
          child: ElevatedButton(
            style: ButtonStyle(
              minimumSize:
                  MaterialStateProperty.resolveWith((states) => Size(80, 40)),
              backgroundColor: MaterialStateProperty.resolveWith(
                (states) => Color(0xff1680c9),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
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
                Navigator.pop(context);
              },
            ),
            child: Text(
              'OK',
              style: TextStyle(
                fontSize: 15.0.h,
                color: Colors.white,
              ),
            ),
            // color: Colors.transparent,
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
