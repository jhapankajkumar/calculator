import 'package:flutter/cupertino.dart';

import '../Constants/constants.dart';
import 'indicator.dart';
import 'piechart.dart';

Widget buildGraphContainer({
  required BuildContext context,
  required String gainTitle,
  required String investedTitle,
  double? totalExpectedAmount,
  double? totalInvestedAmount,
  double? totalGainAmount,
}) {
  double deviceWidth = MediaQuery.of(context).size.width;
  var container = Container();
  double? gainPercentage =
      _getGainPercentage(totalExpectedAmount, totalGainAmount);
  double? investmentPercentage =
      _getInvestmentPercentage(totalExpectedAmount, totalInvestedAmount);

  String? wealthGainValue =
      "$gainTitle (${gainPercentage.toStringAsFixed(2)}%)";
  String? investedAmountValue =
      "$investedTitle (${investmentPercentage.toStringAsFixed(2)}%)";
  if (totalGainAmount != null) {
    container = Container(
        width: deviceWidth,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.fromLTRB(8, 20, 8, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: appTheme.primaryColor,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Indicator(
                  color: Color(0xff31944a),
                  text: wealthGainValue,
                  isSquare: false,
                  textColor: appTheme.accentColor,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xffFF4611),
                  text: investedAmountValue,
                  isSquare: false,
                  textColor: appTheme.accentColor,
                ),
                SizedBox(
                  height: 18,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          totalGainAmount != null
              ? Chart(
                  corpusAmount: totalExpectedAmount,
                  wealthGain: totalGainAmount,
                  amountInvested: totalInvestedAmount,
                )
              : Container(),
        ]));
  }
  return container;
}

double _getGainPercentage(
  double? totalExpectedAmount,
  double? totalGainAmount,
) {
  if ((totalGainAmount ?? 0) < 0) {
    return 0;
  }
  if (totalGainAmount?.isInfinite ?? false) {
    return 100;
  }
  return (totalGainAmount ?? 0) / (totalExpectedAmount ?? 0) * 100;
}

double _getInvestmentPercentage(
  double? totalExpectedAmount,
  double? totalInvestedAmount,
) {
  if ((totalInvestedAmount ?? 0) < 0) {
    return 0;
  }
  return (totalInvestedAmount ?? 0) / (totalExpectedAmount ?? 0) * 100;
}
