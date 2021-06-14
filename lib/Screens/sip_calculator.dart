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

class SIPCalculator extends StatefulWidget {
  SIPCalculator({Key? key, required this.category}) : super(key: key);
  final Screen category;

  @override
  _SIPCalculatorState createState() => _SIPCalculatorState();
}

class _SIPCalculatorState extends State<SIPCalculator> {
  double? corpusAmount;
  double? amount;
  double? rate;
  double? inflationrate;
  double? period;
  double? months;

  double? wealthGain;
  double? investedAmount;
  TextFieldFocus? currentFocus;
  double? stepUpPercentage;

  SIPData detail = SIPData();
  String? errorText;
  SIPResultData? data;
  Period? periodValue = Period.years;

  _calculateSIP() {
    double? duration = 0;
    var helper = UtilityHelper();
    if (periodValue == Period.years) {
      duration = (period ?? 0) * 12;
    } else {
      duration = period;
    }
    data = helper.getCorpusAmount(
        amount ?? 0, rate ?? 0, duration ?? 0, stepUpPercentage);

    setState(() {
      investedAmount = data?.totalInvestment;
      corpusAmount = data?.corpus;
      wealthGain = data?.wealthGain;
      currentFocus = null;
    });
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

  _onOptionChange(Period? value) {
    setState(() {
      periodValue = value;
      if (isAllInputValid()) {
        _calculateButtonTapped();
      }
    });
  }

  _onDoneButtonTapped() {
    setState(() {
      removeFocus();
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
                                onTapDetail: _onDetailButtonTap),
                          )
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
        margin: EdgeInsets.fromLTRB(8, 10, 8, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          buildTextFieldContainerSection(
            textFieldType: TextFieldFocus.amount,
            placeHolder: "5000",
            textLimit: amountTextLimit,
            containerTitle: amountTitle(widget.category),
            focus: currentFocus,
            onFocusChange: _onFocusChange,
            onTextChange: _onTextChange,
            onDoneButtonTapped: _onDoneButtonTapped,
          ),
          SizedBox(height: 20),
          Row(mainAxisSize: MainAxisSize.max, children: [
            Expanded(
              child: buildTextFieldContainerSection(
                textFieldType: TextFieldFocus.period,
                placeHolder: "12",
                textLimit: periodTextLimit,
                containerTitle: periodTitle(widget.category),
                focus: currentFocus,
                onFocusChange: _onFocusChange,
                onTextChange: _onTextChange,
                onDoneButtonTapped: _onDoneButtonTapped,
              ),
            ),
            (widget.category == Screen.sip || widget.category == Screen.rd)
                ? SizedBox(
                    width: 10,
                  )
                : Container(),
            (widget.category == Screen.sip || widget.category == Screen.rd)
                ? Column(
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
                                offset:
                                    Offset(0, 0), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Center(
                              child: buildPeriodDropDown(
                                  periodValue, _onOptionChange)),
                        ),
                      ])
                : Container()
          ]),
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
