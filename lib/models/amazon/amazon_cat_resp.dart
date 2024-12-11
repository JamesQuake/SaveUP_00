// To parse this JSON data, do
//
//     final amazonCatRes = amazonCatResFromJson(jsonString);

import 'dart:convert';

AmazonCatRes amazonCatResFromJson(String str) =>
    AmazonCatRes.fromJson(json.decode(str));

String amazonCatResToJson(AmazonCatRes data) => json.encode(data.toJson());

class AmazonCatRes {
  AmazonCatRes({
    this.searchResult,
  });

  SearchResult searchResult;

  factory AmazonCatRes.fromJson(Map<String, dynamic> json) => AmazonCatRes(
        searchResult: json["SearchResult"] == null
            ? null
            : SearchResult.fromJson(json["SearchResult"]),
      );

  Map<String, dynamic> toJson() => {
        "SearchResult": searchResult == null ? null : searchResult.toJson(),
      };
}

class SearchResult {
  SearchResult({
    this.items,
    this.searchRefinements,
    this.searchUrl,
    this.totalResultCount,
  });

  List<Item> items;
  SearchRefinements searchRefinements;
  String searchUrl;
  int totalResultCount;

  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
        items: json["Items"] == null
            ? null
            : List<Item>.from(json["Items"].map((x) => Item.fromJson(x))),
        searchRefinements: json["SearchRefinements"] == null
            ? null
            : SearchRefinements.fromJson(json["SearchRefinements"]),
        searchUrl: json["SearchURL"] == null ? null : json["SearchURL"],
        totalResultCount:
            json["TotalResultCount"] == null ? null : json["TotalResultCount"],
      );

  Map<String, dynamic> toJson() => {
        "Items": items == null
            ? null
            : List<dynamic>.from(items.map((x) => x.toJson())),
        "SearchRefinements":
            searchRefinements == null ? null : searchRefinements.toJson(),
        "SearchURL": searchUrl == null ? null : searchUrl,
        "TotalResultCount": totalResultCount == null ? null : totalResultCount,
      };
}

class Item {
  Item({
    this.asin,
    this.browseNodeInfo,
    this.detailPageUrl,
    this.images,
    this.itemInfo,
    this.offers,
  });

  String asin;
  BrowseNodeInfo browseNodeInfo;
  String detailPageUrl;
  Images images;
  ItemInfo itemInfo;
  Offers offers;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        asin: json["ASIN"] == null ? null : json["ASIN"],
        browseNodeInfo: json["BrowseNodeInfo"] == null
            ? null
            : BrowseNodeInfo.fromJson(json["BrowseNodeInfo"]),
        detailPageUrl:
            json["DetailPageURL"] == null ? null : json["DetailPageURL"],
        images: json["Images"] == null ? null : Images.fromJson(json["Images"]),
        itemInfo: json["ItemInfo"] == null
            ? null
            : ItemInfo.fromJson(json["ItemInfo"]),
        offers: json["Offers"] == null ? null : Offers.fromJson(json["Offers"]),
      );

  Map<String, dynamic> toJson() => {
        "ASIN": asin == null ? null : asin,
        "BrowseNodeInfo":
            browseNodeInfo == null ? null : browseNodeInfo.toJson(),
        "DetailPageURL": detailPageUrl == null ? null : detailPageUrl,
        "Images": images == null ? null : images.toJson(),
        "ItemInfo": itemInfo == null ? null : itemInfo.toJson(),
        "Offers": offers == null ? null : offers.toJson(),
      };
}

class BrowseNodeInfo {
  BrowseNodeInfo({
    this.browseNodes,
  });

  List<BrowseNode> browseNodes;

