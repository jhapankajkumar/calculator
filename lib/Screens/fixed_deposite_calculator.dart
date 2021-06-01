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

class FixedDepositeCalculator extends StatefulWidget {
  final String title;
  final bool isFixedDeposit;
  FixedDepositeCalculator({
    Key? key,
    required this.title,
    required this.isFixedDeposit,
  });
  @override
  _FixedDepositeCalculatorState createState() =>
      _FixedDepositeCalculatorState();
}

class _FixedDepositeCalculatorState extends State<FixedDepositeCalculator> {
  double? corpusAmount;
  double? amount;
  double? rate;
  double? period;
  double? wealthGain;
  double? investedAmount;
  TextFieldFocus? currentFocus;
  Compounding? _compounding = Compounding.quaterly;

  _calculateAmount() {
    _removeFocus(context);
    var helper = UtilityHelper();
    var compoundedValue = 4;
    if (_compounding == Compounding.annually) {
      compoundedValue = 1;
    } else if (_compounding == Compounding.monthly) {
      compoundedValue = 12;
    }
    corpusAmount = helper
        .getFutureValueAmount(
            amount ?? 0, rate ?? 0, period ?? 0, compoundedValue)
        .roundToDouble();
    setState(() {
      investedAmount = amount;
      wealthGain = (corpusAmount ?? 0) - (investedAmount ?? 0);
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

  _onOptionChange(Compounding? value) {
    setState(() {
      _compounding = value;
    });
  }

  void _removeFocus(BuildContext context) {
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
                      expectedAmountTitle: widget.isFixedDeposit
                          ? StringConstants.expectedAmount
                          : StringConstants.futureValueOfAmount,
                      investedAmountTitle: widget.isFixedDeposit
                          ? StringConstants.investedAmount
                          : StringConstants.stringAmount,
                      wealthGainTitle: StringConstants.wealthGain,
                      totalExpectedAmount: corpusAmount,
                      totalGainAmount: wealthGain,
                      totalInvestedAmount: investedAmount,
                    ),
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
        margin: EdgeInsets.fromLTRB(8, 20, 8, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          buildTextFieldContainerSection(
              textFieldType: TextFieldFocus.amount,
              placeHolder: "5000",
              textLimit: amountTextLimit,
              containerTitle: widget.isFixedDeposit
                  ? StringConstants.fixedDepositAmount
                  : StringConstants.stringAmount,
              focus: currentFocus,
              onFocusChange: _onFocusChange,
              onTextChange: _onTextChange),
          SizedBox(height: 20),
          buildTextFieldContainerSection(
              textFieldType: TextFieldFocus.period,
              placeHolder: "12 Years",
              textLimit: periodTextLimit,
              containerTitle: widget.isFixedDeposit
                  ? StringConstants.depositPriod
                  : StringConstants.numberOfYears,
              focus: currentFocus,
              onFocusChange: _onFocusChange,
              onTextChange: _onTextChange),
          SizedBox(height: 20),
          buildTextFieldContainerSection(
              textFieldType: TextFieldFocus.interestRate,
              placeHolder: "10",
              textLimit: interestRateTextLimit,
              containerTitle: widget.isFixedDeposit
                  ? StringConstants.depositIntrestRate
                  : StringConstants.interestRate,
              focus: currentFocus,
              onFocusChange: _onFocusChange,
              onTextChange: _onTextChange),
          SizedBox(height: 20),
          widget.isFixedDeposit
              ? buildRadioList(
                  compounding: _compounding, onOptionChange: _onOptionChange)
              : Text(
                  '* Compounding quaterly.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: Color(0xffFF4611)),
                ),
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
