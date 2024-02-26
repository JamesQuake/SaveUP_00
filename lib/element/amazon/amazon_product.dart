// import 'package:pay_or_save/models/subcategory.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/element/amazon/Amazon_Webview.dart';
import 'package:pay_or_save/element/amazon/Provider/amazon_provider.dart';
import 'package:pay_or_save/element/amazon/amazonbar.dart';
import 'package:pay_or_save/models/amazon/amazon_item.dart';
import 'package:pay_or_save/pages/webview.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../models/search.dart';
import '../../pages/invest_now.dart';
import '../../pages/save_now.dart';
// import '../element/ebaybar.dart';
// import '../models/productmodel.dart';
// import '../element/authoriser.dart';
// import 'sort.dart';
// import 'webview.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// import 'invest_now.dart';
// import 'overdraft_notice.dart';
// import 'save_now.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class AmazonProductPage extends StatefulWidget {
  final String itemId;
  final String uid;

  AmazonProductPage({
    this.itemId,
    this.uid,
  });

  @override
  _AmazonProductPageState createState() => _AmazonProductPageState();
}

class _AmazonProductPageState extends State<AmazonProductPage> {
  bool _isLoading = false;
  SharedPreferences _prefs;
  String uid;
  int _checking;
  String _productPrice, _url, _productTitle;
  String store = "Amazon";
  AsyncSnapshot projectSnapStorage;
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
  //     //print(response.body);

  //     return productModelFromJson(response.body);
  //   } else {
  //     throw Exception('Failed to load result');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // productSummary = _getproductSummary();
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
                builder: (context) => new AmazonWebview(
                      url: projectSnapStorage
                          .data.itemsResult.items[0].detailPageUrl,
                      title: projectSnapStorage.data.itemsResult.items[0]
                          .itemInfo.title.displayValue,
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
                  onPressed: () {
                    if (_productPrice != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SaveNow(
                                    incomingOrder: _productPrice ?? '',
                                    uid: widget.uid,
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
                                    uid: widget.uid,
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
      body: Consumer<AmazonProvider>(
        builder: (context, amzProv, child) {
          return CustomScrollView(
            // scrollDirection: Axis.,
            slivers: <Widget>[
              AmazonBar(
                cpage: "product",
                showtitle: false,
              ),
              FutureBuilder(
                future: amzProv.getAmzItem(widget.itemId),
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
                        if (projectSnap.connectionState !=
                            ConnectionState.done) {
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
                            projectSnap.data.itemsResult == null) {
                          return Container();
                        }
                        var rating = projectSnap.data.itemsResult.items[0]
                            .offers.listings[0].merchantInfo.feedbackRating;
                        double widthd = 130;
                        double widthd2 = 200;
                        if (projectSnap.connectionState == ConnectionState.done)
                          projectSnapStorage = projectSnap;
                        _productPrice = projectSnap.data.itemsResult.items[0]
                            .offers.listings[0].price.amount
                            .toString();
                        _url =
                            projectSnap.data.itemsResult.items[0].detailPageUrl;
                        _productTitle = projectSnap.data.itemsResult.items[0]
                                .itemInfo.title.displayValue ??
                            "Unknown";
                        var _productInfo = projectSnap
                            .data.itemsResult.items[0].itemInfo.productInfo;
                        var _prod4Color = projectSnap
                            .data.itemsResult.items[0].itemInfo.productInfo;
                        var _external4Upc = projectSnap
                            .data.itemsResult.items[0]?.itemInfo?.externalIds;
                        return Column(
                          children: [
                            Container(
                              constraints: BoxConstraints(maxHeight: 300),
                              child: Stack(
                                fit: StackFit.expand,
                                children: <Widget>[
                                  Center(child: CircularProgressIndicator()),
                                  Image.network(
                                    projectSnap.data.itemsResult.items[0].images
                                        .primary.large.url,
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 15, top: 15),
                              height: 65,
                              child: Text(
                                projectSnap.data.itemsResult.items[0].itemInfo
                                        .title.displayValue ??
                                    "Unknown",
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
                                projectSnap.data.itemsResult.items[0].offers
                                        .listings[0].price.displayAmount ??
                                    "Unknown",
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
                                  projectSnap.data.itemsResult.items[0].offers
                                          .listings[0].condition.value ??
                                      "Unknown",
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
                                                    projectSnap
                                                            .data
                                                            .itemsResult
                                                            .items[0]
                                                            .offers
                                                            .listings[0]
                                                            .condition
                                                            .value ??
                                                        "Unknown",
                                                    style:
                                                        TextStyle(fontSize: 14),
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
                                                    'Color',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black45,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: widthd2,
                                                  child: Text(
                                                    _prod4Color == null
                                                        ? "Unknown"
                                                        : _prod4Color.color ==
                                                                null
                                                            ? "Unknown"
                                                            : _prod4Color.color
                                                                .displayValue,
                                                    style:
                                                        TextStyle(fontSize: 14),
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
                                                    projectSnap
                                                                .data
                                                                .itemsResult
                                                                .items[0]
                                                                .itemInfo
                                                                .byLineInfo
                                                                .brand
                                                                .displayValue ==
                                                            null
                                                        ? 'Unknown'
                                                        : projectSnap
                                                            .data
                                                            .itemsResult
                                                            .items[0]
                                                            .itemInfo
                                                            .byLineInfo
                                                            .brand
                                                            .displayValue,
                                                    style:
                                                        TextStyle(fontSize: 14),
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
                                                    'Availability',
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
                                                            .itemsResult
                                                            .items[0]
                                                            ?.offers
                                                            ?.listings[0]
                                                            ?.availability
                                                            ?.message ??
                                                        "Unknown",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
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
                                                    projectSnap
                                                            .data
                                                            .itemsResult
                                                            .items[0]
                                                            ?.offers
                                                            ?.listings[0]
                                                            ?.merchantInfo
                                                            ?.defaultShippingCountry ??
                                                        "Unknown",
                                                    style:
                                                        TextStyle(fontSize: 14),
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
                                                    _external4Upc == null
                                                        ? "Unknown"
                                                        : _external4Upc.upCs ==
                                                                null
                                                            ? "Unknown"
                                                            : _external4Upc.upCs
                                                                .displayValues[0],
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ]),
                                      Column(
                                        children: [
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
                                                padding:
                                                    EdgeInsets.only(left: 15),
                                                // constraints:
                                                //     BoxConstraints(minHeight: 75),
                                                // child: Center(
                                                //   child: Icon(
                                                //     Icons.arrow_forward_ios_rounded,
                                                //     size: 25,
                                                //   ),
                                                // )
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
                                                  constraints: BoxConstraints(
                                                      maxWidth: 325),
                                                  child: Text(
                                                    projectSnap
                                                            .data
                                                            .itemsResult
                                                            .items[0]
                                                            .itemInfo
                                                            .features
                                                            .displayValues[0] ??
                                                        "Unknown" +
                                                            "\n" +
                                                            projectSnap
                                                                    .data
                                                                    .itemsResult
                                                                    .items[0]
                                                                    .itemInfo
                                                                    .features
                                                                    .displayValues[
                                                                1] ??
                                                        "",
                                                    // overflow:
                                                    //     TextOverflow.ellipsis,
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
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                      childCount: childCount,
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
