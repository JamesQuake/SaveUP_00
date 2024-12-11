import 'package:pay_or_save/element/amazon/Provider/amazon_provider.dart';
import 'package:pay_or_save/element/amazon/Provider/categories_provider.dart';
import 'package:pay_or_save/element/amazon/amz_subcat1.dart';
import 'package:pay_or_save/models/subcategory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../pages/subcategory1.dart';
import 'amazonbar.dart';
import 'amz_searchresult.dart';
// import '../models/category.dart';
// import '../element/ebaybar.dart';
// import '../element/authoriser.dart';
// import '../models/subcategory.dart';
// import '../pages/subcategory1.dart';

class AmzSubCategory extends StatefulWidget {
  final String catId;
  final String catName;
  final String imgUrl;
  final String uid;

  AmzSubCategory({
    this.catId,
    this.catName,
    this.imgUrl,
    @required this.uid,
  });

  @override
  _AmzSubCategoryState createState() => _AmzSubCategoryState();
}

class _AmzSubCategoryState extends State<AmzSubCategory> {
  //List<Category> categoryList = List();
  String catId;
  Future futureAlbum;
  bool _isLoading = false;
  List respo;
  var token;

  @override
  void initState() {
    super.initState();
    // futureAlbum = _getSubcar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          new AmazonBar(
            cpage: "category",
            showtitle: false,
            uid: widget.uid,
          ),
          SliverPersistentHeader(
            delegate: imageHeader(imgUrl: widget.imgUrl),
            pinned: true,
            //floating: true,
          ),
          SliverPersistentHeader(
            delegate: titleHeader(titleT: widget.catName),
            pinned: false,
            //floating: true,
          ),
          Consumer<AmzCategoriesProvider>(
            builder: (context, amz, child) {
              return Consumer<AmazonProvider>(
                builder: (context, amzProv, child) {
                  return FutureBuilder(
                    future: amz.getSubcar1(
                      context: context,
                      catName: widget.catName,
                      catId: widget.catId,
                    ),
                    builder: (context, projectSnap) {
                      var childCount = 0;

                      if (projectSnap.connectionState != ConnectionState.done ||
                          projectSnap.hasData == null) {
                        childCount = 1;
                      } else {
                        // print('stuffffffff');
                        // // print(futureAlbum);
                        // print(amzProv.getAmzSubCat.isEmpty);
                        // print(amzProv.getSubCatId[0]);
                        // print('wilddddd');
                        if (projectSnap.connectionState ==
                            ConnectionState.done) if (amzProv
                                .getAmzSubCat.isEmpty ||
                            amzProv.getAmzSubCat.length < 2) {
                          return AmzSearchResult(
                            browseNode: amzProv.getSubCatId[0],
                            searchIndex: widget.catId,
                            catName: widget.catName,
                            uid: widget.uid,
                          );
                          // Future.delayed(Duration.zero).then((_) {
                          // WidgetsBinding.instance.addPostFrameCallback((_) {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => AmzSearchResult(
                          //               browseNode: amzProv.getSubCatId[0],
                          //               searchIndex: widget.catId,
                          //               catName: widget.catName,
                          //               uid: widget.uid,
                          //             )));
                          // });
                        }
                        childCount = projectSnap.data.length;
                        // return
                      }
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (projectSnap.connectionState !=
                                ConnectionState.done) {
                              //
                              return Container(
                                padding: EdgeInsets.only(top: 7, bottom: 7),
                                child: Center(
                                  //width: 50,
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            if (projectSnap.hasData == null) {
                              return Container();
                            }
                            // print("billard");
                            // print(amzProv.getAmzSubCat.isEmpty);
                            // print(amzProv.getAmzSubCat.length < 3);

                            return Material(
                              child: InkWell(
                                splashFactory: InkRipple.splashFactory,
                                splashColor: Colors.lightBlueAccent,
                                onTap: () => Timer(
                                    const Duration(milliseconds: 400), () {
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) => AmzSubCat1(
                                        parentName: widget.catName,
                                        imgUrl: amz.cat[index]["category"]
                                            ["imageUrl"],
                                        indexId: index,
                                        catName: amzProv.getAmzSubCat[index],
                                        uid: widget.uid,
                                        catId: widget.catId,
                                      ),
                                    ),
                                  );
                                  //  SubCategory1(
                                  //       parentName: widget.catName,
                                  //       catId: projectSnap.data.categoryArray
                                  //           .category[index + 1].categoryId,
                                  //       catName: projectSnap.data.categoryArray
                                  //           .category[index + 1].categoryName,
                                  //       imgUrl: widget.imgUrl,
                                  //     )),
                                }), // handle your onTap here
                                child: Container(
                                  padding: EdgeInsets.only(left: 52, right: 15),
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        new ListTile(
                                          //trailing: Icon(Icons.expand_more,size: 30.0,color: Colors.black,),
                                          title: new Text(
                                              projectSnap.data[index],
                                              style: new TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black87)),
                                        ),
                                        // Text(
                                        //   titleT,
                                        //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                                        // ),
                                      ]),
                                ),
                              ),
                            );
                          },
                          childCount: childCount,
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class imageHeader extends SliverPersistentHeaderDelegate {
  imageHeader({
    this.imgUrl,
  });
  String imgUrl;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: constraints.maxHeight,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Center(child: CircularProgressIndicator()),
            Image.network(
              imgUrl,
              fit: BoxFit.cover,
            ),
          ],
        ),
      );
    });
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => true;

  @override
  double get maxExtent => 250.0;

  @override
  double get minExtent => 80.0;
}

class titleHeader extends SliverPersistentHeaderDelegate {
  titleHeader({
    this.titleT,
  });
  String titleT;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return LayoutBuilder(builder: (context, constraints) {
      final Color color = Colors.primaries[0];
      return Container(
          decoration: BoxDecoration(
              // boxShadow: [BoxShadow(blurRadius: 4.0, color: Colors.black45)],
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  //                   <--- left side
                  color: Colors.black,
                  width: 1.0,
                ),
              )),
          height: constraints.maxHeight,
          child: Container(
            margin: EdgeInsets.only(left: 52),
            alignment: Alignment.centerLeft,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              new ListTile(
                //leading: Icon(Icons.expand_more,size: 40.0,color: Colors.black,),
                title: new Text(titleT,
                    style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xff0078ff))),
              ),
              // Text(
              //   titleT,
              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
              // ),
            ]),
          ));
    });
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => true;

  @override
  double get maxExtent => 65.0;

  @override
  double get minExtent => 65.0;
}
