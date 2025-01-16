import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:pay_or_save/element/walmart_bar.dart';
import 'package:pay_or_save/pages/invest_now.dart';
import 'package:pay_or_save/pages/save_now.dart';
import 'package:pay_or_save/pages/webview.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/walmart_product.dart';

class WalmartProductDetail extends StatefulWidget {
  final String uid;
  final WalmartProduct product;

  WalmartProductDetail({
    @required this.uid,
    @required this.product,
  });

  @override
  _WalmartProductDetailState createState() => _WalmartProductDetailState();
}

class _WalmartProductDetailState extends State<WalmartProductDetail> {
  void _showPayDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "We are redirecting you to Walmart to complete checkout. As a Walmart affiliate, we earn from qualifying purchases.",
                style: TextStyle(fontSize: 17),
              ),
              SizedBox(height: 10.0),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    height: 1.0,
                    fontSize: 16,
                  ),
                  children: [
                    TextSpan(text: "Tap on "),
                    TextSpan(
                      text: " < ",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                      ),
                    ),
                    TextSpan(text: " to return to "),
                    TextSpan(
                      text: " SaveUp",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EbayWebView(
                      url: widget.product.productTrackingUrl,
                      title: widget.product.name,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: MainDrawer(uid: widget.uid),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: const BorderRadius.all(Radius.circular(40.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 62,
                height: 62,
                child: FloatingActionButton(
                  heroTag: 'pay',
                  onPressed: _showPayDialog,
                  backgroundColor: Color(0xffe83a0c),
                  child: Text(
                    'Pay',
                    style: TextStyle(fontSize: 17.0),
                  ),
                ),
              ),
              SizedBox(width: 35.0),
              Container(
                width: 62,
                height: 62,
                child: FloatingActionButton(
                  heroTag: 'save',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SaveNow(
                          incomingOrder: widget.product.salePrice.toString(),
                          uid: widget.uid,
                        ),
                      ),
                    );
                  },
                  backgroundColor: Color(0xff2ca858),
                  child: Text(
                    '\$ave',
                    style: TextStyle(fontSize: 17.0),
                  ),
                ),
              ),
              SizedBox(width: 35.0),
              Container(
                width: 62,
                height: 62,
                child: FloatingActionButton(
                  heroTag: 'invest',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InvestNow(
                          incomingOrder: widget.product.salePrice.toString(),
                          uid: widget.uid,
                        ),
                      ),
                    );
                  },
                  backgroundColor: Color(0xff3790ce),
                  child: Text(
                    'Invest',
                    style: TextStyle(fontSize: 17.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          WalmartBar(
            cpage: "product",
            showtitle: false,
            uid: widget.uid,
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(maxHeight: 300),
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Center(child: CircularProgressIndicator()),
                      Image.network(
                        widget.product.largeImage ?? '',
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15, top: 15),
                  child: Text(
                    widget.product.name ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15),
                  alignment: Alignment.centerLeft,
                  height: 40,
                  child: Text(
                    '\$${widget.product.salePrice?.toStringAsFixed(2) ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                if (widget.product.shortDescription != null)
                  Container(
                    padding: EdgeInsets.only(top: 30),
                    constraints: BoxConstraints(minHeight: 175),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black38,
                          width: 1.0,
                        ),
                      ),
                    ),
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Item Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          widget.product.shortDescription,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                Container(
                  padding: EdgeInsets.only(top: 30),
                  constraints: BoxConstraints(minHeight: 175),
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About this Item',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildDetailRow('Brand', widget.product.brandName ?? 'Unknown'),
                      _buildDetailRow('Stock', widget.product.stock ?? 'Unknown'),
                      if (widget.product.categoryPath != null)
                        _buildDetailRow('Category', widget.product.categoryPath),
                      if (widget.product.upc != null)
                        _buildDetailRow('UPC', widget.product.upc),
                      SizedBox(height: 111.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 130,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black45,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
} 