import 'package:flutter/material.dart';
import '../Constants/constants.dart';

AppBar appBar(
    {required String title,
    required BuildContext context,
    bool? isBackButton}) {
  return AppBar(
    leading: leading(context),
    title: new Text(
      title,
      style: appTheme.textTheme.bodyText2,
    ),
    backgroundColor: appTheme.primaryColor,
    elevation: 0.0,
  );
}

Container leading(BuildContext context) {
  return Container(
    margin: EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.transparent,
          spreadRadius: 8,
          blurRadius: 2,
          offset: Offset(1, 1), // changes position of shadow
        )
      ],
    ),
    child: Center(
      child: IconButton(
        icon: Icon(Icons.arrow_back, color: appTheme.accentColor),
        onPressed: () => Navigator.of(context).pop(),
      ),
    ),
  );
}
