import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'amazon_provider.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:path/path.dart';
// import 'package:async/async.dart';

class AmzCategoriesProvider extends ChangeNotifier {
  bool catLoading;
  AmazonProvider _amzRes;

  List cat = [
    {
      "category": {
        "categoryId": "Appliances",
        "categoryName": "Appliances",
        "imageUrl":
            "https://m.media-amazon.com/images/I/61E1h4TadxL._AC_SL1500_.jpg",
        "imageUrl2": ""
      }
    },
    {
      "category": {
        "categoryId": "ArtsAndCrafts",
        "categoryName": "Arts and Craft",
        "imageUrl":
            "https://m.media-amazon.com/images/I/81ON4-sLO0L._AC_SL1500_.jpg",
        "imageUrl2": ""
      }
    },
    {
      "category": {
        "categoryId": "Automotive",
        "categoryName": "Automotive Parts & Accessories",
        "imageUrl":
            "https://m.media-amazon.com/images/I/71jIlW6La7L._AC_SL1500_.jpg",
        "imageUrl2": ""
      }
    },
    {
      "category": {
        "categoryId": "Baby",
        "categoryName": "Baby",
        "imageUrl":
            "https://m.media-amazon.com/images/I/81cFKwC8fvL._AC_SL1500_.jpg",
        "imageUrl2": ""
      }
    },
    {
      "category": {
        "categoryId": "Beauty",
        "categoryName": "Beauty & Personal Care",
        "imageUrl":
            "https://m.media-amazon.com/images/I/61VIt2hm6hL._SL1000_.jpg",
        "imageUrl2": ""
      }
    },
    {
      "category": {
        "categoryId": "Books",
        "categoryName": "Books",
        "imageUrl": "https://m.media-amazon.com/images/I/81PQlW-p8nL.jpg",
        "imageUrl2": ""
      }
    },
    {
      "category": {
        "categoryId": "Music",
        "categoryName": "CDs & Vinyl",
        "imageUrl":
            "https://m.media-amazon.com/images/I/81CmHO+T49L._SL1500_.jpg",
        "imageUrl2": ""
      }
    },
    {
      "category": {
        "categoryId": "MobileAndAccessories",
        "categoryName": "Cell Phones & Accessories",
        "imageUrl":
            "https://m.media-amazon.com/images/I/51J1d8kZsCL._AC_SL1250_.jpg",
        "imageUrl2": ""
      }
    },
    {
      "category": {
        "categoryId": "Fashion",
        "categoryName": "Clothes and Accessories",
        "imageUrl":
            "https://m.media-amazon.com/images/I/711RLvG6xCL._AC_UX385_.jpg",
        "imageUrl2": ""
      }
    },
    {
      "category": {
        "categoryId": "DigitalMusic",
        "categoryName": "Digital Music",
        "imageUrl":
            "https://m.media-amazon.com/images/I/41hRngcV3dL._UX500_FMwebp_QL85_.jpg",
        "imageUrl2": ""
      }
    },
    {
      "category": {
        "categoryId": "Electronics",
        "categoryName": "Electronics",
        "imageUrl":
            "https://m.media-amazon.com/images/I/71bhWgQK-cL._AC_SL1500_.jpg",
        "imageUrl2":
            "https://m.media-amazon.com/images/I/71V9-3bT9rL._AC_SL1500_.jpg"
      }
    },
    {
      "category": {
        "categoryId": "EverythingElse",
        "categoryName": "Everything Else",
        "imageUrl":
            "https://m.media-amazon.com/images/I/61AD9n19HcL._AC_SL1500_.jpg",
        "imageUrl2": ""
      }
    },
    {
      "category": {
        "categoryId": "GardenAndOutdoor",
        "categoryName": "Garden & Outdoor",
        "imageUrl":
            "https://m.media-amazon.com/images/I/81wJUogo6hL._AC_SL1500_.jpg",
        "imageUrl2": ""
      }
    },
    {
      "category": {
        "categoryId": "GiftCards",
        "categoryName": "Gift Cards",
        "imageUrl":
            "https://m.media-amazon.com/images/I/81WsZXzuXoL._SL1500_.jpg",
        "imageUrl2": ""
      }
    },
    {
      "category": {
        "categoryId": "GroceryAndGourmetFood",
        "categoryName": "Grocery & Gourmet Food",
        "imageUrl":
            "https://m.media-amazon.com/images/I/81DeUk0fwPL._SL1500_.jpg",
        "imageUrl2": ""
      }
    },
    {
      "category": {
        "categoryId": "HealthPersonalCare",
        "categoryName": "Health and Household",
        "imageUrl":
            "https://m.media-amazon.com/images/I/71zrQisetiL._AC_SL1200_.jpg",
        "imageUrl2": ""
      }
    },
    {
      "category": {
        "categoryId": "LocalServices",
        "categoryName": "Home & Business Services",
        "imageUrl":
            "https://m.media-amazon.com/images/I/711drM6kxQL._AC_SL1500_.jpg",
        "imageUrl2": ""
      }
    },
    {
      "category": {
        "categoryId": "HomeAndKitchen",
        "categoryName": "Home and Kitchen",
        "imageUrl":
            "https://m.media-amazon.com/images/I/61zELlfqTPL._AC_SL1500_.jpg",
        "imageUrl2": ""
      }
    },
    {
      "category": {
        "categoryId": "Industrial",
        "categoryName": "Industrial & Scientific",
        "imageUrl":
            "https://m.media-amazon.com/images/I/51+lqvSEmML._SL1500_.jpg",
        "imageUrl2": ""
      }
    },
    {
      "category": {
        "categoryId": "MusicalInstruments",
        "categoryName": "Musical Instruments",
        "imageUrl":
            "https://m.media-amazon.com/images/I/81oNjvm7k8L._AC_SL1500_.jpg",
        "imageUrl2": ""
      }
    },
    {
      "category": {
        "categoryId": "OfficeProducts",
        "categoryName": "Office Products",
        "imageUrl":
            "https://m.media-amazon.com/images/I/71Ui3dxCZ9L._AC_SL1500_.jpg",
        "imageUrl2": ""
      }
    },
    {
      "category": {
        "categoryId": "PetSupplies",
        "categoryName": "Pet Supplies",
        "imageUrl":
            "https://m.media-amazon.com/images/I/61KCxlOlWsL._AC_SL1500_.jpg",
        "imageUrl2": ""
      }
    },
    {
      "category": {
        "categoryId": "Software",
        "categoryName": "Software",
        "imageUrl":
            "https://m.media-amazon.com/images/I/81jQRFWh3UL._AC_SL1500_.jpg",
        "imageUrl2": ""
      }
    },
    {
      "category": {
        "categoryId": "SportsAndOutdoors",
        "categoryName": "Sports & Outdoors",
        "imageUrl":
            "https://m.media-amazon.com/images/I/41iag5vRGVL._AC_SL1001_.jpg",
        "imageUrl2": ""
      }
    },
    {
      "category": {
        "categoryId": "ToolsAndHomeImprovement",
        "categoryName": "Tools & Home Improvement",
        "imageUrl":
            "https://m.media-amazon.com/images/I/5121S9YYyUL._AC_SL1000_.jpg",
        "imageUrl2": ""
      }
    },
    {
      "category": {
        "categoryId": "ToysAndGames",
        "categoryName": "Toys & Games",
        "imageUrl":
            "https://m.media-amazon.com/images/I/71z1rgxpN4L._AC_SL1000_.jpg",
        "imageUrl2": ""
      }
    },
    {
      "category": {
        "categoryId": "VideoGames",
        "categoryName": "Video Games",
        "imageUrl":
            "https://m.media-amazon.com/images/I/61dYrzvBLbL._SL1483_.jpg",
        "imageUrl2": ""
      }
    },
  ];

