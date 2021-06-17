import 'dart:math';

import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/investment_data.dart';
import 'package:calculator/util/utility.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'indicator.dart';

class LineChartView extends StatefulWidget {
  final InvestmentResult data;
  final int barCount;
  final Screen cateogry;
  const LineChartView(
      {Key? key,
      required this.data,
      required this.barCount,
      required this.cateogry})
      : super(key: key);

  @override
  _LineChartViewState createState() => _LineChartViewState();
}

class _LineChartViewState extends State<LineChartView> {
  int deltaFactor = 12;
  bool isFutureValue = false;
  @override
  void initState() {
    if (widget.cateogry == Screen.fd ||
        widget.cateogry == Screen.fv ||
        widget.cateogry == Screen.lumpsum) {
      isFutureValue = true;
      deltaFactor = 1;
    } else {
      isFutureValue = false;
    }
    super.initState();
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
                "Total Expected Amount",
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
                        color: Colors.green,
                        size: indicatorSize,
                        text: "Total Amount",
                        isSquare: false,
                        textColor: Colors.white,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      isFutureValue == false
                          ? Indicator(
                              color: Colors.red,
                              size: indicatorSize,
                              text: "Invested Amount",
                              isSquare: false,
                              textColor: Colors.white,
                            )
                          : Container(),
                      isFutureValue == false
                          ? SizedBox(
                              height: 10,
                            )
                          : Container(),
                      Indicator(
                        color: Colors.yellow,
                        size: indicatorSize,
                        text: "Wealth Gain",
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
                  child: LineChart(
                    sampleData1(),
                    swapAnimationDuration: const Duration(milliseconds: 250),
                  ),
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
    double leading = 0;

    leading = double.parse(widget.data.finalBalance.toString().substring(0, 2));

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
      digitToPad = widget.data.finalBalance.toString().length - 3;
    } else {
      digitToPad = widget.data.finalBalance.toString().length - 2;
    }
    String amount = amountInterval.toInt().toString().padRight(digitToPad, '0');
    amountInterval = int.parse(amount);
    //print('Amount Interval, $amountInterval');
    return [];
  }

  double getMaxValue() {
    return max(max(widget.data.totalProfit, widget.data.totalWithdrawal),
        max(widget.data.totalInvestedAmount, widget.data.finalBalance));
  }

