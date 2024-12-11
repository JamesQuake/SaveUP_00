// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:crypto/crypto.dart';
// import 'package:http/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pay_or_save/models/amazon/amazon_item.dart';
import 'package:pay_or_save/models/amazon/amz_error_model.dart';

import '../../../models/amazon/amazon_cat_resp.dart';
import '../../../models/amazon/amazon_response_model.dart';
import '../call-amazon.dart';
// import '../sigV4/sigv4-client.dart';

class AmazonProvider extends ChangeNotifier {
  List<String> amzSubCat1;
  List<String> amzSubCat;
  List<String> subCatId;
  List<String> subCatId1;
  List _imgUrls;
  List _productLinks;
  List _productNames;
  List _costs;
  List _freeShippingEligibility;
  bool catLoading;

  List getitemsRes = [
    "BrowseNodeInfo.BrowseNodes",
    "CustomerReviews.Count",
    "CustomerReviews.StarRating",
    "Images.Primary.Medium",
    "Images.Primary.Large",
    "ItemInfo.ByLineInfo",
    "ItemInfo.ContentInfo",
    "ItemInfo.ContentRating",
    "ItemInfo.Classifications",
    "ItemInfo.ExternalIds",
    "ItemInfo.Features",
    "ItemInfo.ManufactureInfo",
    "ItemInfo.ProductInfo",
    "ItemInfo.TechnicalInfo",
    "ItemInfo.Title",
    "ItemInfo.TradeInInfo",
    "Offers.Listings.Availability.MaxOrderQuantity",
    "Offers.Listings.Availability.Message",
    "Offers.Listings.Availability.MinOrderQuantity",
    "Offers.Listings.Availability.Type",
    "Offers.Listings.Condition",
    "Offers.Listings.Condition.ConditionNote",
    "Offers.Listings.Condition.SubCondition",
    "Offers.Listings.DeliveryInfo.IsAmazonFulfilled",
    "Offers.Listings.DeliveryInfo.IsFreeShippingEligible",
    "Offers.Listings.DeliveryInfo.IsPrimeEligible",
    "Offers.Listings.DeliveryInfo.ShippingCharges",
    "Offers.Listings.IsBuyBoxWinner",
    "Offers.Listings.MerchantInfo",
    "Offers.Listings.Price",
    "Offers.Listings.Promotions",
    "Offers.Listings.SavingBasis",
    "Offers.Summaries.HighestPrice",
    "Offers.Summaries.LowestPrice",
    "Offers.Summaries.OfferCount"
  ];

  callSearchCatApi(
      {url, keywords, resources, req, searchindex, browsenode}) async {
    // print("working");
    var _response;
    try {
      _response = await makeAmazonCall(
        url: url,
        keywords: keywords,
        resources: resources,
        req: req,
        searchindex: searchindex,
        browsenode: browsenode,
      );
      if (_response.statusCode == 200) {
        var tempStorage = amazonCatResFromJson(_response.body);
        var dispName = tempStorage
            .searchResult.searchRefinements.browseNode.bins
            .map((dn) => dn.displayName)
            .toList();
        var id = tempStorage.searchResult.searchRefinements.browseNode.bins
            .map((dn) => dn.id)
            .toList();
        getAmzSubCat = dispName;
        getSubCatId = id;
      } else {
        final _data = amazonErrorFromJson(_response.body);
        // showDialog(
        //       context: context,g
        //       builder: (context) => AlertDialog(
        //             title: Image.asset('assets/icons/alert-animation.gif',
        //                 height: 50.0),
        //             content: Text(
        //               // _data.message.toString(),
        //               '',
        //               textAlign: TextAlign.center,
        //             ),
        //             shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.all(Radius.circular(35.0))),
        //             actions: [
        //               TextButton(
        //                   onPressed: () {
        //                     Navigator.of(context).pop();
        //                   },
        //                   child: Text('OK'))
        //             ],
        //           ));
      }
    } catch (e) {}

    // print(getSubCatId);
  }

  getFirstCat(url, keywords, resources, req, searchIndex) async {
    await callSearchCatApi(
      url: url,
      keywords: keywords,
      resources: resources,
      req: req,
      searchindex: searchIndex,
    );
    return getAmzSubCat;
  }

