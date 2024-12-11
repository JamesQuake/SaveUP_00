// import 'package:pay_or_save/models/subcategory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../element/ebaybar.dart';
import '../models/subcategory.dart';
import '../models/filtermodel.dart';
import '../pages/subcategory1.dart';
import '../element/minttoken.dart';
import '../element/authoriser.dart';

class filterP extends StatefulWidget {
  final String catId;
  final String catName;
  List filterS;

  filterP({
    this.catId,
    this.catName,
    this.filterS,
  });

  @override
  _filterPState createState() => _filterPState();
}

class _filterPState extends State<filterP> {
  bool _isLoading = false;
  List sortI = [
    'Price Low to High',
    'Price High to Low',
    'Newly Listed',
    'Nearest First'
  ];
  List sortq = ['price', '-price', 'newlyListed', 'distance'];
  String apiUrl;
  Future<FilterModel> aspectFilter;
  var token;
  List _selectedF = [];

  Future<FilterModel> _getAspectFilter() async {
    setState(() {
      _isLoading = true;
    });
    final searchQ = widget.catName;
    final searchCat = widget.catId;

    if (searchCat == '0') {
      apiUrl =
          'https://api.ebay.com/buy/browse/v1/item_summary/search?limit=50&q=$searchQ&fieldgroups=ASPECT_REFINEMENTS';
    } else {
      apiUrl =
          'https://api.ebay.com/buy/browse/v1/item_summary/search?limit=50&category_ids=$searchCat&fieldgroups=ASPECT_REFINEMENTS';
    }

    // if(pUrl != null){
    //   apiUrl = pUrl;
    // }
    // if(sorter != null){
    //   if(sorter == "distance"){
    //     apiUrl =  '$apiUrl&sort=$sorter&filter=pickupCountry:US';
    //     print(apiUrl);
    //   }else{
    //     apiUrl =  '$apiUrl&sort=$sorter';
    //   }
    // }

    final response = await makeCall(apiUrl);

    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      //print(filterModelFromJson(response.body).refinement.aspectDistributions);

      return filterModelFromJson(response.body);
    } else {
      throw Exception('Failed to load result');
    }
  }

  @override
  void initState() {
    super.initState();
    aspectFilter = _getAspectFilter();
    _selectedF = widget.filterS;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          new ebaybar(
            showtitle: false,
          ),
          SliverPersistentHeader(
            delegate: sortHeader(catName: widget.catName, catId: widget.catId),
            pinned: true,
            //floating: true,
          ),
          FutureBuilder<FilterModel>(
            future: aspectFilter,
            builder: (context, projectSnap) {
              var childCount = 0;
              if (projectSnap.hasError) {
                childCount = 1;
              } else {
                if (projectSnap.connectionState != ConnectionState.done ||
                    projectSnap.hasData == null ||
                    projectSnap.data.refinement == null) {
                  childCount = 1;
                } else {
                  childCount =
                      projectSnap.data.refinement.aspectDistributions.length;
                  if (_selectedF.isEmpty) {
                    for (final i
                        in projectSnap.data.refinement.aspectDistributions) {
                      _selectedF.add(i.aspectValueDistributions[
                          i.aspectValueDistributions.length - 1]);
                    }
                  }
                  print(_selectedF);
                }
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
                  if (projectSnap.hasError) {
                    return Container();
                  }
                  if (projectSnap.hasData == null || projectSnap.data == null) {
                    return Container();
                  }
                  projectSnap.data.refinement.aspectDistributions[index]
                          .aspectValueDistributions =
                      projectSnap.data.refinement.aspectDistributions[index]
                          .aspectValueDistributions
                          .toSet()
                          .toList();
                  return Material(
                    child: InkWell(
                      //onTap: () =>Navigator.of(context).pop("ok"), // handle your onTap here
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
                        padding: EdgeInsets.only(left: 20, right: 5),
                        alignment: Alignment.centerLeft,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              new ListTile(
                                  title: new Text(
                                      projectSnap
                                          .data
                                          .refinement
                                          .aspectDistributions[index]
                                          .localizedAspectName,
                                      style: new TextStyle(
                                          fontSize: 16, color: Colors.black87)),
                                  trailing: Container(
                                      constraints:
                                          BoxConstraints(maxWidth: 175),
                                      child: Row(children: [
                                        Expanded(
                                            child: new DropdownButton<String>(
                                          iconSize: 34,
                                          isExpanded: true,
                                          value: projectSnap
                                                  .data
                                                  .refinement
                                                  .aspectDistributions[index]
                                                  .aspectValueDistributions
                                                  .contains(_selectedF[index])
                                              ? _selectedF[index]
                                              : projectSnap
                                                      .data
                                                      .refinement
                                                      .aspectDistributions[index]
                                                      .aspectValueDistributions[
                                                  projectSnap
                                                          .data
                                                          .refinement
                                                          .aspectDistributions[
                                                              index]
                                                          .aspectValueDistributions
                                                          .length -
                                                      1],
                                          style: TextStyle(
                                              color: Color(0xff0078ff)),
                                          underline: Container(
                                            height: 0,
                                            //color: Colors.indigo,
                                          ),
                                          items: projectSnap
                                              .data
                                              .refinement
                                              .aspectDistributions[index]
                                              .aspectValueDistributions
                                              .map((value) {
                                            return new DropdownMenuItem(
                                              value: value,
                                              child: new Text(
                                                value,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String newValue) {
                                            setState(() {
                                              _selectedF[index] = newValue;
                                            });
                                          },
                                        ))
                                      ]))),
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
      floatingActionButton: FutureBuilder<FilterModel>(
        future: aspectFilter,
        builder: (context, projectSnap) {
          if (projectSnap.connectionState != ConnectionState.done) {
            //
            return Container();
          }
          if (projectSnap.hasError) {
            return Container();
          }
          if (projectSnap.hasData == null || projectSnap.data == null) {
            return Container();
          }
          return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Container(
              height: 35,
              width: 80,
              child: FloatingActionButton.extended(
                label: Text('Filter'),
                //icon: Icon(Icons.thumb_up),
                onPressed: () {
                  //print('hi');
                  var counterF = 0;
                  String domCat =
                      projectSnap.data.refinement.dominantCategoryId;
                  String filterQ = 'categoryId:$domCat';
                  for (var k = 0; k < _selectedF.length; k++) {
                    if (_selectedF[k] != 'Not Specified') {
                      String aFilter = projectSnap.data.refinement
                          .aspectDistributions[k].localizedAspectName;
                      String aOption = _selectedF[k];
                      counterF++;
                      filterQ = '$filterQ,$aFilter:{$aOption}';
                    }
                  }
                  filterQ = Uri.encodeComponent(filterQ);
                  //Navigator.of(context).pop(counterF > 0 ? filterQ : null);
                  List toReturn = [];
                  toReturn.add(_selectedF);
                  toReturn.add(counterF > 0 ? filterQ : null);
                  String toReturn2 = jsonEncode(toReturn);
                  Navigator.of(context).pop(toReturn2);
                },
                heroTag: null,
                backgroundColor: Color(0xff0078ff),
              ),
            ),
          ]);
        },
      ),
    );
  }
}

class sortHeader extends SliverPersistentHeaderDelegate {
  String catName;
  String catId;

  sortHeader({this.catName, this.catId});

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
                title: new Text(
                    catId == "0"
                        ? 'Filter (Query: $catName)'
                        : 'Filter (Category: $catName)',
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
  double get maxExtent => 62.0;

  @override
  double get minExtent => 62.0;
}
