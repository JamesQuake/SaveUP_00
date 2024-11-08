// import 'package:flutter/material.dart';

class VirtualClosetModel {
  String uid, pName, pPrice, pImage, pId, pUrl, platform, walmartUri;
  bool status;
  DateTime doc;

  VirtualClosetModel({
    this.uid,
    this.pName,
    this.pPrice,
    this.pImage,
    this.pId,
    this.pUrl,
    this.platform,
    this.status,
    this.doc,
    this.walmartUri,
  });


  factory VirtualClosetModel.fromJson(Map<String, dynamic> json){
    return VirtualClosetModel(
      uid: json['uid'],
      pName: json['pName'],
      pPrice: json['pPrice'],
      pImage: json['pImage'],
      pId: json['pId'],
      pUrl: json['pUrl'],
      walmartUri: json['walmartUri'],
      platform: json['platform'],
      status: json['status'],
      doc: DateTime.fromMillisecondsSinceEpoch(json['doc'].millisecondsSinceEpoch),
    );
  }

}
