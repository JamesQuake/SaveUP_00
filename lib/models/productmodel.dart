
import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    this.itemId,
    this.sellerItemRevision,
    this.title,
    this.subtitle,
    this.shortDescription,
    this.price,
    this.categoryPath,
    this.condition,
    this.conditionId,
    this.itemLocation,
    this.image,
    this.additionalImages,
    this.brand,
    this.seller,
    this.estimatedAvailabilities,
    this.shippingOptions,
    this.shipToLocations,
    this.returnTerms,
    this.taxes,
    this.localizedAspects,
    this.topRatedBuyingExperience,
    this.buyingOptions,
    this.itemAffiliateWebUrl,
    this.itemWebUrl,
    this.description,
    this.paymentMethods,
    this.enabledForGuestCheckout,
    this.eligibleForInlineCheckout,
    this.lotSize,
    this.legacyItemId,
    this.adultOnly,
    this.categoryId,
  });

  String itemId;
  String sellerItemRevision;
  String title;
  String subtitle;
  String shortDescription;
  Price price;
  String categoryPath;
  String condition;
  String conditionId;
  ItemLocation itemLocation;
  Imge image;
  List<Imge> additionalImages;
  String brand;
  Seller seller;
  List<EstimatedAvailability> estimatedAvailabilities;
  List<ShippingOption> shippingOptions;
  ShipToLocations shipToLocations;
  ReturnTerms returnTerms;
  List<Tax> taxes;
  List<LocalizedAspect> localizedAspects;
  bool topRatedBuyingExperience;
  List<String> buyingOptions;
  String itemAffiliateWebUrl;
  String itemWebUrl;
  String description;
  List<PaymentMethod> paymentMethods;
  bool enabledForGuestCheckout;
  bool eligibleForInlineCheckout;
  int lotSize;
  String legacyItemId;
  bool adultOnly;
  String categoryId;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    itemId: json["itemId"] == null ? null : json["itemId"],
    sellerItemRevision: json["sellerItemRevision"] == null ? null : json["sellerItemRevision"],
    title: json["title"] == null ? null : json["title"],
    subtitle: json["subtitle"] == null ? null : json["subtitle"],
    shortDescription: json["shortDescription"] == null ? null : json["shortDescription"],
    price: json["price"] == null ? null : Price.fromJson(json["price"]),
    categoryPath: json["categoryPath"] == null ? null : json["categoryPath"],
    condition: json["condition"] == null ? null : json["condition"],
    conditionId: json["conditionId"] == null ? null : json["conditionId"],
    itemLocation: json["itemLocation"] == null ? null : ItemLocation.fromJson(json["itemLocation"]),
    image: json["image"] == null ? null : Imge.fromJson(json["image"]),
    additionalImages: json["additionalImages"] == null ? null : List<Imge>.from(json["additionalImages"].map((x) => Imge.fromJson(x))),
    brand: json["brand"] == null ? null : json["brand"],
    seller: json["seller"] == null ? null : Seller.fromJson(json["seller"]),
    estimatedAvailabilities: json["estimatedAvailabilities"] == null ? null : List<EstimatedAvailability>.from(json["estimatedAvailabilities"].map((x) => EstimatedAvailability.fromJson(x))),
    shippingOptions: json["shippingOptions"] == null ? null : List<ShippingOption>.from(json["shippingOptions"].map((x) => ShippingOption.fromJson(x))),
    shipToLocations: json["shipToLocations"] == null ? null : ShipToLocations.fromJson(json["shipToLocations"]),
    returnTerms: json["returnTerms"] == null ? null : ReturnTerms.fromJson(json["returnTerms"]),
    taxes: json["taxes"] == null ? null : List<Tax>.from(json["taxes"].map((x) => Tax.fromJson(x))),
    localizedAspects: json["localizedAspects"] == null ? null : List<LocalizedAspect>.from(json["localizedAspects"].map((x) => LocalizedAspect.fromJson(x))),
    topRatedBuyingExperience: json["topRatedBuyingExperience"] == null ? null : json["topRatedBuyingExperience"],
    buyingOptions: json["buyingOptions"] == null ? null : List<String>.from(json["buyingOptions"].map((x) => x)),
    itemAffiliateWebUrl: json["itemAffiliateWebUrl"] == null ? null : json["itemAffiliateWebUrl"],
    itemWebUrl: json["itemWebUrl"] == null ? null : json["itemWebUrl"],
    description: json["description"] == null ? null : json["description"],
    paymentMethods: json["paymentMethods"] == null ? null : List<PaymentMethod>.from(json["paymentMethods"].map((x) => PaymentMethod.fromJson(x))),
    enabledForGuestCheckout: json["enabledForGuestCheckout"] == null ? null : json["enabledForGuestCheckout"],
    eligibleForInlineCheckout: json["eligibleForInlineCheckout"] == null ? null : json["eligibleForInlineCheckout"],
    lotSize: json["lotSize"] == null ? null : json["lotSize"],
    legacyItemId: json["legacyItemId"] == null ? null : json["legacyItemId"],
    adultOnly: json["adultOnly"] == null ? null : json["adultOnly"],
    categoryId: json["categoryId"] == null ? null : json["categoryId"],
  );

  Map<String, dynamic> toJson() => {
    "itemId": itemId == null ? null : itemId,
    "sellerItemRevision": sellerItemRevision == null ? null : sellerItemRevision,
    "title": title == null ? null : title,
    "subtitle": subtitle == null ? null : subtitle,
    "shortDescription": shortDescription == null ? null : shortDescription,
    "price": price == null ? null : price.toJson(),
    "categoryPath": categoryPath == null ? null : categoryPath,
    "condition": condition == null ? null : condition,
    "conditionId": conditionId == null ? null : conditionId,
    "itemLocation": itemLocation == null ? null : itemLocation.toJson(),
    "image": image == null ? null : image.toJson(),
    "additionalImages": additionalImages == null ? null : List<dynamic>.from(additionalImages.map((x) => x.toJson())),
    "brand": brand == null ? null : brand,
    "seller": seller == null ? null : seller.toJson(),
    "estimatedAvailabilities": estimatedAvailabilities == null ? null : List<dynamic>.from(estimatedAvailabilities.map((x) => x.toJson())),
    "shippingOptions": shippingOptions == null ? null : List<dynamic>.from(shippingOptions.map((x) => x.toJson())),
    "shipToLocations": shipToLocations == null ? null : shipToLocations.toJson(),
    "returnTerms": returnTerms == null ? null : returnTerms.toJson(),
    "taxes": taxes == null ? null : List<dynamic>.from(taxes.map((x) => x.toJson())),
    "localizedAspects": localizedAspects == null ? null : List<dynamic>.from(localizedAspects.map((x) => x.toJson())),
    "topRatedBuyingExperience": topRatedBuyingExperience == null ? null : topRatedBuyingExperience,
    "buyingOptions": buyingOptions == null ? null : List<dynamic>.from(buyingOptions.map((x) => x)),
    "itemAffiliateWebUrl": itemAffiliateWebUrl == null ? null : itemAffiliateWebUrl,
    "itemWebUrl": itemWebUrl == null ? null : itemWebUrl,
    "description": description == null ? null : description,
    "paymentMethods": paymentMethods == null ? null : List<dynamic>.from(paymentMethods.map((x) => x.toJson())),
    "enabledForGuestCheckout": enabledForGuestCheckout == null ? null : enabledForGuestCheckout,
    "eligibleForInlineCheckout": eligibleForInlineCheckout == null ? null : eligibleForInlineCheckout,
    "lotSize": lotSize == null ? null : lotSize,
    "legacyItemId": legacyItemId == null ? null : legacyItemId,
    "adultOnly": adultOnly == null ? null : adultOnly,
    "categoryId": categoryId == null ? null : categoryId,
  };
}