  getSecondCat({url, keywords, resources, req, searchindex, browsenode}) async {
    var response = await makeAmazonCall(
      url: url,
      keywords: keywords,
      resources: resources,
      req: req,
      searchindex: searchindex,
      browsenode: browsenode,
    );
    var tempStorage = amazonCatResFromJson(response.body);
    var dispName = tempStorage.searchResult.searchRefinements.browseNode.bins
        .map((dn) => dn.displayName)
        .toList();
    var id = tempStorage.searchResult.searchRefinements.browseNode.bins
        .map((dn) => dn.id)
        .toList();
    getAmzSubCat1 = dispName;
    getSubCatId1 = id;
    return getAmzSubCat1;
  }

  callAmzLastCat({
    url,
    keywords,
    resources,
    req,
    searchindex,
    browsenode,
    caller,
    sorter,
    pageNum,
  }) async {
    var response = await makeAmazonCall(
      url: url,
      keywords: keywords,
      resources: resources,
      req: req,
      searchindex: searchindex,
      browsenode: browsenode,
      sorter: sorter,
      pageNum: pageNum,
    );

    // void prints(var s1) {
    //   String s = s1.toString();
    //   final pattern = RegExp('.{1,800}');
    //   pattern.allMatches(s).forEach((match) => print(match.group(0)));
    // }

    // print(response.body);
    var _tempStore = amazonCatResFromJson(response.body);

    // var imgUrls = _tempStore.searchResult.items
    //     .map((img) => img.images.primary.medium.url)
    //     .toList();

    // var productLink = _tempStore.searchResult.items
    //     .map((link) => link.detailPageUrl)
    //     .toList();

    // var productName = _tempStore.searchResult.items
    //     .map((title) => title.itemInfo.title.displayValue)
    //     .toList();

    // var cost = _tempStore.searchResult.items
    //     .map((price) => price.offers.listings
    //         .map((listing) => listing.price.displayAmount)
    //         .toList())
    //     .toList();

    // var freeShippingEligible = _tempStore.searchResult.items
    //     .map((price) => price.offers.listings
    //         .map((delivery) => delivery.deliveryInfo.isFreeShippingEligible)
    //         .toList())
    //     .toList();

    // getImgUrls = imgUrls;
    // getProductLinks = productLink;
    // getProductNames = productName;
    // getCosts = cost;
    // getFreeShippingStat = freeShippingEligible;
    // print("something");
    if (caller == 0) {
      var _tempStoreRes = amazonResFromJson(response.body);
      return _tempStoreRes;
    } else
      return _tempStore;
  }

  getAmzItem(asin) async {
    // print("moving things");
    var response = await makeAmazonCall(
      resources: getitemsRes,
      asin: asin,
      url: "GetItems",
      req: "POST",
    );
    print("running things");
    print(response.body);
    var _tempStore = amazonItemFromJson(response.body);

    // print(_tempStore);
    return _tempStore;
  }

  List<String> get getAmzSubCat => amzSubCat;
  set getAmzSubCat(val) {
    amzSubCat = val;
    // notifyListeners();
  }

  List<String> get getSubCatId => subCatId;
  set getSubCatId(val) {
    subCatId = val;
    // notifyListeners();
  }

  List<String> get getAmzSubCat1 => amzSubCat1;
  set getAmzSubCat1(val) {
    amzSubCat1 = val;
    // notifyListeners();
  }

  List<String> get getSubCatId1 => subCatId1;
  set getSubCatId1(val) {
    subCatId1 = val;
    // notifyListeners();
  }

  List get getImgUrls => _imgUrls;
  set getImgUrls(val) {
    _imgUrls = val;
    // notifyListeners();
  }

  List get getProductLinks => _productLinks;
  set getProductLinks(val) {
    _productLinks = val;
    // notifyListeners();
  }

  List get getProductNames => _productNames;
  set getProductNames(val) {
    _productNames = val;
    // notifyListeners();
  }

  List get getCosts => _costs;
  set getCosts(val) {
    _costs = val;
    // notifyListeners();
  }

  List get getFreeShippingStat => _freeShippingEligibility;
  set getFreeShippingStat(val) {
    _freeShippingEligibility = val;
    // notifyListeners();
  }
}
