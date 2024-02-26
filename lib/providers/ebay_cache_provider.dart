import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EbayCacheProvider extends ChangeNotifier {
  List subcategoryData = [];
  List subcategory1Data = [];
  List subcategory2Data = [];
  String _subcategoryStr;
  String _subcategory1Str;
  String _subcategory2Str;

  handleEbayData({String resBody, catName}) async {
    print("wilio333");
    final prefs = await SharedPreferences.getInstance();
    print("uuuuu");
    var s1Data = prefs.getString(catName);
    print("wilio");
    print(s1Data);
    if (s1Data == null) {
      if (resBody != null) {
        getSubStr = resBody;
        await prefs.setString(catName, resBody);
      }
      // await prefs.setStringList(key, value)
    } else {
      if (getSubStr == null) getSubStr = s1Data;
      return s1Data;
    }
  }

  handleScndEbayData(String resBody, catName) async {
    final prefs = await SharedPreferences.getInstance();

    var s2Data = await prefs.getString(catName);
    if (s2Data == null) {
      if (resBody != null) {
        getSubStr1 = resBody;
        await prefs.setString(catName, resBody);
      }
      print("igwe");
      // await prefs.setStringList(key, value)
    } else {
      return s2Data;
    }
  }

  String get getSubStr => _subcategoryStr;
  set getSubStr(val) {
    _subcategoryStr = val;
    notifyListeners();
  }

  String get getSubStr1 => _subcategory1Str;
  set getSubStr1(val) {
    _subcategory1Str = val;
    notifyListeners();
  }

  String get getSubStr2 => _subcategory2Str;
  set getSubStr2(val) {
    _subcategory2Str = val;
    notifyListeners();
  }
}
