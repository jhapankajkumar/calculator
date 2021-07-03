import 'dart:io';

import 'package:calculator/Screens/sip_projection_list.dart';
import 'package:calculator/util/Components/appbar.dart';
import 'package:calculator/util/Components/base_container.dart';
import 'package:calculator/util/Components/button.dart';
import 'package:calculator/util/Components/error_message_view.dart';
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
  int? moneyLastedFor;

  bool isInvalidPeriod = false;
  bool isInvalidInterest = false;
  bool isInvalidWithdrawalAmount = false;
  String? errorText;
  SWPResult? result;
  Compounding? periodValue = Compounding.monthly;

  _calculateSIP() {
    setState(() {
      endBalance = 0;
      totalProfit = 0;
      totalWithdrawal = 0;
      moneyLastedFor = null;
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
    // result = SIPResultData();
    for (int i = 1; i <= withdrawalPeriod * period!; i++) {
      // Data data = Data();
      //data.startBalance = totalInvestmentAmount;
      if (tempEndAmount - amount! < 0) {
        moneyLastedFor = i;
        print("Exit At $i");
        break;
      }
      //withdraw money
      tempEndAmount = tempEndAmount - amount!;
      // data.amount = amount;
      tempTotalWithdrawal = tempTotalWithdrawal + amount!;
      double profit = tempEndAmount * roi;
      //data.in
      tempTotalProfit = tempTotalProfit + profit;
      //add interest
      tempEndAmount = tempEndAmount + profit.round();
    }

    setState(() {
      result?.tenor = period ?? 0;
      result?.totalInvestment = totalInvestmentAmount ?? 0;
      result?.endBalance = tempEndAmount;
      result?.totalProfit = tempTotalProfit;
      result?.totalWithdrawal = tempTotalWithdrawal;
      result?.withdrawalAmount = amount ?? 0;
      result?.returnRate = rate ?? 0;
      result?.compounding = periodValue ?? Compounding.monthly;

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
    if (isInvalidPeriod) {
      isValid = false;
    }
    if (isInvalidInterest) {
      isValid = false;
    }
    if (isInvalidWithdrawalAmount) {
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
        } else {
          totalInvestmentAmount = null;
        }
      });
    }

    if (textField == TextFieldFocus.amount) {
      setState(() {
        if (inputtedValue > 0) {
          amount = inputtedValue;
          validateWithdrawalAmount();
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
      if (Platform.isAndroid) {
        removeFocus();
      }

      if (textField == TextFieldFocus.period) {
        validatePeriod();
      } else if (textField == TextFieldFocus.interestRate) {
        validateInterest();
      } else if (textField == TextFieldFocus.investmentAmount) {
        validateWithdrawalAmount();
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

  void validateWithdrawalAmount() {
    setState(() {
      if (totalInvestmentAmount != null) {
        if ((amount ?? 0) > totalInvestmentAmount!) {
          isInvalidWithdrawalAmount = true;
        } else {
          isInvalidWithdrawalAmount = false;
        }
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

  void _onDetailButtonTap() {
    removeFocus();
    if (result != null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return SIPProjetionList(
          category: Screen.swp,
          data: result!,
        );
      }));
    }
  }

  _onDoneButtonTapped() {
    setState(() {
      removeFocus();
    });
  }

  @override
  void initState() {
    result = SWPResult();
    super.initState();
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
                                withdrawalFrequency: periodValue,
                                onTapDetail: _onDetailButtonTap))
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
          //invested amount
          buildTextFieldContainerSection(
            textField: TextFieldFocus.investmentAmount,
            textFieldType: TextFieldType.number,
            placeHolder: "500000000",
            textLimit: amountTextLimit,
            containerTitle: "My Total Invstment is",
            focus: currentFocus,
            onFocusChange: _onFocusChange,
            onTextChange: _onTextChange,
            onDoneButtonTapped: _onDoneButtonTapped,
          ),
          SizedBox(height: 20),
          //withdrawal amount
          buildTextFieldContainerSection(
            textField: TextFieldFocus.amount,
            textFieldType: TextFieldType.number,
            placeHolder: "5000",
            textLimit: amountTextLimit,
            containerTitle: amountTitle(widget.category),
            focus: currentFocus,
            onFocusChange: _onFocusChange,
            onTextChange: _onTextChange,
            onDoneButtonTapped: _onDoneButtonTapped,
            isError: isInvalidWithdrawalAmount,
          ),
          isInvalidWithdrawalAmount
              ? buildErrorView(ErrorType.invalidWithdrawalAmount)
              : Container(),
          SizedBox(height: 20),
          //period
          buildTextFieldContainerSection(
            textField: TextFieldFocus.period,
            textFieldType: TextFieldType.number,
            placeHolder: "12",
            textLimit: periodTextLimit,
            containerTitle: periodTitle(widget.category),
            focus: currentFocus,
            onFocusChange: _onFocusChange,
            onTextChange: _onTextChange,
            onDoneButtonTapped: _onDoneButtonTapped,
            isError: isInvalidPeriod,
          ),
          isInvalidPeriod
              ? buildErrorView(ErrorType.maxPeriodYears)
              : Container(),
          SizedBox(height: 20),
          //return rate
          buildTextFieldContainerSection(
            textField: TextFieldFocus.interestRate,
            textFieldType: TextFieldType.decimal,
            placeHolder: "10",
            textLimit: interestRateTextLimit,
            containerTitle: interestRateTitle(widget.category),
            focus: currentFocus,
            onFocusChange: _onFocusChange,
            onTextChange: _onTextChange,
            onDoneButtonTapped: _onDoneButtonTapped,
            isError: isInvalidInterest,
          ),
          isInvalidInterest
              ? buildErrorView(ErrorType.maxReturnRate)
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