class Imge {
  Imge({
    this.imageUrl,
  });

  String imageUrl;

  factory Imge.fromJson(Map<String, dynamic> json) => Imge(
    imageUrl: json["imageUrl"] == null ? null : json["imageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "imageUrl": imageUrl == null ? null : imageUrl,
  };
}

class EstimatedAvailability {
  EstimatedAvailability({
    this.deliveryOptions,
    this.availabilityThresholdType,
    this.availabilityThreshold,
    this.estimatedAvailabilityStatus,
    this.estimatedSoldQuantity,
  });

  List<String> deliveryOptions;
  String availabilityThresholdType;
  int availabilityThreshold;
  String estimatedAvailabilityStatus;
  int estimatedSoldQuantity;

  factory EstimatedAvailability.fromJson(Map<String, dynamic> json) => EstimatedAvailability(
    deliveryOptions: json["deliveryOptions"] == null ? null : List<String>.from(json["deliveryOptions"].map((x) => x)),
    availabilityThresholdType: json["availabilityThresholdType"] == null ? null : json["availabilityThresholdType"],
    availabilityThreshold: json["availabilityThreshold"] == null ? null : json["availabilityThreshold"],
    estimatedAvailabilityStatus: json["estimatedAvailabilityStatus"] == null ? null : json["estimatedAvailabilityStatus"],
    estimatedSoldQuantity: json["estimatedSoldQuantity"] == null ? null : json["estimatedSoldQuantity"],
  );

