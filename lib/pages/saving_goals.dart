import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
// import 'package:pay_or_save/assets/buttonting.dart';
// import 'package:pay_or_save/assets/custom_row.dart';
import 'package:pay_or_save/assets/dropdown/expanded_section.dart';
// import 'package:pay_or_save/assets/dropdown/new_dropdown.dart';
import 'package:pay_or_save/assets/dropdown/scrollbar.dart';
// import 'package:pay_or_save/assets/dropdown.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
// import 'package:pay_or_save/models/investment_goal_model.dart';
import 'package:pay_or_save/models/saving_goal_model.dart';
// import 'package:pay_or_save/pages/about_savings.dart';
import 'package:pay_or_save/pages/investment_goal.dart';
// import 'package:pay_or_save/pages/save_now.dart';
import 'package:pay_or_save/providers/total_provider.dart';
// import 'package:pay_or_save/pages/about.dart';
import 'package:pay_or_save/services/services.dart';
import 'package:pay_or_save/utilities/validator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher.dart';

import 'edit_saving_goal.dart';
// import 'invest_now.dart';
// import 'package:pay_or_save/widgets/menu.dart';

class SavingGoals extends StatefulWidget {
  final String uid;
  final String incomingRoute;

  @override
  _SavingGoalsState createState() => _SavingGoalsState(uid);

  SavingGoals({Key key, @required this.uid, this.incomingRoute})
      : super(key: key);
}

