import 'package:calculator/Screens/sip_detail.dart';
import 'package:calculator/util/components.dart';
import 'package:calculator/util/constants.dart';
import 'package:calculator/util/indicator.dart';
import 'package:calculator/util/piechart.dart';
import 'package:calculator/util/sip_data.dart';
import 'package:calculator/util/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SIPCalculator extends StatefulWidget {
  SIPCalculator({Key? key, required this.title}) : super(key: key);
  final String title;

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
  final amountTextField = TextEditingController();
  SIPData detail = SIPData();

  var textFieldSelected = false;
  _calculateSIP() {
    var helper = UtilityHelper();

    detail.amount = amount;
    detail.interestRate = rate;
    detail.duration = period;
    corpusAmount = helper
        .getFutureAmountValue(amount ?? 0, rate ?? 0, period ?? 0,
            inflationrate, false, shouldAdjustInflation)
        .roundToDouble();
    setState(() {
      investedAmount = (amount ?? 0) * (period ?? 0) * 12;
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

    if (textField == TextFieldFocus.inflationrate) {
      setState(() {
        inflationrate = inputtedValue;
      });
    } else {
      setState(() {
        inflationrate = null;
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
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
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
                ))));
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
          // padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          margin: EdgeInsets.fromLTRB(8, 20, 8, 0),
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
                    isSquare: true,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Indicator(
                    color: Color(0xfff8b250),
                    text: investedAmountValue,
                    isSquare: true,
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
                    style: headerTextStyle,
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
                            title: Text('Expected Amount'),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: corpusAmount?.isInfinite == false
                                ? Text('\$${formatter.format(corpusAmount)}')
                                : Text('\$INFINITE'),
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
                            title: Text('Invested Amount'),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            tileColor: Colors.grey[300],
                            title: investedAmount?.isInfinite == false
                                ? Text('\$${formatter.format(investedAmount)}')
                                : Text('\$INFINITE'),
                          ),
                        ),
                      ],
                    ),
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
                    CupertinoButton(
                      child: Text("Detail"),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.blue,
                      disabledColor: Colors.grey,
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return InvestmentDetail(detail);
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
        height: 300,
        width: deviceWidth,
        padding: EdgeInsets.all(16),
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          _amountSection(context),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: (deviceWidth - 64) / 2,
                  child: _periodSection(context)),
              Container(
                  width: (deviceWidth - 64) / 2, child: _rateSection(context))
            ],
          ),
          SizedBox(height: 30),
          CupertinoButton(
            child: Text("Calculate"),
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
            "Monthly Investment Amount",
            style: lableStyle,
          ),
          SizedBox(height: 5),
          TextFieldContainer(containerData: data)
        ]);
  }

  Widget _periodSection(BuildContext context) {
    TextFieldContainerData data = TextFieldContainerData(
        placeHolder: "12",
        onTextChange: _onTextChange,
        onFocusChanged: _onFocusChange,
        textField: TextFieldFocus.period,
        currentFocus: currentFocus,
        textLimit: 3);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Investment Period",
        style: lableStyle,
      ),
      SizedBox(height: 3),
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
        "Annual Returns(%)",
        style: lableStyle,
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
