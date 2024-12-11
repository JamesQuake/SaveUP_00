
import 'dart:convert';

FilterModel filterModelFromJson(String str) => FilterModel.fromJson(json.decode(str));

//String filterModelToJson(FilterModel data) => json.encode(data.toJson());

class FilterModel {
  FilterModel({
    this.href,
    this.total,
    this.limit,
    this.offset,
    this.refinement,
  });

  String href;
  int total;
  int limit;
  int offset;
  Refinement refinement;

  factory FilterModel.fromJson(Map<String, dynamic> json) => FilterModel(
    href: json["href"] == null ? null : json["href"],
    total: json["total"] == null ? null : json["total"],
    limit: json["limit"] == null ? null : json["limit"],
    offset: json["offset"] == null ? null : json["offset"],
    refinement: json["refinement"] == null ? null : Refinement.fromJson(json["refinement"]),
  );

  // Map<String, dynamic> toJson() => {
  //   "href": href == null ? null : href,
  //   "total": total == null ? null : total,
  //   "limit": limit == null ? null : limit,
  //   "offset": offset == null ? null : offset,
  //   "refinement": refinement == null ? null : refinement.toJson(),
  // };
}

class Refinement {
  Refinement({
    this.dominantCategoryId,
    this.aspectDistributions,
  });

  String dominantCategoryId;
  List<AspectDistribution> aspectDistributions;

  factory Refinement.fromJson(Map<String, dynamic> json) => Refinement(
    dominantCategoryId: json["dominantCategoryId"] == null ? null : json["dominantCategoryId"],
    aspectDistributions: json["aspectDistributions"] == null ? null : List<AspectDistribution>.from(json["aspectDistributions"].map((x) => AspectDistribution.fromJson(x))),
  );

  // Map<String, dynamic> toJson() => {
  //   "dominantCategoryId": dominantCategoryId == null ? null : dominantCategoryId,
  //   "aspectDistributions": aspectDistributions == null ? null : List<dynamic>.from(aspectDistributions.map((x) => x.toJson())),
  // };
}

class AspectDistribution {
  AspectDistribution({
    this.localizedAspectName,
    this.aspectValueDistributions,
  });

  String localizedAspectName;
  List<String> aspectValueDistributions;

  factory AspectDistribution.fromJson(Map<String, dynamic> json) => AspectDistribution(
    localizedAspectName: json["localizedAspectName"] == null ? null : json["localizedAspectName"],
    aspectValueDistributions: json["aspectValueDistributions"] == null ? null : List<String>.from(json["aspectValueDistributions"].map((x) => x["localizedAspectValue"])),
  );

  // Map<String, dynamic> toJson() => {
  //   "localizedAspectName": localizedAspectName == null ? null : localizedAspectName,
  //   "aspectValueDistributions": aspectValueDistributions == null ? null : List<dynamic>.from(aspectValueDistributions.map((x) => x.toJson())),
  // };
}

// class AspectValueDistribution {
//   AspectValueDistribution({
//     this.localizedAspectValue,
//     this.matchCount,
//     this.refinementHref,
//   });
//
//   String localizedAspectValue;
//   int matchCount;
//   String refinementHref;
//
//   factory AspectValueDistribution.fromJson(Map<String, dynamic> json) => AspectValueDistribution(
//     localizedAspectValue: json["localizedAspectValue"] == null ? null : json["localizedAspectValue"],
//     matchCount: json["matchCount"] == null ? null : json["matchCount"],
//     refinementHref: json["refinementHref"] == null ? null : json["refinementHref"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "localizedAspectValue": localizedAspectValue == null ? null : localizedAspectValue,
//     "matchCount": matchCount == null ? null : matchCount,
//     "refinementHref": refinementHref == null ? null : refinementHref,
//   };
// }