  List res = [
    // "BrowseNodeInfo.BrowseNodes",
    // "CustomerReviews.Count",
    // "Images.Primary.Small",
    // "Images.Primary.Medium",
    // "Images.Primary.Large",
    // "ItemInfo.ContentRating",
    // "ItemInfo.Classifications",
    // "ItemInfo.ProductInfo",
    // "ItemInfo.Title",
    // "Offers.Listings.Condition",
    // "Offers.Listings.Price",
    // "SearchRefinements"
    "BrowseNodeInfo.BrowseNodes",
    "CustomerReviews.Count",
    "Images.Primary.Small",
    "Images.Primary.Medium",
    "Images.Primary.Large",
    "ItemInfo.ContentRating",
    "ItemInfo.Classifications",
    "ItemInfo.ProductInfo",
    "ItemInfo.Title",
    "Offers.Listings.Condition",
    "Offers.Listings.DeliveryInfo.IsFreeShippingEligible",
    "Offers.Listings.DeliveryInfo.ShippingCharges",
    "Offers.Listings.Price",
    "SearchRefinements"
  ];

  Future getSubcar1({
    @required BuildContext context,
    String catName,
    String catId,
  }) async {
    // print("iam");
    // setState(() {
    getCatLoading = true;
    // });
    // catId = widget.catId;
    AmazonProvider amzInstance =
        Provider.of<AmazonProvider>(context, listen: false);
    // print("magic");
    // print("winner");
    List ero = await amzInstance.getFirstCat(
      "SearchItems",
      catName,
      res,
      "POST",
      catId,
    );
    // print("winner");
    // print(ero);
    List tempHold = ero;
    if (tempHold.isNotEmpty) {
      // setState(() {
      getCatLoading = false;
      // });
      // tempHold.removeAt(0);
      tempHold.sort();
      return tempHold;
    } else {
      throw Exception('Failed to load category');
    }
  }

