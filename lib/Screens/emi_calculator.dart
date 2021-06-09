import 'package:calculator/util/Components/appbar.dart';
import 'package:calculator/util/Components/base_container.dart';
import 'package:calculator/util/Components/button.dart';
import 'package:calculator/util/Components/piechartsection.dart';
import 'package:calculator/util/Components/summary_container.dart';
import 'package:calculator/util/Components/text_field_container.dart';
import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/Constants/string_constants.dart';
import 'package:calculator/util/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EMICalculator extends StatefulWidget {
  final String title;
  EMICalculator({
    Key? key,
    required this.title,
  });
  @override
  _EMICalculatorState createState() => _EMICalculatorState();
}

class _EMICalculatorState extends State<EMICalculator> {
  double? loanEMIAmount;
  double? totalIntrestPayble;
  double? totalPayment;
  double? amount;
  double? rate;
  double? period;
  double? loanAmount;
  TextFieldFocus? currentFocus;
  _calculateAmount() {
    removeFocus();
    var helper = UtilityHelper();
    loanEMIAmount = helper
        .getInstallmentAmount(amount ?? 0, period ?? 0, rate ?? 0)
        .roundToDouble();
    setState(() {
      loanAmount = amount;
      totalPayment = (loanEMIAmount ?? 0) * (period ?? 0);
      totalIntrestPayble = (totalPayment ?? 0) - (loanAmount ?? 0);
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
  }

  _onFocusChange(TextFieldFocus? textField, bool value) {
    if (value == true) {
      setState(() {
        currentFocus = textField;
      });
    }
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

  void _calculateButtonTapped() {
    {
      _calculateAmount();
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }
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
                      expectedAmountTitle: StringConstants.loanEMI,
                      investedAmountTitle: StringConstants.totalInterestPayable,
                      wealthGainTitle: StringConstants.totalPayment,
                      totalExpectedAmount: loanEMIAmount,
                      totalGainAmount: totalPayment,
                      totalInvestedAmount: totalIntrestPayble,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    buildGraphContainer(
                        context: context,
                        totalExpectedAmount: totalPayment,
                        totalGainAmount: totalIntrestPayble,
                        totalInvestedAmount: loanAmount,
                        gainTitle: StringConstants.totalInterest,
                        investedTitle: StringConstants.principalLoanAmount),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                )),
            onTap: removeFocus));
  }

  Widget buildInputContainer(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
        width: deviceWidth,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.fromLTRB(8, 20, 8, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          buildTextFieldContainerSection(
              textFieldType: TextFieldFocus.amount,
              placeHolder: "50000000",
              textLimit: amountTextLimit,
              containerTitle: StringConstants.loanAmount,
              focus: currentFocus,
              onFocusChange: _onFocusChange,
              onTextChange: _onTextChange),
          SizedBox(height: 20),
          buildTextFieldContainerSection(
              textFieldType: TextFieldFocus.period,
              placeHolder: "120",
              textLimit: periodTextLimit,
              containerTitle: StringConstants.loanPeriod,
              focus: currentFocus,
              onFocusChange: _onFocusChange,
              onTextChange: _onTextChange),
          SizedBox(height: 20),
          buildTextFieldContainerSection(
              textFieldType: TextFieldFocus.interestRate,
              placeHolder: "10",
              textLimit: interestRateTextLimit,
              containerTitle: StringConstants.loanIntrestRate,
              focus: currentFocus,
              onFocusChange: _onFocusChange,
              onTextChange: _onTextChange),
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
