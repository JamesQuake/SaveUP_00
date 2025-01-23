import 'package:flutter/material.dart';

import '../pages/walmart_items.dart';
import '../pages/walmart_search.dart';

class WalmartBar extends StatelessWidget {
  //final controller = TextEditingController();
  WalmartBar({this.cpage, this.showtitle, this.uid});
  String cpage;
  bool showtitle;
  String uid;
  FocusNode myFocusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    void _showDialog() {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Empty Search String"),
            content: new Text("Please enter some text"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new TextButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    if (cpage == 'searchresult' ||
        cpage == 'main' ||
        cpage == 'product' ||
        cpage == 'category') {
      return SliverAppBar(
        floating: true,
        backgroundColor: Color(0xffefecec),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              color: Color(0xff0070c0),
              padding: EdgeInsets.only(right: 26.0),
              icon: Icon(Icons.dehaze, color: Colors.black),
              iconSize: 28.0,
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WalmartSearch(
                    uid: uid,
                    categoryId: null,
                  ),
                ),
              );
            },
          ),
        ],
        // iconTheme: IconThemeData(
        //   color: Color(0xff0070c0),
        //   size: 28.0,
        // ),
        pinned: true,
        primary: true,
        expandedHeight: showtitle ? 185 : 142,
        collapsedHeight: 82,
        toolbarHeight: 80,
        title: Padding(
          padding: EdgeInsets.only(top: 0),
          child: Image.asset(
            'assets/images/new/walmart.png',
            height: 40,
          ),
        ),
        flexibleSpace: FlexibleSpaceBar(
            //backgroundColor: Color(0xffefecec),
            background: Padding(
                padding: const EdgeInsets.only(top: 105),
                child: Container(
                  color: Color(0xffefecec),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 8.0, 10.0, 5.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.93,
                                child: TextFormField(
                                  //controller: controller,
                                  onFieldSubmitted: (value) {
                                    if (value.isEmpty) {
                                      _showDialog();
                                      return null;
                                    }
                                    if (cpage == 'searchresult') {
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                new WalmartItemsListPage(
                                                  catId: '0',
                                                  catName: value,
                                                  uid: uid,
                                                )),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                new WalmartItemsListPage(
                                                  catId: '0',
                                                  catName: value,
                                                  uid: uid,
                                                )),
                                      );
                                    }
                                  },
                                  textInputAction: TextInputAction.search,
                                  //focusNode: myFocusNode,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    suffixIcon: Icon(Icons.search,
                                        color: myFocusNode.hasFocus
                                            ? Color(0xff0665c9)
                                            : Colors.black),
                                    hintText: 'Search for Anything...',
                                    // focusedBorder: UnderlineInputBorder(
                                    //   borderRadius:BorderRadius.circular(20.0),
                                    //   borderSide: BorderSide(
                                    //       color: Color(0xff0665c9), width: 3.0),
                                    // ),
                                    enabledBorder: UnderlineInputBorder(
                                      //borderRadius:BorderRadius.circular(20.0),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 0),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (showtitle)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 6.0, 8.0, 0.0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.95,
                                  child: Text("Category",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ))),
      );
    } else {
      return SliverAppBar(
        floating: true,
        pinned: true,
        primary: true,
        expandedHeight: 82,
        collapsedHeight: 82,
        toolbarHeight: 80,
        backgroundColor: Color(0xffefecec),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Padding(
          padding: EdgeInsets.only(top: 0),
          child: Image.asset(
            'assets/images/new/walmart.png',
            height: 40,
          ),
        ),
      );
    }
  }
}
