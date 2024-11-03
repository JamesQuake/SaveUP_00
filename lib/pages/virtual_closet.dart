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
  var _sortItems = [
    'Price - Low to High',
    'Price - High to Low',
    'Newest',
    'Oldest',
    'Walmart',
    'eBay'
  ];

  _VirtualClosetState(this._uid);

  @override
  void initState() {
    super.initState();
    _getVirtualClosetProducts();
  }

  List<VirtualClosetModel> _virtualCloset = [];
  bool _isLoading = true;

  Future _getVirtualClosetProducts() async {
    try {
      setState(() => _isLoading = true);

      Query<Map<String, dynamic>> _query = FirebaseFirestore.instance
          .collection('virtualCloset')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
          .orderBy('doc', descending: true);

      if (_sortValue == null) {
        _query = FirebaseFirestore.instance
            .collection('virtualCloset')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
            .orderBy('doc', descending: true);
      } else if (_sortValue == _sortItems[0]) {
        _query = FirebaseFirestore.instance
            .collection('virtualCloset')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
            .orderBy('pPrice', descending: true);
      } else if (_sortValue == _sortItems[1]) {
        _query = FirebaseFirestore.instance
            .collection('virtualCloset')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
            .orderBy('pPrice', descending: false);
      } else if (_sortValue == _sortItems[2]) {
        _query = FirebaseFirestore.instance
            .collection('virtualCloset')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
            .orderBy('doc', descending: true);
      } else if (_sortValue == _sortItems[3]) {
        _query = FirebaseFirestore.instance
            .collection('virtualCloset')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
            .orderBy('doc', descending: false);
      } else if (_sortValue == _sortItems[4]) {
        _query = FirebaseFirestore.instance
            .collection('virtualCloset')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
            .where('platform', isEqualTo: 'Walmart')
            .orderBy('doc', descending: true);
      } else if (_sortValue == _sortItems[5]) {
        _query = FirebaseFirestore.instance
            .collection('virtualCloset')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
            .where('platform', isEqualTo: 'eBay')
            .orderBy('doc', descending: true);
      }

      QuerySnapshot<Map<String, dynamic>> _ff = await _query.get();
      _virtualCloset.clear();
      _virtualCloset = [];
      if (_ff.docs.isNotEmpty) {
        _ff.docs.forEach((element) {
          _virtualCloset.add(VirtualClosetModel.fromJson(element.data()));
        });
        // print('vvvvvvv');
        // print('${_virtualCloset.length}');
      }
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
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
    String apiUrl = '$baseUrl$uri';

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
        if (_virtualCloset[index].platform.toLowerCase() == 'ebay') {
          Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => ProductPage(
                      itemId: _virtualCloset[index].pId,
                      uid: widget.uid,
                    )),
          );
        } else if (_virtualCloset[index].platform.toLowerCase() == 'walmart') {
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
        centerTitle: false,
        elevation: 0.0,
      ),
      endDrawer: MainDrawer(uid: widget.uid, incomingRoute: '/virtual_closet'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? LinearProgressIndicator()
            : Column(
                children: [
                  _virtualCloset.length > 0
                      ? Expanded(
                          child: ListView(
                            children: [
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Sort by:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                        SizedBox(width: 30),
                                        Container(
                                          width: 250,
                                          child: DropdownButton(
                                            hint: _sortValue == null
                                                ? Text('')
                                                : Text(
                                                    _sortValue,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                            isExpanded: true,
                                            iconSize: 30.0,
                                            style: TextStyle(
                                                color: Colors.blue, fontSize: 18),
                                            items: _sortItems.map(
                                              (val) {
                                                return DropdownMenuItem<String>(
                                                  value: val,
                                                  child: Text(val),
                                                );
                                              },
                                            ).toList(),
                                            onChanged: (val) {
                                              setState(() => _sortValue = val);
                                              _getVirtualClosetProducts();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 380.0,
                                    child: ListView.builder(
                                        physics: ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: _virtualCloset.length,
                                        itemBuilder:
                                            (BuildContext context, int index) =>
                                                _item(context, index)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: Text('No products for now'),
                        ),
                ],
              ),
      ),
    );
  }
}
