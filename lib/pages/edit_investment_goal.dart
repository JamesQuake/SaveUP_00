import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:pay_or_save/assets/dropdown/expanded_section.dart';
import 'package:pay_or_save/assets/dropdown/scrollbar.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/models/investment_goal_model.dart';
// import 'package:pay_or_save/pages/investment_goal.dart';
import 'package:pay_or_save/pages/about.dart';
import 'package:pay_or_save/providers/total_provider.dart';
import 'package:pay_or_save/services/services.dart';
import 'package:pay_or_save/utilities/validator.dart';
// import 'package:pay_or_save/widgets/menu.dart';
import 'package:provider/provider.dart';

class EditInvestmentGoal extends StatefulWidget {
  final String uid;
  final InvestmentModel investmentModel;
  final String route;

  @override
  _EditInvestmentGoalState createState() =>
      _EditInvestmentGoalState(uid, investmentModel);

  EditInvestmentGoal(
      {Key key, @required this.uid, this.investmentModel, @required this.route})
      : super(key: key);
}

class _EditInvestmentGoalState extends State<EditInvestmentGoal> {
  String _uid,
      _goal,
      _amount,
      _time,
      _fileURL,
      _path,
      _fileName,
      _extension,
      url;
  Map<String, String> _paths;
  bool _loadingPath = false;
  bool _multiPick = false;
  bool _hasValidMime = false;
  InvestmentModel investmentModel;
  FileType _pickingType;
  final firestoreInstance = FirebaseFirestore.instance;
  final GlobalKey<FormState> _inputFormKey = GlobalKey<FormState>();
  String myGoal;
  final myAmount = TextEditingController();

  String _timeTitle;
  int _group2Value;
  bool _isStrechedDropDown2 = false;
  bool _deleteLoading = false;
  // String incomingRoute = '/'

