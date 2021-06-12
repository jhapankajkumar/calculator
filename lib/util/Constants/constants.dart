import 'package:flutter/material.dart';

import 'dart:io' show Platform;

import 'package:flutter/widgets.dart';

enum DeviceType { Phone, Tablet }

DeviceType getDeviceType() {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
  return data.size.shortestSide < 550 ? DeviceType.Phone : DeviceType.Tablet;
}

var device = getDeviceType();

//Fonts
double captionFontSize = device == DeviceType.Phone ? 12 : 20;
double subTtitleFontSize = device == DeviceType.Phone ? 16 : 24;
double indicatorFontSize = device == DeviceType.Phone ? 12 : 26;
double bodyText1FontSize = device == DeviceType.Phone ? 20 : 28;
double bodyText2FontSize = device == DeviceType.Phone ? 18 : 26;
double calculateButtonFont = device == DeviceType.Phone ? 20 : 28;

//ComponentsR
double menuContainerSize = device == DeviceType.Phone ? 120 : 220;
double menuImageSize = device == DeviceType.Phone ? 60 : 120;
double chartSectionSize = device == DeviceType.Phone ? 150 : 300;
double chartRadisuSize = device == DeviceType.Phone ? 75 : 150;
double indicatorSize = device == DeviceType.Phone ? 16 : 32;
double buttonContainerSize = device == DeviceType.Phone ? 55 : 80;
double textFieldContainerSize = device == DeviceType.Phone ? 50 : 80;

Color ternaryColor = Color(0xffFA6A30);
Color wealthColor = Color(0xff5c76bc);

ThemeData appTheme = ThemeData(
  primaryColor: Color(0xffEFEFEF),
  accentColor: Color(0xff212E51),
  fontFamily: 'Oxygen',
  scaffoldBackgroundColor: Color(0xffEFEFEF),
  brightness: Brightness.light,
  textTheme: TextTheme(
    bodyText1: TextStyle(
        fontSize: bodyText1FontSize,
        fontWeight: FontWeight.normal,
        color: Colors.white),
    bodyText2: TextStyle(
        fontSize: bodyText2FontSize,
        fontWeight: FontWeight.bold,
        color: Color(0xff212E51)),
    caption: TextStyle(
      fontSize: captionFontSize,
      fontWeight: FontWeight.bold,
      color: Color(0xff212E51),
    ),
    subtitle1: TextStyle(
        fontSize: subTtitleFontSize,
        fontWeight: FontWeight.bold,
        color: Color(0xff212E51)),
    subtitle2: TextStyle(
        fontSize: subTtitleFontSize,
        fontWeight: FontWeight.bold,
        color: Colors.black54),
  ),
);

TextStyle subTitle1 = TextStyle(
    fontSize: subTtitleFontSize,
    fontWeight: FontWeight.bold,
    color: ternaryColor);
TextStyle subTitle2 = TextStyle(
    fontSize: subTtitleFontSize,
    fontWeight: FontWeight.bold,
    color: Color(0xff212E51));
TextStyle caption3 = TextStyle(
  fontSize: captionFontSize,
  fontWeight: FontWeight.normal,
  color: ternaryColor,
);

TextStyle caption2 = TextStyle(
  fontSize: captionFontSize,
  fontWeight: FontWeight.normal,
  color: Color(0xff212E51),
);

TextStyle buttonStyle = TextStyle(
  fontSize: calculateButtonFont,
  fontWeight: FontWeight.normal,
  color: Colors.white,
);

int amountTextLimit = 16;
int periodTextLimit = 3;
int monthsLimit = 2;
int interestRateTextLimit = 5;

enum Screen {
  home,
  sip,
  stepup,
  swp,
  lumpsum,
  fd,
  rd,
  emi,
  loan,
  fv,
  pv,
  target,
  retirement,
  detail,
}
