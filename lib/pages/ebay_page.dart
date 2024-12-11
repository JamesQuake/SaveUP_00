import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pay_or_save/assets/main_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:english_words/english_words.dart';
// import 'package:transparent_image/transparent_image.dart';
// import 'dart:convert';
import '../models/category.dart';
import '../element/ebaybar.dart';
import 'subcategory.dart';

// class Ebaypage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Ebay Search',
//       theme: ThemeData(
//         // Add the 3 lines from here...
//         primaryColor: Colors.white,
//       ),
//       home: RandomWords(),
//     );
//   }
// }

class Ebay extends StatefulWidget {
  final String uid;

  const Ebay({Key key, this.uid}) : super(key: key);
  @override
  _EbayState createState() => _EbayState();
}

class _EbayState extends State<Ebay> {
  List<Category> categoryList = List();
  bool _isLoading = false;
  SharedPreferences _prefss;

  _getUsers() async {
    setState(() {
      _isLoading = true;
    });

    var data = await DefaultAssetBundle.of(context)
        .loadString("assets/images/new/category.json");
    categoryList = categoryFromJson(data);

    await getPrefs();

    setState(() {
      _isLoading = false;
    });
  }

  getPrefs() async {
    _prefss = await SharedPreferences.getInstance();
    await _prefss.setString('storedUid', widget.uid);
  }

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: MainDrawer(uid: widget.uid),
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: <Widget>[
          new ebaybar(cpage: "main", showtitle: true, uid: widget.uid),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250.0,
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
              childAspectRatio: 0.85,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Material(
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new SubCategory(
                          catId: categoryList[index].category.categoryId,
                          catName: categoryList[index].category.categoryName,
                          imgUrl: categoryList[index].category.imageUrl2,
                          uid: widget.uid,
                        ),
                      ),
                    ), // handle your onTap here
                    child: Container(
                        margin: EdgeInsets.only(
                          left: 15,
                          right: 15,
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: <Widget>[
                                        Center(
                                            child: CircularProgressIndicator()),
                                        Image.network(
                                          categoryList[index].category.imageUrl,
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
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 150,
                                  alignment: Alignment.center,
                                  child: Text(
                                    categoryList[index].category.categoryName,
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                  ),
                );
              },
              childCount: categoryList.length,
            ),
          )
        ],
      ),
    );
  }
}
