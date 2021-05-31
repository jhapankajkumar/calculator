import 'package:calculator/util/Constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Screens/landing_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: appTheme.primaryColor, // status bar color
    ));
    return MaterialApp(
      title: 'Calculator',
      theme: appTheme,
      home: LandingPage(title: 'Calculator'),
      debugShowCheckedModeBanner: false,
    );
  }
}