  Future getSubcar2({
    @required BuildContext context,
    String catName,
    String searchIndex,
    String browsenode,
  }) async {
    // print("iam");
    // setState(() {
    getCatLoading = true;
    // });
    // catId = widget.catId;
    AmazonProvider amzInstance =
        Provider.of<AmazonProvider>(context, listen: false);
    List _ero = await amzInstance.getSecondCat(
      url: "SearchItems",
      keywords: catName,
      resources: res,
      req: "POST",
      searchindex: searchIndex,
      browsenode: browsenode,
    );
    // print("winner");
    // print(ero);
    List _tempHold = _ero;
    if (_tempHold.isNotEmpty) {
      // setState(() {
      getCatLoading = false;
      // });
      // _tempHold = _tempHold.sort(((a, b) => a.toString().compareTo(b.toString())));
      // _tempHold.removeAt(0);
      _tempHold.sort();
      return _tempHold;
    } else {
      throw Exception('Failed to load category');
    }
  }

  Future getCatResults({
    @required BuildContext context,
    String catName,
    String searchIndex,
    String browseNode,
    int caller,
    String sorter,
    int pageNum,
  }) async {
    // print("something");
    AmazonProvider amzInstance =
        Provider.of<AmazonProvider>(context, listen: false);

    var _temp = await amzInstance.callAmzLastCat(
      url: "SearchItems",
      keywords: catName,
      resources: res,
      req: "POST",
      searchindex: searchIndex,
      browsenode: browseNode,
      caller: caller,
      sorter: sorter,
      pageNum: pageNum,
    );
    // print(_temp);
    return _temp;
  }

  bool get getCatLoading => catLoading;
  set getCatLoading(val) {
    catLoading = val;
    // notifyListeners();
  }

  AmazonProvider get getAmzRes => _amzRes;
  set getAmzRes(val) {
    _amzRes = val;
    // notifyListeners();
  }
}