  double maxY = 5;
  double maxX = 100;
  int interval = 0;
  int amountInterval = 0;
  LineChartData sampleData1() {
    int xValue = widget.data.tenor;
    if (xValue > 90 * deltaFactor) {
      interval = 20 * deltaFactor;
    } else if (xValue > 75 * deltaFactor) {
      interval = 20 * deltaFactor;
    } else if (xValue > 60 * deltaFactor) {
      interval = 15 * deltaFactor;
    } else if (xValue > 50 * deltaFactor) {
      interval = 12 * deltaFactor;
    } else if (xValue > 40 * deltaFactor) {
      interval = 10 * deltaFactor;
    } else if (xValue > 25 * deltaFactor) {
      interval = 8 * deltaFactor;
    } else if (xValue > 20 * deltaFactor) {
      interval = 5 * deltaFactor;
    } else if (xValue > 15 * deltaFactor) {
      interval = 4 * deltaFactor;
    } else if (xValue > 10 * deltaFactor) {
      interval = 3 * deltaFactor;
    } else if (xValue > 5 * deltaFactor) {
      interval = 2 * deltaFactor;
    } else {
      interval = 1 * deltaFactor;
    }
    // print('Year Interval, $interval');
    getYAxisData();
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
          tooltipPadding: EdgeInsets.all(16),
          getTooltipItems: (barSpots) {
            var bar = barSpots.first;
            double finalBalanceAmount = 0;
            double investedAmount = 0;
            double wealthGain = 0;
            //print('Index: ${bar.spotIndex}');
            int index = bar.spotIndex * interval.toInt();
            var list = widget.data.list;
            //print('Index: $index');

            if (widget.data.tenor < index) {
              finalBalanceAmount =
                  list?[widget.data.tenor.toInt() - 1].balance ?? 0;
              investedAmount = list?[widget.data.tenor.toInt() - 1].amount ?? 0;
              wealthGain = list?[widget.data.tenor.toInt() - 1].profit ?? 0;
            } else if (index > 1) {
              finalBalanceAmount = list?[index - 1].balance ?? 0;
              investedAmount = list?[index - 1].amount ?? 0;
              wealthGain = list?[index - 1].profit ?? 0;
            }

            LineTooltipItem item1 = LineTooltipItem(
                "\$ ${bar.spotIndex > 0 ? k_m_b_generator(finalBalanceAmount) : 0}",
                TextStyle(
                    color: Color(0xff4af699),
                    fontSize: 14,
                    fontWeight: FontWeight.bold));
            LineTooltipItem item2 = LineTooltipItem(
                "\$ ${bar.spotIndex > 0 ? k_m_b_generator(investedAmount) : 0}",
                TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold));
            LineTooltipItem item3 = LineTooltipItem(
                "\$ ${bar.spotIndex > 0 ? k_m_b_generator(wealthGain) : 0}",
                TextStyle(
                    color: Colors.yellow,
                    fontSize: 14,
                    fontWeight: FontWeight.bold));
            if (isFutureValue) {
              return [item1, item3];
            } else {
              return [item1, item2, item3];
            }
          },
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: true,
      ),
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
            if (value == 0) {
              return "0";
            }

            switch (value.toInt()) {
              case 20:
              case 40:
              case 60:
              case 80:
              case 100:
                return (((value / 20) / deltaFactor * interval))
                    .toInt()
                    .toString();
            }
            return '';
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
            if (value == 0) {
              return "0    ";
            }
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
      borderData: FlBorderData(
        show: true,
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
      minX: 0,
      maxX: maxX,
      maxY: maxY,
      minY: 0,
      lineBarsData: linesBarDetails(),
    );
  }

  LineChartBarData getFinalBalanceBarData() {
    return LineChartBarData(
      spots: getfinalBalanceSpots(),
      isCurved: true,
      colors: [
        Colors.green,
      ],
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
  }

  LineChartBarData getInvestmentBarData() {
    return LineChartBarData(
      spots: getInvestmentSpots(),
      isCurved: true,
      colors: [
        Colors.red,
      ],
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
  }

  LineChartBarData getWealthGainBarData() {
    return LineChartBarData(
      spots: getInterestAmountSpots(),
      isCurved: true,
      colors: [
        Colors.yellow,
      ],
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
  }

  List<LineChartBarData> linesBarDetails() {
    if (isFutureValue) {
      return [
        getWealthGainBarData(),
        getFinalBalanceBarData(),
      ];
    } else {
      return [
        getWealthGainBarData(),
        getFinalBalanceBarData(),
        getInvestmentBarData(),
      ];
    }
  }

  List<FlSpot>? getfinalBalanceSpots() {
    List<FlSpot> list = [];
    double x = 0;
    list.add(FlSpot(0, 0));
    x = 20;
    int i = interval.toInt();
    var datalist = widget.data.list;
    int tenor = widget.data.tenor.toInt();
    for (; i <= (widget.data.tenor); i = i + interval.toInt()) {
      var amount = datalist?[i - 1].balance ?? 0;
      // print("Amount $amount");
      String sPoint = ((amount) / amountInterval).toStringAsFixed(2);
      var spots = FlSpot(x, double.parse(sPoint));
      list.add(spots);
      x = x + (20);
    }

    if (tenor % interval != 0) {
      var amount = datalist?[tenor - 1].balance ?? 0;
      //print('$tenor SIP Amount $amount');
      x = x - (20) + (((20) / interval) * (tenor % interval));
      String sPoint = ((amount) / amountInterval).toStringAsFixed(2);
      var spots = FlSpot(x, double.parse(sPoint));
      list.add(spots);
    }
    list.forEach((element) {
      // print(element);
    });
    return list;
  }

  List<FlSpot>? getInvestmentSpots() {
    double x = 0;
    List<FlSpot> list = [];
    if (isFutureValue) {
      String sPoint = ((widget.data.totalInvestedAmount) / amountInterval)
          .toStringAsFixed(2);
      list.add(FlSpot(0, double.parse(sPoint)));
    } else {
      list.add(FlSpot(0, 0));
    }

    x = 20;
    var datalist = widget.data.list;
    int tenor = widget.data.tenor.toInt();
    for (int i = interval.toInt();
        i <= (widget.data.tenor);
        i = i + interval.toInt()) {
      var amount = datalist?[i - 1].amount ?? 0;
      //print('$i Sum Amount $amount');
      String sPoint = ((amount) / amountInterval).toStringAsFixed(2);
      var spots = FlSpot(x, double.parse(sPoint));
      list.add(spots);
      x = x + (20);
    }
    if (tenor % interval != 0) {
      var amount = datalist?[tenor - 1].amount ?? 0;
      //print('$tenor Sum Amount $amount');
      x = x - (20) + (((20) / interval) * (tenor % interval));
      String sPoint = ((amount) / amountInterval).toStringAsFixed(2);
      var spots = FlSpot(x, double.parse(sPoint));
      list.add(spots);
    }
    list.forEach((element) {
      // print(element);
    });
    return list;
  }

  List<FlSpot>? getInterestAmountSpots() {
    double x = 0;
    List<FlSpot> list = [];
    list.add(FlSpot(0, 0));
    x = 20;
    var datalist = widget.data.list;
    int tenor = widget.data.tenor.toInt();
    for (int i = interval.toInt();
        i <= (widget.data.tenor);
        i = i + interval.toInt()) {
      dynamic wealthAmount = 0;

      wealthAmount = datalist?[i - 1].profit ?? 0;

      //print('$i Wealth Amount $wealthAmount');
      String sPoint = ((wealthAmount) / amountInterval).toStringAsFixed(2);
      var spots = FlSpot(x, double.parse(sPoint));
      list.add(spots);
      x = x + (20);
    }
    if (tenor % interval != 0) {
      dynamic wealthAmount = 0;
      wealthAmount = datalist?[tenor - 1].profit ?? 0;
      //print('$tenor Wealth Amount $wealthAmount');
      x = x - (20) + (((20) / interval) * (tenor % interval));
      String sPoint = ((wealthAmount) / amountInterval).toStringAsFixed(2);
      var spots = FlSpot(x, double.parse(sPoint));
      list.add(spots);
    }
    return list;
  }

  List<FlSpot>? getWithdrawalSpots() {
    List<FlSpot> list = [];
    double x = 0;
    list.add(FlSpot(0, 0));
    x = 20;
    int i = interval.toInt();
    var datalist = widget.data.list;
    int tenor = widget.data.tenor.toInt();
    for (; i <= (widget.data.tenor); i = i + interval.toInt()) {
      var amount = datalist?[i - 1].cumulatveWithdrawal ?? 0;
      // print("Amount $amount");
      String sPoint = ((amount) / amountInterval).toStringAsFixed(2);
      var spots = FlSpot(x, double.parse(sPoint));
      list.add(spots);
      x = x + (20);
    }

    if (tenor % interval != 0) {
      var amount = datalist?[tenor - 1].cumulatveWithdrawal ?? 0;
      //print('$tenor SIP Amount $amount');
      x = x - (20) + (((20) / interval) * (tenor % interval));
      String sPoint = ((amount) / amountInterval).toStringAsFixed(2);
      var spots = FlSpot(x, double.parse(sPoint));
      list.add(spots);
    }
    list.forEach((element) {
      print(element);
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
}
