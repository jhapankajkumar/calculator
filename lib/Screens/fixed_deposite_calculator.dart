import 'package:calculator/util/components.dart';
import 'package:calculator/util/constants.dart';
import 'package:calculator/util/indicator.dart';
import 'package:calculator/util/piechart.dart';
import 'package:calculator/util/string_constants.dart';
import 'package:calculator/util/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FixedDepositeCalculator extends StatefulWidget {
  final String title;
  final bool isFixedDeposit;
  FixedDepositeCalculator({
    Key? key,
    required this.title,
    required this.isFixedDeposit,
  });
  @override
  _FixedDepositeCalculatorState createState() =>
      _FixedDepositeCalculatorState();
}

enum Compounding { monthly, quaterly, annually }

class _FixedDepositeCalculatorState extends State<FixedDepositeCalculator> {
  bool shouldAdjustInflation = false;
  double? corpusAmount;
  double? amount;
  double? rate;
  double? period;
  int? touchedIndex;
  double? wealthGain;
  double? investedAmount;
  TextFieldFocus? currentFocus;
  final amountTextField = TextEditingController();
  Compounding? _compounding = Compounding.quaterly;
  var textFieldSelected = false;
  _calculateAmount() {
    removeFocust(context);
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
      investedAmount = amount;
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
          widget.isFixedDeposit
              ? _buildRadioList(context)
              : Text(
                  '* Compounding quaterly.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: Color(0xffFF4611)),
                ),
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

  Widget _buildRadioList(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: appTheme.primaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Compounding',
            textAlign: TextAlign.center,
            style: appTheme.textTheme.caption,
          ),
          ListTile(
            title: Text('Monthly', style: appTheme.textTheme.caption),
            horizontalTitleGap: 0,
            leading: Radio<Compounding>(
              value: Compounding.monthly,
              groupValue: _compounding,
              onChanged: (Compounding? value) {
                setState(() {
                  _compounding = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Quaterly', style: appTheme.textTheme.caption),
            horizontalTitleGap: 0,
            leading: Radio<Compounding>(
              value: Compounding.quaterly,
              groupValue: _compounding,
              onChanged: (Compounding? value) {
                setState(() {
                  _compounding = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Annually', style: appTheme.textTheme.caption),
            horizontalTitleGap: 0,
            leading: Radio<Compounding>(
              value: Compounding.annually,
              groupValue: _compounding,
              onChanged: (Compounding? value) {
                setState(() {
                  _compounding = value;
                });
              },
            ),
          ),
        ],
      ),
    );
    return Container();
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
            widget.isFixedDeposit
                ? StringConstants.fixedDepositAmount
                : StringConstants.investmentAmount,
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
        widget.isFixedDeposit
            ? StringConstants.depositPriod
            : StringConstants.investmentPeriod,
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
        widget.isFixedDeposit
            ? StringConstants.depositIntrestRate
            : StringConstants.expectedReturn,
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
