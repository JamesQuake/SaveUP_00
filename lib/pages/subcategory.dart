import 'package:pay_or_save/models/subcategory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pay_or_save/providers/ebay_cache_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../models/category.dart';
import '../element/ebaybar.dart';
import '../element/authoriser.dart';
import '../models/subcategory.dart';
import '../pages/subcategory1.dart';

class SubCategory extends StatefulWidget {
  final String catId;
  final String catName;
  final String imgUrl;

  SubCategory({
    this.catId,
    this.catName,
    this.imgUrl,
  });

  @override
  _SubCategoryState createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  //List<Category> categoryList = List();
  String catId;
  Future<subCar> futureAlbum;
  bool _isLoading = false;

  var token;
  Future<subCar> _getSubcar() async {
    setState(() {
      _isLoading = true;
    });
    var resp = await _checkEbayData(widget.catName);
    catId = widget.catId;
    if (resp != null) {
      setState(() {
        _isLoading = false;
      });
      return subcategoryFromJson(resp);
    }
    String apiUrl =
        'https://open.api.ebay.com/Shopping?callname=GetCategoryInfo&appid=SteveLom-PayorSav-PRD-8f2fb35bc-b3bf8b93&siteid=0&CategoryID=$catId&version=967&IncludeSelector=ChildCategories&ResponseEncodingType=JSON';
    final response = await makeCall(apiUrl);
    if (response.statusCode == 200) {
      await _handleEbayData(resBody: response.body, categName: widget.catName);
      setState(() {
        _isLoading = false;
      });
      return subcategoryFromJson(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }

  _handleEbayData({String resBody, categName}) async {
    final _prefs = await SharedPreferences.getInstance();
    if (resBody != null) {
      await _prefs.setString(categName + "00", resBody);
    }
  }

  _checkEbayData(String categName) async {
    final prefs = await SharedPreferences.getInstance();
    String s1Data = prefs.getString(categName + "00");
    if (s1Data != null) {
      return s1Data;
    }
  }

  @override
  void initState() {
    super.initState();
    futureAlbum = _getSubcar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          new ebaybar(showtitle: false, cpage: "category"),
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
          //     SliverList(
          //   delegate: SliverChildBuilderDelegate(
          //           (context, index) {
          //         return Material(
          //           child: Container(
          //             decoration: BoxDecoration(
          //               // boxShadow: [BoxShadow(blurRadius: 4.0, color: Colors.black45)],
          //                 color: Colors.white,
          //                 border: Border(
          //                   bottom: BorderSide( //                   <--- left side
          //                     color: Colors.black,
          //                     width: 1.0,
          //                   ),
          //                 )
          //             ),
          //               padding: EdgeInsets.only( right: 15),
          //               alignment: Alignment.centerLeft,
          //               child: Column(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   children: [
          //                     new ListTile(
          //                       leading: Icon(Icons.expand_more,size: 40.0,color: Colors.black,),
          //                       title: new Text(widget.catName,
          //                           style: new TextStyle( fontWeight: FontWeight.bold, fontSize: 20)),
          //                     ),
          //                   ]
          //               ),
          //             ),
          //         );
          //       },
          //       childCount: 1),
          // ),
          FutureBuilder<subCar>(
            future: futureAlbum,
            builder: (context, projectSnap) {
              var childCount = 0;

              if (projectSnap.connectionState != ConnectionState.done ||
                  projectSnap.hasData == null) {
                childCount = 1;
              } else {
                // print('stuffffffff');
                // print(futureAlbum);
                // print(projectSnap.hasData);
                // print('wilddddd');
                childCount = projectSnap.data.categoryArray.category.length - 1;
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  if (projectSnap.connectionState != ConnectionState.done) {
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
                  return Material(
                    child: InkWell(
                      splashFactory: InkRipple.splashFactory,
                      splashColor: Colors.lightBlueAccent,
                      onTap: () => Timer(const Duration(milliseconds: 400), () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new SubCategory1(
                                    parentName: widget.catName,
                                    catId: projectSnap.data.categoryArray
                                        .category[index + 1].categoryId,
                                    catName: projectSnap.data.categoryArray
                                        .category[index + 1].categoryName,
                                    imgUrl: widget.imgUrl,
                                  )),
                        );
                      }), // handle your onTap here
                      child: Container(
                        padding: EdgeInsets.only(left: 52, right: 15),
                        alignment: Alignment.centerLeft,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              new ListTile(
                                //trailing: Icon(Icons.expand_more,size: 30.0,color: Colors.black,),
                                title: new Text(
                                    projectSnap.data.categoryArray
                                        .category[index + 1].categoryName,
                                    style: new TextStyle(
                                        fontSize: 18, color: Colors.black87)),
                              ),
                              // Text(
                              //   titleT,
                              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                              // ),
                            ]),
                      ),
                    ),
                  );
                }, childCount: childCount),
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
