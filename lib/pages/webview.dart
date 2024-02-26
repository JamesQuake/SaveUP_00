import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../element/ebaybar.dart';

class EbayWebView extends StatefulWidget {
  EbayWebView({this.url, this.title, this.uid});
  final String title;
  final String url;
  final String uid;
  @override
  EbayWebViewState createState() => EbayWebViewState();
}

class EbayWebViewState extends State<EbayWebView> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Center(child: CircularProgressIndicator()),
            WebView(
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
            ),
          ],
        ));
  }
}
