// import 'dart:convert';
import 'package:flutter/material.dart';

class InvTotal {
  String iAmount;

  InvTotal({this.iAmount});

  factory InvTotal.fromJson({@required Map<String, dynamic> json}) => InvTotal(
        iAmount: json['investAmount'].toString(),
      );

  Map<String, dynamic> toJson({@required InvTotal invTotal}) => {
        'investAmount': invTotal.iAmount,
      };
}
