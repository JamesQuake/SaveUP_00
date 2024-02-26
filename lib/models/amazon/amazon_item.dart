// To parse this JSON data, do
//
//     final amazonItem = amazonItemFromJson(jsonString);

import 'dart:convert';

AmazonItem amazonItemFromJson(String str) =>
    AmazonItem.fromJson(json.decode(str));

String amazonItemToJson(AmazonItem data) => json.encode(data.toJson());

class AmazonItem {
  AmazonItem({
    this.itemsResult,
  });

  ItemsResult itemsResult;

  factory AmazonItem.fromJson(Map<String, dynamic> json) => AmazonItem(
        itemsResult: json["ItemsResult"] == null
            ? null
            : ItemsResult.fromJson(json["ItemsResult"]),
      );

  Map<String, dynamic> toJson() => {
        "ItemsResult": itemsResult == null ? null : itemsResult.toJson(),
      };
}

class ItemsResult {
  ItemsResult({
    this.items,
  });

  List<Item> items;

  factory ItemsResult.fromJson(Map<String, dynamic> json) => ItemsResult(
        items: json["Items"] == null
            ? null
            : List<Item>.from(json["Items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Items": items == null
            ? null
            : List<dynamic>.from(items.map((x) => x.toJson())),
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
  });

  Large large;
  Large medium;

  factory Primary.fromJson(Map<String, dynamic> json) => Primary(
        large: json["Large"] == null ? null : Large.fromJson(json["Large"]),
        medium: json["Medium"] == null ? null : Large.fromJson(json["Medium"]),
      );

  Map<String, dynamic> toJson() => {
        "Large": large == null ? null : large.toJson(),
        "Medium": medium == null ? null : medium.toJson(),
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
    this.byLineInfo,
    this.classifications,
    this.contentInfo,
    this.externalIds,
    this.features,
    this.manufactureInfo,
    this.productInfo,
    this.title,
  });

  ByLineInfo byLineInfo;
  Classifications classifications;
  ContentInfo contentInfo;
  ExternalIds externalIds;
  Features features;
  ManufactureInfo manufactureInfo;
  ProductInfo productInfo;
  Title title;

  factory ItemInfo.fromJson(Map<String, dynamic> json) => ItemInfo(
        byLineInfo: json["ByLineInfo"] == null
            ? null
            : ByLineInfo.fromJson(json["ByLineInfo"]),
        classifications: json["Classifications"] == null
            ? null
            : Classifications.fromJson(json["Classifications"]),
        contentInfo: json["ContentInfo"] == null
            ? null
            : ContentInfo.fromJson(json["ContentInfo"]),
        externalIds: json["ExternalIds"] == null
            ? null
            : ExternalIds.fromJson(json["ExternalIds"]),
        features: json["Features"] == null
            ? null
            : Features.fromJson(json["Features"]),
        manufactureInfo: json["ManufactureInfo"] == null
            ? null
            : ManufactureInfo.fromJson(json["ManufactureInfo"]),
        productInfo: json["ProductInfo"] == null
            ? null
            : ProductInfo.fromJson(json["ProductInfo"]),
        title: json["Title"] == null ? null : Title.fromJson(json["Title"]),
      );

  Map<String, dynamic> toJson() => {
        "ByLineInfo": byLineInfo == null ? null : byLineInfo.toJson(),
        "Classifications":
            classifications == null ? null : classifications.toJson(),
        "ContentInfo": contentInfo == null ? null : contentInfo.toJson(),
        "ExternalIds": externalIds == null ? null : externalIds.toJson(),
        "Features": features == null ? null : features.toJson(),
        "ManufactureInfo":
            manufactureInfo == null ? null : manufactureInfo.toJson(),
        "ProductInfo": productInfo == null ? null : productInfo.toJson(),
        "Title": title == null ? null : title.toJson(),
      };
}

class ByLineInfo {
  ByLineInfo({
    this.brand,
    this.contributors,
    this.manufacturer,
  });

