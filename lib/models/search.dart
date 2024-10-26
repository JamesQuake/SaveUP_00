import 'dart:convert';

Result resultFromJson(String str) => Result.fromJson(json.decode(str));

String resultToJson(Result data) => json.encode(data.toJson());

class Result {
  Result({
    this.href,
    this.total,
    this.next,
    this.prev,
    this.limit,
    this.offset,
    this.itemSummaries,
  });

  String href;
  int total;
  String next;
  String prev;
  int limit;
  int offset;
  List<ItemSummary> itemSummaries;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    href: json["href"] == null ? null : json["href"],
    total: json["total"] == null ? null : json["total"],
    next: json["next"] == null ? null : json["next"],
    prev: json["prev"] == null ? null : json["prev"],
    limit: json["limit"] == null ? null : json["limit"],
    offset: json["offset"] == null ? null : json["offset"],
    itemSummaries: json["itemSummaries"] == null ? null : List<ItemSummary>.from(json["itemSummaries"].map((x) => ItemSummary.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "href": href == null ? null : href,
    "total": total == null ? null : total,
    "next": next == null ? null : next,
    "prev": prev == null ? null : prev,
    "limit": limit == null ? null : limit,
    "offset": offset == null ? null : offset,
    "itemSummaries": itemSummaries == null ? null : List<dynamic>.from(itemSummaries.map((x) => x.toJson())),
  };
}

class ItemSummary {
  ItemSummary({
    this.itemId,
    this.title,
    this.image,
    this.price,
    this.itemHref,
    this.seller,
    this.marketingPrice,
    this.condition,
    this.conditionId,
    this.thumbnailImages,
    this.shippingOptions,
    this.buyingOptions,
    this.epid,
    this.itemAffiliateWebUrl,
    this.itemWebUrl,
    this.itemLocation,
    this.categories,
    this.adultOnly,
    this.legacyItemId,
    this.availableCoupons,
    this.additionalImages,
    this.bidCount,
    this.currentBidPrice,
  });

  String itemId;
  String title;
  Imaged image;
  CurrentBidPrice price;
  String itemHref;
  Seller seller;
  MarketingPrice marketingPrice;
  Condition condition;
  String conditionId;
  List<Imaged> thumbnailImages;
  List<ShippingOption> shippingOptions;
  List<BuyingOption> buyingOptions;
  String epid;
  String itemAffiliateWebUrl;
  String itemWebUrl;
  ItemLocation itemLocation;
  List<Category> categories;
  bool adultOnly;
  String legacyItemId;
  bool availableCoupons;
  List<Imaged> additionalImages;
  int bidCount;
  CurrentBidPrice currentBidPrice;

  factory ItemSummary.fromJson(Map<String, dynamic> json) => ItemSummary(
    itemId: json["itemId"] == null ? null : json["itemId"],
    title: json["title"] == null ? null : json["title"],
    image: json["image"] == null ? null : Imaged.fromJson(json["image"]),
    price: json["price"] == null ? null : CurrentBidPrice.fromJson(json["price"]),
    itemHref: json["itemHref"] == null ? null : json["itemHref"],
    seller: json["seller"] == null ? null : Seller.fromJson(json["seller"]),
    marketingPrice: json["marketingPrice"] == null ? null : MarketingPrice.fromJson(json["marketingPrice"]),
    condition: json["condition"] == null ? null : conditionValues.map[json["condition"]],
    conditionId: json["conditionId"] == null ? null : json["conditionId"],
    thumbnailImages: json["thumbnailImages"] == null ? null : List<Imaged>.from(json["thumbnailImages"].map((x) => Imaged.fromJson(x))),
    shippingOptions: json["shippingOptions"] == null ? null : List<ShippingOption>.from(json["shippingOptions"].map((x) => ShippingOption.fromJson(x))),
    buyingOptions: json["buyingOptions"] == null ? null : List<BuyingOption>.from(json["buyingOptions"].map((x) => buyingOptionValues.map[x])),
    epid: json["epid"] == null ? null : json["epid"],
    itemAffiliateWebUrl: json["itemAffiliateWebUrl"] == null ? null : json["itemAffiliateWebUrl"],
    itemWebUrl: json["itemWebUrl"] == null ? null : json["itemWebUrl"],
    itemLocation: json["itemLocation"] == null ? null : ItemLocation.fromJson(json["itemLocation"]),
    categories: json["categories"] == null ? null : List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
    adultOnly: json["adultOnly"] == null ? null : json["adultOnly"],
    legacyItemId: json["legacyItemId"] == null ? null : json["legacyItemId"],
    availableCoupons: json["availableCoupons"] == null ? null : json["availableCoupons"],
    additionalImages: json["additionalImages"] == null ? null : List<Imaged>.from(json["additionalImages"].map((x) => Imaged.fromJson(x))),
    bidCount: json["bidCount"] == null ? null : json["bidCount"],
    currentBidPrice: json["currentBidPrice"] == null ? null : CurrentBidPrice.fromJson(json["currentBidPrice"]),
  );

