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
import 'package:pay_or_save/element/walmart_bar.dart';
import 'package:pay_or_save/pages/webview.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../models/search.dart';
import '../element/ebaybar.dart';
import '../models/productmodel.dart';
import '../element/authoriser.dart';
// import 'sort.dart';
// import 'webview.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../models/walmart_items_model.dart';
import 'invest_now.dart';
// import 'overdraft_notice.dart';
import 'save_now.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class WalmartProductPage extends StatefulWidget {
  // final String itemId;
  final String uid;
  final Item item;

  WalmartProductPage({
    // this.itemId,
    this.uid,
    this.item,
  });

  @override
  _WalmartProductPageState createState() => _WalmartProductPageState();
}

class _WalmartProductPageState extends State<WalmartProductPage> {
  bool _isLoading = false;
  SharedPreferences _prefs;
  // String uid;
  int _checking;
  // String _productPrice, _url, _productTitle;
  String store = "Walmart";
  // AsyncSnapshot projectSnapStorage;
  // final firestoreInstance = FirebaseFirestore.instance;

  // Future<ProductModel> productSummary;
  var token;
  String outgoingOrder;

  // Future<ProductModel> _getproductSummary() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   final itemId = widget.itemId;

  //   _prefs = await SharedPreferences.getInstance();
  //   var currentUid = _prefs.getString('storedUid');
  //   uid = currentUid;

  //   String apiUrl;
  //   apiUrl = 'https://api.ebay.com/buy/browse/v1/item/$itemId';

  //   final response = await makeCall(apiUrl);

  //   if (response.statusCode == 200) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     print('_getproductSummary');
  //     print(response.body);

  //     return productModelFromJson(response.body);
  //   } else {
  //     throw Exception('Failed to load result');
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   productSummary = _getproductSummary();
  // }

  showPayDialog(BuildContext context) {
    // set up the buttons
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new EbayWebView(
              url: widget.item.url,
              title: widget.item.name,
            ),
          ),
        );
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
                  text: " SaveUp",
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
                    if (widget.item.url != null && widget.item.name != null) {
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
                      print("either" +
                          widget.item.url +
                          "or" +
                          widget.item.name +
                          "is null");
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
                    if (widget.item.currentPrice != null) {
                      // print('user id');
                      // ProductModel _ff;
                      // await productSummary.then((value) => _ff = value);
                      print('${FirebaseAuth.instance.currentUser.uid}');
                      FirebaseFirestore.instance
                          .collection('virtualCloset')
                          .add({
                        'uid': FirebaseAuth.instance.currentUser.uid,
                        'pName': widget.item.name,
                        'pPrice': widget.item.currentPrice,
                        'pImage': widget.item.imageUrl,
                        'pId': widget.item.id,
                        'pUrl': widget.item.url,
                        'walmartUri': widget.item.uri,
                        'status': true,
                        'platform': 'Walmart',
                        'doc': DateTime.now(),
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SaveNow(
                            incomingOrder: widget.item.currentPrice ?? '',
                            uid: widget.uid,
                          ),
                        ),
                      );
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
                    if (widget.item.currentPrice != null) {
                      FirebaseFirestore.instance
                          .collection('virtualCloset')
                          .add({
                        'uid': FirebaseAuth.instance.currentUser.uid,
                        'pName': widget.item.name,
                        'pPrice': widget.item.currentPrice,
                        'pImage': widget.item.imageUrl,
                        'pId': widget.item.id,
                        'pUrl': widget.item.url,
                        'walmartUri': widget.item.uri,
                        'status': true,
                        'platform': 'Walmart',
                        'doc': DateTime.now(),
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InvestNow(
                            incomingOrder: widget.item.currentPrice ?? '',
                            uid: widget.uid,
                          ),
                        ),
                      );
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
          new WalmartBar(
            cpage: "product",
            showtitle: false,
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 1000,
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
              childAspectRatio: 0.32,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                double widthd = 130;
                double widthd2 = 200;

                return Column(
                  children: [
                    Container(
                      constraints: BoxConstraints(maxHeight: 300),
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Center(child: CircularProgressIndicator()),
                          Image.network(
                            widget.item.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15, top: 15),
                      height: 65,
                      child: Text(
                        widget.item.name,
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
                        '\$' + widget.item.currentPrice,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
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
                          widget.item.condition.isNotEmpty
                              ? widget.item.condition
                              : 'New',
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                            widget.item.condition.isNotEmpty
                                                ? widget.item.condition
                                                : 'New',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              top: 25, bottom: 5),
                                          width: widthd,
                                          child: Text(
                                            'Manufacturer',
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
                                            widget.item.manufacturer.isNotEmpty
                                                ? widget.item.manufacturer
                                                : 'Unknown',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (widget.item.material.isNotEmpty) ...[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: 25, bottom: 5),
                                            width: widthd,
                                            child: Text(
                                              'Material',
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
                                              widget.item.material,
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    if (widget
                                        .item.stockAvailability.isNotEmpty) ...[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: 25, bottom: 5),
                                            width: widthd,
                                            child: Text(
                                              'Stock Availability',
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
                                              widget.item.stockAvailability,
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    if (widget.item.size.isNotEmpty) ...[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: 25, bottom: 5),
                                            width: widthd,
                                            child: Text(
                                              'Size',
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
                                              '${widget.item.size} ${widget.item.sizeUnit}',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    if (widget.item.weight.isNotEmpty) ...[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: 25, bottom: 5),
                                            width: widthd,
                                            child: Text(
                                              'Weight',
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
                                              '${widget.item.weight} ${widget.item.weightUnit}',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
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
                                          child: Text(widget.item.category,
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
                                              top: 5, bottom: 25),
                                          width: widthd,
                                          child: Text(
                                            'GTIN',
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
                                            widget.item.gtin,
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
                    if (widget.item.description.isNotEmpty) ...[
                      Container(
                        padding: EdgeInsets.only(top: 30, bottom: 30),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Item Description',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              widget.item.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                );
              },
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}
