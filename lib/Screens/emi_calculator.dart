import 'package:calculator/Screens/sip_projection_list.dart';
import 'package:calculator/util/Components/appbar.dart';
import 'package:calculator/util/Components/base_container.dart';
import 'package:calculator/util/Components/button.dart';
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
  EMIData? data;
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

    var rate = this.rate ?? 0;
    rate = rate / 100 / 12;

    loanEMIAmount = helper
        .pmt(rate, duration?.toInt() ?? 0, amount ?? 0, 0, 0)
        .abs()
        .roundToDouble();
    data?.loanAmount = amount ?? 0;
    data?.emiAmount = loanEMIAmount ?? 0;
    data?.period = duration?.toInt() ?? 0;
    data?.interestRate = rate;

    print(loanEMIAmount);

    // var iPmt = helper
    //     .ipmt(rate, 2, duration?.toInt() ?? 0, amount ?? 0, 0, 0)
    //     .abs()
    //     .roundToDouble();
    // print(iPmt);

    // var pPmt = helper
    //     .ppmt(rate, 2, duration?.toInt() ?? 0, amount ?? 0, 0, 0)
    //     .abs()
    //     .roundToDouble();
    // print(pPmt);
    setState(() {
      loanAmount = amount;
      totalPayment = (loanEMIAmount ?? 0) * (duration ?? 0);
      totalIntrestPayble = (totalPayment ?? 0) - (loanAmount ?? 0);
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

  void _onDetailButtonTap() {
    removeFocus();
    if (data != null && data?.emiAmount != null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return SIPProjetionList(
          category: Screen.emi,
          data: data!,
        );
      }));
    }
  }

  @override
  void initState() {
    data = EMIData();
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
                    loanAmount != null
                        ? buildSummeryContainer(
                            context: context,
                            child: buildEMISummaryViews(
                                loanAmount: loanAmount,
                                emiAmount: loanEMIAmount,
                                totalPaymentAmount: totalPayment,
                                totalInterestAmount: totalIntrestPayble,
                                isDetail: true,
                                onTapDetail: _onDetailButtonTap),
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
              textField: TextFieldFocus.amount,
              textFieldType: TextFieldType.number,
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
                    textField: TextFieldFocus.period,
                    textFieldType: TextFieldType.number,
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
              textField: TextFieldFocus.interestRate,
              textFieldType: TextFieldType.decimal,
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
