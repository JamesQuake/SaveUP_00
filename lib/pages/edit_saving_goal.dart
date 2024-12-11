import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:pay_or_save/assets/dropdown/expanded_section.dart';
// import 'package:pay_or_save/assets/dropdown/new_dropdown.dart';
import 'package:pay_or_save/assets/dropdown/scrollbar.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/models/saving_goal_model.dart';
import 'package:pay_or_save/pages/about.dart';
import 'package:pay_or_save/providers/total_provider.dart';
import 'package:pay_or_save/services/services.dart';
import 'package:pay_or_save/utilities/validator.dart';
// import 'package:pay_or_save/widgets/menu.dart';
import 'package:provider/provider.dart';

class EditSavingGoal extends StatefulWidget {
  final String uid;
  final SavingModel savingModel;
  final String route;

  @override
  _EditSavingGoalState createState() => _EditSavingGoalState(uid, savingModel);

  EditSavingGoal(
      {Key key, @required this.uid, this.savingModel, @required this.route})
      : super(key: key);
}

class _EditSavingGoalState extends State<EditSavingGoal> {
  String _uid,
      _goal,
      _amount,
      _time,
      _fileURL,
      _path,
      _fileName,
      _extension,
      url;

  // bool _isStrechedDown = false;
  // int _groupValue;
  // String _title = 'Select';
  String _timeTitle;
  int _group2Value;
  bool _isStrechedDropDown2 = false;
  // bool _isClosed = true;

