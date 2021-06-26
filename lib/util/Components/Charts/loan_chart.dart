import 'dart:math';

import 'package:calculator/util/Components/Charts/chart_helper.dart';
import 'package:calculator/util/Constants/constants.dart';
import 'package:calculator/util/investment_data.dart';
import 'package:calculator/util/sip_data.dart';
import 'package:calculator/util/utility.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../indicator.dart';

class LoanChartView extends StatefulWidget {
  final EMIData data;
  final int barCount;
  final Screen cateogry;
  const LoanChartView(
      {Key? key,
      required this.data,
      required this.barCount,
      required this.cateogry})
      : super(key: key);

  @override
  _LoanChartViewState createState() => _LoanChartViewState();
}

class _LoanChartViewState extends State<LoanChartView> {
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  final Color withdrawalColor = const Color(0xff53fdd7);
  final Color startBalanceColor = const Color(0xffff5182);
  final Color interestEarnedColor = Colors.yellow;
  final Color finalBalanceColor = Colors.green;
  final double barWidth = 15;
  @override
  void initState() {
    widget.data.installments.forEach((element) {
      // print(element.remainingLoanBalance);
    });
    super.initState();
  }

  List<BarChartGroupData>? getGroupDataList() {
    List<BarChartGroupData> groupList = [];
    List<double>? points = getPointSpots(amountInterval, widget.data);
    List<double>? pPoints = getPrincipalSpots(amountInterval, widget.data);
    int i = 0;
    points?.forEach((element) {
      var barGroup1 = makeGroupData(i, element, pPoints![i], 1.0);
      i = i + 1;
      groupList.add(barGroup1);
    });
    return groupList;
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2, double y3) {
    return BarChartGroupData(barsSpace: 2, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors: [Colors.black],
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6), topRight: Radius.circular(6)),
        rodStackItems: [
          BarChartRodStackItem(0, y1 - y2, const Color(0xff2bdb90)),
          BarChartRodStackItem(y1 - y2, y1, const Color(0xffff4d94)),
        ],
        width: 10,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.loanAmount.toString().length > 16) {
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
                "Loan Amount",
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
                '\$ ${formatter.format(widget.data.loanAmount)}',
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
                        color: finalBalanceColor,
                        size: indicatorSize,
                        text: "Pricipal",
                        isSquare: false,
                        textColor: Colors.white,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Indicator(
                        color: startBalanceColor,
                        size: indicatorSize,
                        text: "Interest",
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
                  child: BarChart(getLoanChartData()),
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

  int interval = 0;
  double amountInterval = 0;

  List<double>? getPointSpots(double amountInterval, EMIData data) {
    List<double> list = [];
    int i = interval.toInt();
    var datalist = data.installments;
    int tenor = data.period.toInt();
    for (; i <= (data.period); i = i + interval.toInt()) {
      double amount = 0;
      amount = data.loanAmount;
      // print("Amount $amount");
      String sPoint = ((amount) / amountInterval).toStringAsFixed(4);
      list.add(double.parse(sPoint));
    }

    if (tenor % interval != 0) {
      double amount = 0;
      amount = data.loanAmount;
      //print('Amount $amount');
      String sPoint = ((amount) / amountInterval).toStringAsFixed(4);
      list.add(double.parse(sPoint));
    }
    list.forEach((element) {
      // print(element);
    });
    return list;
  }

  List<double>? getPrincipalSpots(double amountInterval, EMIData data) {
    List<double> list = [];
    int i = interval.toInt();
    var datalist = data.installments;
    int tenor = data.period.toInt();
    for (; i <= (data.period); i = i + interval.toInt()) {
      double amount = 0;
      amount = datalist[i - 1].remainingLoanBalance;
      // print("Amount $amount");
      String sPoint = ((amount) / amountInterval).toStringAsFixed(4);
      list.add(double.parse(sPoint));
    }

    if (tenor % interval != 0) {
      double amount = 0;
      amount = datalist[tenor - 1].remainingLoanBalance;
      //print('Amount $amount');
      String sPoint = ((amount) / amountInterval).toStringAsFixed(4);
      list.add(double.parse(sPoint));
    }
    list.forEach((element) {
      // print(element);
    });
    return list;
  }

  BarChartData getLoanChartData() {
    interval = ChartHelper.shared
        .getTimeInterval(widget.data.period, 12, widget.cateogry);
    amountInterval =
        ChartHelper.shared.getAmountInterval(widget.data.loanAmount);
    return BarChartData(
      maxY: 5,
      minY: 0,
      barTouchData: BarTouchData(enabled: false),
      groupsSpace: 12,
      titlesData: FlTitlesData(
        bottomTitles:
            ChartHelper.shared.getBottomTiles(interval, widget.cateogry, 12),
        leftTitles: ChartHelper.shared.getLeftSideTiles(amountInterval, false),
        rightTitles: ChartHelper.shared.getRightSideTiles(),
      ),
      gridData: FlGridData(
        show: true,
      ),
      borderData: ChartHelper.shared.getChartBorder(false),
      barGroups: getGroupDataList(),
    );
  }
}
