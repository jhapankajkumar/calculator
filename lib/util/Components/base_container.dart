import 'package:flutter/material.dart';

Widget baseContainer(
    {required BuildContext context, required Widget child, Function? onTap}) {
  double deviceWidth = MediaQuery.of(context).size.width;
  double deviceHeight = MediaQuery.of(context).size.height;

  return GestureDetector(
    onTap: () {
      if (onTap != null) {
        onTap();
      }
    },
    child: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        width: deviceWidth,
        height: deviceHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24)),
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
        child: child),
  );
}