  List<String> _secondDropList = [
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

  _EditInvestmentGoalState(this._uid, this.investmentModel);

  @override
  void initState() {
    super.initState();
    myGoal = investmentModel.goal;
    myAmount.text =
        NumberFormat.simpleCurrency(locale: "en-us", decimalDigits: 0)
            .format(int.parse(investmentModel.goalAmount))
            .toString();
    url = investmentModel.url;
    _amount = investmentModel.goalAmount;
    _goal = investmentModel.goal;
    _timeTitle = investmentModel.time;
    _time = investmentModel.time;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future navigateToAbout(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
  }

  void _validateInputs() {
    var _refereshTheProvider = Provider.of<TotalValues>(context, listen: false);
    //    If all data are correct then save data to out variables
    if (_goal != null && _time != null) {
      // _inputFormKey.currentState.save();
      _saveGoal(_refereshTheProvider);
    } else {
      Validator.onErrorDialog("Make sure you provide all information", context);
    }
  }

  // Future onSubmit(String message, context) {
  //   return showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Alert"),
  //         content: Text(
  //           message,
  //           style: TextStyle(fontSize: 20),
  //         ),
  //         actions: [
  //           new FlatButton(
  //               child: const Text("No"),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               }),
  //           new FlatButton(
  //               child: const Text("Yes"),
  //               onPressed: () {
  //                 firestoreInstance
  //                     .collection("investmentGoals")
  //                     .doc("users")
  //                     .collection(_uid)
  //                     .doc(investmentModel.key)
  //                     .delete()
  //                     .then((_) {
  //                   Navigator.pop(context);
  //                   Navigator.pop(context);
  //                 });
  //               }),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future onSubmit(String message, context) {
    var _refereshProvider = Provider.of<TotalValues>(context, listen: false);
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Alert"),
          content: Text(
            message,
            style: TextStyle(fontSize: 20.h),
          ),
          actions: [
            new FlatButton(
                child: const Text("No"),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: const Text("Yes"),
                onPressed: () {
                  deleteGoal(_refereshProvider);
                  // Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }

  deleteGoal(TotalValues _refereshProvider) {
    setState(() {
      _deleteLoading = true;
    });
    displayLoading();
    firestoreInstance
        .collection("investmentGoals")
        .doc("users")
        .collection(_uid)
        .doc(investmentModel.key)
        .delete()
        .then((_) async {
      print('initial');
      await _refereshProvider.getInvestTotal(widget.uid);
      print('in progress');
      await _refereshProvider.getInvestToDate(widget.uid);
      print('it ran!');
      setState(() {
        _deleteLoading = false;
      });
      Navigator.pop(context);
      Navigator.pop(context);

      // Navigator.pushReplacementNamed(context, widget.route);
      // await
    });
  }

  // handleLoadingScreen(String message, context) async {
  //   await onSubmit(message, context);
  // }

  displayLoading() {
    if (_deleteLoading == true)
      return Center(
        child: LoadingBouncingGrid.circle(
          size: 50.h,
          backgroundColor: Color(0xff0070c0),
        ),
      );
  }

  _saveGoal(_refereshTheProvider) {
    MainServices.onLoading(context);
    if (_path != null) {
      uploadFile().then((value) {
        firestoreInstance
            .collection("investmentGoals")
            .doc("users")
            .collection(_uid)
            .doc(investmentModel.key)
            .update({
          'investTime': _time,
          'investGoal': _amount,
          'photo': (_fileURL != null) ? _fileURL : '',
        }).then((value) {
          _refereshTheProvider.getInvestTotal(widget.uid);
          Navigator.pop(context);
          setState(() {
            // url = investmentModel.url;
          });
          // Validator.onErrorDialog("Saved", context);
          _inputFormKey.currentState?.reset();
          _path = null;
          Navigator.pop(context);
        });
      });
    } else {
      firestoreInstance
          .collection("investmentGoals")
          .doc("users")
          .collection(_uid)
          .doc(investmentModel.key)
          .update({
        'investTime': _time,
        'investGoal': _amount,
      }).then((value) {
        _refereshTheProvider.getInvestTotal(widget.uid);
        Navigator.pop(context);
        // Validator.onErrorDialog("Saved", context);
        _inputFormKey.currentState?.reset();
        _path = null;
        Navigator.pop(context);
      });
    }
  }

  Future<String> uploadFile() async {
    final String fileGEn = Random().nextInt(10000).toString();
    firebase_storage.Reference storageReference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('SavingGoals')
        .child(_uid)
        .child(fileGEn + _fileName);
    firebase_storage.UploadTask uploadTask =
        storageReference.putFile(File(_path));
    //await uploadTask.onComplete;
    await uploadTask.then((firebase_storage.TaskSnapshot snapshot) {
      print('File Uploaded');
      setState(() {
        _path = "Uploaded";
      });
    }).catchError((Object e) {
      print(e); // FirebaseException
    });

    await storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _fileURL = fileURL;
        _path = null;
      });
      return fileURL;
    });
    return null;
  }

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
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
        title: Text("Edit Goal"),
        centerTitle: true,
      ),
      endDrawer: MainDrawer(uid: widget.uid),
      body: Padding(
        padding: EdgeInsets.all(24.h),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Form(
                child: ListView(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 10.0.h,
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 0.4,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 0.4,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text('I’m investing for:'),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 40.0),
                                child: Text(
                                  myGoal.toString() ?? 'Choose goal',
                                  style: TextStyle(
                                    fontSize: 16.0.h,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text('Investment goal:'),
                            ),
                            Spacer(),
                            SizedBox(
                              width: 170.0.w,
                              child: TextFormField(
                                controller: myAmount,
                                cursorColor: Colors.blue,
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 40.0.w,
                                    vertical: 8.0.h,
                                  ),
                                  hintText: "",
                                  hintStyle: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 13.7.h,
                                  ),
                                  // prefixText: '\$',
                                  isDense: true,
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
                                onChanged: (value) {
                                  var val = value.trim();
                                  if (value.contains(",") == true) {
                                    val = value.replaceAll(",", '');
                                    _amount = val;
                                  }

                                  if (value.contains("\$") == true) {
                                    _amount = val.replaceAll('\$', '');
                                  } else {
                                    _amount = val;
                                  }
                                },
                                // onSaved: (value) {
                                //   // final FocusScopeNode _currentScope =
                                //   //     FocusScope.of(context);
                                //   // if (!_currentScope.hasPrimaryFocus &&
                                //   //     _currentScope.hasFocus) {
                                //   //   FocusManager.instance.primaryFocus.unfocus();
                                //   // }
                                //   var val = value.trim();
                                //   print('val her');
                                //   print(val);
                                //   if (val.isNotEmpty) {
                                //     if (myAmount.text.contains('\$') == false) {
                                //       // myAmount.text = '\$' + val;
                                //       _amount = val;
                                //     } else {
                                //       // myAmount.text = '\$' + val;
                                //       _amount = val.replaceAll('\$', '');
                                //     }
                                //     if (val.contains(',') == true) {
                                //       _amount = val.replaceAll(',', '');
                                //     }
                                //   }
                                //   // myAmount.clear();
                                // },

                                ///removed the dollar sign
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
                                  vertical: 0, horizontal: 0),
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
                                                  Text('Time to achieve goal:'),
                                                  Spacer(),
                                                  Flexible(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10),
                                                      child: Text(
                                                        _timeTitle,
                                                        style: TextStyle(
                                                          fontSize: 17.0.h,
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _isStrechedDropDown2 =
                                                            !_isStrechedDropDown2;
                                                      });
                                                    },
                                                    child: Icon(
                                                      _isStrechedDropDown2
                                                          ? Icons.expand_less
                                                          : Icons.expand_more,
                                                      size: 30.h,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            ExpandedSection(
                                              expand: _isStrechedDropDown2,
                                              height: 100,
                                              child: MyScrollbar(
                                                builder: (context,
                                                        scrollController2) =>
                                                    ListView.builder(
                                                  padding: EdgeInsets.all(0),
                                                  controller: scrollController2,
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      _secondDropList.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return RadioListTile(
                                                      title: Text(
                                                        _secondDropList
                                                            .elementAt(index),
                                                        style: TextStyle(
                                                            // fontSize: 15.0,
                                                            ),
                                                      ),
                                                      activeColor:
                                                          Color(0xff0070c0),
                                                      value: index,
                                                      groupValue: _group2Value,
                                                      onChanged: (val) {
                                                        setState(() {
                                                          _group2Value = val;
                                                          _timeTitle =
                                                              _secondDropList
                                                                  .elementAt(
                                                                      index);
                                                          // retailer = val;
                                                        });

                                                        if (_isStrechedDropDown2 ==
                                                            true) {
                                                          setState(() {
                                                            _isStrechedDropDown2 =
                                                                false;
                                                            if (mounted)
                                                              switch (val) {
                                                                case 0:
                                                                  setState(() {
                                                                    // val = val.toString();
                                                                    val =
                                                                        "3 years";
                                                                    print(val);
                                                                  });
                                                                  break;
                                                                case 1:
                                                                  setState(() {
                                                                    val =
                                                                        "5 years";
                                                                  });
                                                                  break;
                                                                case 2:
                                                                  setState(() {
                                                                    val =
                                                                        "10 years";
                                                                  });
                                                                  break;
                                                                case 3:
                                                                  setState(() {
                                                                    val =
                                                                        "15 years";
                                                                  });
                                                                  break;
                                                                case 4:
                                                                  setState(() {
                                                                    val =
                                                                        "20 years";
                                                                  });
                                                                  break;
                                                                case 5:
                                                                  setState(() {
                                                                    val =
                                                                        "25 years";
                                                                  });
                                                                  break;
                                                                case 6:
                                                                  setState(() {
                                                                    val =
                                                                        "30 years";
                                                                  });
                                                                  break;
                                                                case 7:
                                                                  setState(() {
                                                                    val =
                                                                        "35 years";
                                                                  });
                                                                  break;
                                                                case 8:
                                                                  setState(() {
                                                                    val =
                                                                        "40 years";
                                                                  });
                                                                  break;
                                                                case 9:
                                                                  setState(() {
                                                                    val =
                                                                        "45 years";
                                                                  });
                                                                  break;
                                                                default:
                                                                  print(
                                                                      'choose an option');
                                                              }
                                                            _time = val;
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
                        SizedBox(
                          height: 32.h,
                        ),
                        // SizedBox(
                        //   height: 10.0,
                        // ),
                        Row(
                          children: [
                            // (_path == null)
                            //     ?
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                width: 120.w,
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                          text:
                                              'Upload image of your investment goal (optional).'),
                                      WidgetSpan(
                                        // alignment: PlaceholderAlignment.bottom,
                                        child: IconButton(
                                          padding: EdgeInsets.all(0.0),
                                          constraints: BoxConstraints(),
                                          icon: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              0.0,
                                              4.0,
                                              0.0,
                                              0.0,
                                            ),
                                            child: Icon(
                                              Icons.help,
                                              color: Colors.black,
                                              size: 19.h,
                                            ),
                                          ),
                                          onPressed: () {
                                            // _showAbDialog();
                                            _displaySlideDialog(context);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // : Expanded(
                            //     child: Align(
                            //       alignment: Alignment.topLeft,
                            //       child: Text(
                            //         _path,
                            //         textAlign: TextAlign.left,
                            //         style:
                            //             TextStyle(fontSize: 16, color: Colors.green),
                            //       ),
                            //     ),
                            //   ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                _openFileExplorer();
                              },
                              child: Container(
                                width: 70.w,
                                height: 70.w,
                                child: CircleAvatar(
                                  backgroundImage: (_path == null)
                                      ? NetworkImage(url)
                                      : Image.file(File(_path)).image,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 70.0.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Text(
                                "Remove Goal",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19.h),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 31.h,
                              ),
                              onPressed: () {
                                onSubmit(
                                    "Are you sure you want to delete this goal?",
                                    context);
                              },
                            ),
                          ],
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: <Widget>[
                        //     Container(
                        //       width: 70,
                        //       height: 70,
                        //       child: CircleAvatar(
                        //         backgroundImage: (_path == null)
                        //             ? AssetImage(url)
                        //             : Image.file(File(_path)).image,
                        //       ),
                        //     ),
                        //     ButtonTheme(
                        //       minWidth: 120.0,
                        //       height: 50.0,
                        //       child: RaisedButton(
                        //         textColor: Colors.white,
                        //         color: Color(0xff0070c0),
                        //         child: Text("Upload New Image"),
                        //         onPressed: () {
                        //           _openFileExplorer();
                        //         },
                        //         shape: new RoundedRectangleBorder(
                        //           borderRadius: new BorderRadius.circular(20.0),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 0.0, right: 0.0, bottom: 10),
              child: ButtonTheme(
                minWidth: 120.0.w,
                height: 50.0.h,
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Color(0xff0070c0),
                  child: Text("Done"),
                  onPressed: () {
                    _validateInputs();
                  },
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _displaySlideDialog(BuildContext context) {
    // set up the buttons
    Widget okButton = TextButton(
      child: Text(
        "OK",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
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
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '•',
            style: TextStyle(
              fontSize: 45.0.h,
              height: 1.2,
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: 5.0.w,
          ),
          Text(
            'Tap image to edit it.',
            style: TextStyle(
              fontSize: 18.0.h,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
