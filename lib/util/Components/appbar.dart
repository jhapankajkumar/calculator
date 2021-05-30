import 'package:flutter/material.dart';
import '../constants.dart';

class AppNavigationBar extends StatelessWidget {
  final String title;
  const AppNavigationBar({Key? key, required this.title}) : super(key: key);
  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      title: new Text(title),
      backgroundColor: appTheme.primaryColor,
      elevation: 0.0,
    );
  }
}
