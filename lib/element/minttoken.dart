import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

mintToken() async {
  var scope = "https%3A%2F%2Fapi.ebay.com%2Foauth%2Fapi_scope";
  String tokenUrl =
      "https://api.ebay.com/identity/v1/oauth2/token?grant_type=client_credentials&scope=$scope";
  var client_id = "SteveLom-PayorSav-PRD-8f2fb35bc-b3bf8b93";
  var client_secret = "PRD-ba622b8c8b10-bd57-4d29-ae51-e52c";
  String encoded = base64.encode(utf8.encode("$client_id:$client_secret"));
  String fencoded = "Basic $encoded";
  final response = await http.post(
    Uri.parse(tokenUrl),
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': fencoded,
    },
    // body: jsonEncode(<String, String>{
    //   'grant_type': 'client_credentials',
    //   'scope': scope,
    // }),
  );
  // print('jklo');sz//
  //print(response.body);
  var timeStamp = DateTime.now().millisecondsSinceEpoch;
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('token', jsonDecode(response.body)["access_token"]);
  await prefs.setInt('timestamp', timeStamp);
  return jsonDecode(response.body)["access_token"];
}

getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var timeStamp = prefs.getInt('timestamp');
  if (timeStamp != null) {
    var dtimeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    var now = new DateTime.now();
    var difference = now.difference(dtimeStamp);
    if (difference.inHours >= 1) {
      token = await mintToken();
      return token;
    } else {
      return token;
    }
  } else {
    token = await mintToken();
    return token;
  }
}
