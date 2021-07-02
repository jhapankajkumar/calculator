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
import 'dart:io';

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
  TextEditingController? controller;
  String? errorText;
  SIPResult? data;
  Period? periodValue = Period.years;

  bool invalidPeriod = false;
  bool invalidInterest = false;
  bool invalidStepup = false;

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
    if (invalidPeriod == true) {
      isValid = false;
    }
    if (invalidInterest == true) {
      isValid = false;
    }
    if (invalidStepup == true) {
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
          validateStepup();
          // if (isAllInputValid()) {
          //   _calculateSIP();
          // }
        } else {
          stepUpPercentage = null;
        }
      });
    }
  }

  void validatePeriod() {
    setState(() {
      if (periodValue == Period.months &&
          (period ?? 0) > periodMonthsMaxValue) {
        invalidPeriod = true;
      } else if (periodValue == Period.years &&
          (period ?? 0) > periodYearMaxValue) {
        invalidPeriod = true;
      } else {
        invalidPeriod = false;
      }
    });
  }

  void validateInterest() {
    setState(() {
      if ((rate ?? 0) > interestRateMaxValue) {
        invalidInterest = true;
      } else {
        invalidInterest = false;
      }
    });
  }

  void validateStepup() {
    setState(() {
      if ((stepUpPercentage ?? 0) > interestRateMaxValue) {
        invalidStepup = true;
      } else {
        invalidStepup = false;
      }
    });
  }

  _onFocusChange(TextFieldFocus? textField, bool value) {
    print('object');
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
      } else if (textField == TextFieldFocus.stepUp) {
        validateStepup();
      }
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
      if (period != null) {
        if (periodValue == Period.years) {
          period = ((period ?? 0) ~/ 12).toDouble();
          controller?.text = (period ?? 0).toInt().toString();
        } else {
          period = (period ?? 0) * 12;
          controller?.text = (period ?? 0).toInt().toString();
        }
        validatePeriod();
      }

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
  void initState() {
    controller = TextEditingController();
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
            textField: TextFieldFocus.amount,
            textFieldType: TextFieldType.number,
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
                  initialText: period.toString(),
                  textField: TextFieldFocus.period,
                  textFieldType: TextFieldType.number,
                  placeHolder: "12",
                  textLimit: periodTextLimit,
                  containerTitle: periodTitle(widget.category),
                  focus: currentFocus,
                  onFocusChange: _onFocusChange,
                  onTextChange: _onTextChange,
                  onDoneButtonTapped: _onDoneButtonTapped,
                  controller: controller,
                  isError: invalidPeriod),
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
          invalidPeriod == true
              ? buildErrorView(ErrorType.maxPeriodYears)
              : Container(),
          SizedBox(height: 20),
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
            isError: invalidInterest,
          ),
          invalidInterest == true
              ? buildErrorView(widget.category == Screen.rd
                  ? ErrorType.maxInterestRate
                  : ErrorType.maxReturnRate)
              : Container(),
          SizedBox(height: 20),
          widget.category == Screen.stepup
              ? buildTextFieldContainerSection(
                  textField: TextFieldFocus.stepUp,
                  textFieldType: TextFieldType.decimal,
                  placeHolder: "10",
                  textLimit: interestRateTextLimit,
                  containerTitle:
                      StringConstants.annualPercentageIncreamntOnSip,
                  focus: currentFocus,
                  onFocusChange: _onFocusChange,
                  onTextChange: _onTextChange,
                  onDoneButtonTapped: _onDoneButtonTapped,
                  isError: invalidStepup,
                )
              : Container(),
          invalidStepup == true
              ? buildErrorView(ErrorType.maxStepUpRate)
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
