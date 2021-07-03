import 'dart:io';
import 'dart:math';

import 'package:calculator/util/Components/appbar.dart';
import 'package:calculator/util/Components/button.dart';
import 'package:calculator/util/Components/error_message_view.dart';
import 'package:calculator/util/Components/piechartsection.dart';
import 'package:calculator/util/Components/summary_container.dart';
import 'package:calculator/util/Components/text_field_container.dart';
import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/Constants/string_constants.dart';
import 'package:calculator/util/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TargetAmountSIPCalculator extends StatefulWidget {
  TargetAmountSIPCalculator({Key? key, required this.category})
      : super(key: key);
  final Screen category;

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
  double? lumpsumAmount;
  double? targetAmount;
  bool isInvalidPeriod = false;
  bool isInvalidInterest = false;
  _calculateTargetAmount() {
    var helper = UtilityHelper();
    double montlyAmount = helper.getSIPAmount(
        amount ?? 0, rate ?? 0, period ?? 0, inflationrate, false, false);
    print(montlyAmount);
    if (montlyAmount > 1) {
      montlyAmount = montlyAmount.roundToDouble();
    }
    var lumpsum = helper.getLumpsumValueAmount(
        amount ?? 0, rate ?? 0, period ?? 0, 1, null, false);
    setState(() {
      sipAmount = montlyAmount;
      lumpsumAmount = lumpsum;
      targetAmount = amount;
      investedAmount = (sipAmount ?? 0) * (period ?? 0) * 12;
      wealthGain = (amount ?? 0) - (investedAmount ?? 0);
      currentFocus = null;
    });
  }

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
    if (isInvalidPeriod) {
      isValid = false;
    }
    if (isInvalidInterest) {
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
          validatePeriod();
        } else {
          period = null;
        }
      });
    }

    if (textField == TextFieldFocus.interestRate) {
      setState(() {
        if (inputtedValue > 0) {
          rate = inputtedValue;
          validateInterest();
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
    } else {
      if (textField == TextFieldFocus.period) {
        validatePeriod();
      } else if (textField == TextFieldFocus.interestRate) {
        validateInterest();
      }
    }
  }

  void validatePeriod() {
    setState(() {
      if ((period ?? 0) > periodYearMaxValue) {
        isInvalidPeriod = true;
      } else {
        isInvalidPeriod = false;
      }
    });
  }

  void validateInterest() {
    setState(() {
      if ((rate ?? 0) > interestRateMaxValue) {
        isInvalidInterest = true;
      } else {
        isInvalidInterest = false;
      }
    });
  }

  void removeFocus() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (this.currentFocus != null) {
      setState(() {
        this.currentFocus = null;
      });
    }
  }

  _onDoneButtonTapped() {
    setState(() {
      removeFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: appBar(category: widget.category, context: context),
        body: GestureDetector(
            onTap: () {
              removeFocus();
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
                      sipAmount != null
                          ? buildSummeryContainer(
                              context: context,
                              child: buildTargetSummaryViews(
                                context: context,
                                expectedAmountTitle:
                                    StringConstants.expectedAmount,
                                investedAmountTitle:
                                    StringConstants.investedAmount,
                                wealthGainTitle: StringConstants.wealthGain,
                                targetAmount: targetAmount,
                                lumpsum: lumpsumAmount,
                                period: period,
                                sipAmount: sipAmount,
                                totalGainAmount: wealthGain,
                                totalInvestedAmount: investedAmount,
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: 20,
                      ),
                      buildGraphContainer(
                          context: context,
                          totalExpectedAmount: targetAmount,
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

  Widget buildInputContainer(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
        width: deviceWidth,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.fromLTRB(8, 20, 8, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          buildTextFieldContainerSection(
              textField: TextFieldFocus.amount,
              textFieldType: TextFieldType.number,
              placeHolder: "100000000",
              textLimit: amountTextLimit,
              containerTitle: StringConstants.futureTargetAmout,
              focus: currentFocus,
              onFocusChange: _onFocusChange,
              onTextChange: _onTextChange,
              onDoneButtonTapped: _onDoneButtonTapped),
          SizedBox(height: 20),
          buildTextFieldContainerSection(
              textField: TextFieldFocus.period,
              textFieldType: TextFieldType.number,
              placeHolder: "12 Years",
              textLimit: periodTextLimit,
              containerTitle: StringConstants.futureAmountInvestmentPeriod,
              focus: currentFocus,
              onFocusChange: _onFocusChange,
              onTextChange: _onTextChange,
              onDoneButtonTapped: _onDoneButtonTapped,
              isError: isInvalidPeriod),
          isInvalidPeriod == true
              ? buildErrorView(ErrorType.maxPeriodYears)
              : Container(),
          SizedBox(height: 20),
          buildTextFieldContainerSection(
              textField: TextFieldFocus.interestRate,
              textFieldType: TextFieldType.decimal,
              placeHolder: "10",
              textLimit: interestRateTextLimit,
              containerTitle: StringConstants.expectedReturn,
              focus: currentFocus,
              onFocusChange: _onFocusChange,
              onTextChange: _onTextChange,
              onDoneButtonTapped: _onDoneButtonTapped,
              isError: isInvalidInterest),
          isInvalidInterest == true
              ? buildErrorView(ErrorType.maxReturnRate)
              : Container(),
          SizedBox(height: 40),
          Row(children: [
            Expanded(
                child: genericButton(
                    title: StringConstants.calculate,
                    onPress:
                        isAllInputValid() ? _calculateButtonTapped : null)),
          ])
        ]));
  }
}
