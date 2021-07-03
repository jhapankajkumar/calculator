import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/utility.dart';
import 'package:flutter/material.dart';

Widget buildErrorView(ErrorType? errorType) {
  return Row(
    children: [
      Flexible(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Text(
            errorType == null ? "" : getErrorMessageFromType(errorType),
            style: caption3,
          ),
        ),
      ),
    ],
  );
}
