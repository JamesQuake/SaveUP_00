import 'dart:convert';

CatalogResponse catalogResponseFromJson(String str) => CatalogResponse.fromJson(json.decode(str));

String catalogResponseToJson(CatalogResponse data) => json.encode(data.toJson());

class CatalogResponse {
  CatalogResponse({
    this.previouspageuri,
    this.nextpageuri,
    this.lastpageuri,
    this.catalogs,
  });

  String previouspageuri;
  String nextpageuri;
  String lastpageuri;
  List<Catalog> catalogs;

  factory CatalogResponse.fromJson(Map<String, dynamic> json) => CatalogResponse(
    previouspageuri: json["@previouspageuri"] == null ? null : json["@previouspageuri"],
    nextpageuri: json["@nextpageuri"] == null ? null : json["@nextpageuri"],
    lastpageuri: json["@lastpageuri"] == null ? null : json["@lastpageuri"],
    catalogs: json["Catalogs"] == null ? null : List<Catalog>.from(json["Catalogs"].map((x) => Catalog.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "@previouspageuri": previouspageuri == null ? null : previouspageuri,
    "@nextpageuri": nextpageuri == null ? null : nextpageuri,
    "@lastpageuri": lastpageuri == null ? null : lastpageuri,
    "Catalogs": catalogs == null ? null : List<dynamic>.from(catalogs.map((x) => x.toJson())),
  };
}

class Catalog {
  Catalog({
    this.id,
    this.name,
    this.numberOfItems,
    this.itemsUri,
    this.uri,
  });

  String id;
  String name;
  String numberOfItems;
  String itemsUri;
  String uri;

  factory Catalog.fromJson(Map<String, dynamic> json) => Catalog(
    id: json["Id"] == null ? null : json["Id"],
    name: json["Name"] == null ? null : json["Name"].replaceAll(RegExp(r'[0-9_]'), '').trim(),
    numberOfItems: json["NumberOfItems"] == null ? null : json["NumberOfItems"],
    itemsUri: json["ItemsUri"] == null ? null : json["ItemsUri"],
    uri: json["Uri"] == null ? null : json["Uri"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id == null ? null : id,
    "Name": name == null ? null : name,
    "NumberOfItems": numberOfItems == null ? null : numberOfItems,
    "ItemsUri": itemsUri == null ? null : itemsUri,
    "Uri": uri == null ? null : uri,
  };
}