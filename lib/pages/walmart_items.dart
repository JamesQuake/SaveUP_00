// import 'package:pay_or_save/models/subcategory.dart';
import 'package:intl/intl.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/element/walmart_bar.dart';
import 'package:pay_or_save/pages/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
// import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/search.dart';
import '../element/ebaybar.dart';
// import '../models/subcategory.dart';
import '../element/authoriser.dart';
import '../models/walmart_items_model.dart';
import 'sort.dart';
import 'filter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'walmart_product.dart';

class WalmartItemsListPage extends StatefulWidget {
  final String catId;
  final String catName;
  final String uid;

  WalmartItemsListPage({
    this.catId,
    this.catName,
    this.uid,
  });

  @override
  _WalmartItemsListPageState createState() => _WalmartItemsListPageState();
}

class _WalmartItemsListPageState extends State<WalmartItemsListPage> {
  bool _isLoading = false;
  String rFilterQ;
  List filterS = [];
  Future<WalmartItemsResponse> futureResult;
  var token;

  Future<WalmartItemsResponse> _getsearchR(String pUrl, String sort) async {
    setState(() {
      _isLoading = true;
    });

    final searchQ = widget.catName;
    final searchCat = widget.catId;
    String apiUrl;

    String baseUrl = 'https://api.impact.com';
    if (pUrl == null) {
      if (searchCat == '0') {
        apiUrl ='$baseUrl/Mediapartners/IRms8oU5FgpC2680271TvYsYvsUcCgLDm1/Catalogs/ItemSearch?Keyword=$searchQ';
      } else {
        apiUrl =
            apiUrl ='$baseUrl/Mediapartners/IRms8oU5FgpC2680271TvYsYvsUcCgLDm1/Catalogs/${widget.catId}/Items';
      }
    } else {
      apiUrl = '$baseUrl$pUrl';
    }

    // if (sorter != null) {
    //   if (sorter == "distance") {
    //     apiUrl = '$apiUrl&sort=$sorter&filter=pickupCountry:US';
    //     print(apiUrl);
    //   } else {
    //     apiUrl = '$apiUrl&sort=$sorter';
    //   }
    // }
    // if (rFilterQ != null) {
    //   apiUrl = '$apiUrl&aspect_filter=$rFilterQ';
    // }

    print('makeWalmartCall');
    final response = await makeWalmartCall(apiUrl);
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      //print(response.body);
      return walmartItemsResponseFromJson(response.body);
    } else {
      throw Exception('Failed to load result');
    }
  }

  @override
  void initState() {
    super.initState();
    futureResult = _getsearchR(null, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: MainDrawer(uid: widget.uid),
      body: CustomScrollView(
        slivers: <Widget>[
          new WalmartBar(
            cpage: "searchresult",
            showtitle: false,
            uid: widget.uid,
          ),
          FutureBuilder<WalmartItemsResponse>(
            future: futureResult,
            builder: (context, projectSnap) {
              if (projectSnap.connectionState != ConnectionState.done) {
                //
                return SliverPersistentHeader(
                  delegate: titleHeader6(),
                  pinned: true,
                );
              }
              if (projectSnap.hasError) {
                return SliverPersistentHeader(
                  delegate: titleHeader6(),
                  pinned: true,
                );
              }
              if (projectSnap.hasData == null ||
                  projectSnap.data.items == null) {
                return SliverPersistentHeader(
                  delegate: titleHeader7(
                      filterS: filterS,
                      stateSetter: stateSetter,
                      catId: widget.catId,
                      catName: widget.catName,
                      filterSetter: filterSetter),
                  pinned: true,
                );
              }
              return SliverPersistentHeader(
                delegate: titleHeader3(
                    total: int.parse(projectSnap.data.total),
                    filterS: filterS,
                    offset: int.fromEnvironment(projectSnap.data.start),
                    limit: int.parse(projectSnap.data.end),
                    stateSetter: stateSetter,
                    catId: widget.catId,
                    catName: widget.catName,
                    filterSetter: filterSetter),

                pinned: true,
                //floating: true,
              );
            },
          ),
          FutureBuilder<WalmartItemsResponse>(
            future: futureResult,
            builder: (context, projectSnap) {
              var childCount = 0;
              if (projectSnap.hasError) {
                childCount = 1;
              } else {
                if (projectSnap.connectionState != ConnectionState.done ||
                    projectSnap.hasData == null ||
                    projectSnap.data.items == null) {
                  childCount = 1;
                } else {
                  childCount = projectSnap.data.items.length;
                }
              }
              return SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250.0,
                  mainAxisSpacing: 1.0,
                  crossAxisSpacing: 1.0,
                  childAspectRatio: 0.6,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
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
                    if (projectSnap.hasError) {
                      return Container();
                    }
                    if (projectSnap.hasData == null ||
                        projectSnap.data.items == null) {
                      return Container();
                    }
                    // if(index == 30){
                    //   print('30 reached');
                    // }
                    return Material(
                      child: InkWell(
                        onTap: () => Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new WalmartProductPage(
                                    item: projectSnap.data.items[index],
                                    uid: widget.uid,
                                  )),
                        ), // handle your onTap here
                        child: Container(
                            margin: EdgeInsets.only(
                              left: 15,
                              right: 15,
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                              projectSnap
                                                  .data.items[index].imageUrl,
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
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 150,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        projectSnap.data.items[index].name,
                                        style: TextStyle(fontSize: 11),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 150,
                                      alignment: Alignment.centerLeft,
                                      child: Text.rich(
                                        TextSpan(
                                            text: '\$' +
                                                projectSnap.data.items[index]
                                                    .currentPrice,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            children: [
                                              TextSpan(
                                                  text: '\nBuy It Now \n',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              TextSpan(
                                                  text: 'USA' + ' Shipping \n',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  )),
                                              TextSpan(
                                                  text: 'Calculated Shipping',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  )),
                                            ]),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )),
                      ),
                    );
                  },
                  childCount: childCount,
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FutureBuilder<WalmartItemsResponse>(
        future: futureResult,
        builder: (context, projectSnap) {
          if (projectSnap.connectionState != ConnectionState.done) {
            //
            return Container();
          }
          if (projectSnap.hasError) {
            return Container();
          }
          if (projectSnap.hasData == null || projectSnap.data.items == null) {
            return Container();
          }
          return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            if (projectSnap.data.previouspageuri != null)
              Container(
                height: 35,
                width: 35,
                child: FloatingActionButton(
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    size: 17,
                  ),
                  onPressed: () {
                    setState(() {
                      futureResult =
                          _getsearchR(projectSnap.data.previouspageuri, null);
                    });
                  },
                  heroTag: null,
                  backgroundColor: Colors.black,
                ),
              ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
            ),
            if (projectSnap.data.nextpageuri != null)
              Container(
                height: 35,
                width: 35,
                child: FloatingActionButton(
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 17,
                    ),
                    onPressed: () {
                      // print('hi');
                      setState(() {
                        futureResult =
                            _getsearchR(projectSnap.data.nextpageuri, null);
                      });
                    },
                    heroTag: null,
                    backgroundColor: Colors.red),
              ),
          ]);
        },
      ),
    );
  }

  void stateSetter(String sorter) {
    setState(() {
      futureResult = _getsearchR(null, sorter);
    });
  }

  void filterSetter(String filterQ, List rfilterS) {
    setState(() {
      rFilterQ = filterQ;
      filterS = rfilterS;
      futureResult = _getsearchR(null, null);
    });
  }
}

