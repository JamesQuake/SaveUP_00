import 'package:pay_or_save/models/subcategory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import '../models/category.dart';
import '../element/ebaybar.dart';
import '../models/subcategory.dart';
import '../pages/searchresult.dart';
import '../element/authoriser.dart';
// import 'package:transparent_image/transparent_image.dart';

class SubCategory2 extends StatefulWidget {
  final String gparentName;
  final String parentName;
  final String catId;
  final String catName;
  final String imgUrl;

  SubCategory2({
    this.gparentName,
    this.parentName,
    this.catId,
    this.catName,
    this.imgUrl,
  });

  @override
  _SubCategory2State createState() => _SubCategory2State();
}

class _SubCategory2State extends State<SubCategory2> {
  //List<Category> categoryList = List();
  String catId;
  Future<subCar> futureAlbum;
  bool _isLoading = false;

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
      if (subcategoryFromJson(response.body).categoryArray.category.length ==
          1) {
        Navigator.pushReplacement(
          context,
          new MaterialPageRoute(
              builder: (context) => new SearchResult(
                    catId: widget.catId,
                    catName: widget.catName,
                  )),
        );
      }
      return subcategoryFromJson(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }

  _handleEbayData({String resBody, categName}) async {
    final _prefs = await SharedPreferences.getInstance();
    if (resBody != null) {
      await _prefs.setString(categName + "02", resBody);
    }
  }

  _checkEbayData(String categName) async {
    final _prefs = await SharedPreferences.getInstance();
    String s1Data = _prefs.getString(categName + "02");
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
          // SliverPersistentHeader(
          //   delegate: imageHeader(imgUrl: widget.imgUrl),
          //   pinned: true,
          //   //floating: true,
          // ),
          SliverPersistentHeader(
            delegate: titleHeader3(titleT: widget.gparentName),
            pinned: false,
            //floating: true,
          ),
          SliverPersistentHeader(
            delegate: titleHeader2(titleT: widget.parentName),
            pinned: false,
            //floating: true,
          ),
          FutureBuilder<subCar>(
            future: futureAlbum,
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
                  delegate:
                      titleHeader4(titleT: widget.catName, idT: widget.catId),
                  pinned: false,
                  //floating: true,
                );
              } else {
                if (projectSnap.data.categoryArray.category.length == 1) {
                  // Navigator.pushReplacement(
                  //   context,
                  //   new MaterialPageRoute(builder: (context) => new searchResult(
                  //     catId: widget.catId,
                  //     catName: widget.catName,
                  //   )),
                  // );
                  return SliverPersistentHeader(
                    delegate:
                        titleHeader4(titleT: widget.catName, idT: widget.catId),
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
          FutureBuilder<subCar>(
            future: futureAlbum,
            builder: (context, projectSnap) {
              var childCount = 0;
              if (projectSnap.connectionState != ConnectionState.done ||
                  projectSnap.hasData == null) {
                childCount = 1;
              } else {
                childCount = projectSnap.data.categoryArray.category.length - 1;
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  if (projectSnap.connectionState != ConnectionState.done) {
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
                      onTap: () => Timer(const Duration(milliseconds: 400), () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new SearchResult(
                                    catId: widget.catId,
                                    catName: widget.catName,
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
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;
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

class titleHeader3 extends SliverPersistentHeaderDelegate {
  titleHeader3({
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
            splashFactory: InkRipple.splashFactory,
            splashColor: Colors.lightBlueAccent,
            onTap: () => Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new SearchResult(
                            catId: idT,
                            catName: titleT,
                          )),
                ), // handle your onTap here
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
