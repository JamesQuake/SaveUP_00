import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pay_or_save/pages/save.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  final String url, uid;

  @override
  _MyWebViewState createState() => _MyWebViewState(this.url, this.uid);


  MyWebView({Key key, @required this.url, this.uid}) : super(key: key);

}

WebViewController controllerGlobal;

Future<bool> _exitApp(BuildContext context) async {
  if (await controllerGlobal.canGoBack()) {
    print("onwill goback");
    controllerGlobal.goBack();
  } else {
    Navigator.of(context).pop();
    return Future.value(false);
  }
}

class _MyWebViewState extends State<MyWebView> {

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  String url, uid;

  Future navigateToSave(context) async {
      Navigator.push(context, MaterialPageRoute(builder: (context) =>  Save(uid: uid,)));

  }

  _MyWebViewState(this.url, this.uid);

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future _onNoConnectionDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("No Internet Connection"),
          content: const Text("Please try again later!", style: TextStyle(color: Colors.red),),
          actions: [
            new FlatButton(
              child: const Text("Ok"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shopping'),
          // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
          actions: <Widget>[
            NavigationControls(_controller.future),
            //  SampleMenu(_controller.future),
          ],
        ),
        // We're using a Builder here so we have a context that is below the Scaffold
        // to allow calling Scaffold.of(context) so we can show a snackbar.
        body: Builder(builder: (BuildContext context) {
          return WebView(
            onWebResourceError: (WebResourceError webviewerrr) {
              _onNoConnectionDialog();
            },
            initialUrl: "https://quaketechtv.com/Ebay2/index.php",
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            // TODO(iskakaushik): Remove this when collection literals makes it to stable.
            // ignore: prefer_collection_literals
            javascriptChannels: <JavascriptChannel>[
              _toasterJavascriptChannel(context),
            ].toSet(),
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                print('blocking navigation to $request}');
                return NavigationDecision.prevent;
              }
              if (request.url.startsWith('https://flutter.dev/docs')) {
                print('blocking navigation to $request}');
                return NavigationDecision.prevent;
              }
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
            onPageFinished: (String url) {
              print('Page finished loading: $url');
            },
          );
        }),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            navigateToSave(context);
          },
          label: Text('Next', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
//          icon: Icon(Icons.arrow_forward),
          backgroundColor: Color(0xFF660066),
        ),
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }


}

enum MenuOptions {
  showUserAgent,
  listCookies,
  clearCookies,
  addToCache,
  listCache,
  clearCache,
  navigationDelegate,
}

class SampleMenu extends StatelessWidget {
  SampleMenu(this.controller);

  final Future<WebViewController> controller;
  final CookieManager cookieManager = CookieManager();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: controller,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        return PopupMenuButton<MenuOptions>(
          onSelected: (MenuOptions value) {
            switch (value) {
              case MenuOptions.showUserAgent:
              //  _onShowUserAgent(controller.data, context);
                break;
              case MenuOptions.listCookies:
              //_onListCookies(controller.data, context);
                break;
              case MenuOptions.clearCookies:
              //  _onClearCookies(context);
                break;
              case MenuOptions.addToCache:
              //  _onAddToCache(controller.data, context);
                break;
              case MenuOptions.listCache:
              //  _onListCache(controller.data, context);
                break;
              case MenuOptions.clearCache:
              //    _onClearCache(controller.data, context);
                break;
              case MenuOptions.navigationDelegate:
              //  _onNavigationDelegateExample(controller.data, context);
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
            PopupMenuItem<MenuOptions>(
              value: MenuOptions.showUserAgent,
              child: const Text('Show user agent'),
              enabled: controller.hasData,
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.listCookies,
              child: Text('List cookies'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.clearCookies,
              child: Text('Clear cookies'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.addToCache,
              child: Text('Add to cache'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.listCache,
              child: Text('List cache'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.clearCache,
              child: Text('Clear cache'),
            ),
            const PopupMenuItem<MenuOptions>(
              value: MenuOptions.navigationDelegate,
              child: Text('Navigation Delegate example'),
            ),
          ],
        );
      },
    );
  }





}



class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        controllerGlobal = controller;

        return Row(
          children: <Widget>[
//            IconButton(
//              icon: const Icon(Icons.arrow_back_ios),
//              onPressed: !webViewReady
//                  ? null
//                  : () async {
//                if (await controller.canGoBack()) {
//                  controller.goBack();
//                } else {
//                  Scaffold.of(context).showSnackBar(
//                    const SnackBar(content: Text("No back history item")),
//                  );
//                  return;
//                }
//              },
//            ),
//            IconButton(
//              icon: const Icon(Icons.arrow_forward_ios),
//              onPressed: !webViewReady
//                  ? null
//                  : () async {
//                if (await controller.canGoForward()) {
//                  controller.goForward();
//                } else {
//                  Scaffold.of(context).showSnackBar(
//                    const SnackBar(
//                        content: Text("No forward history item")),
//                  );
//                  return;
//                }
//              },
//            ),
//            IconButton(
//              icon: const Icon(Icons.replay),
//              onPressed: !webViewReady
//                  ? null
//                  : () {
//                controller.reload();
//              },
//            ),
          ],
        );
      },
    );

  }
}

