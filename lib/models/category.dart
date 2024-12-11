// import 'package:flutter/material.dart';
import 'dart:convert';

List<Category> categoryFromJson(String str) =>
    List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));

class Category {
  Category({
    this.category,
  });

  Source category;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        category: Source.fromJson(json["category"]),
      );
}

class Source {
  String categoryId;
  String categoryName;
  String imageUrl;
  String imageUrl2;

  Source({this.categoryId, this.categoryName, this.imageUrl, this.imageUrl2});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      categoryId: json["categoryId"] as String,
      categoryName: json["categoryName"] as String,
      imageUrl: json["imageUrl"] as String,
      imageUrl2: json["imageUrl2"] as String,
    );
  }
}
