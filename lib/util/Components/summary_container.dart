import 'package:calculator/util/Components/button.dart';
import 'package:calculator/util/Components/radio_list.dart';
import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/Constants/string_constants.dart';
import 'package:calculator/util/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildSummeryContainer({required BuildContext context, Widget? child}) {
  double deviceWidth = MediaQuery.of(context).size.width;

  var container = Container();
  if (child != null) {
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
              child
            ],
          ),
        ],
      ),
    );
  }
  return container;
}

Widget? buildSummaryViews(
    {required String expectedAmountTitle,
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
  return totalExpectedAmount != null
      ? Column(
          children: [
            SizedBox(
              height: 10,
            ),
            // Expected Amount
            buildSummaryRow(totalExpectedAmount, expectedAmountTitle),
            devider(),
            // Invested Amount
            buildSummaryRow(totalInvestedAmount, investedAmountTitle),
            devider(),
            buildSummaryRow(totalGainAmount, wealthGainTitle),
            // Wealth Gain/Lost
            SizedBox(height: 20),
            isDetail != null
                ? genericButton(title: "Detail", onPress: onTapDetail)
                : Container(),
            SizedBox(height: 10),
          ],
        )
      : Container();
}

Widget? buildEMISummaryViews(
    {double? loanAmount,
    double? totalPaymentAmount,
    double? totalInterestAmount,
    double? emiAmount,
    double? period,
    bool? isDetail,
    Function? onTapDetail}) {
  return totalPaymentAmount != null
      ? Column(
          children: [
            SizedBox(
              height: 10,
            ),
            // EMI Amount
            buildSummaryRow(emiAmount, StringConstants.loanEMI),
            devider(),
            // Invested Amount
            buildSummaryRow(loanAmount, StringConstants.loanAmount),
            devider(),
            buildSummaryRow(
                totalInterestAmount, StringConstants.totalInterestPayable),
            devider(),
            buildSummaryRow(totalPaymentAmount, StringConstants.totalPayment),
            // Wealth Gain/Lost
            SizedBox(height: 20),
            isDetail != null
                ? genericButton(title: "Detail", onPress: onTapDetail)
                : Container(),
            SizedBox(height: 10),
          ],
        )
      : Container();
}

Widget? buildTargetSummaryViews({
  required BuildContext context,
  required String expectedAmountTitle,
  required String investedAmountTitle,
  required String wealthGainTitle,
  double? totalExpectedAmount,
  double? totalInvestedAmount,
  double? totalGainAmount,
  double? sipAmount,
  double? lumpsum,
  double? targetAmount,
  double? period,
}) {
  return sipAmount != null
      ? Column(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                // Expected Amount
                buildSummaryRow(targetAmount, StringConstants.targetAmount),
                devider(),
                buildPeriodRow(period, StringConstants.futureInvestmentPeriod),
                devider(),
                buildSummaryRow(sipAmount, StringConstants.monthlySIPRequired),
                devider(),
                buildSummaryRow(lumpsum, StringConstants.lumpsumRequired),
                devider(),
                buildSummaryRow(totalInvestedAmount,
                    StringConstants.totalAmountInvestedInSIP),
                devider(),
                buildSummaryRow(totalGainAmount, StringConstants.wealthGain),
                SizedBox(height: 10),
              ],
            ),
          ],
        )
      : Container();
}

Widget? buildSWPSummaryViews(
    {double? totalInvestmentAmount,
    double? totalProfit,
    double? totalWithdrawal,
    double? endBalance,
    double? widthdrawalAmount,
    double? withdrawalPeriod,
    Compounding? withdrawalFrequency,
    int? moneyFinishedAtMonth,
    Function? onTapDetail}) {
  double val = (moneyFinishedAtMonth ?? 0) / 12;
  int years = val.toInt();
  int months = (moneyFinishedAtMonth ?? 0) % 12;
  return widthdrawalAmount != null
      ? Column(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                // Expected Amount
                buildSummaryRow(
                    totalInvestmentAmount, StringConstants.totalInvestment),
                devider(),
                buildSummaryRow(
                    totalWithdrawal, StringConstants.totalWithdrawal),
                devider(),
                buildSummaryRow(totalProfit, StringConstants.totalProfit),
                devider(),
                buildSummaryRow(endBalance, StringConstants.balanceLeft),
                // devider(),
                //buildSummaryRow(totalGainAmount, StringConstants.wealthGain),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: appTheme.accentColor, width: 1.0),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[80]),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: moneyFinishedAtMonth == null
                        ? RichText(
                            text: TextSpan(
                              text: '',
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'You would have total amount ',
                                  style: subTitle2,
                                ),
                                TextSpan(
                                    text:
                                        '\$${k_m_b_generator(endBalance ?? 0)} ',
                                    style: subTitle1),
                                TextSpan(
                                    text: 'after withdrawing ',
                                    style: subTitle2),
                                TextSpan(
                                    text:
                                        '\$${k_m_b_generator(widthdrawalAmount)} ',
                                    style: subTitle1),
                                TextSpan(
                                    text:
                                        '${getCompoundingTitle(withdrawalFrequency)} ',
                                    style: subTitle2),
                                TextSpan(text: 'in ', style: subTitle2),
                                TextSpan(
                                    text:
                                        '${withdrawalPeriod?.toInt()} Year(s)',
                                    style: subTitle1),
                              ],
                            ),
                          )
                        : RichText(
                            text: TextSpan(
                              text: '',
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'In ',
                                  style: subTitle2,
                                ),
                                TextSpan(text: '$years ', style: subTitle1),
                                TextSpan(
                                  text: years > 1 ? 'Years ' : 'Year ',
                                  style: subTitle2,
                                ),
                                months > 0
                                    ? TextSpan(
                                        text: '$months ', style: subTitle1)
                                    : TextSpan(),
                                months > 0
                                    ? TextSpan(
                                        text: years > 1 ? 'Months ' : 'Month ',
                                        style: subTitle2,
                                      )
                                    : TextSpan(),
                                TextSpan(
                                  text: 'Your Investment Would Finish ',
                                  style: subTitle2,
                                ),

                                // TextSpan(text: ' 0 ', style: subTitle1),
                                TextSpan(
                                    text: 'after withdrawing ',
                                    style: subTitle2),
                                TextSpan(
                                    text:
                                        '\$${k_m_b_generator(widthdrawalAmount)} ',
                                    style: subTitle1),
                                TextSpan(
                                    text:
                                        '${getCompoundingTitle(withdrawalFrequency).toLowerCase()}. ',
                                    style: subTitle2),
                                // TextSpan(text: 'for ', style: subTitle2),
                              ],
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 20),
                genericButton(title: "Detail", onPress: onTapDetail),

                SizedBox(height: 40),
              ],
            ),
          ],
        )
      : Container();
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
                  (amount ?? 0) < 1
                      ? '${amount?.toStringAsFixed(3)}'
                      : '\$${k_m_b_generator(amount ?? 0)}',
                  textAlign: TextAlign.end,
                  style: subTitle1,
                )
              : (amount?.isNaN == true
                  ? Text('\$0', style: subTitle1)
                  : Text('\$INFINITE', style: subTitle1)),
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
