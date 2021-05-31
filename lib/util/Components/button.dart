import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Constants/constants.dart';

CupertinoButton calculateButton(
    {required String title, required Function? onPress}) {
  return CupertinoButton(
      child: Text(title),
      borderRadius: BorderRadius.all(Radius.circular(8)),
      color: appTheme.accentColor,
      disabledColor: Colors.grey,
      onPressed: onPress != null
          ? () {
              onPress();
            }
          : null);
}
