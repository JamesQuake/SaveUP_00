import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/models/virtural_closet_model.dart';
import 'package:pay_or_save/models/walmart_items_model.dart';
import 'package:pay_or_save/pages/walmart_product.dart';

import '../element/authoriser.dart';
import 'product.dart';

class VirtualCloset extends StatefulWidget {
  final String uid;

  @override
  _VirtualClosetState createState() => _VirtualClosetState(uid);

  VirtualCloset({Key key, @required this.uid}) : super(key: key);
}

class _VirtualClosetState extends State<VirtualCloset> {
  String _uid, _sortValue;

  _VirtualClosetState(this._uid);

  @override
  void initState() {
    super.initState();
    _getVirtualClosetProducts();
  }

  List<VirtualClosetModel> _virtualCloset = [];

  Future _getVirtualClosetProducts() async {
    QuerySnapshot<Map<String, dynamic>> _ff = await FirebaseFirestore.instance
        .collection('virtualCloset')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid).orderBy('doc', descending: true)
        .get();
    _virtualCloset.clear();
    _virtualCloset = [];
    if (_ff.docs.isNotEmpty) {
      _ff.docs.forEach((element) {
        _virtualCloset.add(VirtualClosetModel.fromJson(element.data()));
      });
      print('vvvvvvv');
      print('${_virtualCloset.length}');
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Item> _getWalmartItem(String uri) async {
    // setState(() {
    //   _isLoading = true;
    // });
    
    String baseUrl = 'https://api.impact.com';
    String apiUrl ='$baseUrl$uri';

    print('makeWalmartCall');
    final response = await makeWalmartCall(apiUrl);
    print(response.body);
    if (response.statusCode == 200) {
      // setState(() {
      //   _isLoading = false;
      // });
      //print(response.body);
      return walmartProductResponseFromJson(response.body);
    } else {
      throw Exception('Failed to load result');
    }
  }

  Widget _item(BuildContext context, int index) {
    return ListTile(
      leading: Container(
        width: 80,
        child: Image.network(
          _virtualCloset[index].pImage,
          alignment: Alignment.center,
          fit: BoxFit.fitWidth,
        ),
      ),
      title: Text(
        _virtualCloset[index].pName,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Chip(label: Text('\$${_virtualCloset[index].pPrice}')),
          Text(
            '${_virtualCloset[index].platform} | ${_virtualCloset[index].doc.month}/${_virtualCloset[index].doc.day}/${_virtualCloset[index].doc.year}',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
      onTap: () async {
        if(_virtualCloset[index].platform.toLowerCase() == 'ebay'){
          Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => ProductPage(
                itemId: _virtualCloset[index].pId,
                uid: widget.uid,
              )),
        );
        } else if(_virtualCloset[index].platform.toLowerCase() == 'walmart'){
          EasyLoading.show();
          Item item = await _getWalmartItem(_virtualCloset[index].walmartUri);
          EasyLoading.dismiss();
          Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => WalmartProductPage(
                item: item,
                uid: widget.uid,
              )),
        );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Color(0xff0070c0),
        title: Text(
          'Virtual Closet',
          style: TextStyle(
              // fontSize: 15.0,
              ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      endDrawer: MainDrawer(uid: widget.uid, incomingRoute: '/virtual_closet'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _virtualCloset.length > 0 ? Expanded(
              child: ListView(
                children: [
                  Column(
                    children: <Widget>[
                      /*Row(
                        children: <Widget>[
                          Text(
                            "Sort by:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Container(
                            width: 250,
                            child: DropdownButton(
                              hint: _sortValue == null
                                  ? Text('')
                                  : Text(
                                      _sortValue,
                                      style: TextStyle(color: Colors.black),
                                    ),
                              isExpanded: true,
                              iconSize: 30.0,
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 20),
                              items: [
                                'Price',
                                'Date',
                              ].map(
                                (val) {
                                  return DropdownMenuItem<String>(
                                    value: val,
                                    child: Text(val),
                                  );
                                },
                              ).toList(),
                              onChanged: (val) {
                                setState(
                                  () {
                                    _sortValue = val;
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      */
                      SizedBox(
                        width: 380.0,
                        child: ListView.builder(
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: _virtualCloset.length,
                            itemBuilder: (BuildContext context, int index) =>
                                _item(context, index)),
                      ),
                      // SizedBox(
                      //   height: 50,
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.only(left: 0.0, right: 0.0),
                      //   child: ButtonTheme(
                      //     minWidth: 300.0,
                      //     height: 50.0,
                      //     child: RaisedButton(
                      //       textColor: Colors.white,
                      //       color: Color(0xff0070c0),
                      //       child: Text("Next"),
                      //       onPressed: () {
                      //         navigateToOverdraft(context);
                      //       },
                      //       shape: new RoundedRectangleBorder(
                      //         borderRadius: new BorderRadius.circular(10.0),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 50,
                      // ),
                    ],
                  ),
                ],
              ),
            ) : Center(
              child: Text('No products for now'),
            ),
            /*ButtonTheme(
              minWidth: double.infinity,
              height: 50.0,
              child: RaisedButton(
                textColor: Colors.white,
                color: Color(0xff0070c0),
                child: Text(
                  "Next",
                  style: TextStyle(fontSize: 20.0),
                ),
                onPressed: () {
                  // navigateToOverdraft(context);
                },
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
