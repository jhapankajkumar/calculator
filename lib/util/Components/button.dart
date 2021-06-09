import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Constants/constants.dart';

Container genericButton({required String title, required Function? onPress}) {
  return Container(
    height: buttonContainerSize,
    child: CupertinoButton(
        child: Text(
          title,
          style: buttonStyle,
        ),
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: appTheme.accentColor,
        disabledColor: Colors.grey,
        onPressed: onPress != null
            ? () {
                onPress();
              }
            : null),
  );
}
