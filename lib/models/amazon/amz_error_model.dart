// To parse this JSON data, do
//
//     final amazonError = amazonErrorFromJson(jsonString);

import 'dart:convert';

AmazonError amazonErrorFromJson(String str) =>
    AmazonError.fromJson(json.decode(str));

String amazonErrorToJson(AmazonError data) => json.encode(data.toJson());

class AmazonError {
  AmazonError({
    this.type,
    this.errors,
  });

  String type;
  List<Error> errors;

  factory AmazonError.fromJson(Map<String, dynamic> json) => AmazonError(
        type: json["__type"] == null ? null : json["__type"],
        errors: json["Errors"] == null
            ? null
            : List<Error>.from(json["Errors"].map((x) => Error.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "__type": type == null ? null : type,
        "Errors": errors == null
            ? null
            : List<dynamic>.from(errors.map((x) => x.toJson())),
      };
}

class Error {
  Error({
    this.code,
    this.message,
  });

  String code;
  String message;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        code: json["Code"] == null ? null : json["Code"],
        message: json["Message"] == null ? null : json["Message"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code == null ? null : code,
        "Message": message == null ? null : message,
      };
}
