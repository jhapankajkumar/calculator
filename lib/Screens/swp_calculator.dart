import 'dart:ffi';
import 'dart:math';
import 'package:calculator/Screens/sip_projection_list.dart';
import 'package:calculator/util/Components/appbar.dart';
import 'package:calculator/util/Components/base_container.dart';
import 'package:calculator/util/Components/button.dart';
import 'package:calculator/util/Components/piechartsection.dart';
import 'package:calculator/util/Components/radio_list.dart';
import 'package:calculator/util/Components/summary_container.dart';
import 'package:calculator/util/Components/text_field_container.dart';
import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/sip_data.dart';
import 'package:calculator/util/Constants/string_constants.dart';
import 'package:calculator/util/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SWPCalculator extends StatefulWidget {
  SWPCalculator({Key? key, required this.category}) : super(key: key);
  final Screen category;

  @override
  _SWPCalculatorState createState() => _SWPCalculatorState();
}

class _SWPCalculatorState extends State<SWPCalculator> {
  double? amount;
  double? rate;
  double? inflationrate;
  double? period;
  double? months;

  TextFieldFocus? currentFocus;
  double? stepUpPercentage;
  double? totalInvestmentAmount;
  double totalWithdrawal = 0;
  double totalProfit = 0;
  double endBalance = 0;
  int moneyLastedFor = 0;

  SIPData detail = SIPData();
  String? errorText;
  SIPResultData? data;
  Compounding? periodValue = Compounding.monthly;

  _calculateSIP() {
    setState(() {
      endBalance = 0;
      totalProfit = 0;
      totalWithdrawal = 0;
    });

    double tempEndAmount = totalInvestmentAmount!;
    double tempTotalWithdrawal = 0;
    double tempTotalProfit = 0;
    double withdrawalPeriod = 12;
    if (periodValue == Compounding.annually) {
      withdrawalPeriod = 1;
    } else if (periodValue == Compounding.quaterly) {
      withdrawalPeriod = 4;
    }

    double roi = (rate! / 100) / withdrawalPeriod;
    for (int i = 1; i <= withdrawalPeriod * period!; i++) {
      if (tempEndAmount < 0) {
        moneyLastedFor = i;
        print(i);
        break;
      }
      //withdraw money
      tempEndAmount = tempEndAmount - amount!;
      tempTotalWithdrawal = tempTotalWithdrawal + amount!;
      double profit = tempEndAmount * roi;
      tempTotalProfit = tempTotalProfit + profit;
      //add interest
      tempEndAmount = tempEndAmount + profit.round();
      // print("\n");
      // print(value);
      // print(tempTotalInvestmentAmount);
      // print("\n");
    }

    setState(() {
      endBalance = tempEndAmount;
      totalProfit = tempTotalProfit;
      totalWithdrawal = tempTotalWithdrawal;
      currentFocus = null;
    });
  }

  bool isAllInputValid() {
    bool isValid = true;
    if (errorText != null) {
      isValid = false;
    }
    if (totalInvestmentAmount == null) {
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

    if (textField == TextFieldFocus.investmentAmount) {
      setState(() {
        if (inputtedValue > 0) {
          totalInvestmentAmount = inputtedValue;
          // if (isAllInputValid()) {
          //   _calculateSIP();
          // }
        } else {
          totalInvestmentAmount = null;
        }
      });
    }

    if (textField == TextFieldFocus.amount) {
      setState(() {
        if (inputtedValue > 0) {
          amount = inputtedValue;
          // if (isAllInputValid()) {
          //   _calculateSIP();
          // }
        } else {
          amount = null;
        }
      });
    }

    if (textField == TextFieldFocus.period) {
      setState(() {
        if (inputtedValue > 0) {
          period = inputtedValue;
          // if (isAllInputValid()) {
          //   _calculateSIP();
          // }
        } else {
          period = null;
        }
      });
    }

    if (textField == TextFieldFocus.period) {
      setState(() {
        if (inputtedValue > 0) {
          months = inputtedValue;
          // if (isAllInputValid()) {
          //   _calculateSIP();
          // }
        } else {
          months = null;
        }
      });
    }

    if (textField == TextFieldFocus.interestRate) {
      setState(() {
        if (inputtedValue > 0) {
          rate = inputtedValue;
          // if (isAllInputValid()) {
          //   _calculateSIP();
          // }
        } else {
          rate = null;
        }
      });
    }

    if (textField == TextFieldFocus.stepUp) {
      setState(() {
        if (inputtedValue > 0) {
          stepUpPercentage = inputtedValue;
          // if (isAllInputValid()) {
          //   _calculateSIP();
          // }
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

  void _onDetailButtonTap() {
    removeFocus();
    if (data != null && data!.corpus.isFinite) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return SIPProjetionList(
          category: Screen.detail,
          data: data!,
        );
      }));
    }
  }

  _onDoneButtonTapped() {
    setState(() {
      removeFocus();
    });
  }

  _onOptionChange(Compounding? value) {
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
                    totalWithdrawal > 0
                        ? buildSummeryContainer(
                            context: context,
                            child: buildSWPSummaryViews(
                                endBalance: endBalance,
                                totalInvestmentAmount: totalInvestmentAmount,
                                totalProfit: totalProfit,
                                totalWithdrawal: totalWithdrawal,
                                widthdrawalAmount: amount,
                                withdrawalPeriod: period,
                                moneyFinishedAtMonth: moneyLastedFor,
                                withdrawalFrequency: periodValue))
                        : Container(),
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
        margin: EdgeInsets.fromLTRB(8, 10, 8, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          buildTextFieldContainerSection(
            textFieldType: TextFieldFocus.investmentAmount,
            placeHolder: "500000000",
            textLimit: amountTextLimit,
            containerTitle: "Total Invstment",
            focus: currentFocus,
            onFocusChange: _onFocusChange,
            onTextChange: _onTextChange,
            onDoneButtonTapped: _onDoneButtonTapped,
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: buildTextFieldContainerSection(
                  textFieldType: TextFieldFocus.amount,
                  placeHolder: "5000",
                  textLimit: amountTextLimit,
                  containerTitle: amountTitle(widget.category),
                  focus: currentFocus,
                  onFocusChange: _onFocusChange,
                  onTextChange: _onTextChange,
                  onDoneButtonTapped: _onDoneButtonTapped,
                ),
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
                          child: buildCompoundungDropDown(
                              periodValue, _onOptionChange)),
                    ),
                  ])
            ],
          ),
          SizedBox(height: 20),
          buildTextFieldContainerSection(
            textFieldType: TextFieldFocus.period,
            placeHolder: "12",
            textLimit: periodTextLimit,
            containerTitle: periodTitle(widget.category),
            focus: currentFocus,
            onFocusChange: _onFocusChange,
            onTextChange: _onTextChange,
            onDoneButtonTapped: _onDoneButtonTapped,
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
            onDoneButtonTapped: _onDoneButtonTapped,
          ),
          SizedBox(height: 20),
          widget.category == Screen.stepup
              ? buildTextFieldContainerSection(
                  textFieldType: TextFieldFocus.stepUp,
                  placeHolder: "10",
                  textLimit: interestRateTextLimit,
                  containerTitle:
                      StringConstants.annualPercentageIncreamntOnSip,
                  focus: currentFocus,
                  onFocusChange: _onFocusChange,
                  onTextChange: _onTextChange,
                  onDoneButtonTapped: _onDoneButtonTapped,
                )
              : Container(),
          widget.category == Screen.stepup ? SizedBox(height: 20) : Container(),
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
