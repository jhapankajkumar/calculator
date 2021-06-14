import 'package:calculator/util/Components/appbar.dart';
import 'package:calculator/util/Components/base_container.dart';
import 'package:calculator/util/Components/button.dart';
import 'package:calculator/util/Components/piechartsection.dart';
import 'package:calculator/util/Components/radio_list.dart';
import 'package:calculator/util/Components/summary_container.dart';
import 'package:calculator/util/Components/text_field_container.dart';
import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/Constants/string_constants.dart';
import 'package:calculator/util/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EMICalculator extends StatefulWidget {
  final Screen category;
  EMICalculator({
    Key? key,
    required this.category,
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

  Period? periodValue = Period.years;
  _calculateAmount() {
    removeFocus();
    double? duration = 0;
    var helper = UtilityHelper();
    if (periodValue == Period.years) {
      duration = (period ?? 0) * 12;
    } else {
      duration = period;
    }

    loanEMIAmount = helper
        .getInstallmentAmount(amount ?? 0, duration ?? 0, rate ?? 0)
        .roundToDouble();
    setState(() {
      loanAmount = amount;
      totalPayment = (loanEMIAmount ?? 0) * (duration ?? 0);
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

  _onDoneButtonTapped() {
    setState(() {
      removeFocus();
    });
  }

  _onOptionChange(Period? value) {
    setState(() {
      periodValue = value;
      if (isAllInputValid()) {
        _calculateButtonTapped();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(category: widget.category, context: context),
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
                    loanAmount != null
                        ? buildSummeryContainer(
                            context: context,
                            child: buildSummaryViews(
                                expectedAmountTitle:
                                    summaryExpectedAmountTitle(widget.category),
                                investedAmountTitle:
                                    summaryInvestedAmountTitle(widget.category),
                                wealthGainTitle: StringConstants.totalPayment,
                                totalExpectedAmount: loanEMIAmount,
                                totalGainAmount: totalPayment,
                                totalInvestedAmount: totalIntrestPayble),
                          )
                        : Container(),
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
              containerTitle: amountTitle(widget.category),
              focus: currentFocus,
              onFocusChange: _onFocusChange,
              onTextChange: _onTextChange,
              onDoneButtonTapped: _onDoneButtonTapped),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: buildTextFieldContainerSection(
                    textFieldType: TextFieldFocus.period,
                    placeHolder: "12",
                    textLimit: periodTextLimit,
                    containerTitle: periodTitle(widget.category),
                    focus: currentFocus,
                    onFocusChange: _onFocusChange,
                    onTextChange: _onTextChange,
                    onDoneButtonTapped: _onDoneButtonTapped),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '',
                      style: appTheme.textTheme.caption,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: textFieldContainerSize,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xffEFEFEF),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 0,
                            blurRadius: 0,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                          child: buildPeriodDropDown(
                              periodValue, _onOptionChange)),
                    ),
                  ])
            ],
          ),
          SizedBox(height: 20),
          buildTextFieldContainerSection(
              textFieldType: TextFieldFocus.interestRate,
              placeHolder: "10",
              textLimit: interestRateTextLimit,
              containerTitle: interestRateTitle(widget.category),
              focus: currentFocus,
              onFocusChange: _onFocusChange,
              onTextChange: _onTextChange,
              onDoneButtonTapped: _onDoneButtonTapped),
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