  List<String> _secondDropList = [
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
  bool _loadingDelete = false;
  Map<String, String> _paths;
  bool _loadingPath = false;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickingType;
  SavingModel savingModel;
  String myGoal;
  final myAmount = TextEditingController();

  final firestoreInstance = FirebaseFirestore.instance;
  final GlobalKey<FormState> _inputFormKey = GlobalKey<FormState>();
  final _myController = TextEditingController();

  _EditSavingGoalState(this._uid, this.savingModel);

  @override
  void initState() {
    super.initState();
    myGoal = savingModel.goal;
    myAmount.text =
        NumberFormat.simpleCurrency(locale: "en-us", decimalDigits: 0)
            .format(int.parse(savingModel.goalAmount))
            .toString();
    url = savingModel.url;
    _timeTitle = savingModel.time;
    _time = savingModel.time;
    _amount = savingModel.goalAmount;
    // _goal =
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
    if (_time != null && _amount != null) {
      // _inputFormKey.currentState.save();
      _saveGoal(_refereshTheProvider);
    } else {
      Validator.onErrorDialog("Make sure you provide all information", context);
    }
  }

  _saveGoal(_refereshTheProvider) {
    MainServices.onLoading(context);
    if (_path != null) {
      uploadFile().then((value) {
        firestoreInstance
            .collection("savingGoals")
            .doc("users")
            .collection(_uid)
            .doc(savingModel.key)
            .update({
          // 'savingFor': _goal,
          'savingGoal': _amount,
          'savingTime': _time,
          'photo': (_fileURL != null) ? _fileURL : "",
        }).then((value) {
          _refereshTheProvider.getSavingsTotal(widget.uid);
          setState(() {
            // _title = 'Select';
            url = (_fileURL != null) ? _fileURL : savingModel.url;
            // _timeTitle = 'Select';
            // _group2Value = null;
            // _refereshProvider.
          });
          Navigator.pop(context);
          // Validator.onErrorDialog("Saved", context);
          _inputFormKey.currentState?.reset();
          _path = null;
          Navigator.pop(context);
        });
      });
    } else {
      firestoreInstance
          .collection("savingGoals")
          .doc("users")
          .collection(_uid)
          .doc(savingModel.key)
          .update({
        // 'savingFor': _goal,
        'savingGoal': _amount,
        'savingTime': _time,
      }).then((value) {
        _refereshTheProvider.getSavingsTotal(widget.uid);
        setState(() {
          // _title = 'Select';
          // _timeTitle = 'Select';
          // _groupValue = null;
          // _group2Value = null;
          // url = (_fileURL != null) ? _fileURL : savingModel.url;
        });
        Navigator.pop(context);
        // Validator.onErrorDialog("Saved", context);
        _inputFormKey.currentState?.reset();
        _path = null;
        Navigator.pop(context);
      });
    }
  }

  // Future onSubmit(String message, context) {
  //   var _refereshProvider = Provider.of<TotalValues>(context, listen: false);
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
  //                     .collection("savingGoals")
  //                     .doc("users")
  //                     .collection(_uid)
  //                     .doc(savingModel.key)
  //                     .delete()
  //                     .then((_) async {
  //                   print('initial');
  //                   await _refereshProvider.getSavingsTotal(widget.uid);
  //                   print('in progress');
  //                   await _refereshProvider.getSavingsToDate(widget.uid);
  //                   print('it ran!');
  //                   Navigator.pop(context);
  //                   Navigator.popAndPushNamed(context, '/saving');
  //                 }).onError((error, stackTrace) {
  //                   print(error + ' obs');
  //                 });
  //                 // await firestoreInstance
  //                 //     .collection("savingGoals")
  //                 //     .doc("users")
  //                 //     .collection(_uid)
  //                 //     .doc(savingModel.key)
  //                 //     .delete();
  //                 // print('initial');
  //                 //   await _refereshProvider.getSavingsTotal(widget.uid);
  //                 //   print('in progress');
  //                 //   await _refereshProvider.getSavingsToDate(widget.uid);
  //                 //   print('it ran!');
  //                 //   Navigator.pop(context);
  //                 //   Navigator.pop(context);
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
      _loadingDelete = true;
    });
    displayLoading();
    firestoreInstance
        .collection("savingGoals")
        .doc("users")
        .collection(_uid)
        .doc(savingModel.key)
        .delete()
        .then((_) {
      print('initial');
      _refereshProvider.getSavingsTotal(widget.uid);
      print('in progress');
      _refereshProvider.getSavingsToDate(widget.uid);
      print('it ran!');
      setState(() {
        _loadingDelete = false;
      });
      Navigator.pop(context);
      Navigator.pop(context);
      // Navigator.popAndPushNamed(context, widget.route);
    });
  }

  // handleLoadingScreen(String message, context) async {
  //   await onSubmit(message, context);
  // }

  displayLoading() {
    if (_loadingDelete == true)
      return Center(
        child: LoadingBouncingGrid.circle(
          size: 50,
          backgroundColor: Color(0xff0070c0),
        ),
      );
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
        // actions: <Widget>[MyManue.childPopup(context)],
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context, rootNavigator: true)
              .popAndPushNamed(widget.route),
        ),
        title: Text("Edit Goal"),
        centerTitle: true,
      ),
      endDrawer: MainDrawer(uid: widget.uid),
      body: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 24.0.h, 24.0.w, 15.0.h),
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
                              Text('I’m saving for:'),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.h, horizontal: 40.0.w),
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
                              child: Text('Savings goal:'),
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
                                    // hintText: _amount,
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
                                  }

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
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10.h),
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
                                                                        '6 months';
                                                                    print(val);
                                                                  });
                                                                  break;
                                                                case 1:
                                                                  setState(() {
                                                                    val =
                                                                        '12 months';
                                                                  });
                                                                  break;
                                                                case 2:
                                                                  setState(() {
                                                                    val =
                                                                        '18 months';
                                                                  });
                                                                  break;
                                                                case 3:
                                                                  setState(() {
                                                                    val =
                                                                        '24 months';
                                                                  });
                                                                  break;
                                                                case 4:
                                                                  setState(() {
                                                                    val =
                                                                        '30 months';
                                                                  });
                                                                  break;
                                                                case 5:
                                                                  setState(() {
                                                                    val =
                                                                        '3 years';
                                                                  });
                                                                  break;
                                                                case 6:
                                                                  setState(() {
                                                                    val =
                                                                        '5 years';
                                                                  });
                                                                  break;
                                                                case 7:
                                                                  setState(() {
                                                                    val =
                                                                        '7 years';
                                                                  });
                                                                  break;
                                                                case 8:
                                                                  setState(() {
                                                                    val =
                                                                        '8 years';
                                                                  });
                                                                  break;
                                                                case 9:
                                                                  setState(() {
                                                                    val =
                                                                        '10 years';
                                                                  });
                                                                  break;
                                                                case 10:
                                                                  setState(() {
                                                                    val =
                                                                        '15 years';
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
                        // Expanded(
                        //   child: Align(
                        //     alignment: Alignment.centerLeft,
                        //     child: Text(
                        //       'Upload image of your savings goal (optional).',
                        //       softWrap: true,
                        //       // overflow: TextOverflow.clip,
                        //       // textAlign: TextAlign.left,
                        //     ),
                        //   ),
                        // ),
                        // IconButton(
                        //   // padding: EdgeInsets.only(left: 0.0),
                        //   icon: Icon(
                        //     Icons.help,
                        //     color: Colors.black,
                        //     size: 19,
                        //   ),
                        //   onPressed: () {
                        //     // _showAbDialog();
                        //     showSlideDialog(context);
                        //   },
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
                                              'Upload image of your savings goal (optional).'),
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
                                            showSlideDialog(context);
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
                                height: 70.h,
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

  showSlideDialog(BuildContext context) {
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