  Map<String, dynamic> toJson() => {
    "itemId": itemId == null ? null : itemId,
    "title": title == null ? null : title,
    "image": image == null ? null : image.toJson(),
    "price": price == null ? null : price.toJson(),
    "itemHref": itemHref == null ? null : itemHref,
    "seller": seller == null ? null : seller.toJson(),
    "marketingPrice": marketingPrice == null ? null : marketingPrice.toJson(),
    "condition": condition == null ? null : conditionValues.reverse[condition],
    "conditionId": conditionId == null ? null : conditionId,
    "thumbnailImages": thumbnailImages == null ? null : List<dynamic>.from(thumbnailImages.map((x) => x.toJson())),
    "shippingOptions": shippingOptions == null ? null : List<dynamic>.from(shippingOptions.map((x) => x.toJson())),
    "buyingOptions": buyingOptions == null ? null : List<dynamic>.from(buyingOptions.map((x) => buyingOptionValues.reverse[x])),
    "epid": epid == null ? null : epid,
    "itemAffiliateWebUrl": itemAffiliateWebUrl == null ? null : itemAffiliateWebUrl,
    "itemWebUrl": itemWebUrl == null ? null : itemWebUrl,
    "itemLocation": itemLocation == null ? null : itemLocation.toJson(),
    "categories": categories == null ? null : List<dynamic>.from(categories.map((x) => x.toJson())),
    "adultOnly": adultOnly == null ? null : adultOnly,
    "legacyItemId": legacyItemId == null ? null : legacyItemId,
    "availableCoupons": availableCoupons == null ? null : availableCoupons,
    "additionalImages": additionalImages == null ? null : List<dynamic>.from(additionalImages.map((x) => x.toJson())),
    "bidCount": bidCount == null ? null : bidCount,
    "currentBidPrice": currentBidPrice == null ? null : currentBidPrice.toJson(),
  };
}

class Imaged {
  Imaged({
    this.imageUrl,
  });

  String imageUrl;

  factory Imaged.fromJson(Map<String, dynamic> json) => Imaged(
    imageUrl: json["imageUrl"] == null ? null : json["imageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "imageUrl": imageUrl == null ? null : imageUrl,
  };
}

enum BuyingOption { FIXED_PRICE, BEST_OFFER, AUCTION }

final buyingOptionValues = EnumValues({
  "AUCTION": BuyingOption.AUCTION,
  "BEST_OFFER": BuyingOption.BEST_OFFER,
  "FIXED_PRICE": BuyingOption.FIXED_PRICE
});

class Category {
  Category({
    this.categoryId,
  });

  String categoryId;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    categoryId: json["categoryId"] == null ? null : json["categoryId"],
  );

  Map<String, dynamic> toJson() => {
    "categoryId": categoryId == null ? null : categoryId,
  };
}

enum Condition { NEW, GOOD }

final conditionValues = EnumValues({
  "Good": Condition.GOOD,
  "New": Condition.NEW
});

class CurrentBidPrice {
  CurrentBidPrice({
    this.value,
    this.currency,
  });

