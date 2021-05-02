import 'package:flutter/material.dart';

class SharedDataManager {
  static final SharedDataManager _singleton = new SharedDataManager._internal();
  factory SharedDataManager() {
    return _singleton;
  }
  SharedDataManager._internal();
  int menuSelectedIndex = -1;
}

ThemeData appTheme = ThemeData(
    primaryColor: Color(0xFF303030),
    accentColor: Color(0xFF535556),
    fontFamily: 'Oxygen',
    brightness: Brightness.dark);

TextStyle titleStyle =
    TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white);

TextStyle lableStyle = TextStyle(
    fontSize: 13.0, fontWeight: FontWeight.bold, color: Colors.black54);
TextStyle textFieldTextStyle = TextStyle(
    fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black45);
TextStyle headerTextStyle = TextStyle(
    fontSize: 20.0, fontWeight: FontWeight.normal, color: Colors.black45);