class titleHeader3 extends SliverPersistentHeaderDelegate {
  final void Function(String) stateSetter;
  final void Function(String, List) filterSetter;

  titleHeader3({
    this.total,
    this.offset,
    this.limit,
    this.stateSetter,
    this.filterSetter,
    this.catName,
    this.catId,
    this.filterS,
  });

  List filterS;
  int total;
  int offset;
  int limit;
  String catName;
  String catId;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return LayoutBuilder(builder: (context, constraints) {
      final Color color = Colors.primaries[0];
      int other = limit + offset;
      return Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(blurRadius: 4.0, color: Colors.black45)],
          color: Colors.white,
        ),
        //alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 8, right: 12, top: 0),
        child: Material(
          child: StaggeredGrid.count(
            // padding: EdgeInsets.only(top: 8),
            mainAxisSpacing: 3.0,
            crossAxisSpacing: 3.0,
            crossAxisCount: 12,
            // staggeredTiles: [
            //   StaggeredTile.count(5, 2),
            //   StaggeredTile.count(2, 1),
            //   StaggeredTile.count(1, 1),
            //   StaggeredTile.count(2, 1),
            //   StaggeredTile.count(2, 1),
            // ],
            children: <Widget>[
              StaggeredGridTile.count(
                crossAxisCellCount: 6,
                mainAxisCellCount: 2,
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Text.rich(
                    TextSpan(
                        text: 'Results ' +
                            NumberFormat.decimalPattern('en_us').format(
                              total,
                            ),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xff0078ff)),
                        children: [
                          TextSpan(
                              text: '\n $offset - $other',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              )),
                        ]),
                  ),
                ),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 1,
                child: Container(
                    // child: IconButton(
                    //   icon: Icon(Icons.arrow_back_ios_rounded),
                    //   color: Color(0xff0078ff),
                    //   tooltip: 'Previous',
                    //   onPressed: () {
                    //     print('hi');
                    //   },
                    // ),
                    ),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1,
                child: Container(
                    // child: IconButton(
                    //   icon: Icon(Icons.arrow_forward_ios_rounded),
                    //   tooltip: 'next',
                    //   color: Color(0xff0078ff),
                    //   onPressed: () {
                    //     print('hi');
                    //   },
                    // ),
                    ),
              ),
              // StaggeredGridTile.count(
              //   crossAxisCellCount: 2,
              //   mainAxisCellCount: 1,
              //   child: InkWell(
              //     onTap: () => Navigator.push(
              //       context,
              //       new MaterialPageRoute<String>(
              //           builder: (context) => new sortP()),
              //     ).then((String value) {
              //       //print(value);
              //       this.stateSetter(value);
              //     }), // handle your onTap here
              //     child: Container(
              //       alignment: Alignment.centerRight,
              //       child: Text('Sort',
              //           style: new TextStyle(
              //               fontWeight: FontWeight.bold,
              //               fontSize: 18,
              //               color: Color(0xff0078ff))),
              //     ),
              //   ),
              // ),
              // StaggeredGridTile.count(
              //   crossAxisCellCount: 2,
              //   mainAxisCellCount: 1,
              //   child: InkWell(
              //     onTap: () => Navigator.push(
              //       context,
              //       new MaterialPageRoute<String>(
              //           builder: (context) => new filterP(
              //               catId: catId, catName: catName, filterS: filterS)),
              //     ).then((String value) {
              //       print(value);
              //       List returned = jsonDecode(value);
              //       this.filterSetter(returned[1], returned[0]);
              //     }), // handle your onTap here
              //     child: Container(
              //       alignment: Alignment.centerRight,
              //       child: Text('Filter',
              //           style: new TextStyle(
              //               fontWeight: FontWeight.bold,
              //               fontSize: 18,
              //               color: Color(0xff0078ff))),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      );
    });
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => true;

  @override
  double get maxExtent => 55.0;

  @override
  double get minExtent => 55.0;
}