  Title brand;
  List<Contributor> contributors;
  Title manufacturer;

  factory ByLineInfo.fromJson(Map<String, dynamic> json) => ByLineInfo(
        brand: json["Brand"] == null ? null : Title.fromJson(json["Brand"]),
        contributors: json["Contributors"] == null
            ? null
            : List<Contributor>.from(
                json["Contributors"].map((x) => Contributor.fromJson(x))),
        manufacturer: json["Manufacturer"] == null
            ? null
            : Title.fromJson(json["Manufacturer"]),
      );

  Map<String, dynamic> toJson() => {
        "Brand": brand == null ? null : brand.toJson(),
        "Contributors": contributors == null
            ? null
            : List<dynamic>.from(contributors.map((x) => x.toJson())),
        "Manufacturer": manufacturer == null ? null : manufacturer.toJson(),
      };
}

class Title {
  Title({
    this.displayValue,
    this.label,
    this.locale,
  });

  String displayValue;
  String label;
  String locale;

  factory Title.fromJson(Map<String, dynamic> json) => Title(
        displayValue:
            json["DisplayValue"] == null ? null : json["DisplayValue"],
        label: json["Label"] == null ? null : json["Label"],
        locale: json["Locale"] == null ? null : json["Locale"],
      );

  Map<String, dynamic> toJson() => {
        "DisplayValue": displayValue == null ? null : displayValue,
        "Label": label == null ? null : label,
        "Locale": locale == null ? null : locale,
      };
}

class Contributor {
  Contributor({
    this.locale,
    this.name,
    this.role,
    this.roleType,
  });

  String locale;
  String name;
  String role;
  String roleType;

  factory Contributor.fromJson(Map<String, dynamic> json) => Contributor(
        locale: json["Locale"] == null ? null : json["Locale"],
        name: json["Name"] == null ? null : json["Name"],
        role: json["Role"] == null ? null : json["Role"],
        roleType: json["RoleType"] == null ? null : json["RoleType"],
      );

