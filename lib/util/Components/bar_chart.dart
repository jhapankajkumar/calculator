import 'dart:math';

import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/investment_data.dart';
import 'package:calculator/util/utility.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'indicator.dart';

class BarChartView extends StatefulWidget {
  final InvestmentResult data;
  final int barCount;
  final Screen cateogry;
  const BarChartView(
      {Key? key,
      required this.data,
      required this.barCount,
      required this.cateogry})
      : super(key: key);

  @override
  _BarChartViewState createState() => _BarChartViewState();
}

class _BarChartViewState extends State<BarChartView> {
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  final Color withdrawalColor = const Color(0xff53fdd7);
  final Color startBalanceColor = const Color(0xffff5182);
  final Color interestEarnedColor = Colors.yellow;
  final Color finalBalanceColor = Colors.green;
  final double width = 5;
  @override
  void initState() {
    super.initState();
  }

  List<BarChartGroupData>? getGroupDataList() {
    List<BarChartGroupData> groupList = [];
    List<double>? finalBalancelist = getfinalBalanceSpots();
    List<double>? withdrawalList = getWithdrawalSpots();
    List<double>? profitList = getInterestAmountSpots();
    List<double>? startBalanceList = getStartingBalanceSpots();

    int i = 0;
    finalBalancelist?.forEach((element) {
      var barGroup1 = makeGroupData(
        i,
        startBalanceList?[i] ?? 0,
        element,
        withdrawalList?[i] ?? 0,
        profitList?[i] ?? 0,
      );
      i = i + 1;
      groupList.add(barGroup1);
    });
    return groupList;
  }

