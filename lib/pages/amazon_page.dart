// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/element/amazon/Provider/categories_provider.dart';
import 'package:pay_or_save/element/amazon/amazonbar.dart';
import 'package:pay_or_save/element/amazon/amz_subcategories.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:english_words/english_words.dart';
// import 'package:transparent_image/transparent_image.dart';
// import 'dart:convert';
import '../element/amazon/amazonbar.dart';
// import '../models/category.dart';
// import '../element/ebaybar.dart';
import '../models/category.dart';
import 'subcategory.dart';

// class Ebaypage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Ebay Search',
//       theme: ThemeData(
//         // Add the 3 lines from here...
//         primaryColor: Colors.white,
//       ),
//       home: RandomWords(),
//     );
//   }
// }

class Amazon extends StatefulWidget {
  final String uid;

  const Amazon({Key key, this.uid}) : super(key: key);
  @override
  _AmazonState createState() => _AmazonState();
}

class _AmazonState extends State<Amazon> {
  List<Category> _categoryList = [];
  bool _isLoading = false;
  // SharedPreferences _prefss;

  // _getUsers() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  // initialize() async {
  //   var data = await DefaultAssetBundle.of(context)
  //       .loadString("assets/db/amzcat.json");
  //   print("sumo");
  //   print(data);
  //   _categoryList = categoryFromJson(data);
  //   setState(() {});
  // }
  // await getPrefs();

  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  // getPrefs() async {
  //   _prefss = await SharedPreferences.getInstance();
  //   await _prefss.setString('storedUid', widget.uid);
  // }

  @override
  void initState() {
    super.initState();
    // initialize();
    // _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: MainDrawer(uid: widget.uid),
      body: Consumer<AmzCategoriesProvider>(
        builder: (context, amz, child) {
          return CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: <Widget>[
              new AmazonBar(
                cpage: "main",
                showtitle: true,
                uid: widget.uid,
              ),
              SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250.0,
                  mainAxisSpacing: 1.0,
                  crossAxisSpacing: 1.0,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Material(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new AmzSubCategory(
                                      catId: amz.cat[index]["category"]
                                          ["categoryId"],
                                      catName: amz.cat[index]["category"]
                                          ["categoryName"],
                                      imgUrl: amz.cat[index]["category"]
                                          ["imageUrl"],
                                      uid: widget.uid,
                                    )),
                          );
                        }, // handle your onTap here
                        child: Container(
                            margin: EdgeInsets.only(
                              left: 15,
                              right: 15,
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        bottom: 8,
                                      ),
                                      width: 160,
                                      height: 160,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: <Widget>[
                                            Center(
                                                child:
                                                    CircularProgressIndicator()),
                                            Image.network(
                                              amz.cat[index]["category"]
                                                  ["imageUrl"],
                                              fit: BoxFit.cover,
                                            ),
                                          ],
                                        ),

                                        // CachedNetworkImage(
                                        //   imageUrl:  categoryList[index].category.imageUrl,,
                                        //   placeholder: new CircularProgressIndicator(),
                                        //   errorWidget: new Icon(Icons.error),
                                        // ),
                                        // Image.network(
                                        //   categoryList[index].category.imageUrl,
                                        //   fit: BoxFit.cover,
                                        // ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 150,
                                      alignment: Alignment.center,
                                      child: Text(
                                        amz.cat[index]["category"]
                                            ["categoryName"],
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                        softWrap: true,
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )),
                      ),
                    );
                  },
                  childCount: amz.cat.length,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
