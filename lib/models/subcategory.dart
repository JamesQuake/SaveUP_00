

import 'dart:convert';

subCar subcategoryFromJson(String str) => subCar.fromJson(json.decode(str));

String subCarToJson(subCar data) => json.encode(data.toJson());

class subCar {
  subCar({
    this.timestamp,
    this.ack,
    this.build,
    this.version,
    this.categoryArray,
    this.categoryCount,
    this.updateTime,
    this.categoryVersion,
  });

  DateTime timestamp;
  String ack;
  String build;
  String version;
  CategoryArray categoryArray;
  int categoryCount;
  DateTime updateTime;
  String categoryVersion;

  factory subCar.fromJson(Map<String, dynamic> json) => subCar(
    timestamp: DateTime.parse(json["Timestamp"]),
    ack: json["Ack"],
    build: json["Build"],
    version: json["Version"],
    categoryArray: CategoryArray.fromJson(json["CategoryArray"]),
    categoryCount: json["CategoryCount"],
    updateTime: DateTime.parse(json["UpdateTime"]),
    categoryVersion: json["CategoryVersion"],
  );

  Map<String, dynamic> toJson() => {
    "Timestamp": timestamp.toIso8601String(),
    "Ack": ack,
    "Build": build,
    "Version": version,
    "CategoryArray": categoryArray.toJson(),
    "CategoryCount": categoryCount,
    "UpdateTime": updateTime.toIso8601String(),
    "CategoryVersion": categoryVersion,
  };
}

class CategoryArray {
  CategoryArray({
    this.category,
  });

  List<Categor> category;

  factory CategoryArray.fromJson(Map<String, dynamic> json) => CategoryArray(
    category: List<Categor>.from(json["Category"].map((x) => Categor.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Categor": List<dynamic>.from(category.map((x) => x.toJson())),
  };
}

class Categor {
  Categor({
    this.categoryId,
    this.categoryLevel,
    this.categoryName,
    this.categoryParentId,
    this.categoryNamePath,
    this.categoryIdPath,
    this.leafCategory,
  });

  String categoryId;
  int categoryLevel;
  String categoryName;
  String categoryParentId;
  String categoryNamePath;
  String categoryIdPath;
  bool leafCategory;

  factory Categor.fromJson(Map<String, dynamic> json) => Categor(
    categoryId: json["CategoryID"],
    categoryLevel: json["CategoryLevel"],
    categoryName: json["CategoryName"],
    categoryParentId: json["CategoryParentID"],
    categoryNamePath: json["CategoryNamePath"],
    categoryIdPath: json["CategoryIDPath"],
    leafCategory: json["LeafCategory"],
  );

  Map<String, dynamic> toJson() => {
    "CategoryID": categoryId,
    "CategoryLevel": categoryLevel,
    "CategoryName": categoryName,
    "CategoryParentID": categoryParentId,
    "CategoryNamePath": categoryNamePath,
    "CategoryIDPath": categoryIdPath,
    "LeafCategory": leafCategory,
  };
}