  BarChartGroupData makeGroupData(
      int x, double y1, double y2, double y3, double y4) {
    return BarChartGroupData(barsSpace: 2, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors: [startBalanceColor],
        width: width,
      ),
      BarChartRodData(
        y: y2,
        colors: [finalBalanceColor],
        width: width,
      ),
      BarChartRodData(
        y: y3,
        colors: [withdrawalColor],
        width: width,
      ),
      BarChartRodData(
        y: y4,
        colors: [interestEarnedColor],
        width: width,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.finalBalance.toString().length > 16) {
      return Text('Data is too larget to fit in chart');
    }
    return Container(
      margin: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width - 32,
      height: MediaQuery.of(context).size.width + 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        gradient: LinearGradient(
          colors: [
            Color(0xff2c274c),
            appTheme.accentColor,
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                widget.cateogry == Screen.swp
                    ? "Balance Left"
                    : "Total Expected Amount",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: subTtitleFontSize,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                '\$ ${formatter.format(widget.data.finalBalance)}',
                style: TextStyle(
                    color: ternaryColor,
                    fontSize: subTtitleFontSize,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Indicator(
                        color: startBalanceColor,
                        size: indicatorSize,
                        text: "Start Balance",
                        isSquare: false,
                        textColor: Colors.white,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Indicator(
                        color: finalBalanceColor,
                        size: indicatorSize,
                        text: "Final Balance",
                        isSquare: false,
                        textColor: Colors.white,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Indicator(
                        color: withdrawalColor,
                        size: indicatorSize,
                        text: "Amount Withdrawal",
                        isSquare: false,
                        textColor: Colors.white,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Indicator(
                        color: interestEarnedColor,
                        size: indicatorSize,
                        text: "Interest Earned",
                        isSquare: false,
                        textColor: Colors.white,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                  child: BarChart(getBarChartData()),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Duration in Years ',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 2),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<double> getYAxisData() {
    double leading = double.parse(getMaxValue().toString().substring(0, 2));

    leading = leading + 1;
    if (leading > 75) {
      amountInterval = 20;
    } else if (leading > 60) {
      amountInterval = 15;
    } else if (leading > 50) {
      amountInterval = 12;
    } else if (leading > 40) {
      amountInterval = 10;
    } else if (leading > 25) {
      amountInterval = 8;
    } else if (leading > 20) {
      amountInterval = 5;
    } else if (leading > 15) {
      amountInterval = 4;
    } else if (leading > 10) {
      amountInterval = 3;
    } else if (leading > 5) {
      amountInterval = 2;
    } else {
      amountInterval = 1;
    }
    int digitToPad = 0;
    if (amountInterval < 10) {
      digitToPad = getMaxValue().toString().length - 3;
    } else {
      digitToPad = getMaxValue().toString().length - 2;
    }
    String amount = amountInterval.toInt().toString().padRight(digitToPad, '0');
    amountInterval = double.parse(amount);
    return [];
  }

  double getMaxValue() {
    return max(max(widget.data.totalProfit, widget.data.totalWithdrawal),
        max(widget.data.totalInvestedAmount, widget.data.finalBalance));
  }

  double maxY = 5;
  double maxX = 100;
  double interval = 0;
  double amountInterval = 0;

  List<double>? getfinalBalanceSpots() {
    List<double> list = [];
    int i = interval.toInt();
    var datalist = widget.data.list;
    int tenor = widget.data.tenor.toInt();
    for (; i <= (widget.data.tenor); i = i + interval.toInt()) {
      var amount = datalist?[i - 1].balance ?? 0;
      // print("Amount $amount");
      String sPoint = ((amount) / amountInterval).toStringAsFixed(4);
      list.add(double.parse(sPoint));
    }

    if (tenor % interval != 0) {
      var amount = datalist?[tenor - 1].balance ?? 0;
      //print('Amount $amount');
      String sPoint = ((amount) / amountInterval).toStringAsFixed(4);
      list.add(double.parse(sPoint));
    }
    list.forEach((element) {
      // print(element);
    });
    return list;
  }

  List<double>? getInterestAmountSpots() {
    List<double> list = [];

    var datalist = widget.data.list;
    int tenor = widget.data.tenor.toInt();
    for (int i = interval.toInt();
        i <= (widget.data.tenor);
        i = i + interval.toInt()) {
      dynamic wealthAmount = datalist?[i - 1].cumulatveProfit ?? 0;
      //print('$i Wealth Amount $wealthAmount');
      String sPoint = ((wealthAmount) / amountInterval).toStringAsFixed(4);
      list.add(double.parse(sPoint));
    }
    if (tenor % interval != 0) {
      dynamic wealthAmount = datalist?[tenor - 1].cumulatveProfit ?? 0;

      //print('$tenor Wealth Amount $wealthAmount');
      String sPoint = ((wealthAmount) / amountInterval).toStringAsFixed(4);

      list.add(double.parse(sPoint));
    }
    return list;
  }

  List<double>? getStartingBalanceSpots() {
    List<double> list = [];

    var datalist = widget.data.list;
    int tenor = widget.data.tenor.toInt();
    for (int i = interval.toInt();
        i <= (widget.data.tenor);
        i = i + interval.toInt()) {
      dynamic amount = datalist?[i - 1].amount ?? 0;
      //print('$i Wealth Amount $wealthAmount');
      String sPoint = ((amount) / amountInterval).toStringAsFixed(4);
      list.add(double.parse(sPoint));
    }
    if (tenor % interval != 0) {
      dynamic amount = datalist?[tenor - 1].amount ?? 0;

      //print('$tenor Wealth Amount $wealthAmount');
      String sPoint = ((amount) / amountInterval).toStringAsFixed(4);

      list.add(double.parse(sPoint));
    }
    return list;
  }

  List<double>? getWithdrawalSpots() {
    List<double> list = [];
    int i = interval.toInt();
    var datalist = widget.data.list;
    int tenor = widget.data.tenor.toInt();
    for (; i <= (widget.data.tenor); i = i + interval.toInt()) {
      var amount = datalist?[i - 1].cumulatveWithdrawal ?? 0;
      //print('$tenor SIP Amount $amount');
      String sPoint = ((amount) / amountInterval).toStringAsFixed(4);
      list.add(double.parse(sPoint));
    }

    if (tenor % interval != 0) {
      var amount = datalist?[tenor - 1].cumulatveWithdrawal ?? 0;
      //print('$tenor SIP Amount $amount');
      String sPoint = ((amount) / amountInterval).toStringAsFixed(4);
      list.add(double.parse(sPoint));
    }
    list.forEach((element) {
      // print(element);
    });
    return list;
  }

  // ignore: non_constant_identifier_names
  String k_m_b_generators(double num) {
    if (num < 1000) {
      return num.toString();
    } else if (num > 999 && num < 99999) {
      return "${(num / 1000).toStringAsFixed(1)} K";
    } else if (num > 99999 && num < 999999) {
      return "${(num / 1000).toStringAsFixed(0)} K";
    } else if (num > 999999 && num < 999999999) {
      return "${(num / 1000000).toStringAsFixed(1)} M";
    } else if (num > 999999999 && num < 999999999999) {
      return "${(num / 1000000000).toStringAsFixed(1)} B";
    } else if (num > 999999999999 && num < 999999999999999) {
      return "${(num / 1000000000000).toStringAsFixed(1)} T";
    } else if (num > 999999999999999 && num < 999999999999999999) {
      return "${(num / 1000000000000000).toStringAsFixed(1)} Q";
    } else {
      return num.toStringAsExponential(1);
    }
  }

  BarChartData getBarChartData() {
    int xValue = widget.data.tenor;
    if (xValue > 90 * 12) {
      interval = 20 * 12;
    } else if (xValue > 75 * 12) {
      interval = 20 * 12;
    } else if (xValue > 60 * 12) {
      interval = 15 * 12;
    } else if (xValue > 50 * 12) {
      interval = 12 * 12;
    } else if (xValue > 40 * 12) {
      interval = 10 * 12;
    } else if (xValue > 25 * 12) {
      interval = 8 * 12;
    } else if (xValue > 20 * 12) {
      interval = 5 * 12;
    } else if (xValue > 15 * 12) {
      interval = 4 * 12;
    } else if (xValue > 10 * 12) {
      interval = 3 * 12;
    } else if (xValue > 5 * 12) {
      interval = 2 * 12;
    } else {
      interval = 1 * 12;
    }
    getYAxisData();
    return BarChartData(
      maxY: maxY,
      minY: 0,
      barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Color(0xff2c274c),
            getTooltipItem: (_a, _b, _c, _d) {
              double finalBalanceAmount = 0;
              double investedAmount = 0;
              double wealthGain = 0;
              double withdrawalAmount = 0;
              //print('Index: ${bar.spotIndex}');
              int index = (_a.x + 1) * interval.toInt();
              var list = widget.data.list;

              if (widget.data.tenor < index) {
                finalBalanceAmount =
                    list?[widget.data.tenor.toInt() - 1].balance ?? 0;
                investedAmount =
                    list?[widget.data.tenor.toInt() - 1].amount ?? 0;
                wealthGain =
                    list?[widget.data.tenor.toInt() - 1].cumulatveProfit ?? 0;
                withdrawalAmount =
                    list?[widget.data.tenor.toInt() - 1].cumulatveWithdrawal ??
                        0;
              } else {
                finalBalanceAmount = list?[index - 1].balance ?? 0;
                investedAmount = list?[index - 1].amount ?? 0;
                wealthGain = list?[index - 1].cumulatveProfit ?? 0;
                withdrawalAmount = list?[index - 1].cumulatveWithdrawal ?? 0;
              }

              BarTooltipItem item1 = BarTooltipItem(
                  "",
                  TextStyle(
                      color: Color(0xff4af699),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                        text: '\$ ${k_m_b_generator(investedAmount)}\n',
                        style: TextStyle(
                            color: startBalanceColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: '\$ ${k_m_b_generator(finalBalanceAmount)}\n',
                      style: TextStyle(
                          color: finalBalanceColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                        text: '\$ ${k_m_b_generator(withdrawalAmount)}\n',
                        style: TextStyle(
                            color: withdrawalColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: '\$ ${k_m_b_generator(wealthGain)}',
                        style: TextStyle(
                            color: interestEarnedColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ]);
              return item1;
            },
          ),
          touchCallback: (response) {}),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            return (((value + 1) / 12 * interval)).toInt().toString();
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            // if (value == 0) {
            //   return "0    ";
            // }
            return k_m_b_generators(amountInterval * value);
          },
          margin: 8,
          reservedSize: 55,
        ),
        rightTitles: SideTitles(
            showTitles: true,
            getTitles: (value) {
              return '';
            },
            reservedSize: 5),
      ),
      gridData: FlGridData(
        show: true,
      ),
      borderData: FlBorderData(
        show: false,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      barGroups: getGroupDataList(),
    );
  }
}
