import 'package:calculator/util/Components/button.dart';
import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/Constants/string_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = new NumberFormat("##,###");

Widget buildSummeryContainer(
    {required BuildContext context,
    required String expectedAmountTitle,
    required String investedAmountTitle,
    required String wealthGainTitle,
    double? totalExpectedAmount,
    double? totalInvestedAmount,
    double? totalGainAmount,
    double? sipAmount,
    double? targetAmount,
    double? period,
    bool? isDetail,
    bool? isTargetAmount,
    Function? onTapDetail}) {
  double deviceWidth = MediaQuery.of(context).size.width;

  var container = Container();
  if (totalGainAmount != null) {
    container = Container(
      width: deviceWidth,
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.fromLTRB(8, 20, 8, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: appTheme.primaryColor,
      ),
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                color: appTheme.accentColor,
                padding: EdgeInsets.all(8),
                width: deviceWidth,
                child: Text(
                  StringConstants.summary,
                  style: appTheme.textTheme.bodyText1,
                ),
              ),
              isTargetAmount == null
                  ? Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        // Expected Amount
                        buildSummaryRow(
                            totalExpectedAmount, expectedAmountTitle),
                        devider(),
                        // Invested Amount
                        buildSummaryRow(
                            totalInvestedAmount, investedAmountTitle),
                        devider(),
                        buildSummaryRow(totalGainAmount, wealthGainTitle),
                        // Wealth Gain/Lost

                        SizedBox(height: 20),
                        isDetail != null
                            ? genericButton(
                                title: "Detail", onPress: onTapDetail)
                            : Container(),
                        SizedBox(height: 10),
                      ],
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        // Expected Amount
                        buildSummaryRow(
                            targetAmount, StringConstants.targetAmount),
                        devider(),
                        buildPeriodRow(
                            period, StringConstants.futureInvestmentPeriod),
                        devider(),
                        buildSummaryRow(
                            sipAmount, StringConstants.monthlySIPRequired),
                        devider(),
                        buildSummaryRow(totalInvestedAmount,
                            StringConstants.totalAmountInvestedInSIP),
                        devider(),
                        buildSummaryRow(
                            totalGainAmount, StringConstants.wealthGain),
                        SizedBox(height: 10),
                      ],
                    ),
            ],
          ),
        ],
      ),
    );
  }
  return container;
}

Widget devider() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: 1,
      color: appTheme.accentColor,
    ),
  );
}

Widget buildSummaryRow(double? amount, String title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        child: ListTile(
          title: Text(
            title,
            style: subTitle2,
          ),
        ),
      ),
      Expanded(
        child: ListTile(
          title: amount?.isInfinite == false
              ? Text(
                  '\$${formatter.format(amount)}',
                  textAlign: TextAlign.end,
                  style: subTitle1,
                )
              : Text('\$INFINITE', style: subTitle1),
        ),
      ),
    ],
  );
}

Widget buildPeriodRow(double? amount, String title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        child: ListTile(
          title: Text(
            title,
            style: subTitle2,
          ),
        ),
      ),
      Expanded(
        child: ListTile(
          title: amount?.isInfinite == false
              ? Text(
                  amount != null ? '${amount.toInt()}' : "",
                  style: subTitle1,
                  textAlign: TextAlign.right,
                )
              : Text('\$INFINITE', style: subTitle1),
        ),
      ),
    ],
  );
}
