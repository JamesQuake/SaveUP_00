import 'minttoken.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

makeCall(String url) async {
  var token = await getToken();
  var authorization = 'Bearer $token';
  final response = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'X-EBAY-API-IAF-TOKEN': authorization,
      'Authorization': authorization,
    },
  );
  return response;
}

makeWalmartCall(String url) async {
  // Create the authorization header
  String basicAuth = 'Basic ' + base64Encode(utf8.encode('IRms8oU5FgpC2680271TvYsYvsUcCgLDm1:W4XemHqxZELGf_fqJG5eViKPE.nSJVpq'));

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': basicAuth,
      'Accept': 'application/json',
      },
  );
  return response;
}