class _SavingGoalsState extends State<SavingGoals>
    with TickerProviderStateMixin {
  String _uid,
      _savingFor,
      // _other,
      _savingAmount,
      _savingTime,
      _fileURL,
      _path,
      _fileName;
  int _newIndex = 1;

  TextEditingController savGoalAmt = TextEditingController();

  // _extension;
  Map<String, String> _paths;
  // bool _loadingPath = false;
  // bool _multiPick = false;
  // bool _hasValidMime = false;
  // FileType _pickingType;
  bool isStrechedDropDown = false;
  int groupValue;
  String title = '';
  String timeTitle = '';
  int group2Value;
  bool isStrechedDropDown2 = false;
  List savingsTotalList;
  int savingsTotal;
  Future<int> _totalProvider;
  SharedPreferences _prefss;
  // String nativeRoute = '/'

  List<String> dropList = [
    'Business Startup',
    'Car',
    'Computer/Electronics',
    'Down Payment',
    'Education',
    'Furnishings',
    'Rainy Day Fund',
    'Travel/Vacation',
    'Wedding',
    'General',
    'Other',
    'No goal at this time',
  ];
  List<String> secondDropList = [
    '3 months',
    '6 months',
    '12 months',
    '18 months',
    '24 months',
    '30 months',
    '3 years',
    '5 years',
    '7 years',
    '8 years',
    '10 years',
    '15 years',
  ];
  int total;
  bool isClosed = true;
  int numberItems = 0;
  String formattedDigit;
  List<SavingModel> _goalSavings;
  Future<List<SavingModel>> _goalFuture;
  int providerTotal;
  String route = '/saving';
  // List<InvestmentModel> _listInvestment;
  final myController = TextEditingController();
  final firestoreInstance = FirebaseFirestore.instance;
  final GlobalKey<FormState> _inputFormKey = GlobalKey<FormState>();
  ScrollController _scrollController;

  var itemsIcons = {
    'Car':
        'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FAuto.png?alt=media&token=f4d0ab35-b62d-4613-b3d4-61cef7c41425',
    'Computer/Electronics':
        'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FComputer-Electronics.png?alt=media&token=f80cedfc-b1af-4a7f-82fe-86adc9ef4648', //check
    'Education':
        'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FEducation.png?alt=media&token=3fba9b33-0ad3-403c-8921-fd7090cda3d4',
    'Furnishings':
        'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FFurnishing.png?alt=media&token=aa005a28-b999-4057-b0bb-360920dcb5c7',
    'Home':
        'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FHome.png?alt=media&token=d5b66d28-3302-4904-9f5c-4b0b4bfcc987',
    'General Savings':
        'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FGeneral.png?alt=media&token=03dfe2a4-2b14-41f0-b4e7-c059bc9d1e8b',
    'Rainy Day':
        'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FRainy-Day.png?alt=media&token=325a4a20-04c1-466b-a6f5-c64ce980aadb',
    'Start a Business':
        'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FBusiness.png?alt=media&token=6f9deeb6-3892-4b95-b34f-120553d9fecd',
    'Travel/Vacation':
        'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FTravel.png?alt=media&token=a3b69bd0-4796-4932-89bb-6b9bc8ffee1b',
    'Wedding':
        'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FWedding.png?alt=media&token=b451e6e2-2c10-4d08-89c5-1336c24d5cd4',
    'Other':
        'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FOther.png?alt=media&token=61ab369f-0da5-47cd-8d85-b90bca35e15d',
    'No goal at this time':
        'https://firebasestorage.googleapis.com/v0/b/pay-or-save.appspot.com/o/AppAssets%2FGeneral.png?alt=media&token=03dfe2a4-2b14-41f0-b4e7-c059bc9d1e8b',
  };

  _SavingGoalsState(this._uid);

  // func() async {
  //   TotalValues totalValues = Provider.of<TotalValues>(context, listen: false);
  //   await totalValues.getSavingsTotal(widget.uid);
  // }

  @override
  void initState() {
    // Future.delayed(Duration.zero).then((value) {
    //   providerTotal = Provider.of<TotalValues>(context, listen: false)
    //       .getSavingsTotal(widget.uid);
    // });
    // SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
    // print("runing refresh");
    refreshProvider(context);
    // print("refresh ran");
    _scrollController = ScrollController()..addListener(() {});
    // getSavingsItems();
    // _totalProvider = Provider.of<TotalValues>(context, listen: false)
    // .getSavingsTotal(widget.uid);
    // _goalFuture = getSavingsItems();
    _goalSavings = List<SavingModel>();
    // _getTotal();
    // refreshProvider(context);
    // setState(() {});
    // getPrefs();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    savGoalAmt.dispose();
    myController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.jumpTo(0);
  }

  // getPrefs() async {
  //   _prefss = await SharedPreferences.getInstance();
  //   await _prefss.setString('storedUid', widget.uid);
  // }

  Future navigateToSetInvestmentGoals(context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InvestmentGoals(
                  uid: _uid,
                )));
  }

  _launchUrl() async {
    const _url =
        "https://www.amazon.com/500-Cup-Coffee-Lifestyle-Independence-ebook/dp/B01ETYC3PW/ref=sr_1_6?crid=3GLRJ9JN6MGDB&keywords=500+cup+of+coffee&qid=1643138839&sprefix=500+cup+of+coffee%2Caps%2C67&sr=8-6";
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      throw "Could not launch $_url";
    }
  }

  void _validateInputs() {
    if (_inputFormKey.currentState.validate()) {
      //    If all data are correct then save data to out variables

      if (_savingTime != null && _savingFor != null) {
        _inputFormKey.currentState.save();
        // _inputFormKey.currentState.build();
        // _goalItem(context, index);
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
    if (_savingTime != null && _savingFor != null) {
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
        _savingFor = null;
        _savingTime = null;
        _inputFormKey.currentState?.reset();
        _path = null;
        isStrechedDropDown = true;
        isStrechedDropDown2 = false;
      });
    }
  }

  Future navigateEditSavingGoal(
      context, SavingModel model, String route) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditSavingGoal(
                  uid: _uid,
                  savingModel: model,
                  route: route,
                )));
  }

  _saveGoal(context) {
    if (numberItems < 10) {
      MainServices.onLoading(context);
      if (_path != null) {
        uploadFile().then((value) {
          // print('stuff');
          // print(value);
          firestoreInstance
              .collection("savingGoals")
              .doc("users")
              .collection(_uid)
              .add({
            'savingFor': _savingFor,
            'savingAmount': 0,
            'savingGoal': _savingAmount,
            'savingTime': _savingTime,
            'defaultIcon': (_savingFor == 'Other') ? '' : _savingFor,
            'photo': (_fileURL != null)
                ? _fileURL
                : (itemsIcons.containsKey(_savingFor))
                    ? itemsIcons[_savingFor]
                    : itemsIcons['Other'],
            'created': DateTime.now().millisecondsSinceEpoch,
            // 'goalId':
          }).then((value) async {
            var goalDocId = value.id;
            await firestoreInstance
                .collection("savingGoals")
                .doc("users")
                .collection(_uid)
                .doc(goalDocId)
                .update({
              'goalId': goalDocId,
            });
            if (mounted)
              setState(() {
                title = '';
                timeTitle = '';
                groupValue = null;
                group2Value = null;
                _fileURL = null;
              });
            Navigator.pop(context);
            refreshProvider(context);
            if (mounted)
              setState(() {
                savGoalAmt.clear();
                myController.text = '';
                isClosed = true;
                _savingFor = null;
                _savingTime = null;
                // _goalFuture = getSavingsItems();
              });
            _inputFormKey.currentState?.reset();
            _path = null;
            numberItems = numberItems + 1;
          });
          // print('TEST HERE');
          // print(testVar);
        });
      } else {
        firestoreInstance
            .collection("savingGoals")
            .doc("users")
            .collection(_uid)
            .add({
          'savingFor': _savingFor,
          'savingAmount': 0,
          'savingGoal': _savingAmount,
          'savingTime': _savingTime,
          'defaultIcon': (_savingFor == 'Other') ? '' : _savingFor,
          'photo': (_fileURL != null)
              ? _fileURL
              : (itemsIcons.containsKey(_savingFor))
                  ? itemsIcons[_savingFor]
                  : itemsIcons['Other'],
          'created': DateTime.now().millisecondsSinceEpoch,
        }).then((value) async {
          var goalDocId = value.id;
          await firestoreInstance
              .collection("savingGoals")
              .doc("users")
              .collection(_uid)
              .doc(goalDocId)
              .update({
            'goalId': goalDocId,
          });
          if (mounted)
            setState(() {
              title = '';
              timeTitle = '';
              groupValue = null;
              group2Value = null;
              _fileURL = null;
              // savGoalAmt.clear();
            });
          Navigator.pop(context);

          refreshProvider(context);
          if (mounted)
            setState(() {
              myController.text = '';
              savGoalAmt.clear();
              isClosed = true;
              _savingFor = null;
              _savingTime = null;
              // _goalFuture = getSavingsItems();
            });
          _inputFormKey.currentState?.reset();
          _path = null;
          numberItems = numberItems + 1;
        });
      }
    } else {
      Validator.onErrorDialog(
          "You have reached limit of 10 saving goals", context);
    }
  }

  refreshProvider(context) async {
    var _referesh = Provider.of<TotalValues>(context, listen: false);
    await _referesh.getSavingsTotal(widget.uid);
  }

  Future<String> uploadFile() async {
    final String fileGEn = Random().nextInt(10000).toString();
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('SavingGoals')
        .child(_uid)
        .child(fileGEn + _fileName);
    UploadTask uploadTask = storageReference.putFile(File(_path));
    await uploadTask.then((TaskSnapshot snapshot) {
      print('File Uploaded');
      // setState(() {
      //   _path = "Uploaded";
      // });
    }).catchError((Object e) {
      print(e); // FirebaseException
    });
    // print('File Uploaded');
    // if (mounted)
    //   setState(() {
    //     _path = "Uploaded";
    //   });
    await storageReference.getDownloadURL().then((fileURL) {
      // if (mounted)
      setState(() {
        _fileURL = fileURL;
      });
      return fileURL;
    });

    /// touched, previously null.
    return _fileURL;
  }

  PickedFile compressedImage;

  void _openFileExplorer() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile compressedImage = await imagePicker.getImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxHeight: 700,
      maxWidth: 1000,
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

  String valueChoose;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: (widget.incomingRoute == "drawer")
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
              )
            : Container(),
        backgroundColor: Color(0xff0e8646),
        title: Text(
          'Set Savings Goals',
        ),
        centerTitle: true,
        elevation: 0.0,
        // resizeToAvoidBottomInset: false,
        actions: [
          Builder(
            builder: (context) => IconButton(
              padding: EdgeInsets.only(right: 30.0),
              icon: Icon(Icons.dehaze),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      endDrawer: MainDrawer(
        uid: widget.uid,
        incomingRoute: route,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
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
                          'Set up to 10 Savings Goals, 1 at a time',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff0e8646),
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
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 50,
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
                                                      'I’m saving for:',
                                                      style: TextStyle(
                                                          fontSize: 16.0.h),
                                                    ),
                                                    Spacer(),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10),
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
                                                    controller:
                                                        scrollController2,
                                                    shrinkWrap: true,
                                                    itemCount: dropList.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return RadioListTile(
                                                        title: Text(
                                                          dropList
                                                              .elementAt(index),
                                                        ),
                                                        activeColor:
                                                            Color(0xff0070c0),
                                                        value: index,
                                                        groupValue: groupValue,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            groupValue = val;
                                                            title = dropList
                                                                .elementAt(
                                                                    index);
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
                                                                    // val = val.toString();
                                                                    val = 'Business Startup';
                                                                    print(val);
                                                                    break;
                                                                  case 1:
                                                                    val =
                                                                        'Car';
                                                                    break;
                                                                  case 2:
                                                                    val =
                                                                        'Computer/Electronics';
                                                                    break;
                                                                  case 3:
                                                                    val =
                                                                        'Down Payment';
                                                                    break;
                                                                  case 4:
                                                                    val =
                                                                        'Education';
                                                                    break;
                                                                  case 5:
                                                                    val =
                                                                        'Furnishings';
                                                                    break;
                                                                  case 6:
                                                                    val =
                                                                        'Rainy Day Fund';
                                                                    break;
                                                                  case 7:
                                                                    val =
                                                                        'Travel/Vacation';
                                                                    break;
                                                                  case 8:
                                                                    val =
                                                                        'Wedding';
                                                                    break;
                                                                  case 9:
                                                                    val =
                                                                        'General';
                                                                    break;
                                                                  case 10:
                                                                    val =
                                                                        'Other';
                                                                    break;
                                                                  case 11:
                                                                    val =
                                                                        'No goal at this time';
                                                                    break;
                                                                  default:
                                                                    print(
                                                                        'choose an option');
                                                                }
                                                              setState(() {
                                                                if (val ==
                                                                    'Other') {
                                                                  isClosed =
                                                                      false;
                                                                } else {
                                                                  isClosed =
                                                                      true;
                                                                  _savingFor =
                                                                      val;
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
                            ],
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
                                            _savingFor = value.trim(),
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
                                  'Savings goal:',
                                  style: TextStyle(fontSize: 16.0.h),
                                ),
                              ),
                              Spacer(),
                              SizedBox(
                                width: 170.0.w,
                                child: TextFormField(
                                    controller: savGoalAmt,
                                    // focusNode: ,
                                    autofocus: false,
                                    cursorColor: Colors.black,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.5.h,
                                    ),
                                    textAlign: TextAlign.right,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 25.0,
                                        vertical: 8.0,
                                      ),
                                      hintText: 'enter amount',
                                      hintStyle: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14.5.h,
                                      ),
                                      isDense: true,
                                      // prefix: Text(
                                      //   '\$',
                                      //   textAlign: TextAlign.right,
                                      // ),
                                      // prefixStyle: TextStyle(),
                                      // prefixText: '\$',
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
                                      // focusedErrorBorder: UnderlineInputBorder(
                                      //   borderSide: BorderSide.none,
                                      // ),
                                      // errorBorder: UnderlineInputBorder(
                                      //   borderSide: BorderSide.none,
                                      // ),
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
                                        if (savGoalAmt.text.contains('\$') ==
                                            false) {
                                          savGoalAmt.text = '\$' + val;
                                          _savingAmount =
                                              val.replaceAll('\$', '');
                                        } else {
                                          savGoalAmt.text = '\$' + val;
                                          _savingAmount =
                                              val.replaceAll('\$', '');
                                        }
                                      }
                                      savGoalAmt.clear();
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
                                      if (val.isNotEmpty) {
                                        if (savGoalAmt.text.contains('\$') ==
                                            false) {
                                          savGoalAmt.text = '\$' + val;
                                          // _savingAmount = val.replaceFirst('\$', '');
                                        } else if (savGoalAmt.text
                                                .contains('\$') ==
                                            true) {
                                          // print('nmnbvb');
                                          // ignore: await_only_futures
                                          val = val.replaceAll('\$', '');
                                          savGoalAmt.text = savGoalAmt.text
                                              .replaceAll('\$', '');
                                          // savGoalAmt.text.matchAsPrefix(string)
                                          savGoalAmt.text = '\$' + val;
                                          // _savingAmount = val;
                                        }
                                      }
                                    },
                                    onEditingComplete: () =>
                                        FocusScope.of(context).unfocus(),
                                    onChanged: (value) {
                                      var val = value.trim();
                                      var val1 = value.trim();
                                      if (val.isNotEmpty) {
                                        if (savGoalAmt.text.contains('\$') ==
                                            false) {
                                          // print('nmnbvb');
                                          // print(val1);
                                          // print(savGoalAmt.text);
                                          savGoalAmt.text =
                                              NumberFormat.simpleCurrency(
                                            locale: 'en-us',
                                            decimalDigits: 0,
                                          ).format(
                                            int.parse(val),
                                          );
                                          savGoalAmt.selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset: savGoalAmt
                                                          .text.length));
                                          // _savingAmount = val.replaceAll('\$', '');
                                        } else if (savGoalAmt.text
                                                .contains('\$') ==
                                            true) {
                                          val = val1.replaceAll("\$", "");
                                          val = val.replaceAll(",", "");
                                          savGoalAmt.text =
                                              NumberFormat.simpleCurrency(
                                            locale: 'en-us',
                                            decimalDigits: 0,
                                          ).format(
                                            int.parse(val),
                                          );
                                          savGoalAmt.selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset: savGoalAmt
                                                          .text.length));
                                          // _savingAmount = val.replaceAll('\$', '');
                                        }
                                      }
                                    }
                                    // onChanged: (val) {
                                    //   // if (savGoalAmt.text.contains('\$') == false) {
                                    //   savGoalAmt.text = '\$' + val;
                                    //   // } else if (savGoalAmt.text.contains('\$') ==
                                    //   //     true) {
                                    //   //   savGoalAmt.text.replaceAll('\$', '');
                                    //   //   savGoalAmt.text = '\$' + val;
                                    //   // }
                                    // },
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
                                width: MediaQuery.of(context).size.width - 50,
                                padding: EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 0),
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
                                                                          '3 months';
                                                                      print(
                                                                          val);
                                                                    });
                                                                    break;
                                                                  case 1:
                                                                    setState(
                                                                        () {
                                                                      // val = val.toString();
                                                                      val =
                                                                          '6 months';
                                                                      print(
                                                                          val);
                                                                    });
                                                                    break;
                                                                  case 2:
                                                                    setState(
                                                                        () {
                                                                      val =
                                                                          '12 months';
                                                                    });
                                                                    break;
                                                                  case 3:
                                                                    setState(
                                                                        () {
                                                                      val =
                                                                          '18 months';
                                                                    });
                                                                    break;
                                                                  case 4:
                                                                    setState(
                                                                        () {
                                                                      val =
                                                                          '24 months';
                                                                    });
                                                                    break;
                                                                  case 5:
                                                                    setState(
                                                                        () {
                                                                      val =
                                                                          '30 months';
                                                                    });
                                                                    break;
                                                                  case 6:
                                                                    setState(
                                                                        () {
                                                                      val =
                                                                          '3 years';
                                                                    });
                                                                    break;
                                                                  case 7:
                                                                    setState(
                                                                        () {
                                                                      val =
                                                                          '5 years';
                                                                    });
                                                                    break;
                                                                  case 8:
                                                                    setState(
                                                                        () {
                                                                      val =
                                                                          '7 years';
                                                                    });
                                                                    break;
                                                                  case 9:
                                                                    setState(
                                                                        () {
                                                                      val =
                                                                          '8 years';
                                                                    });
                                                                    break;
                                                                  case 10:
                                                                    setState(
                                                                        () {
                                                                      val =
                                                                          '10 years';
                                                                    });
                                                                    break;
                                                                  case 11:
                                                                    setState(
                                                                        () {
                                                                      val =
                                                                          '15 years';
                                                                    });
                                                                    break;
                                                                  default:
                                                                    print(
                                                                        'choose an option');
                                                                }
                                                              _savingTime = val;
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
                    SizedBox(
                      height: 10.0.h,
                    ),
                    Row(
                      children: [
                        // Consumer<TotalValues>(
                        //   build
                        // ),
                        // (_path == null) ?
                        Flexible(
                          flex: 3,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Upload image of your savings goal (optional)',
                              style: TextStyle(fontSize: 16.0.h),
                            ),
                          ),
                        ),
                        // : Expanded(
                        //     child: Align(
                        //         alignment: Alignment.topLeft, child: Container()),
                        //   ),
                        Spacer(),
                        (_path != null)

                            ///use circleavatar if problems
                            ? GestureDetector(
                                onTap: () {
                                  _openFileExplorer();
                                },
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
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                'Savings Goal',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.h,
                                ),
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 0.4,
                        ),
                        Consumer<TotalValues>(
                          builder: (context, sgProvider, child) {
                            // print('uid: ${widget.uid}');
                            return FutureBuilder(
                              future: sgProvider.getSavingsInProvider(
                                  widget.uid), // async work
                              builder: (BuildContext context, snapshot) {
                                if (sgProvider.savingModelInstance != null) {
                                  return ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount:
                                        (sgProvider.savingModelInstance != null)
                                            ? sgProvider
                                                .savingModelInstance.length
                                            : 0,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () {
                                              navigateEditSavingGoal(
                                                  context,
                                                  sgProvider
                                                          .savingModelInstance[
                                                      index],
                                                  route);
                                              // print('running');
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
                                                    backgroundImage:
                                                        NetworkImage(
                                                            // if(index )
                                                            sgProvider
                                                                .savingModelInstance[
                                                                    index]
                                                                .url),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.0.w,
                                                ),
                                                Text(
                                                  sgProvider
                                                      .savingModelInstance[
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
                                                    int.parse(sgProvider
                                                        .savingModelInstance[
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
                                }
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return new Text('Loading....');
                                  default:
                                    if (snapshot.hasError)
                                      return new Text(
                                          'Error: ${snapshot.error}');
                                    else
                                      return ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount:
                                            (sgProvider.savingModelInstance !=
                                                    null)
                                                ? sgProvider
                                                    .savingModelInstance.length
                                                : 0,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Column(
                                            children: [
                                              GestureDetector(
                                                behavior:
                                                    HitTestBehavior.translucent,
                                                onTap: () {
                                                  navigateEditSavingGoal(
                                                      context,
                                                      sgProvider
                                                              .savingModelInstance[
                                                          index],
                                                      route);
                                                  // print('running');
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        (index + 1).toString() +
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
                                                        backgroundImage:
                                                            NetworkImage(
                                                                // if(index )
                                                                sgProvider
                                                                    .savingModelInstance[
                                                                        index]
                                                                    .url),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10.0.w,
                                                    ),
                                                    Text(
                                                      sgProvider
                                                          .savingModelInstance[
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
                                                        int.parse(sgProvider
                                                            .savingModelInstance[
                                                                index]
                                                            .goalAmount),
                                                      ),
                                                      textAlign: TextAlign.end,
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
                                  'Total Savings Goal:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0.h,
                                  ),
                                ),
                              ),
                            ),
                            // Spacer(),
                            SizedBox(
                              width: 30.w,
                            ),
                            Consumer<TotalValues>(
                              builder: (context, totaValue, child) {
                                return FutureBuilder(
                                    future: totaValue.savingsTot == null
                                        ? totaValue.getSavingsTotal(widget.uid)
                                        : null,
                                    builder: (context, snapshot) {
                                      // print("printing here");
                                      // print(totaValue.savingsTot);
                                      // refreshProvider(context);
                                      if (totaValue.savingsTot != null) {
                                        return Container(
                                          width: 80.0.w,
                                          child: (totaValue.savingsTot == 0)
                                              ? Text(
                                                  NumberFormat.simpleCurrency(
                                                    locale: 'en-us',
                                                    decimalDigits: 2,
                                                  ).format(
                                                      totaValue.savingsTot),
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
                                                      totaValue.savingsTot),
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
                                                child: (totaValue.savingsTot ==
                                                        0)
                                                    ? Text(
                                                        NumberFormat
                                                            .simpleCurrency(
                                                          locale: 'en-us',
                                                          decimalDigits: 2,
                                                        ).format(totaValue
                                                            .savingsTot),
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
                                                        ).format(totaValue
                                                            .savingsTot),
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
                        SizedBox(
                          height: 40.0.h,
                        ),
                        // Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
              // Spacer(),
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
                              (states) => Color(0xff0e8646),
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
                                    ? Colors.green
                                    : null;
                              },
                            ),
                          ),
                          onPressed: () => Timer(
                            const Duration(milliseconds: 400),
                            () {
                              // _validateInputs();
                              _validateInputs();
                              setState(() {});
                            },
                          ),
                          child: Text(
                            'Save\nThis Goal',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0.h,
                              color: Colors.white,
                              height: 1.0,
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
                              (states) => Color(0xff0e8646),
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
                                    ? Colors.green
                                    : null;
                              },
                            ),
                          ),
                          onPressed: () => Timer(
                            const Duration(milliseconds: 400),
                            () {
                              // _validateInputs();
                              _setAnotherGoalAndValidate();
                              _scrollToTop();
                              refreshProvider(context);
                              setState(() {
                                // getSavingsItems();
                              });
                            },
                          ),
                          child: Container(
                            child: Text(
                              'Set\nNew Goal',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.0.h,
                                color: Colors.white,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 85.0.w,
                        height: 50.0.h,
                        child: Consumer<TotalValues>(
                          builder: (context, modelInstance, state) {
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
                                () {
                                  // print(modelInstance.savingModelInstance);
                                  if (modelInstance
                                      .savingModelInstance.isNotEmpty) {
                                    navigateToSetInvestmentGoals(context);
                                  } else {
                                    Validator.onErrorDialog(
                                        "You must save at least one savings goal.",
                                        context);
                                  }
                                  // SharedPreferences prefs =
                                  //     await SharedPreferences.getInstance();
                                  // var currentUid = prefs.getString('storedUid');
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
              ),
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
                      style: TextStyle(
                        height: 1.4,
                        fontSize: 16.h,
                      ),
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
                  'Savings Goals',
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
            Text(
              "Savings typically earn low returns, but there's virtually no risk.",
              style: TextStyle(
                // fontWeight: FontWeight.bold,
                // color: Color(0xff0070c0),
                fontSize: 16.0.h,
              ),
            ),
            SizedBox(
              height: 17.h,
            ),
            Text(
              "Most people save to reach relatively short term goals like paying for a vacation or a down payment for a car or home. They also save for a rainy day.",
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
                  'Saving is Safe',
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
                "When you save, you put money in a safe place like a savings account or CD. Even though your savings don't earn much interest, they are readily available when you need them.",
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
                          // _launchUrl();
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
              minimumSize: MaterialStateProperty.resolveWith(
                  (states) => Size(80.w, 40.h)),
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