  String value;
  String currency;

  factory CurrentBidPrice.fromJson(Map<String, dynamic> json) => CurrentBidPrice(
    value: json["value"] == null ? null : json["value"],
    currency: json["currency"] == null ? null : json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "value": value == null ? null : value,
    "currency": currency == null ? null : currencyValues.reverse[currency],
  };
}

enum Currency { USD }

final currencyValues = EnumValues({
  "USD": Currency.USD
});

class ItemLocation {
  ItemLocation({
    this.postalCode,
    this.country,
  });

  String postalCode;
  String country;

  factory ItemLocation.fromJson(Map<String, dynamic> json) => ItemLocation(
    postalCode: json["postalCode"] == null ? null : json["postalCode"],
    country: json["country"] == null ? null : json["country"],
  );

  Map<String, dynamic> toJson() => {
    "postalCode": postalCode == null ? null : postalCode,
    "country": country == null ? null : countryValues.reverse[country],
  };
}

enum Country { US }

final countryValues = EnumValues({
  "US": Country.US
});

class MarketingPrice {
  MarketingPrice({
    this.originalPrice,
    this.discountPercentage,
    this.discountAmount,
    this.priceTreatment,
  });

  CurrentBidPrice originalPrice;
  String discountPercentage;
  CurrentBidPrice discountAmount;
  String priceTreatment;

  factory MarketingPrice.fromJson(Map<String, dynamic> json) => MarketingPrice(
    originalPrice: json["originalPrice"] == null ? null : CurrentBidPrice.fromJson(json["originalPrice"]),
    discountPercentage: json["discountPercentage"] == null ? null : json["discountPercentage"],
    discountAmount: json["discountAmount"] == null ? null : CurrentBidPrice.fromJson(json["discountAmount"]),
    priceTreatment: json["priceTreatment"] == null ? null : json["priceTreatment"],
  );

  Map<String, dynamic> toJson() => {
    "originalPrice": originalPrice == null ? null : originalPrice.toJson(),
    "discountPercentage": discountPercentage == null ? null : discountPercentage,
    "discountAmount": discountAmount == null ? null : discountAmount.toJson(),
    "priceTreatment": priceTreatment == null ? null : priceTreatment,
  };
}

class Seller {
  Seller({
    this.username,
    this.feedbackPercentage,
    this.feedbackScore,
  });

  String username;
  String feedbackPercentage;
  int feedbackScore;

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
    username: json["username"] == null ? null : json["username"],
    feedbackPercentage: json["feedbackPercentage"] == null ? null : json["feedbackPercentage"],
    feedbackScore: json["feedbackScore"] == null ? null : json["feedbackScore"],
  );

  Map<String, dynamic> toJson() => {
    "username": username == null ? null : username,
    "feedbackPercentage": feedbackPercentage == null ? null : feedbackPercentage,
    "feedbackScore": feedbackScore == null ? null : feedbackScore,
  };
}

class ShippingOption {
  ShippingOption({
    this.shippingCostType,
    this.shippingCost,
  });

  ShippingCostType shippingCostType;
  CurrentBidPrice shippingCost;

  factory ShippingOption.fromJson(Map<String, dynamic> json) => ShippingOption(
    shippingCostType: json["shippingCostType"] == null ? null : shippingCostTypeValues.map[json["shippingCostType"]],
    shippingCost: json["shippingCost"] == null ? null : CurrentBidPrice.fromJson(json["shippingCost"]),
  );

  Map<String, dynamic> toJson() => {
    "shippingCostType": shippingCostType == null ? null : shippingCostTypeValues.reverse[shippingCostType],
    "shippingCost": shippingCost == null ? null : shippingCost.toJson(),
  };
}

enum ShippingCostType { FIXED }

final shippingCostTypeValues = EnumValues({
  "FIXED": ShippingCostType.FIXED
});

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
