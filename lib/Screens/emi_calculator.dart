import 'package:calculator/util/components.dart';
import 'package:calculator/util/constants.dart';
import 'package:calculator/util/indicator.dart';
import 'package:calculator/util/piechart.dart';
import 'package:calculator/util/string_constants.dart';
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

enum Compounding { monthly, quaterly, annually }

class _EMICalculatorState extends State<EMICalculator> {
  bool shouldAdjustInflation = false;
  double? loanEMIAmount;
  double? totalIntrestPayble;
  double? totalPayment;
  double? amount;
  double? rate;
  double? period;
  int? touchedIndex;
  double? loanAmount;
  TextFieldFocus? currentFocus;
  final amountTextField = TextEditingController();
  var textFieldSelected = false;
  _calculateAmount() {
    removeFocust(context);
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

  void removeFocust(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          leading: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.transparent,
                  spreadRadius: 8,
                  blurRadius: 2,
                  offset: Offset(1, 1), // changes position of shadow
                )
              ],
            ),
            child: Center(
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: appTheme.accentColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          title: new Text(
            widget.title,
            style: appTheme.textTheme.bodyText2,
          ),
          backgroundColor: appTheme.primaryColor,
          elevation: 0.0,
        ),
        body: GestureDetector(
            onTap: () {
              removeFocust(context);
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              width: deviceWidth,
              height: deviceHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.transparent,
                    spreadRadius: 8,
                    blurRadius: 2,
                    offset: Offset(1, 1), // changes position of shadow
                  )
                ],
              ),
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      buildInputContainer(context),
                      SizedBox(
                        height: 20,
                      ),
                      buildSummeryContainer(context),
                      SizedBox(
                        height: 20,
                      ),
                      buildGraphContainer(context),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  )),
            )));
  }

  Widget buildGraphContainer(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    var container = Container();
    double? gainPercentage = _getGainPercentage();
    double? investmentPercentage = _getInvestmentPercentage();

    String? wealthGainValue =
        "Total Interest (${gainPercentage.toStringAsFixed(2)}%)";
    String? investedAmountValue =
        "Principal Loan Amount (${investmentPercentage.toStringAsFixed(2)}%)";
    if (loanAmount != null) {
      container = Container(
          width: deviceWidth,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.fromLTRB(8, 20, 8, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: appTheme.primaryColor,
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Indicator(
                    color: Color(0xff31944a),
                    text: wealthGainValue,
                    isSquare: false,
                    textColor: appTheme.accentColor,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Indicator(
                    color: Color(0xffFF4611),
                    text: investedAmountValue,
                    isSquare: false,
                    textColor: appTheme.accentColor,
                  ),
                  SizedBox(
                    height: 18,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            loanEMIAmount != null
                ? Chart(
                    corpusAmount: totalPayment,
                    wealthGain: totalIntrestPayble,
                    amountInvested: loanAmount,
                  )
                : Container(),
          ]));
    }
    return container;
  }

  Widget buildSummeryContainer(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    var container = Container();
    if (loanEMIAmount != null) {
      container = Container(
        width: deviceWidth,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        margin: EdgeInsets.fromLTRB(8, 20, 8, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: appTheme.primaryColor,
        ),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  color: appTheme.accentColor,
                  padding: EdgeInsets.all(8),
                  width: deviceWidth,
                  child: Text(
                    "Summary",
                    style: appTheme.textTheme.bodyText1,
                  ),
                ),
                //summery

                Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    // Expected Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text(
                              StringConstants.loanEMI,
                              style: subTitle1,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: loanEMIAmount?.isInfinite == false
                                ? Text('\$${formatter.format(loanEMIAmount)}',
                                    style: subTitle2)
                                : Text('\$INFINITE', style: subTitle2),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 1,
                      color: appTheme.accentColor,
                    ),
                    // Invested Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text(StringConstants.totalInterestPayable,
                                style: subTitle1),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            tileColor: Colors.grey[300],
                            title: totalIntrestPayble?.isInfinite == false
                                ? Text(
                                    '\$${formatter.format(totalIntrestPayble)}',
                                    style: subTitle2)
                                : Text('\$INFINITE', style: subTitle2),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 1,
                      color: appTheme.accentColor,
                    ),
                    // Wealth Gain/Lost
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text(StringConstants.totalPayment),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: totalPayment?.isInfinite == false
                                ? Text(
                                    '\$${formatter.format(totalPayment)}',
                                    style: subTitle2,
                                  )
                                : Text('\$INFINITE', style: subTitle2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }
    return container;
  }

  Widget buildInputContainer(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
        width: deviceWidth,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.fromLTRB(8, 20, 8, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          _amountSection(context),
          SizedBox(height: 20),
          _periodSection(context),
          SizedBox(height: 20),
          _rateSection(context),
          SizedBox(height: 20),
          SizedBox(height: 20),
          CupertinoButton(
            child: Text(StringConstants.calculate),
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: appTheme.accentColor,
            disabledColor: Colors.grey,
            onPressed: isAllInputValid()
                ? () {
                    _calculateAmount();
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  }
                : null,
          )
        ]));
  }

  Widget _amountSection(BuildContext context) {
    TextFieldContainerData data = TextFieldContainerData(
        placeHolder: "50000000",
        onTextChange: _onTextChange,
        onFocusChanged: _onFocusChange,
        textField: TextFieldFocus.amount,
        currentFocus: currentFocus,
        textLimit: 15);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            StringConstants.loanAmount,
            style: appTheme.textTheme.caption,
          ),
          SizedBox(height: 10),
          TextFieldContainer(containerData: data)
        ]);
  }

  Widget _periodSection(BuildContext context) {
    TextFieldContainerData data = TextFieldContainerData(
        placeHolder: "120 Months",
        onTextChange: _onTextChange,
        onFocusChanged: _onFocusChange,
        textField: TextFieldFocus.period,
        currentFocus: currentFocus,
        textLimit: 3);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        StringConstants.loanPeriod,
        style: appTheme.textTheme.caption,
      ),
      SizedBox(height: 10),
      TextFieldContainer(containerData: data)
    ]);
  }

  Widget _rateSection(BuildContext context) {
    TextFieldContainerData data = TextFieldContainerData(
        placeHolder: "10",
        onTextChange: _onTextChange,
        onFocusChanged: _onFocusChange,
        textField: TextFieldFocus.interestRate,
        currentFocus: currentFocus,
        textLimit: 5);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        StringConstants.loanIntrestRate,
        style: appTheme.textTheme.caption,
      ),
      SizedBox(height: 10),
      TextFieldContainer(
        containerData: data,
      )
    ]);
  }

  double _getGainPercentage() {
    if ((totalIntrestPayble ?? 0) < 0) {
      return 0;
    }
    if (totalIntrestPayble?.isInfinite ?? false) {
      return 100;
    }
    return (totalIntrestPayble ?? 0) / (totalPayment ?? 0) * 100;
  }

  double _getInvestmentPercentage() {
    if ((loanAmount ?? 0) < 0) {
      return 0;
    }
    return (loanAmount ?? 0) / (totalPayment ?? 0) * 100;
  }
}