  Map<String, dynamic> toJson() => {
    "deliveryOptions": deliveryOptions == null ? null : List<dynamic>.from(deliveryOptions.map((x) => x)),
    "availabilityThresholdType": availabilityThresholdType == null ? null : availabilityThresholdType,
    "availabilityThreshold": availabilityThreshold == null ? null : availabilityThreshold,
    "estimatedAvailabilityStatus": estimatedAvailabilityStatus == null ? null : estimatedAvailabilityStatus,
    "estimatedSoldQuantity": estimatedSoldQuantity == null ? null : estimatedSoldQuantity,
  };
}

class ItemLocation {
  ItemLocation({
    this.city,
    this.stateOrProvince,
    this.postalCode,
    this.country,
  });

  String city;
  String stateOrProvince;
  String postalCode;
  String country;

  factory ItemLocation.fromJson(Map<String, dynamic> json) => ItemLocation(
    city: json["city"] == null ? null : json["city"],
    stateOrProvince: json["stateOrProvince"] == null ? null : json["stateOrProvince"],
    postalCode: json["postalCode"] == null ? null : json["postalCode"],
    country: json["country"] == null ? null : json["country"],
  );

  Map<String, dynamic> toJson() => {
    "city": city == null ? null : city,
    "stateOrProvince": stateOrProvince == null ? null : stateOrProvince,
    "postalCode": postalCode == null ? null : postalCode,
    "country": country == null ? null : country,
  };
}

class LocalizedAspect {
  LocalizedAspect({
    this.type,
    this.name,
    this.value,
  });

  String type;
  String name;
  String value;

  factory LocalizedAspect.fromJson(Map<String, dynamic> json) => LocalizedAspect(
    type: json["type"] == null ? null : json["type"],
    name: json["name"] == null ? null : json["name"],
    value: json["value"] == null ? null : json["value"],
  );

  Map<String, dynamic> toJson() => {
    "type": type == null ? null : type,
    "name": name == null ? null : name,
    "value": value == null ? null : value,
  };
}

class PaymentMethod {
  PaymentMethod({
    this.paymentMethodType,
    this.paymentMethodBrands,
  });

  String paymentMethodType;
  List<PaymentMethodBrand> paymentMethodBrands;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    paymentMethodType: json["paymentMethodType"] == null ? null : json["paymentMethodType"],
    paymentMethodBrands: json["paymentMethodBrands"] == null ? null : List<PaymentMethodBrand>.from(json["paymentMethodBrands"].map((x) => PaymentMethodBrand.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "paymentMethodType": paymentMethodType == null ? null : paymentMethodType,
    "paymentMethodBrands": paymentMethodBrands == null ? null : List<dynamic>.from(paymentMethodBrands.map((x) => x.toJson())),
  };
}

class PaymentMethodBrand {
  PaymentMethodBrand({
    this.paymentMethodBrandType,
  });

  String paymentMethodBrandType;

  factory PaymentMethodBrand.fromJson(Map<String, dynamic> json) => PaymentMethodBrand(
    paymentMethodBrandType: json["paymentMethodBrandType"] == null ? null : json["paymentMethodBrandType"],
  );

  Map<String, dynamic> toJson() => {
    "paymentMethodBrandType": paymentMethodBrandType == null ? null : paymentMethodBrandType,
  };
}

class Price {
  Price({
    this.value,
    this.currency,
  });

  String value;
  String currency;

  factory Price.fromJson(Map<String, dynamic> json) => Price(
    value: json["value"] == null ? null : json["value"],
    currency: json["currency"] == null ? null : json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "value": value == null ? null : value,
    "currency": currency == null ? null : currency,
  };
}

class ReturnTerms {
  ReturnTerms({
    this.returnsAccepted,
    this.refundMethod,
    this.returnShippingCostPayer,
    this.returnPeriod,
  });

