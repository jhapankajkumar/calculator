import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/Constants/string_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = new NumberFormat("#,###");
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
                  "Summary",
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

                        SizedBox(height: 10),
                        isDetail != null
                            ? CupertinoButton(
                                child: Text("Detail"),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: appTheme.accentColor,
                                disabledColor: Colors.grey,
                                onPressed: () {
                                  if (onTapDetail != null) {
                                    onTapDetail();
                                  }
                                },
                              )
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
                            targetAmount, StringConstants.futureTargetAmout),
                        devider(),
                        buildSummaryRow(period,
                            StringConstants.futureAmountInvestmentPeriod),
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
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        child: ListTile(
          title: Text(title),
        ),
      ),
      Expanded(
        child: ListTile(
          title: amount?.isInfinite == false
              ? Text(
                  '\$${formatter.format(amount)}',
                  style: subTitle2,
                )
              : Text('\$INFINITE', style: subTitle2),
        ),
      ),
    ],
  );
}

Widget buildDescriptionRow(double? amount, String title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        child: ListTile(
          title: RichText(
            text: TextSpan(
              text: 'You require monthly SIP of amount ',
              style: subTitle1,
              children: <TextSpan>[
                TextSpan(
                    text: '\$${formatter.format(amount)}', style: subTitle2),
                TextSpan(text: ' to achieve your target amount.'),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
