import 'dart:convert';

WalmartItemsResponse walmartItemsResponseFromJson(String str) => WalmartItemsResponse.fromJson(json.decode(str));

String walmartItemsResponseToJson(WalmartItemsResponse data) => json.encode(data.toJson());

Item walmartProductResponseFromJson(String str) => Item.fromJson(json.decode(str));

class WalmartItemsResponse {
  WalmartItemsResponse({
    this.page,
    this.numpages,
    this.pagesize,
    this.total,
    this.start,
    this.end,
    this.previouspageuri,
    this.nextpageuri,
    this.items,
  });

  String page;
  String numpages;
  String pagesize;
  String total;
  String start;
  String end;
  String previouspageuri;
  String nextpageuri;
  List<Item> items;

  factory WalmartItemsResponse.fromJson(Map<String, dynamic> json) => WalmartItemsResponse(
    page: json["@page"] == null ? null : json["@page"],
    numpages: json["@numpages"] == null ? null : json["@numpages"],
    pagesize: json["@pagesize"] == null ? null : json["@pagesize"],
    total: json["@total"] == null ? null : json["@total"],
    start: json["@start"] == null ? null : json["@start"],
    end: json["@end"] == null ? null : json["@end"],
    previouspageuri: json["@previouspageuri"] == null ? null : json["@previouspageuri"],
    nextpageuri: json["@nextpageuri"] == null ? null : json["@nextpageuri"],
    items: json["Items"] == null ? null : List<Item>.from(json["Items"].map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "@page": page == null ? null : page,
    "@numpages": numpages == null ? null : numpages,
    "@pagesize": pagesize == null ? null : pagesize,
    "@total": total == null ? null : total,
    "@start": start == null ? null : start,
    "@end": end == null ? null : end,
    "@previouspageuri": previouspageuri == null ? null : previouspageuri,
    "@nextpageuri": nextpageuri == null ? null : nextpageuri,
    "Items": items == null ? null : List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class Item {
  Item({
    this.id,
    this.catalogId,
    this.catalogItemId,
    this.name,
    this.description,
    this.manufacturer,
    this.url,
    this.imageUrl,
    this.additionalImageUrls,
    this.currentPrice,
    this.originalPrice,
    this.discountPercentage,
    this.currency,
    this.stockAvailability,
    this.gtin,
    this.category,
    this.colors,
    this.material,
    this.pattern,
    this.size,
    this.sizeUnit,
    this.weight,
    this.weightUnit,
    this.condition,
    this.ageGroup,
    this.uri,
  });

  String id;
  String catalogId;
  String catalogItemId;
  String name;
  String description;
  String manufacturer;
  String url;
  String imageUrl;
  List<String> additionalImageUrls;
  String currentPrice;
  String originalPrice;
  String discountPercentage;
  String currency;
  String stockAvailability;
  String gtin;
  String category;
  List<String> colors;
  String material;
  String pattern;
  String size;
  String sizeUnit;
  String weight;
  String weightUnit;
  String condition;
  String ageGroup;
  String uri;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["Id"] == null ? null : json["Id"],
    catalogId: json["CatalogId"] == null ? null : json["CatalogId"],
    catalogItemId: json["CatalogItemId"] == null ? null : json["CatalogItemId"],
    name: json["Name"] == null ? null : json["Name"],
    description: json["Description"] == null ? null : json["Description"],
    manufacturer: json["Manufacturer"] == null ? null : json["Manufacturer"],
    url: json["Url"] == null ? null : json["Url"],
    imageUrl: json["ImageUrl"] == null ? null : json["ImageUrl"],
    additionalImageUrls: json["AdditionalImageUrls"] == null ? null : List<String>.from(json["AdditionalImageUrls"].map((x) => x)),
    currentPrice: json["CurrentPrice"] == null ? null : json["CurrentPrice"],
    originalPrice: json["OriginalPrice"] == null ? null : json["OriginalPrice"],
    discountPercentage: json["DiscountPercentage"] == null ? null : json["DiscountPercentage"],
    currency: json["Currency"] == null ? null : json["Currency"],
    stockAvailability: json["StockAvailability"] == null ? null : json["StockAvailability"],
    gtin: json["Gtin"] == null ? null : json["Gtin"],
    category: json["Category"] == null ? null : json["Category"],
    colors: json["Colors"] == null ? null : List<String>.from(json["Colors"].map((x) => x)),
    material: json["Material"] == null ? null : json["Material"],
    pattern: json["Pattern"] == null ? null : json["Pattern"],
    size: json["Size"] == null ? null : json["Size"],
    sizeUnit: json["SizeUnit"] == null ? null : json["SizeUnit"],
    weight: json["Weight"] == null ? null : json["Weight"],
    weightUnit: json["WeightUnit"] == null ? null : json["WeightUnit"],
    condition: json["Condition"] == null ? null : json["Condition"],
    ageGroup: json["AgeGroup"] == null ? null : json["AgeGroup"],
    uri: json["Uri"] == null ? null : json["Uri"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id == null ? null : id,
    "CatalogId": catalogId == null ? null : catalogId,
    "CatalogItemId": catalogItemId == null ? null : catalogItemId,
    "Name": name == null ? null : name,
    "Description": description == null ? null : description,
    "Manufacturer": manufacturer == null ? null : manufacturer,
    "Url": url == null ? null : url,
    "ImageUrl": imageUrl == null ? null : imageUrl,
    "AdditionalImageUrls": additionalImageUrls == null ? null : List<dynamic>.from(additionalImageUrls.map((x) => x)),
    "CurrentPrice": currentPrice == null ? null : currentPrice,
    "OriginalPrice": originalPrice == null ? null : originalPrice,
    "DiscountPercentage": discountPercentage == null ? null : discountPercentage,
    "Currency": currency == null ? null : currency,
    "StockAvailability": stockAvailability == null ? null : stockAvailability,
    "Gtin": gtin == null ? null : gtin,
    "Category": category == null ? null : category,
    "Colors": colors == null ? null : List<dynamic>.from(colors.map((x) => x)),
    "Material": material == null ? null : material,
    "Pattern": pattern == null ? null : pattern,
    "Size": size == null ? null : size,
    "SizeUnit": sizeUnit == null ? null : sizeUnit,
    "Weight": weight == null ? null : weight,
    "WeightUnit": weightUnit == null ? null : weightUnit,
    "Condition": condition == null ? null : condition,
    "AgeGroup": ageGroup == null ? null : ageGroup,
    "Uri": uri == null ? null : uri,
  };
}