  factory BrowseNodeInfo.fromJson(Map<String, dynamic> json) => BrowseNodeInfo(
        browseNodes: json["BrowseNodes"] == null
            ? null
            : List<BrowseNode>.from(
                json["BrowseNodes"].map((x) => BrowseNode.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "BrowseNodes": browseNodes == null
            ? null
            : List<dynamic>.from(browseNodes.map((x) => x.toJson())),
      };
}

class BrowseNode {
  BrowseNode({
    this.contextFreeName,
    this.displayName,
    this.id,
    this.isRoot,
  });

  String contextFreeName;
  String displayName;
  String id;
  bool isRoot;

  factory BrowseNode.fromJson(Map<String, dynamic> json) => BrowseNode(
        contextFreeName:
            json["ContextFreeName"] == null ? null : json["ContextFreeName"],
        displayName: json["DisplayName"] == null ? null : json["DisplayName"],
        id: json["Id"] == null ? null : json["Id"],
        isRoot: json["IsRoot"] == null ? null : json["IsRoot"],
      );

  Map<String, dynamic> toJson() => {
        "ContextFreeName": contextFreeName == null ? null : contextFreeName,
        "DisplayName": displayName == null ? null : displayName,
        "Id": id == null ? null : id,
        "IsRoot": isRoot == null ? null : isRoot,
      };
}

class Images {
  Images({
    this.primary,
  });

  Primary primary;

  factory Images.fromJson(Map<String, dynamic> json) => Images(
        primary:
            json["Primary"] == null ? null : Primary.fromJson(json["Primary"]),
      );

  Map<String, dynamic> toJson() => {
        "Primary": primary == null ? null : primary.toJson(),
      };
}

class Primary {
  Primary({
    this.large,
    this.medium,
    this.small,
  });

  Large large;
  Large medium;
  Large small;

  factory Primary.fromJson(Map<String, dynamic> json) => Primary(
        large: json["Large"] == null ? null : Large.fromJson(json["Large"]),
        medium: json["Medium"] == null ? null : Large.fromJson(json["Medium"]),
        small: json["Small"] == null ? null : Large.fromJson(json["Small"]),
      );

  Map<String, dynamic> toJson() => {
        "Large": large == null ? null : large.toJson(),
        "Medium": medium == null ? null : medium.toJson(),
        "Small": small == null ? null : small.toJson(),
      };
}

class Large {
  Large({
    this.height,
    this.url,
    this.width,
  });

  int height;
  String url;
  int width;

  factory Large.fromJson(Map<String, dynamic> json) => Large(
        height: json["Height"] == null ? null : json["Height"],
        url: json["URL"] == null ? null : json["URL"],
        width: json["Width"] == null ? null : json["Width"],
      );

  Map<String, dynamic> toJson() => {
        "Height": height == null ? null : height,
        "URL": url == null ? null : url,
        "Width": width == null ? null : width,
      };
}

class ItemInfo {
  ItemInfo({
    this.classifications,
    this.productInfo,
    this.title,
  });

  Classifications classifications;
  ProductInfo productInfo;
  Title title;

  factory ItemInfo.fromJson(Map<String, dynamic> json) => ItemInfo(
        classifications: json["Classifications"] == null
            ? null
            : Classifications.fromJson(json["Classifications"]),
        productInfo: json["ProductInfo"] == null
            ? null
            : ProductInfo.fromJson(json["ProductInfo"]),
        title: json["Title"] == null ? null : Title.fromJson(json["Title"]),
      );

  Map<String, dynamic> toJson() => {
        "Classifications":
            classifications == null ? null : classifications.toJson(),
        "ProductInfo": productInfo == null ? null : productInfo.toJson(),
        "Title": title == null ? null : title.toJson(),
      };
}

class Classifications {
  Classifications({
    this.binding,
    this.productGroup,
  });

  Title binding;
  Title productGroup;

  factory Classifications.fromJson(Map<String, dynamic> json) =>
      Classifications(
        binding:
            json["Binding"] == null ? null : Title.fromJson(json["Binding"]),
        productGroup: json["ProductGroup"] == null
            ? null
            : Title.fromJson(json["ProductGroup"]),
      );

  Map<String, dynamic> toJson() => {
        "Binding": binding == null ? null : binding.toJson(),
        "ProductGroup": productGroup == null ? null : productGroup.toJson(),
      };
}

class Title {
  Title({
    this.displayValue,
    this.label,
    this.locale,
  });

  String displayValue;
  TitleLabel label;
  Locale locale;

  factory Title.fromJson(Map<String, dynamic> json) => Title(
        displayValue:
            json["DisplayValue"] == null ? null : json["DisplayValue"],
        label:
            json["Label"] == null ? null : titleLabelValues.map[json["Label"]],
        locale:
            json["Locale"] == null ? null : localeValues.map[json["Locale"]],
      );

  Map<String, dynamic> toJson() => {
        "DisplayValue": displayValue == null ? null : displayValue,
        "Label": label == null ? null : titleLabelValues.reverse[label],
        "Locale": locale == null ? null : localeValues.reverse[locale],
      };
}

enum TitleLabel { BINDING, PRODUCT_GROUP, COLOR, RELEASE_DATE, SIZE, TITLE }

final titleLabelValues = EnumValues({
  "Binding": TitleLabel.BINDING,
  "Color": TitleLabel.COLOR,
  "ProductGroup": TitleLabel.PRODUCT_GROUP,
  "ReleaseDate": TitleLabel.RELEASE_DATE,
  "Size": TitleLabel.SIZE,
  "Title": TitleLabel.TITLE
});

enum Locale { EN_US }

final localeValues = EnumValues({"en_US": Locale.EN_US});

class ProductInfo {
  ProductInfo({
    this.color,
    this.itemDimensions,
    this.releaseDate,
    this.size,
    this.unitCount,
    this.isAdultProduct,
  });

  Title color;
  ItemDimensions itemDimensions;
  Title releaseDate;
  Title size;
  UnitCount unitCount;
  IsAdultProduct isAdultProduct;

  factory ProductInfo.fromJson(Map<String, dynamic> json) => ProductInfo(
        color: json["Color"] == null ? null : Title.fromJson(json["Color"]),
        itemDimensions: json["ItemDimensions"] == null
            ? null
            : ItemDimensions.fromJson(json["ItemDimensions"]),
        releaseDate: json["ReleaseDate"] == null
            ? null
            : Title.fromJson(json["ReleaseDate"]),
        size: json["Size"] == null ? null : Title.fromJson(json["Size"]),
        unitCount: json["UnitCount"] == null
            ? null
            : UnitCount.fromJson(json["UnitCount"]),
        isAdultProduct: json["IsAdultProduct"] == null
            ? null
            : IsAdultProduct.fromJson(json["IsAdultProduct"]),
      );

  Map<String, dynamic> toJson() => {
        "Color": color == null ? null : color.toJson(),
        "ItemDimensions":
            itemDimensions == null ? null : itemDimensions.toJson(),
        "ReleaseDate": releaseDate == null ? null : releaseDate.toJson(),
        "Size": size == null ? null : size.toJson(),
        "UnitCount": unitCount == null ? null : unitCount.toJson(),
        "IsAdultProduct":
            isAdultProduct == null ? null : isAdultProduct.toJson(),
      };
}

class IsAdultProduct {
  IsAdultProduct({
    this.displayValue,
    this.label,
    this.locale,
  });

  bool displayValue;
  String label;
  Locale locale;

  factory IsAdultProduct.fromJson(Map<String, dynamic> json) => IsAdultProduct(
        displayValue:
            json["DisplayValue"] == null ? null : json["DisplayValue"],
        label: json["Label"] == null ? null : json["Label"],
        locale:
            json["Locale"] == null ? null : localeValues.map[json["Locale"]],
      );

  Map<String, dynamic> toJson() => {
        "DisplayValue": displayValue == null ? null : displayValue,
        "Label": label == null ? null : label,
        "Locale": locale == null ? null : localeValues.reverse[locale],
      };
}

class ItemDimensions {
  ItemDimensions({
    this.height,
    this.length,
    this.width,
    this.weight,
  });

  UnitCount height;
  UnitCount length;
  UnitCount width;
  UnitCount weight;

  factory ItemDimensions.fromJson(Map<String, dynamic> json) => ItemDimensions(
        height:
            json["Height"] == null ? null : UnitCount.fromJson(json["Height"]),
        length:
            json["Length"] == null ? null : UnitCount.fromJson(json["Length"]),
        width: json["Width"] == null ? null : UnitCount.fromJson(json["Width"]),
        weight:
            json["Weight"] == null ? null : UnitCount.fromJson(json["Weight"]),
      );

  Map<String, dynamic> toJson() => {
        "Height": height == null ? null : height.toJson(),
        "Length": length == null ? null : length.toJson(),
        "Width": width == null ? null : width.toJson(),
        "Weight": weight == null ? null : weight.toJson(),
      };
}

class UnitCount {
  UnitCount({
    this.displayValue,
    this.label,
    this.locale,
    this.unit,
  });

  double displayValue;
  UnitCountLabel label;
  Locale locale;
  Unit unit;

  factory UnitCount.fromJson(Map<String, dynamic> json) => UnitCount(
        displayValue: json["DisplayValue"] == null
            ? null
            : json["DisplayValue"].toDouble(),
        label: json["Label"] == null
            ? null
            : unitCountLabelValues.map[json["Label"]],
        locale:
            json["Locale"] == null ? null : localeValues.map[json["Locale"]],
        unit: json["Unit"] == null ? null : unitValues.map[json["Unit"]],
      );

  Map<String, dynamic> toJson() => {
        "DisplayValue": displayValue == null ? null : displayValue,
        "Label": label == null ? null : unitCountLabelValues.reverse[label],
        "Locale": locale == null ? null : localeValues.reverse[locale],
        "Unit": unit == null ? null : unitValues.reverse[unit],
      };
}

enum UnitCountLabel { HEIGHT, LENGTH, WEIGHT, WIDTH, NUMBER_OF_ITEMS }

final unitCountLabelValues = EnumValues({
  "Height": UnitCountLabel.HEIGHT,
  "Length": UnitCountLabel.LENGTH,
  "NumberOfItems": UnitCountLabel.NUMBER_OF_ITEMS,
  "Weight": UnitCountLabel.WEIGHT,
  "Width": UnitCountLabel.WIDTH
});

enum Unit { INCHES, POUNDS }

final unitValues = EnumValues({"Inches": Unit.INCHES, "Pounds": Unit.POUNDS});

class Offers {
  Offers({
    this.listings,
  });

  List<Listing> listings;

  factory Offers.fromJson(Map<String, dynamic> json) => Offers(
        listings: json["Listings"] == null
            ? null
            : List<Listing>.from(
                json["Listings"].map((x) => Listing.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Listings": listings == null
            ? null
            : List<dynamic>.from(listings.map((x) => x.toJson())),
      };
}

class Listing {
  Listing({
    this.condition,
    this.deliveryInfo,
    this.id,
    this.price,
    this.violatesMap,
  });

  Condition condition;
  DeliveryInfo deliveryInfo;
  String id;
  Price price;
  bool violatesMap;

  factory Listing.fromJson(Map<String, dynamic> json) => Listing(
        condition: json["Condition"] == null
            ? null
            : Condition.fromJson(json["Condition"]),
        deliveryInfo: json["DeliveryInfo"] == null
            ? null
            : DeliveryInfo.fromJson(json["DeliveryInfo"]),
        id: json["Id"] == null ? null : json["Id"],
        price: json["Price"] == null ? null : Price.fromJson(json["Price"]),
        violatesMap: json["ViolatesMAP"] == null ? null : json["ViolatesMAP"],
      );

  Map<String, dynamic> toJson() => {
        "Condition": condition == null ? null : condition.toJson(),
        "DeliveryInfo": deliveryInfo == null ? null : deliveryInfo.toJson(),
        "Id": id == null ? null : id,
        "Price": price == null ? null : price.toJson(),
        "ViolatesMAP": violatesMap == null ? null : violatesMap,
      };
}

class Condition {
  Condition({
    this.value,
  });

  Value value;

  factory Condition.fromJson(Map<String, dynamic> json) => Condition(
        value: json["Value"] == null ? null : valueValues.map[json["Value"]],
      );

  Map<String, dynamic> toJson() => {
        "Value": value == null ? null : valueValues.reverse[value],
      };
}

enum Value { NEW }

final valueValues = EnumValues({"New": Value.NEW});

class DeliveryInfo {
  DeliveryInfo({
    this.isFreeShippingEligible,
  });

  bool isFreeShippingEligible;

  factory DeliveryInfo.fromJson(Map<String, dynamic> json) => DeliveryInfo(
        isFreeShippingEligible: json["IsFreeShippingEligible"] == null
            ? null
            : json["IsFreeShippingEligible"],
      );

  Map<String, dynamic> toJson() => {
        "IsFreeShippingEligible":
            isFreeShippingEligible == null ? null : isFreeShippingEligible,
      };
}

class Price {
  Price({
    this.amount,
    this.currency,
    this.displayAmount,
    this.savings,
    this.percentage,
  });

  double amount;
  Currency currency;
  String displayAmount;
  Price savings;
  int percentage;

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        amount: json["Amount"] == null ? null : json["Amount"].toDouble(),
        currency: json["Currency"] == null
            ? null
            : currencyValues.map[json["Currency"]],
        displayAmount:
            json["DisplayAmount"] == null ? null : json["DisplayAmount"],
        savings:
            json["Savings"] == null ? null : Price.fromJson(json["Savings"]),
        percentage: json["Percentage"] == null ? null : json["Percentage"],
      );

  Map<String, dynamic> toJson() => {
        "Amount": amount == null ? null : amount,
        "Currency": currency == null ? null : currencyValues.reverse[currency],
        "DisplayAmount": displayAmount == null ? null : displayAmount,
        "Savings": savings == null ? null : savings.toJson(),
        "Percentage": percentage == null ? null : percentage,
      };
}

enum Currency { USD }

final currencyValues = EnumValues({"USD": Currency.USD});

class SearchRefinements {
  SearchRefinements({
    this.browseNode,
    this.otherRefinements,
  });

  OtherRefinementClass browseNode;
  List<OtherRefinementClass> otherRefinements;

  factory SearchRefinements.fromJson(Map<String, dynamic> json) =>
      SearchRefinements(
        browseNode: json["BrowseNode"] == null
            ? null
            : OtherRefinementClass.fromJson(json["BrowseNode"]),
        otherRefinements: json["OtherRefinements"] == null
            ? null
            : List<OtherRefinementClass>.from(json["OtherRefinements"]
                .map((x) => OtherRefinementClass.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "BrowseNode": browseNode == null ? null : browseNode.toJson(),
        "OtherRefinements": otherRefinements == null
            ? null
            : List<dynamic>.from(otherRefinements.map((x) => x.toJson())),
      };
}

class OtherRefinementClass {
  OtherRefinementClass({
    this.bins,
    this.displayName,
    this.id,
  });

  List<Bin> bins;
  String displayName;
  String id;

  factory OtherRefinementClass.fromJson(Map<String, dynamic> json) =>
      OtherRefinementClass(
        bins: json["Bins"] == null
            ? null
            : List<Bin>.from(json["Bins"].map((x) => Bin.fromJson(x))),
        displayName: json["DisplayName"] == null ? null : json["DisplayName"],
        id: json["Id"] == null ? null : json["Id"],
      );

  Map<String, dynamic> toJson() => {
        "Bins": bins == null
            ? null
            : List<dynamic>.from(bins.map((x) => x.toJson())),
        "DisplayName": displayName == null ? null : displayName,
        "Id": id == null ? null : id,
      };
}

class Bin {
  Bin({
    this.displayName,
    this.id,
  });

  String displayName;
  String id;

  factory Bin.fromJson(Map<String, dynamic> json) => Bin(
        displayName: json["DisplayName"] == null ? null : json["DisplayName"],
        id: json["Id"] == null ? null : json["Id"],
      );

  Map<String, dynamic> toJson() => {
        "DisplayName": displayName == null ? null : displayName,
        "Id": id == null ? null : id,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