  bool returnsAccepted;
  String refundMethod;
  String returnShippingCostPayer;
  ReturnPeriod returnPeriod;

  factory ReturnTerms.fromJson(Map<String, dynamic> json) => ReturnTerms(
    returnsAccepted: json["returnsAccepted"] == null ? null : json["returnsAccepted"],
    refundMethod: json["refundMethod"] == null ? null : json["refundMethod"],
    returnShippingCostPayer: json["returnShippingCostPayer"] == null ? null : json["returnShippingCostPayer"],
    returnPeriod: json["returnPeriod"] == null ? null : ReturnPeriod.fromJson(json["returnPeriod"]),
  );

  Map<String, dynamic> toJson() => {
    "returnsAccepted": returnsAccepted == null ? null : returnsAccepted,
    "refundMethod": refundMethod == null ? null : refundMethod,
    "returnShippingCostPayer": returnShippingCostPayer == null ? null : returnShippingCostPayer,
    "returnPeriod": returnPeriod == null ? null : returnPeriod.toJson(),
  };
}

class ReturnPeriod {
  ReturnPeriod({
    this.value,
    this.unit,
  });

  int value;
  String unit;

  factory ReturnPeriod.fromJson(Map<String, dynamic> json) => ReturnPeriod(
    value: json["value"] == null ? null : json["value"],
    unit: json["unit"] == null ? null : json["unit"],
  );

