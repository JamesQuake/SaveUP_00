import 'dart:convert';
import 'package:http/http.dart';

import 'sigV4/sigv4-client.dart';

makeAmazonCall({
  String url,
  String keywords,
  List resources,
  String req,
  String searchindex,
  String browsenode,
  String asin,
  String sorter,
  bool sortRes,
  int pageNum,
}) async {
  final client = Sigv4Client(
    keyId: 'AKIAJYKRYX3LVU2K2UYA',
    accessKey: 'zagf52zn4hPiw7VXLqbf93RZx3aAulJKJLbbk4XP',
    region: 'us-east-1',
    serviceName: 'ProductAdvertisingAPI',
  );
  //endpoint
  final path = "https://webservices.amazon.com/paapi5/" + url.toLowerCase();

  final largeRequest = client.request(
    path,
    method: req,
    // query: {'key': 'value'},
    headers: {
      'Host': 'webservices.amazon.com',
      'Content-Type': 'application/json',
      'Content-Encoding': 'amz-1.0',
      'X-Amz-Target': 'com.amazon.paapi5.v1.ProductAdvertisingAPIv1.' + url,
      'Accept': 'application/json, text/javascript',
      'Accept-Language': 'en-US',
    },
    body: json.encode({
      if (url == "GetItems") "ItemIds": [asin],
      if (url == "SearchItems") "Keywords": keywords,
      if (url == "SearchItems") "ItemCount": 100,
      if (url == "SearchItems" && pageNum != null) "ItemPage": pageNum,
      if (url == "SearchItems" && sorter != null && sorter != "")
        "SortBy": sorter,
      "Marketplace": "www.amazon.com",
      "PartnerTag": "ewyzly-20",
      "PartnerType": "Associates",
      "Resources": resources,
      if (searchindex != null && searchindex != "") "SearchIndex": searchindex,
      if (browsenode != null && browsenode != "") "BrowseNodeId": browsenode,
    }),
  );

  dynamic resp = await post(
    largeRequest.url,
    headers: largeRequest.headers,
    body: largeRequest.body,
  );
  // getSignatureKey(key, dateStamp, regionName, serviceName) {
  //   dynamic newkey = utf8.encode('wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY');
  //   var kDate = Hmac(sha256, newkey);
  // var kRegion = crypto.HmacSHA256(regionName, kDate);
  // var kService = crypto.HmacSHA256(serviceName, kRegion);
  // var kSigning = crypto.HmacSHA256("aws4_request", kService);
  // return kSigning;
  // }
  return resp;
}
