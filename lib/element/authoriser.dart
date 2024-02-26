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
