import 'package:pay_or_save/element/amazon/Provider/amazon_provider.dart';
import 'package:pay_or_save/element/amazon/Provider/categories_provider.dart';
import 'package:pay_or_save/element/amazon/amz_searchresult.dart';
import 'package:pay_or_save/element/amazon/amz_subcategories.dart';
import 'package:pay_or_save/models/subcategory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
// import '../models/category.dart';
// import '../element/ebaybar.dart';
// import '../element/authoriser.dart';
// import '../models/subcategory.dart';
// import '../pages/subcategory2.dart';
// import '../pages/searchresult.dart';
import 'package:transparent_image/transparent_image.dart';

import 'amazonbar.dart';

class AmzSubCat1 extends StatefulWidget {
  final String parentName;
  final String catId;
  final String catName;
  final String imgUrl;
  final int indexId;
  final String uid;

  AmzSubCat1({
    this.parentName,
    this.catId,
    this.catName,
    this.imgUrl,
    this.indexId,
    @required this.uid,
  });

  @override
  _AmzSubCat1State createState() => _AmzSubCat1State();
}

class _AmzSubCat1State extends State<AmzSubCat1> {
  //List<Category> categoryList = List();
  String catId;
  // Future<subCar> futureAlbum;
  bool _isLoading = false;

  // Future<subCar> _getSubcar() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   catId = widget.catId;
  //  final response = await makeCall(apiUrl);

  // if (response.statusCode == 200) {
  //   setState(() {
  //     _isLoading = false;
  //   });
  //   if (subcategoryFromJson(response.body).categoryArray.category.length ==
  //       1) {
  //     Navigator.pushReplacement(
  //       context,
  //       new MaterialPageRoute(
  //           builder: (context) => new SearchResult(
  //                 catId: widget.catId,
  //                 catName: widget.catName,
  //               )),
  //     );
  //   }
  //   return subcategoryFromJson(response.body);
  // } else {
  //   throw Exception('Failed to load album');
  // }
  // }

