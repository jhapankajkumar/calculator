import 'dart:math';
import 'package:calculator/Screens/sip_projection_list.dart';
import 'package:calculator/util/Components/appbar.dart';
import 'package:calculator/util/Components/base_container.dart';
import 'package:calculator/util/Components/button.dart';
import 'package:calculator/util/Components/piechartsection.dart';
import 'package:calculator/util/Components/summary_container.dart';
import 'package:calculator/util/Components/text_field_container.dart';
import 'package:calculator/util/sip_data.dart';
import 'package:calculator/util/Constants/string_constants.dart';
import 'package:calculator/util/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SIPCalculator extends StatefulWidget {
  SIPCalculator({Key? key, required this.title, required this.isSteupUp})
      : super(key: key);
  final String title;
  final bool isSteupUp;

  @override
  _SIPCalculatorState createState() => _SIPCalculatorState();
}

class _SIPCalculatorState extends State<SIPCalculator> {
  double? corpusAmount;
  double? amount;
  double? rate;
  double? inflationrate;
  double? period;

  double? wealthGain;
  double? investedAmount;
  TextFieldFocus? currentFocus;
  double? stepUpPercentage;

  SIPData detail = SIPData();
  String? errorText;

  _calculateSIP() {
    var helper = UtilityHelper();
    detail.amount = amount;
    detail.interestRate = rate;
    detail.duration = period;
    detail.increase = stepUpPercentage;
    if (widget.isSteupUp && stepUpPercentage != null) {
      var stepupFinalAmount = 0.0;
      var stepupInvestAmount = 0.0;
      var stepupInterestAmount = 0.0;
      var sipAmount = amount;
      var totalInvestAmount = sipAmount;
      var s = (stepUpPercentage ?? 0) / 100;
      var n = (period ?? 0) * 12;
      var roi = (rate ?? 0) / 100 / 12;
      var value3 = 1 + roi;
      var value4 = pow(value3, n);
      var finalValue = (sipAmount ?? 0) * value4;
      n = n - 1;
      while (n > 0) {
        if (n % 12 > 0) {
          sipAmount = sipAmount;
          totalInvestAmount = (totalInvestAmount ?? 0) + (sipAmount ?? 0);
          var value4 = pow(value3, n);
          finalValue = finalValue + (sipAmount ?? 0) * value4;
          n = n - 1;
        } else {
          sipAmount = (sipAmount ?? 0) + ((sipAmount ?? 0) * s);
          totalInvestAmount = (totalInvestAmount ?? 0) + sipAmount;
          var value4 = pow(value3, n);
          finalValue = finalValue + sipAmount * value4;
          n = n - 1;
        }
      }
      stepupFinalAmount = finalValue.roundToDouble();
      stepupInvestAmount = (totalInvestAmount ?? 0).roundToDouble();
      stepupInterestAmount = stepupFinalAmount - stepupInvestAmount;
      stepupInterestAmount = stepupInterestAmount.roundToDouble();

      setState(() {
        investedAmount = stepupInvestAmount;
        corpusAmount = stepupFinalAmount;
        wealthGain = stepupInterestAmount;
        currentFocus = null;
      });
    } else {
      corpusAmount = helper
          .getCorpusAmount(
              amount ?? 0, rate ?? 0, period ?? 0, inflationrate, false, false)
          .roundToDouble();
      setState(() {
        investedAmount = (amount ?? 0) * (period ?? 0) * 12;
        wealthGain = (corpusAmount ?? 0) - (investedAmount ?? 0);
        currentFocus = null;
      });
    }
  }

  bool isAllInputValid() {
    bool isValid = true;
    if (errorText != null) {
      isValid = false;
    }
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
      _calculateSIP();
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

  void _removeFocus() {
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

  void _onDetailButtonTap() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return SIPProjetionList(detail);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(title: widget.title, context: context),
        body: baseContainer(
            context: context,
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
                        totalExpectedAmount: corpusAmount,
                        totalGainAmount: wealthGain,
                        totalInvestedAmount: investedAmount,
                        isDetail: true,
                        onTapDetail: _onDetailButtonTap),
                    SizedBox(
                      height: 20,
                    ),
                    buildGraphContainer(
                        context: context,
                        totalExpectedAmount: corpusAmount,
                        totalGainAmount: wealthGain,
                        totalInvestedAmount: investedAmount,
                        gainTitle: StringConstants.wealthGain,
                        investedTitle: StringConstants.amountInvested),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )),
            onTap: _removeFocus));
  }

  Widget buildInputContainer(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
        width: deviceWidth,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.fromLTRB(8, 10, 8, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          buildTextFieldContainerSection(
              textFieldType: TextFieldFocus.amount,
              placeHolder: "5000",
              textLimit: 15,
              containerTitle: StringConstants.monthlyInvestmentAmount,
              focus: currentFocus,
              onFocusChange: _onFocusChange,
              onTextChange: _onTextChange),
          SizedBox(height: 20),
          buildTextFieldContainerSection(
              textFieldType: TextFieldFocus.period,
              placeHolder: "12 Years",
              textLimit: 3,
              containerTitle: StringConstants.investmentPeriod,
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
          SizedBox(height: 20),
          widget.isSteupUp
              ? buildTextFieldContainerSection(
                  textFieldType: TextFieldFocus.stepUp,
                  placeHolder: "10",
                  textLimit: 5,
                  containerTitle:
                      StringConstants.annualPercentageIncreamntOnSip,
                  focus: currentFocus,
                  onFocusChange: _onFocusChange,
                  onTextChange: _onTextChange)
              : Container(),
          widget.isSteupUp ? SizedBox(height: 20) : Container(),
          SizedBox(height: 20),
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
