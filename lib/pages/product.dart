// import 'package:pay_or_save/models/subcategory.dart';
// import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/pages/webview.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../models/search.dart';
import '../element/ebaybar.dart';
import '../models/productmodel.dart';
import '../element/authoriser.dart';
// import 'sort.dart';
// import 'webview.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'invest_now.dart';
// import 'overdraft_notice.dart';
import 'save_now.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class ProductPage extends StatefulWidget {
  final String itemId;
  final String uid;

  ProductPage({
    this.itemId,
    this.uid,
  });

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool _isLoading = false;
  SharedPreferences _prefs;
  String uid;
  int _checking;
  String _productPrice, _url, _productTitle;
  String store = "eBay";
  AsyncSnapshot projectSnapStorage;
  // final firestoreInstance = FirebaseFirestore.instance;

  Future<ProductModel> productSummary;
  var token;
  String outgoingOrder;

  Future<ProductModel> _getproductSummary() async {
    setState(() {
      _isLoading = true;
    });

    final itemId = widget.itemId;

    _prefs = await SharedPreferences.getInstance();
    var currentUid = _prefs.getString('storedUid');
    uid = currentUid;

    String apiUrl;
    apiUrl = 'https://api.ebay.com/buy/browse/v1/item/$itemId';

    final response = await makeCall(apiUrl);

    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      print('_getproductSummary');
      print(response.body);

      return productModelFromJson(response.body);
    } else {
      throw Exception('Failed to load result');
    }
  }

  @override
  void initState() {
    super.initState();
    productSummary = _getproductSummary();
  }

  showPayDialog(BuildContext context) {
    // set up the buttons
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        // print(projectSnapStorage.data.title);
        if (projectSnapStorage.hasData == true) {
          Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new EbayWebView(
                      url: projectSnapStorage.data.itemWebUrl,
                      title: projectSnapStorage.data.title,
                    )),
          );
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "We are redirecting you to " +
                store +
                " to complete checkout. As an " +
                store +
                " affiliate, we earn from qualifying purchases.",
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          SizedBox(height: 10.0),
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.black,
                height: 1.0,
                // fontStyle: FontStyle.italic,
                fontSize: 16,
              ),
              children: [
                TextSpan(
                  text: "Tap on ",
                ),
                TextSpan(
                  text: " < ",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                ),
                TextSpan(
                  text: " to return to ",
                ),
                TextSpan(
                  text: " eWyzly",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(height: 15.0),
          // ElevatedButton(
          //   onPressed: () {},
          //   child: Text(
          //     '<',
          //     style: TextStyle(
          //       fontSize: 25.0,
          //       color: Colors.white,
          //     ),
          //   ),
          //   style: ElevatedButton.styleFrom(
          //     shape: CircleBorder(),
          //     primary: Colors.blue,
          //     // padding: EdgeInsets.all(10),
          //   ),
          // ),
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

  // _getCheckingBalance() {
  //   return firestoreInstance.collection("users").doc(uid).get().then((db) {
  //     _checking = db.data()['checking'].toInt();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: MainDrawer(uid: widget.uid),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        // alignment: Alignment.center,
        // width: 250.0,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: const BorderRadius.all(Radius.circular(40.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 62,
                height: 62,
                child: FloatingActionButton(
                  heroTag: 'pay',
                  onPressed: () {
                    if (_url != null && _productTitle != null) {
                      // Navigator.push(
                      //   context,
                      //   new MaterialPageRoute<String>(
                      //       builder: (context) => new EbayWebView(
                      //             url: _url ?? '',
                      //             title: _productTitle ?? '',
                      //           )),
                      // );
                      showPayDialog(context);
                    } else {
                      print("either" + _url + "or" + _productTitle + "is null");
                    }
                  },
                  backgroundColor: Color(0xffe83a0c),
                  child: Text(
                    'Pay',
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 35.0),
              Container(
                width: 62,
                height: 62,
                child: FloatingActionButton(
                  heroTag: 'save',
                  onPressed: () async {
                    if (_productPrice != null) {
                      print('user id');
                      ProductModel _ff;
                      await productSummary.then((value) => _ff = value);
                      print('${FirebaseAuth.instance.currentUser.uid}');
                      FirebaseFirestore.instance.collection('virtualCloset').add({
                        'uid': FirebaseAuth.instance.currentUser.uid,
                        'pName':_productTitle,
                        'pPrice':_productPrice,
                        'pImage':_ff.image.imageUrl,
                        'pId': _ff.itemId,
                        'pUrl': _url,
                        'status':true,
                        'platform':'eBay',
                        'doc':DateTime.now(),
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SaveNow(
                                    incomingOrder: _productPrice ?? '',
                                    uid: uid,
                                  )));
                    } else {
                      print('_price is null');
                    }
                  },
                  backgroundColor: Color(0xff2ca858),
                  child: Text(
                    '\$ave',
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 35.0),
              Container(
                width: 62,
                height: 62,
                child: FloatingActionButton(
                  heroTag: 'invest',
                  onPressed: () {
                    if (_productPrice != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InvestNow(
                                    incomingOrder: _productPrice ?? '',
                                    uid: uid,
                                  )));
                    } else {
                      print('invest price is null');
                    }
                  },
                  backgroundColor: Color(0xff3790ce),
                  child: Text(
                    'Invest',
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        // scrollDirection: Axis.,
        slivers: <Widget>[
          new ebaybar(
            cpage: "product",
            showtitle: false,
          ),
          FutureBuilder<ProductModel>(
            future: productSummary,
            builder: (context, projectSnap) {
              var childCount = 0;
              if (projectSnap.hasError) {
                childCount = 1;
              } else {
                childCount = 1;
              }
              return SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 1000,
                  mainAxisSpacing: 1.0,
                  crossAxisSpacing: 1.0,
                  childAspectRatio: 0.32,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (projectSnap.connectionState != ConnectionState.done) {
                      return Column(children: [
                        Container(
                          height: 300,
                          //padding: EdgeInsets.only(top:7,bottom:7),
                          child: Center(
                            //width: 50,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      ]);
                    }
                    if (projectSnap.hasError) {
                      return Container();
                    }
                    if (projectSnap.hasData == null ||
                        projectSnap.data.itemId == null) {
                      return Container();
                    }
                    var rating = double.parse(
                            projectSnap.data.seller.feedbackPercentage) /
                        100 *
                        5;
                    double widthd = 130;
                    double widthd2 = 200;
                    if (projectSnap.connectionState == ConnectionState.done)
                      projectSnapStorage = projectSnap;
                    _productPrice = projectSnap.data.price.value;
                    _url = projectSnap.data.itemWebUrl;
                    _productTitle = projectSnap.data.title;

                    return Column(
                      children: [
                        Container(
                          constraints: BoxConstraints(maxHeight: 300),
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              Center(child: CircularProgressIndicator()),
                              Image.network(
                                projectSnap.data.image.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 15, top: 15),
                          height: 65,
                          child: Text(
                            projectSnap.data.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 15),
                          alignment: Alignment.centerLeft,
                          height: 40,
                          child: Text(
                            '\$' + projectSnap.data.price.value,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 15),
                          constraints: BoxConstraints(minHeight: 50),
                          child: Row(
                            children: [
                              Text(
                                'RATINGS  ',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black38),
                              ),
                              RatingBar.builder(
                                initialRating: rating,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 24.0,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 1.0),
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          constraints: BoxConstraints(minHeight: 50),
                          decoration: BoxDecoration(
                              border: Border(
                            bottom: BorderSide(
                              //                   <--- left side
                              color: Colors.black,
                              width: 1.0,
                            ),
                            top: BorderSide(
                              //                   <--- left side
                              color: Colors.black,
                              width: 1.0,
                            ),
                          )),
                          child: Center(
                            child: Text(
                              projectSnap.data.condition,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 30),
                          constraints: BoxConstraints(minHeight: 175),
                          decoration: BoxDecoration(
                              border: Border(
                            bottom: BorderSide(
                              //                   <--- left side
                              color: Colors.black38,
                              width: 1.0,
                            ),
                          )),
                          margin: EdgeInsets.only(left: 15, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'About this Item',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 25, bottom: 5),
                                              width: widthd,
                                              child: Text(
                                                'Condition',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black45,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 25, bottom: 5),
                                              width: widthd2,
                                              child: Text(
                                                projectSnap.data.condition,
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              width: widthd,
                                              child: Text(
                                                'Quantity',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black45,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: widthd2,
                                              child: Text(
                                                projectSnap
                                                    .data
                                                    .estimatedAvailabilities[0]
                                                    .availabilityThreshold
                                                    .toString(),
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              width: widthd,
                                              child: Text(
                                                'Brand',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black45,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: widthd2,
                                              child: Text(
                                                projectSnap.data.brand == null
                                                    ? 'Unknown'
                                                    : projectSnap.data.brand,
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              width: widthd,
                                              child: Text(
                                                'Category path',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black45,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: widthd2,
                                              child: Text(
                                                  projectSnap.data.categoryPath,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.green)),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              width: widthd,
                                              child: Text(
                                                'Item Location',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black45,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: widthd2,
                                              child: Text(
                                                projectSnap.data.itemLocation
                                                        .city +
                                                    ', ' +
                                                    projectSnap.data
                                                        .itemLocation.country,
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 5, bottom: 25),
                                              width: widthd,
                                              child: Text(
                                                'UPC',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black45,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 5, bottom: 25),
                                              width: widthd2,
                                              child: Text(
                                                projectSnap.data.legacyItemId,
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]),
                                  Column(children: [
                                    Material(
                                        child: InkWell(
                                      // onTap: () => Navigator.push(
                                      //   context,
                                      //   new MaterialPageRoute<String>(
                                      //       builder: (context) =>
                                      //           new EbayWebView(
                                      //             url: projectSnap
                                      //                 .data.itemWebUrl,
                                      //             title: projectSnap.data.title,
                                      //           )),
                                      // ), // handle your onTap here
                                      child: Container(
                                        padding: EdgeInsets.only(left: 15),
                                        // constraints:
                                        //     BoxConstraints(minHeight: 75),
                                        // child: Center(
                                        //   child: Icon(
                                        //     Icons.arrow_forward_ios_rounded,
                                        //     size: 25,
                                        //   ),
                                        // )
                                      ),
                                    ))
                                  ]),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 30),
                          constraints: BoxConstraints(minHeight: 175),
                          decoration: BoxDecoration(
                              border: Border(
                            bottom: BorderSide(
                              //                   <--- left side
                              color: Colors.black38,
                              width: 1.0,
                            ),
                          )),
                          margin: EdgeInsets.only(left: 15, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Item Description',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 25, bottom: 15),
                                              constraints:
                                                  BoxConstraints(maxWidth: 325),
                                              child: Text(
                                                projectSnap
                                                    .data.shortDescription,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]),
                                  Column(children: [
                                    Material(
                                        child: InkWell(
                                      // onTap: () => Navigator.push(
                                      //   context,
                                      //   new MaterialPageRoute<String>(
                                      //       builder: (context) =>
                                      //           new EbayWebView(
                                      //             url: projectSnap
                                      //                 .data.itemWebUrl,
                                      //             title: projectSnap.data.title,
                                      //           )),
                                      // ), // handle your onTap here
                                      child: Container(
                                        padding: EdgeInsets.only(left: 15),
                                        // constraints:
                                        //     BoxConstraints(minHeight: 75),
                                        // child: Center(
                                        //   child: Icon(
                                        //     Icons.arrow_forward_ios_rounded,
                                        //     size: 25,
                                        //   ),
                                        // )
                                      ),
                                    ))
                                  ]),
                                ],
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.end,
                              //   children: [
                              //     Column(children: [
                              //       Material(
                              //           child: InkWell(
                              //         onTap: () => Navigator.push(
                              //           context,
                              //           new MaterialPageRoute<String>(
                              //               builder: (context) =>
                              //                   new EbayWebView(
                              //                     url: projectSnap
                              //                         .data.itemWebUrl,
                              //                     title: projectSnap.data.title,
                              //                   )),
                              //         ), // handle your onTap here
                              //         child: Container(
                              //           padding: EdgeInsets.only(
                              //               right: 30, bottom: 25),
                              //           child: Text(
                              //             'Read more',
                              //             style: TextStyle(
                              //                 fontSize: 16,
                              //                 fontWeight: FontWeight.bold,
                              //                 color: Color(0xff0078ff)),
                              //           ),
                              //         ),
                              //       ))
                              //     ]),
                              //   ],
                              // )
                            ],
                          ),
                        ),
                        // Container(
                        //   // padding: EdgeInsets.only(top: 30),
                        //   constraints: BoxConstraints(minHeight: 175),
                        //   decoration: BoxDecoration(
                        //       border: Border(
                        //     bottom: BorderSide(
                        //       //                   <--- left side
                        //       color: Colors.black38,
                        //       width: 1.0,
                        //     ),
                        //   )),
                        //   margin: EdgeInsets.only(left: 15, right: 15),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        // Row(
                        //   mainAxisAlignment:
                        //       MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     GestureDetector(
                        //       onTap: () {
                        //         // isFav
                        //         //     ? _controller.reverse()
                        //         //     : _controller.forward();
                        //         // Navigator.push(
                        //         //     context,
                        //         //     MaterialPageRoute(
                        //         //         builder: (context) => MyOverdraft(
                        //         //             // uid: widget.uid,
                        //         //             )));
                        //         Navigator.push(
                        //           context,
                        //           new MaterialPageRoute<String>(
                        //               builder: (context) =>
                        //                   new EbayWebView(
                        //                     url: projectSnap
                        //                         .data.itemWebUrl,
                        //                     title: projectSnap.data.title,
                        //                   )),
                        //         );
                        //       },
                        //       child: Container(
                        //         width: 100.0,
                        //         height: 100.0,
                        //         decoration: BoxDecoration(
                        //           color: Color(0xff3790ce),
                        //           shape: BoxShape.circle,
                        //           boxShadow: [
                        //             BoxShadow(
                        //               color: Colors.grey.withOpacity(0.4),
                        //               spreadRadius: 5,
                        //               blurRadius: 7,
                        //               offset: Offset(0,
                        //                   3), // changes position of shadow
                        //             ),
                        //           ],
                        //         ),
                        //         child: Align(
                        //           alignment: Alignment.center,
                        //           child: Text(
                        //             'Pay',
                        //             style: TextStyle(
                        //               color: Colors.white,
                        //               fontSize: 23.0,
                        //               fontWeight: FontWeight.w600,
                        //             ),
                        //           ),
                        //         ),
                        //         // color: Color(0xff3790ce),
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       width: 10.0,
                        //     ),
                        //     GestureDetector(
                        //       onTap: () {
                        //         // isFav
                        //         // ? _controller.reverse()
                        //         //     : _controller.forward();
                        //         // if(_chcking < amt) {'navigate to overdraft page'}
                        //         // await _getCheckingBalance();

                        //         Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //                 builder: (context) => SaveNow(
                        //                       incomingOrder: projectSnap
                        //                           .data.price.value,
                        //                       uid: uid,
                        //                     )));
                        //       },
                        //       child: Container(
                        //         width: 100.0,
                        //         // _sizeAnimation.value,
                        //         height: 100.0,
                        //         // _sizeAnimation.value,
                        //         decoration: BoxDecoration(
                        //           color: Color(0xff11a858),
                        //           shape: BoxShape.circle,
                        //           boxShadow: [
                        //             BoxShadow(
                        //               color: Colors.grey.withOpacity(0.4),
                        //               spreadRadius: 5,
                        //               blurRadius: 7,
                        //               offset: Offset(0,
                        //                   3), // changes position of shadow
                        //             ),
                        //           ],
                        //         ),
                        //         child: Align(
                        //           alignment: Alignment.center,
                        //           child: Text(
                        //             'Save',
                        //             style: TextStyle(
                        //               color: Colors.white,
                        //               fontSize: 23.0,
                        //               fontWeight: FontWeight.w600,
                        //             ),
                        //           ),
                        //         ),
                        //         // color: Color(0xff11a858),
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       width: 10.0,
                        //     ),
                        //     GestureDetector(
                        //       onTap: () {
                        //         // await _getCheckingBalance();
                        //         Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //                 builder: (context) => InvestNow(
                        //                       incomingOrder: projectSnap
                        //                           .data.price.value,
                        //                       uid: uid,
                        //                     )));
                        //       },
                        //       child: Container(
                        //         width: 100.0,
                        //         height: 100.0,
                        //         decoration: BoxDecoration(
                        //           color: Color(0xff11a858),
                        //           shape: BoxShape.circle,
                        //           boxShadow: [
                        //             BoxShadow(
                        //               color: Colors.grey.withOpacity(0.4),
                        //               spreadRadius: 5,
                        //               blurRadius: 7,
                        //               offset: Offset(0,
                        //                   3), // changes position of shadow
                        //             ),
                        //           ],
                        //         ),
                        //         child: Align(
                        //           alignment: Alignment.center,
                        //           child: Text(
                        //             'Invest',
                        //             style: TextStyle(
                        //               color: Colors.white,
                        //               fontSize: 23.0,
                        //               fontWeight: FontWeight.w600,
                        //             ),
                        //           ),
                        //         ),
                        //         // color: Color(0xff11a858),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    );
                  },
                  childCount: childCount,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
