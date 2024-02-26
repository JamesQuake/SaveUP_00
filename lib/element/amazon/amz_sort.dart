import 'package:pay_or_save/models/subcategory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import '../models/category.dart';
// import '../element/ebaybar.dart';
// import '../models/subcategory.dart';
import 'amazonbar.dart';
// import '../pages/subcategory1.dart';

class AmazonSort extends StatefulWidget {
  @override
  _AmazonSortState createState() => _AmazonSortState();
}

class _AmazonSortState extends State<AmazonSort> {
  //List<Category> categoryList = List();
  String catId;
  // Future<subCar> futureAlbum;
  bool _isLoading = false;
  List sortI = [
    'Price Low to High',
    'Price High to Low',
    'Newest Arrival',
    'Relevance'
  ];
  List sortq = [
    'Price:LowToHigh',
    'Price:HighToLow',
    'NewestArrivals',
    'Relevance'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          AmazonBar(
            showtitle: false,
          ),
          SliverPersistentHeader(
            delegate: sortHeader(),
            pinned: true,
            //floating: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Material(
                child: InkWell(
                  onTap: () => Navigator.of(context)
                      .pop(sortq[index]), // handle your onTap here
                  child: Container(
                    decoration: BoxDecoration(
                        // boxShadow: [BoxShadow(blurRadius: 4.0, color: Colors.black45)],
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            //                   <--- left side
                            color: Colors.black26,
                            width: 1.0,
                          ),
                        )),
                    padding: EdgeInsets.only(left: 20, right: 15),
                    alignment: Alignment.centerLeft,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new ListTile(
                            title: new Text(sortI[index],
                                style: new TextStyle(
                                    fontSize: 16, color: Colors.black87)),
                          ),
                        ]),
                  ),
                ),
              );
            }, childCount: sortI.length),
          ),
        ],
      ),
    );
  }
}

class sortHeader extends SliverPersistentHeaderDelegate {
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
            padding: EdgeInsets.only(left: 20),
            alignment: Alignment.centerLeft,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              new ListTile(
                title: new Text('Sort',
                    style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xff0078ff))),
              ),
            ]),
          ));
    });
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => true;

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;
}