  Map<String, dynamic> toJson() => {
        "Locale": locale == null ? null : locale,
        "Name": name == null ? null : name,
        "Role": role == null ? null : role,
        "RoleType": roleType == null ? null : roleType,
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

class ContentInfo {
  ContentInfo({
    this.languages,
  });

  Languages languages;

  factory ContentInfo.fromJson(Map<String, dynamic> json) => ContentInfo(
        languages: json["Languages"] == null
            ? null
            : Languages.fromJson(json["Languages"]),
      );

  Map<String, dynamic> toJson() => {
        "Languages": languages == null ? null : languages.toJson(),
      };
}

class Languages {
  Languages({
    this.displayValues,
    this.label,
    this.locale,
  });

  List<DisplayValue> displayValues;
  String label;
  String locale;

  factory Languages.fromJson(Map<String, dynamic> json) => Languages(
        displayValues: json["DisplayValues"] == null
            ? null
            : List<DisplayValue>.from(
                json["DisplayValues"].map((x) => DisplayValue.fromJson(x))),
        label: json["Label"] == null ? null : json["Label"],
        locale: json["Locale"] == null ? null : json["Locale"],
      );

  Map<String, dynamic> toJson() => {
        "DisplayValues": displayValues == null
            ? null
            : List<dynamic>.from(displayValues.map((x) => x.toJson())),
        "Label": label == null ? null : label,
        "Locale": locale == null ? null : locale,
      };
}

class DisplayValue {
  DisplayValue({
    this.displayValue,
    this.type,
  });

  String displayValue;
  String type;

  factory DisplayValue.fromJson(Map<String, dynamic> json) => DisplayValue(
        displayValue:
            json["DisplayValue"] == null ? null : json["DisplayValue"],
        type: json["Type"] == null ? null : json["Type"],
      );

  Map<String, dynamic> toJson() => {
        "DisplayValue": displayValue == null ? null : displayValue,
        "Type": type == null ? null : type,
      };
}

class ExternalIds {
  ExternalIds({
    this.eaNs,
    this.upCs,
  });

  EaNs eaNs;
  UpCs upCs;

  factory ExternalIds.fromJson(Map<String, dynamic> json) => ExternalIds(
        eaNs: json["EANs"] == null ? null : EaNs.fromJson(json["EANs"]),
        upCs: json["UPCs"] == null ? null : UpCs.fromJson(json["UPCs"]),
      );

  Map<String, dynamic> toJson() => {
        "EANs": eaNs == null ? null : eaNs.toJson(),
        "UPCs": upCs == null ? null : upCs.toJson(),
      };
}

class EaNs {
  EaNs({
    this.displayValues,
    this.label,
    this.locale,
  });

  List<String> displayValues;
  String label;
  String locale;

  factory EaNs.fromJson(Map<String, dynamic> json) => EaNs(
        displayValues: json["DisplayValues"] == null
            ? null
            : List<String>.from(json["DisplayValues"].map((x) => x)),
        label: json["Label"] == null ? null : json["Label"],
        locale: json["Locale"] == null ? null : json["Locale"],
      );

  Map<String, dynamic> toJson() => {
        "DisplayValues": displayValues == null
            ? null
            : List<dynamic>.from(displayValues.map((x) => x)),
        "Label": label == null ? null : label,
      };
}

class UpCs {
  UpCs({
    this.displayValues,
    this.label,
    this.locale,
  });

  List<String> displayValues;
  String label;
  String locale;

  factory UpCs.fromJson(Map<String, dynamic> json) => UpCs(
        displayValues: json["DisplayValues"] == null
            ? null
            : List<String>.from(json["DisplayValues"].map((x) => x)),
        label: json["Label"] == null ? null : json["Label"],
        locale: json["Locale"] == null ? null : json["Locale"],
      );

  Map<String, dynamic> toJson() => {
        "DisplayValues": displayValues == null
            ? null
            : List<dynamic>.from(displayValues.map((x) => x)),
        "Label": label == null ? null : label,
        "Locale": locale == null ? null : locale,
      };
}

class Features {
  Features({
    this.displayValues,
    this.label,
    this.locale,
  });

  List<String> displayValues;
  String label;
  String locale;

  factory Features.fromJson(Map<String, dynamic> json) => Features(
        displayValues: json["DisplayValues"] == null
            ? null
            : List<String>.from(json["DisplayValues"].map((x) => x)),
        label: json["Label"] == null ? null : json["Label"],
        locale: json["Locale"] == null ? null : json["Locale"],
      );

  Map<String, dynamic> toJson() => {
        "DisplayValues": displayValues == null
            ? null
            : List<dynamic>.from(displayValues.map((x) => x)),
        "Label": label == null ? null : label,
        "Locale": locale == null ? null : locale,
      };
}

class ManufactureInfo {
  ManufactureInfo({
    this.itemPartNumber,
    this.model,
  });

  Title itemPartNumber;
  Title model;

  factory ManufactureInfo.fromJson(Map<String, dynamic> json) =>
      ManufactureInfo(
        itemPartNumber: json["ItemPartNumber"] == null
            ? null
            : Title.fromJson(json["ItemPartNumber"]),
        model: json["Model"] == null ? null : Title.fromJson(json["Model"]),
      );

  Map<String, dynamic> toJson() => {
        "ItemPartNumber":
            itemPartNumber == null ? null : itemPartNumber.toJson(),
        "Model": model == null ? null : model.toJson(),
      };
}

class ProductInfo {
  ProductInfo({
    this.color,
    this.isAdultProduct,
    this.itemDimensions,
    this.size,
    this.unitCount,
  });

  Title color;
  IsAdultProduct isAdultProduct;
  ItemDimensions itemDimensions;
  Title size;
  UnitCount unitCount;

  factory ProductInfo.fromJson(Map<String, dynamic> json) => ProductInfo(
        color: json["Color"] == null ? null : Title.fromJson(json["Color"]),
        isAdultProduct: json["IsAdultProduct"] == null
            ? null
            : IsAdultProduct.fromJson(json["IsAdultProduct"]),
        itemDimensions: json["ItemDimensions"] == null
            ? null
            : ItemDimensions.fromJson(json["ItemDimensions"]),
        size: json["Size"] == null ? null : Title.fromJson(json["Size"]),
        unitCount: json["UnitCount"] == null
            ? null
            : UnitCount.fromJson(json["UnitCount"]),
      );

  Map<String, dynamic> toJson() => {
        "Color": color == null ? null : color.toJson(),
        "IsAdultProduct":
            isAdultProduct == null ? null : isAdultProduct.toJson(),
        "ItemDimensions":
            itemDimensions == null ? null : itemDimensions.toJson(),
        "Size": size == null ? null : size.toJson(),
        "UnitCount": unitCount == null ? null : unitCount.toJson(),
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
  String locale;

  factory IsAdultProduct.fromJson(Map<String, dynamic> json) => IsAdultProduct(
        displayValue:
            json["DisplayValue"] == null ? null : json["DisplayValue"],
        label: json["Label"] == null ? null : json["Label"],
        locale: json["Locale"] == null ? null : json["Locale"],
      );

  Map<String, dynamic> toJson() => {
        "DisplayValue": displayValue == null ? null : displayValue,
        "Label": label == null ? null : label,
        "Locale": locale == null ? null : locale,
      };
}

class ItemDimensions {
  ItemDimensions({
    this.height,
    this.length,
    this.weight,
    this.width,
  });

  UnitCount height;
  UnitCount length;
  UnitCount weight;
  UnitCount width;

  factory ItemDimensions.fromJson(Map<String, dynamic> json) => ItemDimensions(
        height:
            json["Height"] == null ? null : UnitCount.fromJson(json["Height"]),
        length:
            json["Length"] == null ? null : UnitCount.fromJson(json["Length"]),
        weight:
            json["Weight"] == null ? null : UnitCount.fromJson(json["Weight"]),
        width: json["Width"] == null ? null : UnitCount.fromJson(json["Width"]),
      );

  Map<String, dynamic> toJson() => {
        "Height": height == null ? null : height.toJson(),
        "Length": length == null ? null : length.toJson(),
        "Weight": weight == null ? null : weight.toJson(),
        "Width": width == null ? null : width.toJson(),
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
  String label;
  String locale;
  String unit;

  factory UnitCount.fromJson(Map<String, dynamic> json) => UnitCount(
        displayValue: json["DisplayValue"] == null
            ? null
            : json["DisplayValue"].toDouble(),
        label: json["Label"] == null ? null : json["Label"],
        locale: json["Locale"] == null ? null : json["Locale"],
        unit: json["Unit"] == null ? null : json["Unit"],
      );

  Map<String, dynamic> toJson() => {
        "DisplayValue": displayValue == null ? null : displayValue,
        "Label": label == null ? null : label,
        "Locale": locale == null ? null : locale,
        "Unit": unit == null ? null : unit,
      };
}

class Offers {
  Offers({
    this.listings,
    this.summaries,
  });

  List<Listing> listings;
  List<Summary> summaries;

  factory Offers.fromJson(Map<String, dynamic> json) => Offers(
        listings: json["Listings"] == null
            ? null
            : List<Listing>.from(
                json["Listings"].map((x) => Listing.fromJson(x))),
        summaries: json["Summaries"] == null
            ? null
            : List<Summary>.from(
                json["Summaries"].map((x) => Summary.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Listings": listings == null
            ? null
            : List<dynamic>.from(listings.map((x) => x.toJson())),
        "Summaries": summaries == null
            ? null
            : List<dynamic>.from(summaries.map((x) => x.toJson())),
      };
}

class Listing {
  Listing({
    this.availability,
    this.condition,
    this.deliveryInfo,
    this.id,
    this.isBuyBoxWinner,
    this.merchantInfo,
    this.price,
    this.savingBasis,
    this.violatesMap,
  });

  Availability availability;
  Condition condition;
  DeliveryInfo deliveryInfo;
  String id;
  bool isBuyBoxWinner;
  MerchantInfo merchantInfo;
  Price price;
  Price savingBasis;
  bool violatesMap;

  factory Listing.fromJson(Map<String, dynamic> json) => Listing(
        availability: json["Availability"] == null
            ? null
            : Availability.fromJson(json["Availability"]),
        condition: json["Condition"] == null
            ? null
            : Condition.fromJson(json["Condition"]),
        deliveryInfo: json["DeliveryInfo"] == null
            ? null
            : DeliveryInfo.fromJson(json["DeliveryInfo"]),
        id: json["Id"] == null ? null : json["Id"],
        isBuyBoxWinner:
            json["IsBuyBoxWinner"] == null ? null : json["IsBuyBoxWinner"],
        merchantInfo: json["MerchantInfo"] == null
            ? null
            : MerchantInfo.fromJson(json["MerchantInfo"]),
        price: json["Price"] == null ? null : Price.fromJson(json["Price"]),
        savingBasis: json["SavingBasis"] == null
            ? null
            : Price.fromJson(json["SavingBasis"]),
        violatesMap: json["ViolatesMAP"] == null ? null : json["ViolatesMAP"],
      );

  Map<String, dynamic> toJson() => {
        "Availability": availability == null ? null : availability.toJson(),
        "Condition": condition == null ? null : condition.toJson(),
        "DeliveryInfo": deliveryInfo == null ? null : deliveryInfo.toJson(),
        "Id": id == null ? null : id,
        "IsBuyBoxWinner": isBuyBoxWinner == null ? null : isBuyBoxWinner,
        "MerchantInfo": merchantInfo == null ? null : merchantInfo.toJson(),
        "Price": price == null ? null : price.toJson(),
        "SavingBasis": savingBasis == null ? null : savingBasis.toJson(),
        "ViolatesMAP": violatesMap == null ? null : violatesMap,
      };
}

class Availability {
  Availability({
    this.message,
    this.minOrderQuantity,
    this.type,
  });

  String message;
  int minOrderQuantity;
  String type;

  factory Availability.fromJson(Map<String, dynamic> json) => Availability(
        message: json["Message"] == null ? null : json["Message"],
        minOrderQuantity:
            json["MinOrderQuantity"] == null ? null : json["MinOrderQuantity"],
        type: json["Type"] == null ? null : json["Type"],
      );

  Map<String, dynamic> toJson() => {
        "Message": message == null ? null : message,
        "MinOrderQuantity": minOrderQuantity == null ? null : minOrderQuantity,
        "Type": type == null ? null : type,
      };
}

class Condition {
  Condition({
    this.subCondition,
    this.value,
  });

  SubConditionClass subCondition;
  String value;

  factory Condition.fromJson(Map<String, dynamic> json) => Condition(
        subCondition: json["SubCondition"] == null
            ? null
            : SubConditionClass.fromJson(json["SubCondition"]),
        value: json["Value"] == null ? null : json["Value"],
      );

  Map<String, dynamic> toJson() => {
        "SubCondition": subCondition == null ? null : subCondition.toJson(),
        "Value": value == null ? null : value,
      };
}

class SubConditionClass {
  SubConditionClass({
    this.value,
  });

  String value;

  factory SubConditionClass.fromJson(Map<String, dynamic> json) =>
      SubConditionClass(
        value: json["Value"] == null ? null : json["Value"],
      );

  Map<String, dynamic> toJson() => {
        "Value": value == null ? null : value,
      };
}

class DeliveryInfo {
  DeliveryInfo({
    this.isAmazonFulfilled,
    this.isFreeShippingEligible,
    this.isPrimeEligible,
  });

  bool isAmazonFulfilled;
  bool isFreeShippingEligible;
  bool isPrimeEligible;

  factory DeliveryInfo.fromJson(Map<String, dynamic> json) => DeliveryInfo(
        isAmazonFulfilled: json["IsAmazonFulfilled"] == null
            ? null
            : json["IsAmazonFulfilled"],
        isFreeShippingEligible: json["IsFreeShippingEligible"] == null
            ? null
            : json["IsFreeShippingEligible"],
        isPrimeEligible:
            json["IsPrimeEligible"] == null ? null : json["IsPrimeEligible"],
      );

  Map<String, dynamic> toJson() => {
        "IsAmazonFulfilled":
            isAmazonFulfilled == null ? null : isAmazonFulfilled,
        "IsFreeShippingEligible":
            isFreeShippingEligible == null ? null : isFreeShippingEligible,
        "IsPrimeEligible": isPrimeEligible == null ? null : isPrimeEligible,
      };
}

class MerchantInfo {
  MerchantInfo({
    this.defaultShippingCountry,
    this.feedbackCount,
    this.feedbackRating,
    this.id,
    this.name,
  });

  String defaultShippingCountry;
  int feedbackCount;
  double feedbackRating;
  String id;
  String name;

  factory MerchantInfo.fromJson(Map<String, dynamic> json) => MerchantInfo(
        defaultShippingCountry: json["DefaultShippingCountry"] == null
            ? null
            : json["DefaultShippingCountry"],
        feedbackCount:
            json["FeedbackCount"] == null ? null : json["FeedbackCount"],
        feedbackRating: json["FeedbackRating"] == null
            ? null
            : json["FeedbackRating"].toDouble(),
        id: json["Id"] == null ? null : json["Id"],
        name: json["Name"] == null ? null : json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "DefaultShippingCountry":
            defaultShippingCountry == null ? null : defaultShippingCountry,
        "FeedbackCount": feedbackCount == null ? null : feedbackCount,
        "FeedbackRating": feedbackRating == null ? null : feedbackRating,
        "Id": id == null ? null : id,
        "Name": name == null ? null : name,
      };
}

class Price {
  Price({
    this.amount,
    this.currency,
    this.displayAmount,
    this.savings,
    this.percentage,
    this.priceType,
  });

  double amount;
  String currency;
  String displayAmount;
  Price savings;
  int percentage;
  String priceType;

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        amount: json["Amount"] == null ? null : json["Amount"].toDouble(),
        currency: json["Currency"] == null ? null : json["Currency"],
        displayAmount:
            json["DisplayAmount"] == null ? null : json["DisplayAmount"],
        savings:
            json["Savings"] == null ? null : Price.fromJson(json["Savings"]),
        percentage: json["Percentage"] == null ? null : json["Percentage"],
        priceType: json["PriceType"] == null ? null : json["PriceType"],
      );

  Map<String, dynamic> toJson() => {
        "Amount": amount == null ? null : amount,
        "Currency": currency == null ? null : currency,
        "DisplayAmount": displayAmount == null ? null : displayAmount,
        "Savings": savings == null ? null : savings.toJson(),
        "Percentage": percentage == null ? null : percentage,
        "PriceType": priceType == null ? null : priceType,
      };
}

class Summary {
  Summary({
    this.condition,
    this.highestPrice,
    this.lowestPrice,
    this.offerCount,
  });

  SubConditionClass condition;
  Price highestPrice;
  Price lowestPrice;
  int offerCount;

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        condition: json["Condition"] == null
            ? null
            : SubConditionClass.fromJson(json["Condition"]),
        highestPrice: json["HighestPrice"] == null
            ? null
            : Price.fromJson(json["HighestPrice"]),
        lowestPrice: json["LowestPrice"] == null
            ? null
            : Price.fromJson(json["LowestPrice"]),
        offerCount: json["OfferCount"] == null ? null : json["OfferCount"],
      );

  Map<String, dynamic> toJson() => {
        "Condition": condition == null ? null : condition.toJson(),
        "HighestPrice": highestPrice == null ? null : highestPrice.toJson(),
        "LowestPrice": lowestPrice == null ? null : lowestPrice.toJson(),
        "OfferCount": offerCount == null ? null : offerCount,
      };
}
