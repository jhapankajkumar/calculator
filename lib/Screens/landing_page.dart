import 'package:calculator/Screens/sip_detail.dart';
import 'package:calculator/util/components.dart';
import 'package:calculator/util/constants.dart';
import 'package:calculator/util/sip_data.dart';
import 'package:calculator/util/utility.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    if (corpusAmount != null) {
      container = Container(
          width: deviceWidth,
          // padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          margin: EdgeInsets.fromLTRB(8, 20, 8, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.grey[300],
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              // color: Colors.blue[200],
              margin: EdgeInsets.fromLTRB(16, 15, 0, 0),
              width: deviceWidth,
              child: Text(
                "Amount Invested vs Return",
                style: headerTextStyle,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            corpusAmount != null
                ? Container(
                    // width: 300,

                    height: 350,
                    color: Colors.white,
                    child: Center(
                      child: PieChart(
                        PieChartData(
                            pieTouchData:
                                PieTouchData(touchCallback: (pieTouchResponse) {
                              setState(() {
                                final desiredTouch = pieTouchResponse.touchInput
                                        is! PointerExitEvent &&
                                    pieTouchResponse.touchInput
                                        is! PointerUpEvent;
                                if (desiredTouch &&
                                    pieTouchResponse.touchedSection != null) {
                                  touchedIndex = pieTouchResponse
                                      .touchedSection?.touchedSectionIndex;
                                } else {
                                  touchedIndex = -1;
                                }
                              });
                            }),
                            startDegreeOffset: 270,
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 2,
                            centerSpaceRadius: 0,
                            sections: showingSections()),
                      ),
                    ),
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
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey,
          //     spreadRadius: 2,
          //     blurRadius: 2,
          //     offset: Offset(1, 1), // changes position of shadow
          //   )
          // ],
        ),
        child: Column(
          children: [
            Card(
              borderOnForeground: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    color: Colors.blue[200],
                    padding: EdgeInsets.all(8),
                    width: deviceWidth,
                    child: Text(
                      "Summery",
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
                                  ? Text(
                                      '\$${formatter.format(investedAmount)}')
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
                      ElevatedButton(
                        child: Text("Detail >>"),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return InvestmentDetail(detail);
                          }));
                        },
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
              shadowColor: Colors.blueGrey,
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
        placeHolder: "Amount",
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
        placeHolder: "Period",
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
        placeHolder: "Return Rate",
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

  List<PieChartSectionData>? showingSections() {
    List<PieChartSectionData>? sectionData;

    if ((wealthGain ?? 0).compareTo(0) > 0 && wealthGain?.isInfinite == false) {
      sectionData = List.generate(2, (i) {
        final isTouched = i == touchedIndex;
        final double radius = isTouched ? 150 : 125;
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: const Color(0xff31944a).withOpacity(1.0),
              value: _getGainPercentage(),
              title: isTouched ? 'Wealth Gain' : "",
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff044d7c)),
              titlePositionPercentageOffset: 0.55,
            );
          case 1:
            return PieChartSectionData(
              color: const Color(0xfff8b250).withOpacity(1.0),
              value: _getInvestmentPercentage(),
              title: isTouched ? 'Amount Invested' : "",
              radius: radius,
              titleStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff044d7c)),
              titlePositionPercentageOffset: 0.55,
            );
          default:
            return PieChartSectionData();
        }
      });
    } else if (corpusAmount?.isInfinite == true) {
      sectionData = List.generate(1, (i) {
        return PieChartSectionData(
          color: const Color(0xff31944a).withOpacity(1.0),
          value: _getGainPercentage(),
          title: '',
          radius: 150,
          titleStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xff044d7c)),
          titlePositionPercentageOffset: 0.55,
        );
      });
    } else {
      sectionData = List.generate(1, (i) {
        return PieChartSectionData(
          color: const Color(0xfff8b250).withOpacity(1.0),
          value: _getInvestmentPercentage(),
          title: '',
          radius: 150,
          titleStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xff90672d)),
          titlePositionPercentageOffset: 0.55,
        );
      });
    }
    return sectionData;
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
