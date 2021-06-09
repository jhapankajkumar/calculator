import 'package:calculator/util/Constants/constants.dart';
import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final Color? color;
  final String? text;
  final bool? isSquare;
  final double? size;
  final Color? textColor;

  const Indicator({
    required this.color,
    this.text,
    required this.isSquare,
    this.size,
    this.textColor = const Color(0xff505050),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: (isSquare ?? false) ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          child: Text(
            text ?? "",
            maxLines: 2,
            style: TextStyle(
                fontSize: indicatorFontSize,
                fontWeight: FontWeight.bold,
                color: textColor),
          ),
        )
      ],
    );
  }
}
