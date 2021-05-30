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

class SIPCalculator extends StatefulWidget {
  SIPCalculator({Key? key, required this.title, required this.isSteupUp})
      : super(key: key);
  final String title;
  final bool isSteupUp;

  @override
  _SIPCalculatorState createState() => _SIPCalculatorState();
}

class _SIPCalculatorState extends State<SIPCalculator> {
  bool shouldAdjustInflation = false;
  double? corpusAmount;
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
  String? errorText;

  var textFieldSelected = false;
  _calculateSIP() {
    var helper = UtilityHelper();
    detail.amount = amount;
    detail.interestRate = rate;
    detail.duration = period;
    detail.increase = stepUpPercentage;
    if (widget.isSteupUp && stepUpPercentage != null) {
      var stepupFinalAmount = 0.0;
      var stepupInvestAmount = 0.0;
      var stepupInterestAmount = 0.0;
      var sipAmount = amount;
      var totalInvestAmount = sipAmount;
      var s = (stepUpPercentage ?? 0) / 100;
      var n = (period ?? 0) * 12;
      var roi = (rate ?? 0) / 100 / 12;
      var value3 = 1 + roi;
      var value4 = pow(value3, n);
      var finalValue = (sipAmount ?? 0) * value4;
      n = n - 1;
      while (n > 0) {
        if (n % 12 > 0) {
          sipAmount = sipAmount;
          totalInvestAmount = (totalInvestAmount ?? 0) + (sipAmount ?? 0);
          var value4 = pow(value3, n);
          finalValue = finalValue + (sipAmount ?? 0) * value4;
          n = n - 1;
        } else {
          sipAmount = (sipAmount ?? 0) + ((sipAmount ?? 0) * s);
          totalInvestAmount = (totalInvestAmount ?? 0) + sipAmount;
          var value4 = pow(value3, n);
          finalValue = finalValue + sipAmount * value4;
          n = n - 1;
        }
      }
      stepupFinalAmount = finalValue.roundToDouble();
      stepupInvestAmount = (totalInvestAmount ?? 0).roundToDouble();
      stepupInterestAmount = stepupFinalAmount - stepupInvestAmount;
      stepupInterestAmount = stepupInterestAmount.roundToDouble();

      setState(() {
        investedAmount = stepupInvestAmount;
        corpusAmount = stepupFinalAmount;
        wealthGain = stepupInterestAmount;
        currentFocus = null;
      });
    } else {
      corpusAmount = helper
          .getCorpusAmount(amount ?? 0, rate ?? 0, period ?? 0, inflationrate,
              false, shouldAdjustInflation)
          .roundToDouble();
      setState(() {
        investedAmount = (amount ?? 0) * (period ?? 0) * 12;
        wealthGain = (corpusAmount ?? 0) - (investedAmount ?? 0);
        currentFocus = null;
      });
    }
  }

  final formatter = new NumberFormat("#,###");
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
    if (corpusAmount != null) {
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
            corpusAmount != null
                ? Chart(
                    corpusAmount: corpusAmount,
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
    if (corpusAmount != null) {
      container = Container(
        width: deviceWidth,
        padding: EdgeInsets.all(0),
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
                              StringConstants.expectedAmount,
                              style: subTitle1,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: corpusAmount?.isInfinite == false
                                ? Text('\$${formatter.format(corpusAmount)}',
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
                            title: Text(StringConstants.investedAmount,
                                style: subTitle1),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            tileColor: Colors.grey[300],
                            title: investedAmount?.isInfinite == false
                                ? Text('\$${formatter.format(investedAmount)}',
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
                            title: Text(StringConstants.wealthGain),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: wealthGain?.isInfinite == false
                                ? Text(
                                    '\$${formatter.format(wealthGain)}',
                                    style: subTitle2,
                                  )
                                : Text('\$INFINITE', style: subTitle2),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 1,
                      color: appTheme.accentColor,
                    ),
                    SizedBox(height: 30),
                    CupertinoButton(
                      child: Text("Detail"),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: appTheme.accentColor,
                      disabledColor: Colors.grey,
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return SIPProjetionList(detail);
                        }));
                      },
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
        margin: EdgeInsets.fromLTRB(8, 10, 8, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          _amountSection(context),
          SizedBox(height: 20),
          _periodSection(context),
          SizedBox(height: 20),
          _rateSection(context),
          SizedBox(height: 20),
          widget.isSteupUp ? _stepUpSection(context) : Container(),
          widget.isSteupUp ? SizedBox(height: 20) : Container(),
          SizedBox(height: 20),
          CupertinoButton(
            child: Text(StringConstants.calculate),
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: appTheme.accentColor,
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
        placeHolder: "5000",
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
            StringConstants.monthlyInvestmentAmount,
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
        placeHolder: "12",
        onTextChange: _onTextChange,
        onFocusChanged: _onFocusChange,
        textField: TextFieldFocus.interestRate,
        currentFocus: currentFocus,
        textLimit: 5);
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

  Widget _stepUpSection(BuildContext context) {
    TextFieldContainerData data = TextFieldContainerData(
        placeHolder: "10",
        onTextChange: _onTextChange,
        onFocusChanged: _onFocusChange,
        textField: TextFieldFocus.stepUp,
        currentFocus: currentFocus,
        textLimit: 3);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        StringConstants.annualPercentageIncreamntOnSip,
        style: appTheme.textTheme.caption,
      ),
      SizedBox(height: 5),
      TextFieldContainer(
        containerData: data,
      )
    ]);
  }

  double _getGainPercentage() {
    if ((wealthGain ?? 0) < 0) {
      return 0;
    }
    if (corpusAmount?.isInfinite ?? false) {
      return 100;
    }
    return (wealthGain ?? 0) / (corpusAmount ?? 0) * 100;
  }

  double _getInvestmentPercentage() {
    if ((investedAmount ?? 0) < 0) {
      return 0;
    }
    return (investedAmount ?? 0) / (corpusAmount ?? 0) * 100;
  }
}
