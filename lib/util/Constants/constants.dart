import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData(
  primaryColor: Color(0xffEFEFEF),
  accentColor: Color(0xff212E51),
  fontFamily: 'Oxygen',
  scaffoldBackgroundColor: Color(0xffEFEFEF),
  brightness: Brightness.light,
  textTheme: TextTheme(
    bodyText1: TextStyle(
        fontSize: 20.0, fontWeight: FontWeight.normal, color: Colors.white),
    bodyText2: TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.bold, color: Color(0xff212E51)),
    caption: TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.bold,
      color: Color(0xff212E51),
    ),
    subtitle1: TextStyle(
        fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xff212E51)),
    subtitle2: TextStyle(
        fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black54),
  ),
);

TextStyle subTitle1 = TextStyle(
    fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xff212E51));
TextStyle subTitle2 = TextStyle(
    fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xffFF4611));
