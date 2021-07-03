import 'dart:io';

import 'package:calculator/Screens/sip_projection_list.dart';
import 'package:calculator/util/Components/appbar.dart';
import 'package:calculator/util/Components/base_container.dart';
import 'package:calculator/util/Components/button.dart';
import 'package:calculator/util/Components/error_message_view.dart';
import 'package:calculator/util/Components/piechartsection.dart';
import 'package:calculator/util/Components/radio_list.dart';
import 'package:calculator/util/Components/summary_container.dart';
import 'package:calculator/util/Components/text_field_container.dart';
import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/Constants/string_constants.dart';
import 'package:calculator/util/sip_data.dart';
import 'package:calculator/util/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FixedDepositeCalculator extends StatefulWidget {
  final Screen category;
  FixedDepositeCalculator({
    Key? key,
    required this.category,
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
  FutureValue futureData = FutureValue();
  Compounding? _compounding = Compounding.quaterly;
  bool isInvalidPeriod = false;
  bool isInvalidInterest = false;
  _calculateAmount() {
    removeFocus();
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
      futureData.tenor = period ?? 0;
      futureData.corpus = corpusAmount ?? 0;
      futureData.compounding = _compounding ?? Compounding.quaterly;
      futureData.returnRate = rate ?? 0.0;
      futureData.investmentAmount = amount ?? 0;
      investedAmount = amount;
      wealthGain = (corpusAmount ?? 0) - (investedAmount ?? 0);
      futureData.totalProfit = wealthGain ?? 0;
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

  _onOptionChange(Compounding? value) {
    setState(() {
      _compounding = value;
      if (isAllInputValid()) {
        _calculateButtonTapped();
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

  void _onDetailButtonTap() {
    removeFocus();
    if (futureData.corpus.isFinite) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return SIPProjetionList(
          category: widget.category,
          data: futureData,
        );
      }));
    }
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
                    corpusAmount != null
                        ? buildSummeryContainer(
                            context: context,
                            child: buildSummaryViews(
                              expectedAmountTitle:
                                  summaryExpectedAmountTitle(widget.category),
                              investedAmountTitle:
                                  summaryInvestedAmountTitle(widget.category),
                              wealthGainTitle: StringConstants.wealthGain,
                              totalExpectedAmount: corpusAmount,
                              totalGainAmount: wealthGain,
                              totalInvestedAmount: investedAmount,
                              isDetail: true,
                              onTapDetail: _onDetailButtonTap,
                            ))
                        : Container(),
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
              textField: TextFieldFocus.amount,
              textFieldType: TextFieldType.number,
              placeHolder: "5000",
              textLimit: amountTextLimit,
              containerTitle: amountTitle(widget.category),
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
              containerTitle: periodTitle(widget.category),
              focus: currentFocus,
              onFocusChange: _onFocusChange,
              onTextChange: _onTextChange,
              onDoneButtonTapped: _onDoneButtonTapped,
              isError: isInvalidPeriod),
          isInvalidPeriod == true
              ? buildErrorView(ErrorType.maxPeriodYears)
              : Container(),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: buildTextFieldContainerSection(
                    textField: TextFieldFocus.interestRate,
                    textFieldType: TextFieldType.decimal,
                    placeHolder: "10",
                    textLimit: interestRateTextLimit,
                    containerTitle: interestRateTitle(widget.category),
                    focus: currentFocus,
                    onFocusChange: _onFocusChange,
                    onTextChange: _onTextChange,
                    onDoneButtonTapped: _onDoneButtonTapped,
                    isError: isInvalidInterest),
              ),
              widget.category == Screen.fd
                  ? SizedBox(
                      width: 10,
                    )
                  : Container(),
              widget.category == Screen.fd
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          Text(
                            "Compounding",
                            style: appTheme.textTheme.caption,
                          ),
                          SizedBox(height: 10),
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
                                  offset: Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Center(
                              child: buildCompoundungDropDown(
                                  _compounding, _onOptionChange),
                            ),
                          ),
                        ])
                  : Container()
            ],
          ),
          isInvalidInterest == true
              ? buildErrorView(widget.category == Screen.fd
                  ? ErrorType.maxInterestRate
                  : ErrorType.maxReturnRate)
              : Container(),
          SizedBox(height: 20),
          widget.category == Screen.fv
              ? Text(
                  '* Compounding quaterly.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: ternaryColor),
                )
              : Container(),
          SizedBox(height: 20),
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