  @override
  void initState() {
    super.initState();
    print(widget.indexId);
    // futureAlbum = _getSubcar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AmzCategoriesProvider>(
        builder: (context, amz, child) {
          return Consumer<AmazonProvider>(
            builder: (context, amzProv, child) {
              return CustomScrollView(
                slivers: <Widget>[
                  AmazonBar(
                    cpage: "category",
                    showtitle: false,
                    uid: widget.uid,
                  ),
                  // SliverPersistentHeader(
                  //   delegate: imageHeader(imgUrl: widget.imgUrl),
                  //   pinned: true,
                  //   //floating: true,
                  // ),
                  SliverPersistentHeader(
                    delegate: titleHeader2(titleT: widget.parentName),
                    pinned: false,
                    //floating: true,
                  ),
                  FutureBuilder(
                    future: amz.getSubcar2(
                      context: context,
                      catName: widget.catName,
                      searchIndex: widget.catId,
                      browsenode: amzProv.getSubCatId[widget.indexId],
                    ),
                    builder: (context, projectSnap) {
                      if (projectSnap.connectionState != ConnectionState.done ||
                          projectSnap.hasData == null) {
                        // Navigator.pushReplacement(
                        //   context,
                        //   new MaterialPageRoute(builder: (context) => new searchResult(
                        //     catId: widget.catId,
                        //     catName: widget.catName,
                        //   )),
                        // );
                        return SliverPersistentHeader(
                          delegate: titleHeader4(
                              titleT: widget.catName, idT: widget.catId),
                          pinned: false,
                          //floating: true,
                        );
                      } else {
                        if (projectSnap.data.length == 1) {
                          // Navigator.pushReplacement(
                          //   context,
                          //   new MaterialPageRoute(builder: (context) => new searchResult(
                          //     catId: widget.catId,
                          //     catName: widget.catName,
                          //   )),
                          // );
                          return SliverPersistentHeader(
                            delegate: titleHeader4(
                                titleT: widget.catName, idT: widget.catId),
                            pinned: false,
                            //floating: true,
                          );
                        } else {
                          return SliverPersistentHeader(
                            delegate: titleHeader(titleT: widget.catName),
                            pinned: false,
                            //floating: true,
                          );
                        }
                      }
                    },
                  ),
                  FutureBuilder(
                    future: amz.getSubcar2(
                      context: context,
                      catName: widget.catName,
                      searchIndex: widget.catId,
                      browsenode: amzProv.getSubCatId[widget.indexId],
                    ),
                    builder: (context, projectSnap) {
                      var childCount = 0;
                      if (projectSnap.connectionState != ConnectionState.done ||
                          projectSnap.hasData == null) {
                        childCount = 1;
                      } else {
                        if (amzProv.getAmzSubCat1.isEmpty ||
                            amzProv.getAmzSubCat1.length < 2) {
                          Future.delayed(Duration.zero).then((_) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AmzSearchResult(
                                          browseNode: amzProv.getSubCatId[0],
                                          searchIndex: widget.catId,
                                          catName: widget.catName,
                                          uid: widget.uid,
                                        )));
                          });
                        }
                        childCount = projectSnap.data.length;
                      }
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (projectSnap.connectionState !=
                                ConnectionState.done) {
                              //todo handle state
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

                            return Material(
                              child: InkWell(
                                splashFactory: InkRipple.splashFactory,
                                splashColor: Colors.lightBlueAccent,
                                onTap: () => Timer(
                                    const Duration(milliseconds: 400), () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => AmzSearchResult(
                                                browseNode:
                                                    amzProv.getSubCatId1[index],
                                                searchIndex: widget.catId,
                                                catName: widget.catName,
                                                uid: widget.uid,
                                              )));
                                }),
                                // handle your onTap here
                                child: Container(
                                  padding: EdgeInsets.only(left: 52, right: 15),
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        new ListTile(
                                          // trailing: Icon(Icons.expand_more,size: 30.0,color: Colors.black,),
                                          title: new Text(
                                            projectSnap.data[index],
                                            style: new TextStyle(
                                              fontSize: 18,
                                              color: Colors.black87,
                                            ),
                                          ),
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
                  ),
                ],
              );
            },
          );
        },
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
      return Material(
          child: InkWell(
              splashFactory: InkRipple.splashFactory,
              splashColor: Colors.lightBlueAccent,
              onTap: () => Navigator.pop(context), // handle your onTap here
              child: Container(
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
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                  ))));
    });
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => true;

  @override
  double get maxExtent => 65.0;

  @override
  double get minExtent => 65.0;
}

class titleHeader2 extends SliverPersistentHeaderDelegate {
  titleHeader2({
    this.titleT,
  });
  String titleT;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return LayoutBuilder(builder: (context, constraints) {
      final Color color = Colors.primaries[0];
      return Material(
        child: InkWell(
            splashFactory: InkRipple.splashFactory,
            splashColor: Colors.lightBlueAccent,
            onTap: () => Navigator.pop(context), // handle your onTap here
            child: Container(
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
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        new ListTile(
                          //leading: Icon(Icons.expand_less,size: 40.0,color: Colors.black,),
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
                ))),
      );
    });
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => true;

  @override
  double get maxExtent => 65.0;

  @override
  double get minExtent => 65.0;
}

class titleHeader4 extends SliverPersistentHeaderDelegate {
  titleHeader4({
    this.titleT,
    this.idT,
  });
  String titleT;
  String idT;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return LayoutBuilder(builder: (context, constraints) {
      final Color color = Colors.primaries[0];
      return Material(
        child: InkWell(
            // TODO: implement function
            // onTap: () => Navigator.push(
            //       context,
            //       new MaterialPageRoute(
            //           builder: (context) => new SearchResult(
            //                 catId: idT,
            //                 catName: titleT,
            //               )),
            //     ), // handle your onTap here
            child: Container(
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
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        new ListTile(
                          //leading: Icon(Icons.expand_less,size: 40.0,color: Colors.black,),
                          title: new Text(titleT,
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                        // Text(
                        //   titleT,
                        //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                        // ),
                      ]),
                ))),
      );
    });
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => true;

  @override
  double get maxExtent => 65.0;

  @override
  double get minExtent => 65.0;
}
