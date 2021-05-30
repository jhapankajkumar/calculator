import 'dart:math';

import 'package:calculator/Screens/sip_projection_list.dart';
import 'package:calculator/util/components.dart';
import 'package:calculator/util/constants.dart';
import 'package:calculator/util/indicator.dart';
import 'package:calculator/util/piechart.dart';
import 'package:calculator/util/sip_data.dart';
import 'package:calculator/util/string_constants.dart';
import 'package:calculator/util/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TargetAmountSIPCalculator extends StatefulWidget {
  TargetAmountSIPCalculator({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _TargetAmountSIPCalculatorState createState() =>
      _TargetAmountSIPCalculatorState();
}

class _TargetAmountSIPCalculatorState extends State<TargetAmountSIPCalculator> {
  bool shouldAdjustInflation = false;
  double? sipAmount;
  double? amount;
  double? rate;
  double? inflationrate;
  double? period;
  int? touchedIndex;
  double? wealthGain;
  double? investedAmount;
  TextFieldFocus? currentFocus;
  double? stepUpPercentage;
  final amountTextField = TextEditingController();
  SIPData detail = SIPData();

  var textFieldSelected = false;
  _calculateSIP() {
    var helper = UtilityHelper();
    detail.amount = amount;
    detail.interestRate = rate;
    detail.duration = period;
    detail.increase = stepUpPercentage;
    double montlyAmount = helper
        .getSIPAmount(amount ?? 0, rate ?? 0, period ?? 0, inflationrate, false,
            shouldAdjustInflation)
        .roundToDouble();
    setState(() {
      sipAmount = montlyAmount;
      investedAmount = (sipAmount ?? 0) * (period ?? 0) * 12;
      wealthGain = (amount ?? 0) - (investedAmount ?? 0);
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

    if (textField == TextFieldFocus.stepUp) {
      setState(() {
        if (inputtedValue > 0) {
          stepUpPercentage = inputtedValue;
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
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
              if (this.currentFocus != null) {
                setState(() {
                  this.currentFocus = null;
                });
              }
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
                        height: 20,
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
        "Wealth Gain (${gainPercentage.toStringAsFixed(2)}%)";
    String? investedAmountValue =
        "Amount Invested (${investmentPercentage.toStringAsFixed(2)}%)";
    if (sipAmount != null) {
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
            sipAmount != null
                ? Chart(
                    corpusAmount: amount,
                    wealthGain: wealthGain,
                    amountInvested: investedAmount,
                  )
                : Container(),
          ]));
    }
    return container;
  }

  Widget buildSummeryContainer(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    var container = Container();
    if (sipAmount != null) {
      container = Container(
        width: deviceWidth,
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.fromLTRB(8, 20, 8, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(1, 1), // changes position of shadow
            )
          ],
        ),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  color: Colors.blue[200],
                  padding: EdgeInsets.all(8),
                  width: deviceWidth,
                  child: Text(
                    "Summary",
                    style: appTheme.textTheme.subtitle1,
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
                            title: Text('Your target amount'),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: amount?.isInfinite == false
                                ? Text('\$${formatter.format(amount)}')
                                : Text('\$0'),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListTile(
                            tileColor: Colors.grey[300],
                            title: Text('Number of years to save'),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            tileColor: Colors.grey[300],
                            title: investedAmount?.isInfinite == false
                                ? Text('${(period?.toInt())}')
                                : Text('\$0'),
                          ),
                        ),
                      ],
                    ),
                    // Invested Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListTile(
                            tileColor: Colors.grey[300],
                            title: Text('Monthly SIP required'),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            tileColor: Colors.grey[300],
                            title: investedAmount?.isInfinite == false
                                ? Text('\$${formatter.format(sipAmount)}',
                                    style: TextStyle(color: Colors.red))
                                : Text('\$INFINITE'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text('Total amount invested in SIP'),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: wealthGain?.isInfinite == false
                                ? Text(
                                    '\$${formatter.format(investedAmount)}',
                                  )
                                : Text(
                                    '\$INFINITE',
                                  ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Wealth Gain/Lost
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListTile(
                            title: Text('Wealth Gain'),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: wealthGain?.isInfinite == false
                                ? Text(
                                    '\$${formatter.format(wealthGain)}',
                                    style: TextStyle(color: Colors.green),
                                  )
                                : Text('\$INFINITE',
                                    style: TextStyle(color: Colors.green)),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),
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
          SizedBox(height: 30),
          CupertinoButton(
            child: Text(StringConstants.calculate),
            // padding: EdgeInsets.all(16),
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.blue,
            disabledColor: Colors.grey,
            onPressed: isAllInputValid()
                ? () {
                    _calculateSIP();
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
        placeHolder: "10000000",
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
            StringConstants.futureTargetAmout,
            style: appTheme.textTheme.caption,
          ),
          SizedBox(height: 10),
          TextFieldContainer(containerData: data)
        ]);
  }

  Widget _periodSection(BuildContext context) {
    TextFieldContainerData data = TextFieldContainerData(
        placeHolder: "12 Years",
        onTextChange: _onTextChange,
        onFocusChanged: _onFocusChange,
        textField: TextFieldFocus.period,
        currentFocus: currentFocus,
        textLimit: 3);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        StringConstants.investmentPeriod,
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
        textLimit: 3);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        StringConstants.expectedReturn,
        style: appTheme.textTheme.caption,
      ),
      SizedBox(height: 10),
      TextFieldContainer(
        containerData: data,
      )
    ]);
  }

  double _getGainPercentage() {
    if ((wealthGain ?? 0) < 0) {
      return 0;
    }
    if (amount?.isInfinite ?? false) {
      return 100;
    }
    return (wealthGain ?? 0) / (amount ?? 0) * 100;
  }

  double _getInvestmentPercentage() {
    if ((investedAmount ?? 0) < 0) {
      return 0;
    }
    return (investedAmount ?? 0) / (amount ?? 0) * 100;
  }
}