class titleHeader7 extends SliverPersistentHeaderDelegate {
  final void Function(String) stateSetter;
  final void Function(String, List) filterSetter;

  titleHeader7({
    this.stateSetter,
    this.filterSetter,
    this.catName,
    this.catId,
    this.filterS,
  });

  List filterS;
  String catName;
  String catId;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return LayoutBuilder(builder: (context, constraints) {
      final Color color = Colors.primaries[0];
      return Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(blurRadius: 4.0, color: Colors.black45)],
          color: Colors.white,
        ),
        //alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 8, right: 12, top: 0),
        child: Material(
          child: StaggeredGrid.count(
            // padding: EdgeInsets.only(top: 8),
            mainAxisSpacing: 3.0,
            crossAxisSpacing: 3.0,
            crossAxisCount: 12,
            // staggeredTiles: [
            //   StaggeredTile.count(5, 2),
            //   StaggeredTile.count(2, 1),
            //   StaggeredTile.count(1, 1),
            //   StaggeredTile.count(2, 1),
            //   StaggeredTile.count(2, 1),
            // ],
            children: <Widget>[
              StaggeredGridTile.count(
                crossAxisCellCount: 5,
                mainAxisCellCount: 2,
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Text.rich(
                    TextSpan(
                        text: 'Results 0',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xff0078ff)),
                        children: [
                          TextSpan(
                              text: '\n 0 - 0',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              )),
                        ]),
                  ),
                ),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 1,
                child: Container(
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded),
                    color: Colors.green,
                    tooltip: 'next',
                    onPressed: () {
                      print('hi');
                    },
                  ),
                ),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1,
                child: Container(
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward_ios_rounded),
                    tooltip: 'next',
                    color: Colors.green,
                    onPressed: () {
                      print('hi');
                    },
                  ),
                ),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 1,
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    new MaterialPageRoute<String>(
                        builder: (context) => new sortP()),
                  ).then((String value) {
                    print(value);
                    this.stateSetter(value);
                  }), // handle your onTap here
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text('Sort',
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xff0078ff))),
                  ),
                ),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 1,
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    new MaterialPageRoute<String>(
                        builder: (context) => new filterP(
                            catId: catId, catName: catName, filterS: filterS)),
                  ).then((String value) {
                    print(value);
                    List returned = jsonDecode(value);
                    this.filterSetter(returned[1], returned[0]);
                  }), // handle your onTap here
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text('Filter',
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xff0078ff))),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => true;

  @override
  double get maxExtent => 55.0;

  @override
  double get minExtent => 55.0;
}

class titleHeader6 extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return LayoutBuilder(builder: (context, constraints) {
      final Color color = Colors.primaries[0];
      return Container();
    });
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => true;

  @override
  double get maxExtent => 50.0;

  @override
  double get minExtent => 50.0;
}