  Map<String, dynamic> toJson() => {
    "value": value == null ? null : value,
    "unit": unit == null ? null : unit,
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

class ShipToLocations {
  ShipToLocations({
    this.regionIncluded,
    this.regionExcluded,
  });

  List<RegionCluded> regionIncluded;
  List<RegionCluded> regionExcluded;

  factory ShipToLocations.fromJson(Map<String, dynamic> json) => ShipToLocations(
    regionIncluded: json["regionIncluded"] == null ? null : List<RegionCluded>.from(json["regionIncluded"].map((x) => RegionCluded.fromJson(x))),
    regionExcluded: json["regionExcluded"] == null ? null : List<RegionCluded>.from(json["regionExcluded"].map((x) => RegionCluded.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "regionIncluded": regionIncluded == null ? null : List<dynamic>.from(regionIncluded.map((x) => x.toJson())),
    "regionExcluded": regionExcluded == null ? null : List<dynamic>.from(regionExcluded.map((x) => x.toJson())),
  };
}

class RegionCluded {
  RegionCluded({
    this.regionName,
    this.regionType,
    this.regionId,
  });

  String regionName;
  String regionType;
  String regionId;

  factory RegionCluded.fromJson(Map<String, dynamic> json) => RegionCluded(
    regionName: json["regionName"] == null ? null : json["regionName"],
    regionType: json["regionType"] == null ? null : json["regionType"],
    regionId: json["regionId"] == null ? null : json["regionId"],
  );

  Map<String, dynamic> toJson() => {
    "regionName": regionName == null ? null : regionName,
    "regionType": regionType == null ? null : regionType,
    "regionId": regionId == null ? null : regionId,
  };
}

class ShippingOption {
  ShippingOption({
    this.shippingServiceCode,
    this.shippingCarrierCode,
    this.type,
    this.shippingCost,
    this.quantityUsedForEstimate,
    this.minEstimatedDeliveryDate,
    this.maxEstimatedDeliveryDate,
    this.additionalShippingCostPerUnit,
    this.shippingCostType,
  });

  String shippingServiceCode;
  String shippingCarrierCode;
  String type;
  Price shippingCost;
  int quantityUsedForEstimate;
  DateTime minEstimatedDeliveryDate;
  DateTime maxEstimatedDeliveryDate;
  Price additionalShippingCostPerUnit;
  String shippingCostType;

  factory ShippingOption.fromJson(Map<String, dynamic> json) => ShippingOption(
    shippingServiceCode: json["shippingServiceCode"] == null ? null : json["shippingServiceCode"],
    shippingCarrierCode: json["shippingCarrierCode"] == null ? null : json["shippingCarrierCode"],
    type: json["type"] == null ? null : json["type"],
    shippingCost: json["shippingCost"] == null ? null : Price.fromJson(json["shippingCost"]),
    quantityUsedForEstimate: json["quantityUsedForEstimate"] == null ? null : json["quantityUsedForEstimate"],
    minEstimatedDeliveryDate: json["minEstimatedDeliveryDate"] == null ? null : DateTime.parse(json["minEstimatedDeliveryDate"]),
    maxEstimatedDeliveryDate: json["maxEstimatedDeliveryDate"] == null ? null : DateTime.parse(json["maxEstimatedDeliveryDate"]),
    additionalShippingCostPerUnit: json["additionalShippingCostPerUnit"] == null ? null : Price.fromJson(json["additionalShippingCostPerUnit"]),
    shippingCostType: json["shippingCostType"] == null ? null : json["shippingCostType"],
  );

  Map<String, dynamic> toJson() => {
    "shippingServiceCode": shippingServiceCode == null ? null : shippingServiceCode,
    "shippingCarrierCode": shippingCarrierCode == null ? null : shippingCarrierCode,
    "type": type == null ? null : type,
    "shippingCost": shippingCost == null ? null : shippingCost.toJson(),
    "quantityUsedForEstimate": quantityUsedForEstimate == null ? null : quantityUsedForEstimate,
    "minEstimatedDeliveryDate": minEstimatedDeliveryDate == null ? null : minEstimatedDeliveryDate.toIso8601String(),
    "maxEstimatedDeliveryDate": maxEstimatedDeliveryDate == null ? null : maxEstimatedDeliveryDate.toIso8601String(),
    "additionalShippingCostPerUnit": additionalShippingCostPerUnit == null ? null : additionalShippingCostPerUnit.toJson(),
    "shippingCostType": shippingCostType == null ? null : shippingCostType,
  };
}

class Tax {
  Tax({
    this.taxJurisdiction,
    this.taxType,
    this.shippingAndHandlingTaxed,
    this.includedInPrice,
    this.ebayCollectAndRemitTax,
  });

  TaxJurisdiction taxJurisdiction;
  String taxType;
  bool shippingAndHandlingTaxed;
  bool includedInPrice;
  bool ebayCollectAndRemitTax;

  factory Tax.fromJson(Map<String, dynamic> json) => Tax(
    taxJurisdiction: json["taxJurisdiction"] == null ? null : TaxJurisdiction.fromJson(json["taxJurisdiction"]),
    taxType: json["taxType"] == null ? null : json["taxType"],
    shippingAndHandlingTaxed: json["shippingAndHandlingTaxed"] == null ? null : json["shippingAndHandlingTaxed"],
    includedInPrice: json["includedInPrice"] == null ? null : json["includedInPrice"],
    ebayCollectAndRemitTax: json["ebayCollectAndRemitTax"] == null ? null : json["ebayCollectAndRemitTax"],
  );

  Map<String, dynamic> toJson() => {
    "taxJurisdiction": taxJurisdiction == null ? null : taxJurisdiction.toJson(),
    "taxType": taxType == null ? null : taxType,
    "shippingAndHandlingTaxed": shippingAndHandlingTaxed == null ? null : shippingAndHandlingTaxed,
    "includedInPrice": includedInPrice == null ? null : includedInPrice,
    "ebayCollectAndRemitTax": ebayCollectAndRemitTax == null ? null : ebayCollectAndRemitTax,
  };
}

class TaxJurisdiction {
  TaxJurisdiction({
    this.region,
    this.taxJurisdictionId,
  });

  Region region;
  String taxJurisdictionId;

  factory TaxJurisdiction.fromJson(Map<String, dynamic> json) => TaxJurisdiction(
    region: json["region"] == null ? null : Region.fromJson(json["region"]),
    taxJurisdictionId: json["taxJurisdictionId"] == null ? null : json["taxJurisdictionId"],
  );

  Map<String, dynamic> toJson() => {
    "region": region == null ? null : region.toJson(),
    "taxJurisdictionId": taxJurisdictionId == null ? null : taxJurisdictionId,
  };
}

class Region {
  Region({
    this.regionName,
    this.regionType,
  });

  String regionName;
  String regionType;

  factory Region.fromJson(Map<String, dynamic> json) => Region(
    regionName: json["regionName"] == null ? null : json["regionName"],
    regionType: json["regionType"] == null ? null : json["regionType"],
  );

  Map<String, dynamic> toJson() => {
    "regionName": regionName == null ? null : regionName,
    "regionType": regionType == null ? null : regionType,
  };
}
