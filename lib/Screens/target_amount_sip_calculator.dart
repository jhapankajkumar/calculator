import 'dart:math';

import 'package:calculator/util/Components/appbar.dart';
import 'package:calculator/util/Components/button.dart';
import 'package:calculator/util/Components/piechartsection.dart';
import 'package:calculator/util/Components/summary_container.dart';
import 'package:calculator/util/Components/text_field_container.dart';
import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/Components/indicator.dart';
import 'package:calculator/util/Components/piechart.dart';
import 'package:calculator/util/sip_data.dart';
import 'package:calculator/util/Constants/string_constants.dart';
import 'package:calculator/util/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TargetAmountSIPCalculator extends StatefulWidget {
  TargetAmountSIPCalculator({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _TargetAmountSIPCalculatorState createState() =>
      _TargetAmountSIPCalculatorState();
}

class _TargetAmountSIPCalculatorState extends State<TargetAmountSIPCalculator> {
  double? sipAmount;
  double? amount;
  double? rate;
  double? inflationrate;
  double? period;

  double? wealthGain;
  double? investedAmount;
  TextFieldFocus? currentFocus;
  double? stepUpPercentage;

  SIPData detail = SIPData();

  _calculateTargetAmount() {
    var helper = UtilityHelper();
    detail.amount = amount;
    detail.interestRate = rate;
    detail.duration = period;
    detail.increase = stepUpPercentage;
    double montlyAmount = helper
        .getSIPAmount(
            amount ?? 0, rate ?? 0, period ?? 0, inflationrate, false, false)
        .roundToDouble();
    setState(() {
      sipAmount = montlyAmount;
      investedAmount = (sipAmount ?? 0) * (period ?? 0) * 12;
      wealthGain = (amount ?? 0) - (investedAmount ?? 0);
      currentFocus = null;
    });
  }

  final formatter = new NumberFormat("#,###");
  bool isAllInputValid() {
    bool isValid = true;
    if (rate == null) {
      isValid = false;
    }
    if (amount == null) {
      isValid = false;
    }
    if (period == null) {
      isValid = false;
    }
    return isValid;
  }

  void _calculateButtonTapped() {
    {
      _calculateTargetAmount();
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }
  }

  _onTextChange(TextFieldFocus? textField, String value) {
    bool emptyString = value.length == 0;
    double inputtedValue = 0;
    if (emptyString == false) {
      inputtedValue = double.parse(value);
    }
    if (textField == TextFieldFocus.amount) {
      setState(() {
        if (inputtedValue > 0) {
          amount = inputtedValue;
        } else {
          amount = null;
        }
      });
    }

    if (textField == TextFieldFocus.period) {
      setState(() {
        if (inputtedValue > 0) {
          period = inputtedValue;
        } else {
          period = null;
        }
      });
    }

    if (textField == TextFieldFocus.interestRate) {
      setState(() {
        if (inputtedValue > 0) {
          rate = inputtedValue;
        } else {
          rate = null;
        }
      });
    }

    if (textField == TextFieldFocus.stepUp) {
      setState(() {
        if (inputtedValue > 0) {
          stepUpPercentage = inputtedValue;
        } else {
          stepUpPercentage = null;
        }
      });
    }
  }

  _onFocusChange(TextFieldFocus? textField, bool value) {
    if (value == true) {
      setState(() {
        currentFocus = textField;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: appBar(title: widget.title, context: context),
        body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
              if (this.currentFocus != null) {
                setState(() {
                  this.currentFocus = null;
                });
              }
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              width: deviceWidth,
              height: deviceHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24)),
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
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      buildInputContainer(context),
                      SizedBox(
                        height: 20,
                      ),
                      buildSummeryContainer(
                          context: context,
                          expectedAmountTitle: StringConstants.expectedAmount,
                          investedAmountTitle: StringConstants.investedAmount,
                          wealthGainTitle: StringConstants.wealthGain,
                          targetAmount: amount,
                          period: period,
                          sipAmount: sipAmount,
                          totalGainAmount: wealthGain,
                          totalInvestedAmount: investedAmount,
                          isTargetAmount: true),
                      SizedBox(
                        height: 20,
                      ),
                      buildGraphContainer(
                          context: context,
                          totalExpectedAmount: amount,
                          totalGainAmount: wealthGain,
                          totalInvestedAmount: investedAmount,
                          gainTitle: StringConstants.wealthGain,
                          investedTitle: StringConstants.amountInvested),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )),
            )));
  }

  /*Widget buildSummeryContainer(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    var container = Container();
    if (sipAmount != null) {
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
                //summery

                Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    // Expected Amount
                    buildSummaryRow(amount, StringConstants.futureTargetAmout),
                    devider(),
                    buildSummaryRow(
                        period, StringConstants.futureAmountInvestmentPeriod),
                    devider(),
                    buildSummaryRow(
                        sipAmount, StringConstants.monthlySIPRequired),
                    devider(),
                    buildSummaryRow(investedAmount,
                        StringConstants.totalAmountInvestedInSIP),
                    devider(),
                    buildSummaryRow(wealthGain, StringConstants.wealthGain),
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
  }*/

  Widget buildInputContainer(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
        width: deviceWidth,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.fromLTRB(8, 20, 8, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          buildTextFieldContainerSection(
              textFieldType: TextFieldFocus.amount,
              placeHolder: "100000000",
              textLimit: 15,
              containerTitle: StringConstants.futureTargetAmout,
              focus: currentFocus,
              onFocusChange: _onFocusChange,
              onTextChange: _onTextChange),
          SizedBox(height: 20),
          buildTextFieldContainerSection(
              textFieldType: TextFieldFocus.period,
              placeHolder: "12 Years",
              textLimit: 3,
              containerTitle: StringConstants.futureAmountInvestmentPeriod,
              focus: currentFocus,
              onFocusChange: _onFocusChange,
              onTextChange: _onTextChange),
          SizedBox(height: 20),
          buildTextFieldContainerSection(
              textFieldType: TextFieldFocus.interestRate,
              placeHolder: "10",
              textLimit: 5,
              containerTitle: StringConstants.expectedReturn,
              focus: currentFocus,
              onFocusChange: _onFocusChange,
              onTextChange: _onTextChange),
          SizedBox(height: 40),
          Row(children: [
            Expanded(
                child: calculateButton(
                    title: StringConstants.calculate,
                    onPress:
                        isAllInputValid() ? _calculateButtonTapped : null)),
          ])
        ]));
  }
}
